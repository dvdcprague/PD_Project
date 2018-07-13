-- ***************************************************************************
-- GOAL
-- Aggregate events into features of patient and generate training, testing data for Parkinson's Disease prediction.
-- ***************************************************************************


-- ***************************************************************************
-- 1. Load data
-- ***************************************************************************

-- load patient file
patients = LOAD '../../data/enrolled_patients.csv' USING PigStorage(',') AS (recordId:chararray, patientNo:chararray, diagnosis:chararray, age:int, gender:chararray);

-- select required columns from patients to merge lab results
patients = FOREACH patients GENERATE patientNo;

-- load lab results file
labEvents = LOAD '../../data/Biospecimen_Analysis_Results.csv' USING PigStorage(',') as (patientNo: chararray, gender: chararray, diagnosis:chararray, clinicalEvent: chararray, testType:chararray, testName:chararray, testValue:chararray, units:chararray, runDate:chararray, projectID:chararray, PIName:chararray, PIInstitute:chararray, updateStamp:chararray);

-- select required columns from labEvents
labEvents = FOREACH labEvents GENERATE REPLACE(patientNo, '\\"', '') AS patientNo, REPLACE(clinicalEvent, '\\"', '') AS clinicalEvent, REPLACE(testType, '\\"', '') AS testType, REPLACE(testName, '\\"', '') AS testName, REPLACE(testValue, '\\"', '') AS testValue;


-- Merge lab results with enrolled patients to get data for study
labEvents_merged = JOIN patients by patientNo, labEvents by patientNo;
labEvents_merged = FOREACH labEvents_merged GENERATE patients::patientNo AS patientNo, labEvents::clinicalEvent AS clinicalEvent, labEvents::testType AS testType, labEvents::testName AS testName, labEvents::testValue AS testValue;   

-- ***************************************************************************
-- 2. Clean data
-- ***************************************************************************
-- Convert all value to upper case
labEvents_merged = FOREACH labEvents_merged GENERATE UPPER(patientNo) AS patientNo, UPPER(clinicalEvent) AS clinicalEvent, UPPER(testType) AS testType, UPPER(testName) AS testName, UPPER(testValue) AS testValue;   


-- 2.1 Remove duplicated labels of gene names
labFiltered = FOREACH labEvents_merged GENERATE patientNo, clinicalEvent, testType, REPLACE(testName, '[\\\'\\(\\)]+', '') AS testName, testValue;
labFiltered = FOREACH labFiltered GENERATE patientNo, clinicalEvent, testType, REPLACE(testName, ' REP 1', '') AS testName, testValue;
labFiltered = FOREACH labFiltered GENERATE patientNo, clinicalEvent, testType, REPLACE(testName, ' REP 2', '') AS testName, testValue;


-- 2.2 Remove unconvertiable test values
labFiltered = FILTER labFiltered BY NOT (testValue MATCHES '.*ABOVE.*' OR testValue MATCHES '.*BELOW.*' OR testValue MATCHES '.*UNDETERMINED.*' OR testValue MATCHES '.*>.*' OR testValue MATCHES '.*<.*' OR testValue MATCHES '.*N/A.*');


-- 2.3 Remove data that are not collected by standard visits
labFiltered = FILTER labFiltered BY NOT (clinicalEvent MATCHES 'ST' OR clinicalEvent MATCHES 'U01');


-- 2.4 Convert test values from string to float
labFiltered = FOREACH labFiltered GENERATE patientNo, clinicalEvent, testType, testName, (FLOAT) testValue;


-- ***************************************************************************
-- 3. Feature construction
-- ***************************************************************************
-- 3.1 Get lab events present in all three categories of diagnosis (according to exploratory analysis, only CSF ALPHA-SYNUCLEIN and CSF HEMOGLOBIN present in all three categories of diagnosis, so let's filter out test type and test name based on that)
labProcessed = FILTER labFiltered BY (testType MATCHES 'CEREBROSPINAL FLUID' AND (testName MATCHES 'CSF ALPHA-SYNUCLEIN' OR testName MATCHES 'CSF HEMOGLOBIN'));


-- 3.2 Group lab events to get mean test values
grp = GROUP labProcessed BY (patientNo, clinicalEvent, testType, testName);
labProcessed= FOREACH grp GENERATE group.$0, group.$1, group.$2, group.$3, AVG(labProcessed.testValue) AS testValue;

-- 3.3 Generate features at each time points (visits)

featureGrp = GROUP labProcessed BY (testName, clinicalEvent);
featureList = FOREACH featureGrp GENERATE CONCAT(group.$0, '_', group.$1) AS featureName;
DUMP featureList;

-- Generate tables for each test at each time points

labProcessed_csf_bl = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'BL');
labProcessed_csf_bl_feature = FOREACH labProcessed_csf_bl GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_BL;

