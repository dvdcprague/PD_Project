from sklearn.ensemble import AdaBoostClassifier

from const import RANDOM_STATE
from grid_search import search


class adaBoost(object):
    """
    class for ada boost algorithm
    """

    def __init__(self, params, X, y, model_name="Ada Boost"):
        """
        setup parameters
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
        function to get a default model
        :return:
        """
        self.model = AdaBoostClassifier(random_state=RANDOM_STATE)

    def optimization(self):
        """
        function to perform grid search of best parameters
        :return:
        """
        self.get_default_model()
        self.best_params, self.best_scores = search(self.model, self.get_model_name(), self.X, self.y, self.params)

    def get_model_name(self):
        """
        get model name
        :return:
        """
        return self.model_name

    def get_best_model(self):
        """
        get optimized model
        :return:
        """
        self.optimization()
        return AdaBoostClassifier(random_state=RANDOM_STATE, **self.best_params)
