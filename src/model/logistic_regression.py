from sklearn.linear_model import LogisticRegression
from grid_search import search

from const import RANDOM_STATE

class logisticRegression(object):
    """
    class with logistic regression model
    """
    def __init__(self, params, X, y, model_name = "Logistic Regression"):
        """
        set up parameters
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
        get a default model
        :return:
        """
        self.model = LogisticRegression(random_state=RANDOM_STATE)

    def optimization(self):
        """
        perform grid search for optimized parameters
        :return:
        """
        self.get_default_model()
        self.best_params, self.best_scores = search(self.model, self.get_model_name(), self.X, self.y, self.params)

    def get_model_name(self):
        """
        get optimized parameters
        :return:
        """
        return self.model_name

    def get_best_model(self):
        """
        get optmized model
        :return:
        """
        self.optimization()
        return LogisticRegression(random_state=RANDOM_STATE, **self.best_params)