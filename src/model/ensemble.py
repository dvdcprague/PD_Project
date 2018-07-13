import itertools
import logging
import time

import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
from sklearn.model_selection import ShuffleSplit

from ada_boost import adaBoost
from const import RANDOM_STATE, N_CLASS, PER_FIX, EXCLUDE_HY_INDEX
from grid_search import search, multiclass_roc_auc_score
from logistic_regression import logisticRegression
from metric import performance
from random_forest import randomForest
from svc import svcClf


class ensembleModel(object):
    """
    class to run ensemble model
    """

    def __init__(self, params, trn_data_path, tst_data_path):
        """
        initialize parameters
        :param params: parameters of models for grid search
        :param trn_data_path: training data path
        :param tst_data_path: testing data path
        """
        self.params = params
        self.trn_data_path = trn_data_path
        self.tst_data_path = tst_data_path
        self.ensemble_clf = None

    def load_data(self):
        """
        function to load training and test data
        :return:
        """
        # load training data
        train = np.load(self.trn_data_path)
        self.X_train = train["X_train"]
        self.y_train = train["y_train"]

        # load test data
        test = np.load(self.tst_data_path)
        self.X_test = test["X_test"]
        self.y_test = test["y_test"]

    def get_single_models(self):
        """
        function to get best single models
        :return:
        """
        self.single_models = {}
        self.rf = randomForest(self.params["rf"], self.X_train, self.y_train)
        self.ada = adaBoost(self.params["ada"], self.X_train, self.y_train)
        self.svc = svcClf(self.params["svc"], self.X_train, self.y_train)
        self.lr = logisticRegression(self.params["lr"], self.X_train, self.y_train)

        self.single_models[self.rf.get_model_name()] = self.rf.get_best_model()
        logging.info("Best parameters for random forest: {}\n".format(self.rf.best_params))

        self.single_models[self.ada.get_model_name()] = self.ada.get_best_model()
        logging.info("Best parameters for ada boost: {}\n".format(self.ada.best_params))

        self.single_models[self.svc.get_model_name()] = self.svc.get_best_model()
        logging.info("Best parameters for svc: {}\n".format(self.svc.best_params))

        self.single_models[self.lr.get_model_name()] = self.lr.get_best_model()
        logging.info("Best parameters for logistic regression: {}\n".format(self.lr.best_params))

    def my_ensemble_classifier(self, X_train, Y_train, X_test, niter=5,
                               retrain=True, models=None):
        """
        function uses single models to train on train set and generating validation predictions for ensemble model
        :param self.single_models:
        :param X_train:
        :param Y_train:
        :param X_test:
        :param retrain:
        :return: predicted validation, test with single models, and validation dataset label
        """
        # get single models
        single_models = {}
        if models:
            for single_model in self.single_models:
                if single_model in models:
                    single_models[single_model] = self.single_models[single_model]
        else:
            single_models = self.single_models
        logging.info("Models for ensemble: {}\n".format(single_models.keys()))
        # set 5-fold validation
        rs = ShuffleSplit(n_splits=niter, test_size=0.2, random_state=RANDOM_STATE)
        P_val = np.zeros(shape=(len(Y_train), len(single_models) * N_CLASS))
        Y_val = np.zeros(len(Y_train))
        P_test = np.zeros(shape=(X_test.shape[0], len(single_models) * N_CLASS))
        auc_list = {}
        for train_index, test_index in rs.split(X_train, Y_train):
            x_train, x_test = X_train[train_index], X_train[test_index]
            y_train, y_test = Y_train[train_index], Y_train[test_index]
            idx = 0
            # for each model train on training set and predict on validation set and combine prediction of validations
            # from each model
            for clf_name in single_models:
                clf_opt = single_models[clf_name]
                clf_opt.fit(x_train, y_train)
                y_pred = clf_opt.predict_proba(x_test)
                P_val[test_index, idx:idx + 3] = np.array(y_pred)
                auc = multiclass_roc_auc_score(y_test, clf_opt.predict(x_test))
                if clf_name not in auc_list:
                    auc_list[clf_name] = auc / niter
                else:
                    auc_list[clf_name] += auc / niter
                if not retrain:
                    P_test[:, idx:idx + 3] += clf_opt.predict_proba(X_test) / niter
                idx += 3
            Y_val[test_index] = np.array(y_test)
        # retrain single models with full train set and predict for test data
        if retrain:
            idx = 0
            for clf_name in single_models:
                clf_opt = single_models[clf_name]
                clf_opt.fit(X_train, Y_train)
                P_test[:, idx:idx + 3] = np.array(clf_opt.predict_proba(X_test))
                idx += 3

        return P_val, Y_val, P_test

    def select_ensemble_model(self, P_train, Y_train):
        """
        function to select ensemble parameters
        :param P_train:
        :param Y_train:
        :return: best parameters
        """
        ensemble_clf = LogisticRegression(random_state=RANDOM_STATE)
        best_params, self.best_scores = search(ensemble_clf, "ensemble", P_train, Y_train, self.params["ensemble"])
        logging.info("Best parameters for ensemble: {}".format(best_params))
        return best_params

    def my_classifier_predictions(self, models, niter=5):
        """
        function to predict test with ensemble model
        :param models:
        :param niter:
        :return: hard label and prediction probability
        """

        # get ensemble parameters
        P_val, Y_val, P_test = self.my_ensemble_classifier(self.X_train, self.y_train, self.X_test, models=models)
        best_params = self.select_ensemble_model(P_val, Y_val)
        self.ensemble_clf = LogisticRegression(random_state=RANDOM_STATE, **best_params)

        # retrain ensemble model
        self.ensemble_clf.fit(P_val, Y_val)
        # predict with ensemble model and save results
        preds = self.ensemble_clf.predict(P_test)
        preds_prob = self.ensemble_clf.predict_proba(P_test)

        return preds, preds_prob

    def get_best_model(self):
        """
        function to get best ensemble model
        need to execute prediction function first
        :return:
        """
        return self.ensemble_clf

    def get_important_features(self):
        """
        function to get ensemble model coefficiency
        :return:
        """
        best_model = self.get_best_model()
        if best_model is None:
            logging.debug("Ensemble model is not trained")
            return
        return best_model.coef_


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG,
                        format="%(asctime)s %(levelname)s %(message)s",
                        filename="ensemble.log",
                        filemode="w")
    if EXCLUDE_HY_INDEX:
        logging.info("\n\n=========Running ensemble model without Hoehn-Yahr index and updrs_3_scores features=========\n\n")
        print "\n\n=========Running ensemble model without Hoehn-Yahr index and updrs_3_scores features=========\n\n"
    else:
        logging.info("\n\n=========Running ensemble model with all features=========\n\n")
        print "\n\n=========Running ensemble model with all features=========\n\n"

    # define parameters of models for grid search
    params = {"rf": {"n_estimators": [10, 30, 50, 70, 90, 100, 120, 160, 200, 240],
                     "min_samples_split": [2, 4, 6, 8], "min_samples_leaf": [1, 2, 3, 4]},
              "ada": {"n_estimators": [10, 30, 50, 70, 90, 100, 120, 160, 200, 240],
                      "learning_rate": [0.1, 0.3, 0.5, 0.7, 0.9, 1.0]},
              "svc": {"C": np.logspace(-5, 0, 10), "kernel": ["linear", "poly", "rbf", "sigmoid"],
                      "degree": [2, 3, 4], "coef0": [0.0, 0.1, 0.2]},
              "lr": {"C": np.logspace(-5, 0, 10), "penalty": ["l1", "l2"], "tol": [1e-3, 1e-4, 1e-5],
                     "class_weight": [None, "balanced"]},
              "ensemble": {"tol": [1e-3, 1e-5, 1e-7], "penalty": ["l1", "l2"], "C": np.logspace(-5, 0, 10),
                           "class_weight": [None, "balanced"]}}

    # models for ensemble
    models = ["Random Forest", "Ada Boost", "SVC", "Logistic Regression"]

    trn_data_path = "../../data/" + PER_FIX + "train.npz"
    tst_data_path = "../../data/" + PER_FIX + "test.npz"

    start = time.time()
    ens = ensembleModel(params, trn_data_path, tst_data_path)
    # get train and test data
    ens.load_data()
    # get single models trained
    ens.get_single_models()

    val_scores = pd.DataFrame(index=["AUC"])
    test_scores = pd.DataFrame(index=["AUC", "Accuracy", "Recall", "Precision", "F1"])

    # test different ensembles
    for i in range(1, len(models) + 1):
        for subset in itertools.combinations(models, i):
            ens_preds, ens_preds_prob = ens.my_classifier_predictions(subset)

            # generate ensemble scores on validation and test data
            perform = performance(ens.y_test, ens_preds, ens_preds_prob)
            ens_scores = perform.get_scores()
            val_scores["Ensemble: " + "-".join(subset)] = ens.best_scores
            test_scores["Ensemble: " + "-".join(subset)] = [ens_scores.auc_score, ens_scores.accu_score,
                                                            ens_scores.recall,
                                                            ens_scores.precision, ens_scores.f1_score]

            # generate ensemble plots on test data
            perform.roc_auc_curve(title=PER_FIX + "Ensemble with {} (ROC)".format("-".join(subset)))
            perform.confusion_matrix(cm=confusion_matrix(ens.y_test, ens_preds),
                                     title=PER_FIX + "Ensemble with {} (confusion matrix)".format("-".join(subset)))
            # generate single model scores on validation and test data
            for clf in ens.single_models:
                if clf in subset:
                    single_model_preds = ens.single_models[clf].predict(ens.X_test)
                    single_model_preds_prob = ens.single_models[clf].predict_proba(ens.X_test)
                    snm_scores = performance(ens.y_test, single_model_preds, single_model_preds_prob).get_scores()
                    best_scores = None
                    if clf == "Random Forest":
                        best_scores = ens.rf.best_scores
                    if clf == "Logistic Regression":
                        best_scores = ens.lr.best_scores
                    if clf == "Ada Boost":
                        best_scores = ens.ada.best_scores
                    if clf == "SVC":
                        best_scores = ens.svc.best_scores
                    val_scores[clf] = best_scores
                    test_scores[clf] = [snm_scores.auc_score, snm_scores.accu_score,
                                        snm_scores.recall, snm_scores.precision, snm_scores.f1_score]

    # save scores on validation and test data to results folder
    val_scores.to_csv("../../results/" + PER_FIX + "scores_on_validation_data.csv")
    test_scores.to_csv("../../results/" + PER_FIX + "scores_on_test_data.csv")

    logging.info("Completed with {} seconds\n\n\n".format(time.time() - start))
