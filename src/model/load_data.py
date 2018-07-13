import logging
import time

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder

from const import RANDOM_STATE, EXCLUDE_HY_INDEX, PER_FIX, EXCLUDE_COLS


class loadData():
    """
    class to load input data
    """

    def __init__(self, file_names):
        """
        setup input file names
        :param file_names: a list of string
        """
        self.file_names = file_names

    def load_clinical_data(self):
        """
        function to load clinical features
        :return:
        """
        try:
            self.clinicl_df = pd.read_csv(self.file_names["clinical_data"])
            self.clinicl_df = self.clinicl_df.astype(np.float64)
            logging.info("processing clinical data")
        except IOError:
            logging.debug("Incorrect clinical file name")

    def load_lab_data(self):
        """
        function to load lab features
        :return:
        """
        try:
            self.lab_df = pd.read_csv(self.file_names["lab_data"], header=None)
            # rename column names
            self.lab_df.columns = ["patient_no", "ALPHA_SYNUCLEIN_BL", "ALPHA_SYNUCLEIN_V01",
                                   "ALPHA_SYNUCLEIN_V02", "ALPHA_SYNUCLEIN_V04",
                                   "ALPHA_SYNUCLEIN_V05", "ALPHA_SYNUCLEIN_V06",
                                   "ALPHA_SYNUCLEIN_V07", "ALPHA_SYNUCLEIN_V08",
                                   "HEMOGLOBIN_BL", "HEMOGLOBIN_V02", "HEMOGLOBIN_V04",
                                   "HEMOGLOBIN_V06", "HEMOGLOBIN_V08"]
            self.lab_df = self.lab_df.astype(np.float64)
            logging.info("processing lab data")
        except IOError:
            logging.debug("Incorrect lab file name")

    def load_imaging_data(self):
        """
        function to load imaging features
        :return:
        """
        try:
            self.imaging_df = pd.read_csv(self.file_names["imaging_data"])
            self.imaging_df = self.imaging_df.rename(columns={"PATNO": "patient_no"})
            self.imaging_df = self.imaging_df.astype(np.float64)
            logging.info("processing imaging data")
        except IOError:
            logging.debug("Incorrect imaging date file name")

    def split_train_test(self, trn_data_path, tst_data_path, cols_to_norm=None, is_norm=False, ex_cols=None):
        """
        function used to split data into 80% train and 20% test data

        :param trn_data_path: String: train data path
        :param tst_data_path: String: test data path
        :param cols_to_norm: a list of column names to apply normalization
        :param is_norm: boolean to determine whether to normalize features
        :param ex_cols: a list of features to exclude
        :return: save train and test data as csv file
        """
        # load features
        self.load_clinical_data()
        self.load_lab_data()
        self.load_imaging_data()
        # merge features
        df_merged = self.clinicl_df.merge(self.lab_df, on=["patient_no"], how="left")
        df_merged = df_merged.merge(self.imaging_df, on=["patient_no"], how="left")
        lbl = LabelEncoder()
        # transform labels to 0, 1 and 2
        label = lbl.fit_transform(df_merged["diagnosis"])
        logging.debug("labels: {}".format(label))
        # drop index and target labels
        df_merged.drop(["patient_no", "diagnosis"], axis=1, inplace=True)
        if ex_cols:
            # drop excluded features
            df_merged.drop(ex_cols, axis=1, inplace=True)
        logging.debug("Feature names: {}".format(df_merged.columns))
        if is_norm and cols_to_norm is not None:
            for col in cols_to_norm:
                df_merged[col] = df_merged[col] / df_merged[col].max()
        # split train/test data
        X_train, X_test, y_train, y_test = train_test_split(df_merged.values, label,
                                                            test_size=0.20, random_state=RANDOM_STATE)
        logging.info("train labels: {}".format(y_train))
        logging.info("test labels: {}".format(y_test))
        # save splited train and test data
        np.savez(trn_data_path, X_train=X_train, y_train=y_train)
        np.savez(tst_data_path, X_test=X_test, y_test=y_test)


if __name__ == "__main__":

    logging.basicConfig(level=logging.DEBUG,
                        format="%(asctime)s %(levelname)s %(message)s",
                        filename="load_data.log",
                        filemode="w")

    if EXCLUDE_HY_INDEX:
        logging.info("\n\n=========Load data without Hoehn-Yahr index and updrs_3_scores features=========\n\n")
        print "\n\n=========Load data without Hoehn-Yahr index and updrs_3_scores features=========\n\n"
    else:
        logging.info("\n\n=========Load data with all features=========\n\n")
        print "\n\n=========Load data with all features=========\n\n"

    file_names = {"clinical_data": "../../data/enrolled_clinical_features_imputed.csv",
                  "lab_data": "../../data/labFeatures.csv",
                  "imaging_data": "../../data/MRI and DatScan.csv"}
    # load data
    load_data = loadData(file_names)
    trn_data_path = "../../data/" + PER_FIX + "train.npz"
    tst_data_path = "../../data/" + PER_FIX + "test.npz"

    start = time.time()
    # exclude Hoehn-Yahr index if EXCLUDE_HY_INDEX is True, change this value to False if include all features
    if EXCLUDE_HY_INDEX:
        load_data.split_train_test(trn_data_path=trn_data_path, tst_data_path=tst_data_path, ex_cols=EXCLUDE_COLS)
    else:
        load_data.split_train_test(trn_data_path=trn_data_path, tst_data_path=tst_data_path)
    logging.info("Completed with {} seconds".format(time.time() - start))
