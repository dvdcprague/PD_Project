import itertools
from itertools import cycle

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn

seaborn.set(style='ticks')

from sklearn.metrics import f1_score, accuracy_score, recall_score, precision_score, roc_curve, auc
from sklearn.preprocessing import label_binarize

from const import N_CLASS, CLASS_NAME, EXCLUDE_HY_INDEX, EXCLUDE_COLS
from grid_search import multiclass_roc_auc_score


class performance(object):
    """
    class to measure performance of models
    """

    def __init__(self, y_true, y_pred, y_pred_prob):
        """
        initiate parameters
        :param y_true: target label
        :param y_pred: prediction results
        :param y_pred_prob: prediction probability
        """
        self.y_true = y_true
        self.y_pred = y_pred
        self.y_pred_prob = y_pred_prob

    def get_scores(self, average="weighted"):
        """
        function to get auc, accuracy, recall, precision and f1 score
        :param average: method to calculate scores
        :return: scores object with auc, accuracy, recall, precision and f1 score
        """
        auc_score = multiclass_roc_auc_score(self.y_true, self.y_pred)
        accu_score = accuracy_score(self.y_true, self.y_pred)
        recall = recall_score(self.y_true, self.y_pred, average=average)
        precision = precision_score(self.y_true, self.y_pred, average=average)
        f1 = f1_score(self.y_true, self.y_pred, average=average)

        return Scores(auc_score, accu_score, recall, precision, f1)

    def roc_auc_curve(self, title):
        """
        function to generate roc curve
        :param title: title of the graph
        :return: save graph to results
        """

        plt.figure(dpi=300)
        y_true = label_binarize(self.y_true, classes=[0, 1, 2])

        # Compute ROC curve and ROC area for each class
        fpr = dict()
        tpr = dict()
        roc_auc = dict()
        # Generate curve for each class
        for i in range(N_CLASS):
            fpr[i], tpr[i], _ = roc_curve(y_true[:, i], self.y_pred_prob[:, i])
            roc_auc[i] = auc(fpr[i], tpr[i])

        colors = cycle(["aqua", "darkorange", "cornflowerblue"])
        for i, color in zip(range(N_CLASS), colors):
            plt.plot(fpr[i], tpr[i], color=color, lw=2,
                     label="ROC curve of class {0} (area = {1:0.2f})"
                           "".format(CLASS_NAME[i], roc_auc[i]))

        plt.plot([0, 1], [0, 1], "k--")
        plt.xlim([0.0, 1.0])
        plt.ylim([0.0, 1.05])
        plt.xlabel("False Positive Rate")
        plt.ylabel("True Positive Rate")
        plt.title(title)
        plt.legend(loc="lower right")
        # save the graph
        plt.savefig("../../results/Figures/model/" + title + ".png", bbox_inches="tight")

    def confusion_matrix(self, cm, title, normalize=False, cmap=plt.cm.Blues):
        """
        This function prints and plots the confusion matrix.
        Normalization can be applied by setting `normalize=True`.
        :param cm: confusion matrix
        :param title: title of the graph
        :param normalize: boolean to determine whether to show normalized results
        :param cmap: define colors for graph
        :return: save graph to results folder
        """
        if normalize:
            cm = cm.astype("float") / cm.sum(axis=1)[:, np.newaxis]
            print("Normalized confusion matrix")
        else:
            print("Confusion matrix, without normalization")

        print(cm)
        plt.figure(dpi=300)
        plt.imshow(cm, interpolation="nearest", cmap=cmap)
        plt.title(title)
        plt.colorbar()
        tick_marks = np.arange(len(CLASS_NAME))
        plt.xticks(tick_marks, CLASS_NAME)
        plt.yticks(tick_marks, CLASS_NAME)

        fmt = ".2f" if normalize else "d"
        thresh = cm.max() / 2.
        for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
            plt.text(j, i, format(cm[i, j], fmt),
                     horizontalalignment="center",
                     color="white" if cm[i, j] > thresh else "black")

        plt.tight_layout()
        plt.ylabel("True label")
        plt.xlabel("Predicted label")
        plt.savefig("../../results/Figures/model/" + title + ".png", bbox_inches="tight")

    def feature_analysis(self, feature_names, feature_imp, title):
        """
        this function generates graph with ranked features
        :param feature_names: names of features
        :param feature_imp: value of feature importance
        :param title: title of the graph
        :return: save graph to results folder
        """
        # define index start with lab features
        if EXCLUDE_HY_INDEX:
            lab_start = 13 - len(EXCLUDE_COLS)
        else:
            lab_start = 13
        features_df = pd.DataFrame({'feature_name': feature_names,
                                    'feature_importance': abs(feature_imp)})
        features_df['feature_type'] = 'Clinical'
        features_df['feature_type'][lab_start:lab_start + 13] = 'Lab'
        features_df['feature_type'][lab_start + 13:lab_start + 19] = 'Imaging'

        # sort importance values in ascending order
        features_df = features_df.sort_values(by=['feature_importance']).reset_index(drop=True)

        fg = seaborn.FacetGrid(data=features_df, col='feature_type', hue='feature_type', col_wrap=3,
                               col_order=['Clinical', 'Imaging', 'Lab'], size=5, aspect=1, despine=False, sharex=False)
        fg.map(seaborn.barplot, 'feature_name', 'feature_importance')
        [plt.setp(ax.get_xticklabels(), rotation=90) for ax in fg.axes.flat]
        fg.axes[0].set_ylabel('Feature Importance')
        fg.axes[0].set_xlabel('')
        fg.axes[1].set_xlabel('')
        fg.axes[2].set_xlabel('')
        plt.subplots_adjust(top=0.88)
        fg.fig.suptitle(title)
        # save figure
        fg.savefig("../../results/Figures/model/" + title + ".png")


class Scores(object):
    def __init__(self, auc_score, accu_score, recall, precision, f1):
        """
        initialize scores
        :param auc_score:
        :param accu_score:
        :param recall:
        :param precision:
        :param f1:
        """
        self.auc_score = auc_score
        self.accu_score = accu_score
        self.recall = recall
        self.precision = precision
        self.f1_score = f1