labProcessed_csf_01 = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'V01');
labProcessed_csf_01_feature = FOREACH labProcessed_csf_01 GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_V01;

labProcessed_csf_02 = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'V02');
labProcessed_csf_02_feature = FOREACH labProcessed_csf_02 GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_V02;

labProcessed_csf_04 = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'V04');
labProcessed_csf_04_feature = FOREACH labProcessed_csf_04 GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_V04;

labProcessed_csf_05 = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'V05');
labProcessed_csf_05_feature = FOREACH labProcessed_csf_05 GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_V05;

labProcessed_csf_06 = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'V06');
labProcessed_csf_06_feature = FOREACH labProcessed_csf_06 GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_V06;

labProcessed_csf_07 = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'V07');
labProcessed_csf_07_feature = FOREACH labProcessed_csf_07 GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_V07;

labProcessed_csf_08 = FILTER labProcessed BY(testName MATCHES 'CSF ALPHA-SYNUCLEIN' AND clinicalEvent MATCHES 'V08');
labProcessed_csf_08_feature = FOREACH labProcessed_csf_08 GENERATE patientNo, testValue AS ALPHA_SYNUCLEIN_V08;

labProcessed_hem_bl = FILTER labProcessed BY(testName MATCHES 'CSF HEMOGLOBIN' AND clinicalEvent MATCHES 'BL');
labProcessed_hem_bl_feature = FOREACH labProcessed_hem_bl GENERATE patientNo, testValue AS HEMOGLOBIN_BL;

labProcessed_hem_02 = FILTER labProcessed BY(testName MATCHES 'CSF HEMOGLOBIN' AND clinicalEvent MATCHES 'V02');
labProcessed_hem_02_feature = FOREACH labProcessed_hem_02 GENERATE patientNo, testValue AS HEMOGLOBIN_V02;

labProcessed_hem_04 = FILTER labProcessed BY(testName MATCHES 'CSF HEMOGLOBIN' AND clinicalEvent MATCHES 'V04');
labProcessed_hem_04_feature = FOREACH labProcessed_hem_04 GENERATE patientNo, testValue AS HEMOGLOBIN_V04;

labProcessed_hem_06 = FILTER labProcessed BY(testName MATCHES 'CSF HEMOGLOBIN' AND clinicalEvent MATCHES 'V06');
labProcessed_hem_06_feature = FOREACH labProcessed_hem_06 GENERATE patientNo, testValue AS HEMOGLOBIN_V06;

labProcessed_hem_08 = FILTER labProcessed BY(testName MATCHES 'CSF HEMOGLOBIN' AND clinicalEvent MATCHES 'V08');
labProcessed_hem_08_feature = FOREACH labProcessed_hem_08 GENERATE patientNo, testValue AS HEMOGLOBIN_V08;


-- Join tables

labTable1 = JOIN patients BY patientNo LEFT OUTER, labProcessed_csf_bl_feature by patientNo;
labFeatures = FOREACH labTable1 GENERATE patients::patientNo AS patientNo, labProcessed_csf_bl_feature::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL; 

labTable2 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_csf_01_feature by patientNo;
labFeatures = FOREACH labTable2 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labProcessed_csf_01_feature::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01; 

labTable3 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_csf_02_feature by patientNo;
labFeatures = FOREACH labTable3 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labProcessed_csf_02_feature::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02; 

labTable4 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_csf_04_feature by patientNo;
labFeatures = FOREACH labTable4 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labProcessed_csf_04_feature::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04; 

labTable5 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_csf_05_feature by patientNo;
labFeatures = FOREACH labTable5 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labProcessed_csf_05_feature::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05; 

