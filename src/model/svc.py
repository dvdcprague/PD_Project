from sklearn.svm import SVC
from grid_search import search

from const import RANDOM_STATE


class svcClf(object):
    """
    class with support vector classifier
    """
    def __init__(self, params, X, y, model_name="SVC"):
        """
        setup initial paramters
        :param params: parameters for grid search
        :param X: training features
        :param y: target label
        :param model_name:
        """
        self.params = params
        self.X = X
        self.y = y
        self.model_name = model_name

    def get_default_model(self):
        """
        get a default svc model
        :return:
        """
        self.model = SVC(probability=True, random_state=RANDOM_STATE)

    def optimization(self):
        """
        grid search for optimized parameters
        :return:
        """
        self.get_default_model()
        self.best_params, self.best_scores = search(self.model, self.get_model_name(), self.X, self.y, self.params)

    def get_model_name(self):
        """
        get the model name
        :return:
        """
        return self.model_name

    def get_best_model(self):
        """
        get optimized model
        :return:
        """
        self.optimization()
        return SVC(probability=True, random_state=RANDOM_STATE, **self.best_params)