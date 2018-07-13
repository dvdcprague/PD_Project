#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov  7 11:34:03 2017

@author: cc
"""

import logging

import numpy as np
from sklearn.metrics import confusion_matrix

from ada_boost import adaBoost
from const import PER_FIX, EXCLUDE_HY_INDEX, EXCLUDE_COLS
from grid_search import multiclass_roc_auc_score
from logistic_regression import logisticRegression
from metric import performance
from random_forest import randomForest
from svc import svcClf

logging.basicConfig(level=logging.DEBUG,
                    format="%(asctime)s %(levelname)s %(message)s",
                    filename="single_model.log",
                    filemode="w")

if EXCLUDE_HY_INDEX:
    logging.info("\n\n=========Running single models without Hoehn-Yahr index and updrs_3_scores features=========\n\n")
    print "\n\n=========Running single models without Hoehn-Yahr index and updrs_3_scores features=========\n\n"
else:
    logging.info("\n\n=========Running single models with all features=========\n\n")
    print "\n\n=========Running single models with all features=========\n\n"

# load training and test sets
trn_data_path = "../../data/" + PER_FIX + "train.npz"
tst_data_path = "../../data/" + PER_FIX + "test.npz"

train = np.load(trn_data_path)
X_train = train["X_train"]
y_train = train["y_train"]
test = np.load(tst_data_path)
X_test = test["X_test"]
y_test = test["y_test"]

feature_names = ["AGE", "GENDER", "MDS-UPDRS_PART_I_SCORE", "MDS-UPDRS_PART_2_SCORE", "MDS-UPDRS_PART_3_SCORE",
                 "MDS-UPDRS_PART_4_SCORE",
                 "Hoehn_Yahr_INDEX", "MODIFIED_Schwad_England_ALD", "GDS_SCORE", "MoCA_SCORE", "SCOPA_AUT",
                 "EPWORTH_SLEEPINESS_SCORE", "UPSIT",
                 "ALPHA_SYNUCLEIN_BL", "ALPHA_SYNUCLEIN_V01",
                 "ALPHA_SYNUCLEIN_V02", "ALPHA_SYNUCLEIN_V04",
                 "ALPHA_SYNUCLEIN_V05", "ALPHA_SYNUCLEIN_V06",
                 "ALPHA_SYNUCLEIN_V07", "ALPHA_SYNUCLEIN_V08",
                 "HEMOGLOBIN_BL", "HEMOGLOBIN_V02", "HEMOGLOBIN_V04",
                 "HEMOGLOBIN_V06", "HEMOGLOBIN_V08",
                 "MRIRSLT", "CAUDATE", "PUTAMEN", "STRIATUM", "DENSITY", "ASYMMETRY"]
if EXCLUDE_HY_INDEX:
    for col in EXCLUDE_COLS:
        if col == "hy":
            feature_names.remove("Hoehn_Yahr_INDEX")
        elif col == "updrs_3_score":
            feature_names.remove("MDS-UPDRS_PART_3_SCORE")


########################################
# Logistic regression
print("Running Logistic Regression Classifier...")

params_lr = {"C": np.logspace(-5, 0, 10), "penalty": ['l1', 'l2'], "tol": [1e-3, 1e-4, 1e-5],
             "class_weight": [None, "balanced"]}
lr = logisticRegression(params_lr, X_train, y_train)
lr.optimization()
best_lr = lr.get_best_model()
best_lr.fit(X_train, y_train)
y_train_pred_lr = best_lr.predict(X_train)
y_test_pred_lr = best_lr.predict(X_test)

AUC_train_lr = multiclass_roc_auc_score(y_train, y_train_pred_lr)
AUC_test_lr = multiclass_roc_auc_score(y_test, y_test_pred_lr)

print("AUC for training set is: " + str(AUC_train_lr))
print("AUC for test set is: " + str(AUC_test_lr))

logging.info("AUC of {} on training data: {}".format("logistic regression", AUC_train_lr))
logging.info("AUC of {} on test data: {}".format("logistic regression", AUC_test_lr))

y_test_pred_prob_lr = best_lr.predict_proba(X_test)
perform = performance(y_test, y_test_pred_lr, y_test_pred_prob_lr)

# plot feature importance
perform.feature_analysis(feature_names, best_lr.coef_[0],
                         PER_FIX + "Logistic Regression Classifier (Feature Importance)")

# plot ROC curve for test set
perform.roc_auc_curve(title=PER_FIX + "Logistic Regression Classifier (ROC)")

# plot confusion matrix
cm_lr = confusion_matrix(y_test, y_test_pred_lr)
perform.confusion_matrix(cm_lr, title=PER_FIX + "Logistic Regression Classifier (Confusion Matrix)")

##########################################
# Random Forest
print("Running Random Forest Classifier...")

params_rf = {"n_estimators": [10, 30, 50, 70, 90, 100, 120, 160, 200, 240],
             "min_samples_split": [2, 4, 6, 8],
             "min_samples_leaf": [1, 2, 3, 4]}
rf = randomForest(params_rf, X_train, y_train)
rf.optimization()
best_rf = rf.get_best_model()
best_rf.fit(X_train, y_train)
y_train_pred_rf = best_rf.predict(X_train)
y_test_pred_rf = best_rf.predict(X_test)

AUC_train_rf = multiclass_roc_auc_score(y_train, y_train_pred_rf)
AUC_test_rf = multiclass_roc_auc_score(y_test, y_test_pred_rf)

print("AUC for training set is: " + str(AUC_train_rf))
print("AUC for test set is: " + str(AUC_test_rf))

logging.info("AUC of {} on training data: {}".format("random forest", AUC_train_rf))
logging.info("AUC of {} on test data: {}".format("random forest", AUC_test_rf))

y_test_pred_prob_rf = best_rf.predict_proba(X_test)
perform = performance(y_test, y_test_pred_rf, y_test_pred_prob_rf)

# plot feature importance
perform.feature_analysis(feature_names, best_rf.feature_importances_,
                         PER_FIX + "Random Forest Classifier (Feature Importance)")

# plot ROC curve for test set

perform.roc_auc_curve(title=PER_FIX + "Random Forest Classifier (ROC)")

# plot confusion matrix
cm_rf = confusion_matrix(y_test, y_test_pred_rf)
perform.confusion_matrix(cm_rf, title=PER_FIX + "Random Forest Classifier (Confusion Matrix)")

##########################################
# Support Vector Classifier
print("Running Support Vector Classifier...")

params_svc = {"C": np.logspace(-5, 0, 10),
              "kernel": ["linear", "poly", "rbf", "sigmoid"],
              "degree": [2, 3, 4],
              "coef0": [0.0, 0.1, 0.2]}

svc = svcClf(params_svc, X_train, y_train)
svc.optimization()
best_svc = svc.get_best_model()
best_svc.fit(X_train, y_train)
y_train_pred_svc = best_svc.predict(X_train)
y_test_pred_svc = best_svc.predict(X_test)

AUC_train_svc = multiclass_roc_auc_score(y_train, y_train_pred_svc)
AUC_test_svc = multiclass_roc_auc_score(y_test, y_test_pred_svc)

print("AUC for training set is: " + str(AUC_train_svc))
print("AUC for test set is: " + str(AUC_test_svc))

logging.info("AUC of {} on training data: {}".format("support vector classifier", AUC_train_svc))
logging.info("AUC of {} on test data: {}".format("support vector classifier", AUC_test_svc))

y_test_pred_prob_svc = best_svc.predict_proba(X_test)
perform = performance(y_test, y_test_pred_svc, y_test_pred_prob_svc)

# plot feature importance
perform.feature_analysis(feature_names, best_svc.coef_[0], PER_FIX + "Support Vector Classifier (Feature Importance)")

# plot ROC curve for test set

perform.roc_auc_curve(title=PER_FIX + "Support Vector Classifier (ROC)")

# plot confusion matrix
cm_svc = confusion_matrix(y_test, y_test_pred_svc)
perform.confusion_matrix(cm_svc, title=PER_FIX + "Support Vector Classifier (Confusion Matrix)")

##########################################
# Ada Boost
print("Running Ada Boost Classifier...")

params_ada = {"n_estimators": [10, 30, 50, 70, 90, 100, 120, 160, 200, 240],
              "learning_rate": [0.1, 0.3, 0.5, 0.7, 0.9, 1.0]}

ada = adaBoost(params_ada, X_train, y_train)
ada.optimization()
best_ada = ada.get_best_model()
best_ada.fit(X_train, y_train)
y_train_pred_ada = best_ada.predict(X_train)
y_test_pred_ada = best_ada.predict(X_test)

AUC_train_ada = multiclass_roc_auc_score(y_train, y_train_pred_ada)
AUC_test_ada = multiclass_roc_auc_score(y_test, y_test_pred_ada)

print("AUC for training set is: " + str(AUC_train_ada))
print("AUC for test set is: " + str(AUC_test_ada))

logging.info("AUC of {} on training data: {}".format("ada boost classifier", AUC_train_ada))
logging.info("AUC of {} on test data: {}".format("ada boost classifier", AUC_test_ada))

y_test_pred_prob_ada = best_ada.predict_proba(X_test)
perform = performance(y_test, y_test_pred_ada, y_test_pred_prob_ada)

# plot feature importance
perform.feature_analysis(feature_names, best_ada.feature_importances_,
                         PER_FIX + "Ada Boost Classifier (Feature Importance)")

# plot ROC curve for test set

perform.roc_auc_curve(title=PER_FIX + "Ada Boost Classifier (ROC)")

# plot confusion matrix
cm_ada = confusion_matrix(y_test, y_test_pred_ada)
perform.confusion_matrix(cm_ada, title=PER_FIX + "Ada Boost Classifier (Confusion Matrix)")