labTable6 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_csf_06_feature by patientNo;
labFeatures = FOREACH labTable6 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labProcessed_csf_06_feature::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06; 

labTable7 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_csf_07_feature by patientNo;
labFeatures = FOREACH labTable7 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labFeatures::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06, labProcessed_csf_07_feature::ALPHA_SYNUCLEIN_V07 AS ALPHA_SYNUCLEIN_V07; 

labTable8 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_csf_08_feature by patientNo;
labFeatures = FOREACH labTable8 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labFeatures::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06, labFeatures::ALPHA_SYNUCLEIN_V07 AS ALPHA_SYNUCLEIN_V07, labProcessed_csf_08_feature::ALPHA_SYNUCLEIN_V08 AS ALPHA_SYNUCLEIN_V08; 

labTable9 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_hem_bl_feature by patientNo;
labFeatures = FOREACH labTable9 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labFeatures::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06, labFeatures::ALPHA_SYNUCLEIN_V07 AS ALPHA_SYNUCLEIN_V07, labFeatures::ALPHA_SYNUCLEIN_V08 AS ALPHA_SYNUCLEIN_V08, labProcessed_hem_bl_feature::HEMOGLOBIN_BL AS HEMOGLOBIN_BL; 

labTable10 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_hem_02_feature by patientNo;
labFeatures = FOREACH labTable10 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labFeatures::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06, labFeatures::ALPHA_SYNUCLEIN_V07 AS ALPHA_SYNUCLEIN_V07, labFeatures::ALPHA_SYNUCLEIN_V08 AS ALPHA_SYNUCLEIN_V08, labFeatures::HEMOGLOBIN_BL AS HEMOGLOBIN_BL, labProcessed_hem_02_feature::HEMOGLOBIN_V02 AS HEMOGLOBIN_V02; 

labTable11 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_hem_04_feature by patientNo;
labFeatures = FOREACH labTable11 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labFeatures::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06, labFeatures::ALPHA_SYNUCLEIN_V07 AS ALPHA_SYNUCLEIN_V07, labFeatures::ALPHA_SYNUCLEIN_V08 AS ALPHA_SYNUCLEIN_V08, labFeatures::HEMOGLOBIN_BL AS HEMOGLOBIN_BL, labFeatures::HEMOGLOBIN_V02 AS HEMOGLOBIN_V02, labProcessed_hem_04_feature::HEMOGLOBIN_V04 AS HEMOGLOBIN_V04; 

labTable12 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_hem_06_feature by patientNo;
labFeatures = FOREACH labTable12 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labFeatures::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06, labFeatures::ALPHA_SYNUCLEIN_V07 AS ALPHA_SYNUCLEIN_V07, labFeatures::ALPHA_SYNUCLEIN_V08 AS ALPHA_SYNUCLEIN_V08, labFeatures::HEMOGLOBIN_BL AS HEMOGLOBIN_BL, labFeatures::HEMOGLOBIN_V02 AS HEMOGLOBIN_V02, labFeatures::HEMOGLOBIN_V04 AS HEMOGLOBIN_V04, labProcessed_hem_06_feature::HEMOGLOBIN_V06 AS HEMOGLOBIN_V06;

labTable13 = JOIN labFeatures BY patientNo LEFT OUTER, labProcessed_hem_08_feature by patientNo;
labFeatures = FOREACH labTable13 GENERATE labFeatures::patientNo AS patientNo, labFeatures::ALPHA_SYNUCLEIN_BL AS ALPHA_SYNUCLEIN_BL, labFeatures::ALPHA_SYNUCLEIN_V01 AS ALPHA_SYNUCLEIN_V01, labFeatures::ALPHA_SYNUCLEIN_V02 AS ALPHA_SYNUCLEIN_V02, labFeatures::ALPHA_SYNUCLEIN_V04 AS ALPHA_SYNUCLEIN_V04, labFeatures::ALPHA_SYNUCLEIN_V05 AS ALPHA_SYNUCLEIN_V05, labFeatures::ALPHA_SYNUCLEIN_V06 AS ALPHA_SYNUCLEIN_V06, labFeatures::ALPHA_SYNUCLEIN_V07 AS ALPHA_SYNUCLEIN_V07, labFeatures::ALPHA_SYNUCLEIN_V08 AS ALPHA_SYNUCLEIN_V08, labFeatures::HEMOGLOBIN_BL AS HEMOGLOBIN_BL, labFeatures::HEMOGLOBIN_V02 AS HEMOGLOBIN_V02, labFeatures::HEMOGLOBIN_V04 AS HEMOGLOBIN_V04, labFeatures::HEMOGLOBIN_V06 AS HEMOGLOBIN_V06, labProcessed_hem_08_feature::HEMOGLOBIN_V08 AS HEMOGLOBIN_V08;

