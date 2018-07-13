# define consts used in other classes
RANDOM_STATE = 42
N_CLASS = 3
CLASS_NAME = ["PD", "Healthy Control", "Prodromal"]

# exclude Hoehn-Yahr index and updrs_3_score if EXCLUDE_HY_INDEX is True. This value can be changed to False in order
# to include all features
EXCLUDE_HY_INDEX = False
PER_FIX = ""
EXCLUDE_COLS = None 
if EXCLUDE_HY_INDEX:
    EXCLUDE_COLS = ["updrs_3_score", "hy"]
    PER_FIX = "Exclude_" + "_".join(EXCLUDE_COLS) + "_"
   