labFeatures = FILTER labFeatures BY (patientNo != 'patient_no');


-- 3.4 Impute missing values with mean for each feature
grp = GROUP labFeatures ALL;
avg = FOREACH grp GENERATE AVG(grp.$1.$1) AS avg1, AVG(grp.$1.$2) AS avg2, AVG(grp.$1.$3) AS avg3, AVG(grp.$1.$4) AS avg4, AVG(grp.$1.$5) AS avg5, AVG(grp.$1.$6) AS avg6, AVG(grp.$1.$7) AS avg7, AVG(grp.$1.$8) AS avg8, AVG(grp.$1.$9) AS avg9, AVG(grp.$1.$10) AS avg10, AVG(grp.$1.$11) AS avg11, AVG(grp.$1.$12) AS avg12, AVG(grp.$1.$13) AS avg13;

labFeatures = FOREACH labFeatures GENERATE patientNo,
((ALPHA_SYNUCLEIN_BL IS NULL) ? (DOUBLE)avg.avg1 : ALPHA_SYNUCLEIN_BL) AS ALPHA_SYNUCLEIN_BL, 
((ALPHA_SYNUCLEIN_V01 IS NULL) ? (DOUBLE)avg.avg2 : ALPHA_SYNUCLEIN_V01) AS ALPHA_SYNUCLEIN_V01, 
((ALPHA_SYNUCLEIN_V02 IS NULL) ? (DOUBLE)avg.avg3 : ALPHA_SYNUCLEIN_V02) AS ALPHA_SYNUCLEIN_V02, 
((ALPHA_SYNUCLEIN_V04 IS NULL) ? (DOUBLE)avg.avg4 : ALPHA_SYNUCLEIN_V04) AS ALPHA_SYNUCLEIN_V04, 
((ALPHA_SYNUCLEIN_V05 IS NULL) ? (DOUBLE)avg.avg5 : ALPHA_SYNUCLEIN_V05) AS ALPHA_SYNUCLEIN_V05, 
((ALPHA_SYNUCLEIN_V06 IS NULL) ? (DOUBLE)avg.avg6 : ALPHA_SYNUCLEIN_V06) AS ALPHA_SYNUCLEIN_V06, 
((ALPHA_SYNUCLEIN_V07 IS NULL) ? (DOUBLE)avg.avg7 : ALPHA_SYNUCLEIN_V07) AS ALPHA_SYNUCLEIN_V07, 
((ALPHA_SYNUCLEIN_V08 IS NULL) ? (DOUBLE)avg.avg8 : ALPHA_SYNUCLEIN_V08) AS ALPHA_SYNUCLEIN_V08, 
((HEMOGLOBIN_BL IS NULL) ? (DOUBLE)avg.avg9 : HEMOGLOBIN_BL) AS HEMOGLOBIN_BL, 
((HEMOGLOBIN_V02 IS NULL) ? (DOUBLE)avg.avg10 : HEMOGLOBIN_V02) AS HEMOGLOBIN_V02, 
((HEMOGLOBIN_V04 IS NULL) ? (DOUBLE)avg.avg11 : HEMOGLOBIN_V04) AS HEMOGLOBIN_V04, 
((HEMOGLOBIN_V06 IS NULL) ? (DOUBLE)avg.avg12 : HEMOGLOBIN_V06) AS HEMOGLOBIN_V06, 
((HEMOGLOBIN_V08 IS NULL) ? (DOUBLE)avg.avg13 : HEMOGLOBIN_V08) AS HEMOGLOBIN_V08; 

-- 3.5 Normalize features using min-max normalization
maxValues = FOREACH grp GENERATE MAX(grp.$1.$1) AS max1, MAX(grp.$1.$2) AS max2, MAX(grp.$1.$3) AS max3, MAX(grp.$1.$4) AS max4, MAX(grp.$1.$5) AS max5, MAX(grp.$1.$6) AS max6, MAX(grp.$1.$7) AS max7, MAX(grp.$1.$8) AS max8, MAX(grp.$1.$9) AS max9, MAX(grp.$1.$10) AS max10, MAX(grp.$1.$11) AS max11, MAX(grp.$1.$12) AS max12, MAX(grp.$1.$13) AS max13;

labFeatures = FOREACH labFeatures GENERATE patientNo,
ALPHA_SYNUCLEIN_BL/maxValues.max1 AS ALPHA_SYNUCLEIN_BL_norm,
ALPHA_SYNUCLEIN_V01/maxValues.max2 AS ALPHA_SYNUCLEIN_V01_norm,
ALPHA_SYNUCLEIN_V02/maxValues.max3 AS ALPHA_SYNUCLEIN_V02_norm,
ALPHA_SYNUCLEIN_V04/maxValues.max4 AS ALPHA_SYNUCLEIN_V04_norm,
ALPHA_SYNUCLEIN_V05/maxValues.max5 AS ALPHA_SYNUCLEIN_V05_norm,
ALPHA_SYNUCLEIN_V06/maxValues.max6 AS ALPHA_SYNUCLEIN_V06_norm,
ALPHA_SYNUCLEIN_V07/maxValues.max7 AS ALPHA_SYNUCLEIN_V07_norm,
ALPHA_SYNUCLEIN_V08/maxValues.max8 AS ALPHA_SYNUCLEIN_V08_norm,
HEMOGLOBIN_BL/maxValues.max9 AS HEMOGLOBIN_BL_norm,
HEMOGLOBIN_V02/maxValues.max10 AS HEMOGLOBIN_V02_norm,
HEMOGLOBIN_V04/maxValues.max11 AS HEMOGLOBIN_V04_norm,
HEMOGLOBIN_V06/maxValues.max12 AS HEMOGLOBIN_V06_norm,
HEMOGLOBIN_V08/maxValues.max13 AS HEMOGLOBIN_V08_norm;

-- 3.6 Reorder features
f1 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_BL' AS featureName, ALPHA_SYNUCLEIN_BL_norm;
f2 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_V01' AS featureName, ALPHA_SYNUCLEIN_V01_norm;
f3 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_V02' AS featureName, ALPHA_SYNUCLEIN_V02_norm;
f4 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_V04' AS featureName, ALPHA_SYNUCLEIN_V04_norm;
f5 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_V05' AS featureName, ALPHA_SYNUCLEIN_V05_norm;
f6 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_V06' AS featureName, ALPHA_SYNUCLEIN_V06_norm;
f7 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_V07' AS featureName, ALPHA_SYNUCLEIN_V07_norm;
f8 = FOREACH labFeatures GENERATE patientNo, 'ALPHA_SYNUCLEIN_V08' AS featureName, ALPHA_SYNUCLEIN_V08_norm;
f9 = FOREACH labFeatures GENERATE patientNo, 'HEMOGLOBIN_BL' AS featureName, HEMOGLOBIN_BL_norm;
f10 = FOREACH labFeatures GENERATE patientNo,'HEMOGLOBIN_V02' AS featureName, HEMOGLOBIN_V02_norm;
f11 = FOREACH labFeatures GENERATE patientNo, 'HEMOGLOBIN_V04' AS featureName, HEMOGLOBIN_V04_norm;
f12 = FOREACH labFeatures GENERATE patientNo, 'HEMOGLOBIN_V06' AS featureName, HEMOGLOBIN_V06_norm;
f13 = FOREACH labFeatures GENERATE patientNo, 'HEMOGLOBIN_V08' AS featureName, HEMOGLOBIN_V08_norm;

labFeaturesOrder = UNION f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13;

-- 3.7 Save data
STORE labFeatures INTO '../../data/labFeatures.csv' USING PigStorage(',');
STORE labFeaturesOrder INTO '../../data/labFeaturesOrder.csv' USING PigStorage(',');

