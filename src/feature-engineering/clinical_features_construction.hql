-- ***************************************************************************
-- Loading Data:
-- create external table mapping for different tables
******************************************************
-- create screen table
DROP TABLE IF EXISTS screen;
CREATE EXTERNAL TABLE screen (
  REC_ID STRING,
  F_STATUS STRING,
  PATNO STRING,
  EVENT_ID STRING,
  PAG_NAME STRING,
  SIGNCNST STRING,
  CONSNTDT STRING,
  APPRDX INT,
  CURRENT_APPRDX STRING,
  BIRTHDT DOUBLE,
  GENDER INT,
  HISPLAT INT,
  RAINDALS INT,
  RAASIAN INT,
  RABLACK INT,
  RAHAWOPI INT,
  RAWHITE INT,
  RANOS INT,
  PRJENRDT STRING,
  REFERRAL STRING,
  DECLINED STRING,
  RSNDEC STRING,
  EXCLUDED STRING,
  RSNEXC STRING,
  ORIG_ENTRY STRING,
  LAST_UPDATE STRING,
  QUERY STRING,
  SITE_APRV STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE
 LOCATION '/input/screen';

-- create random table
DROP TABLE IF EXISTS random;
CREATE EXTERNAL TABLE random (
  REC_ID STRING,
  F_STATUS STRING,
  PATNO STRING,
  EVENT_ID STRING,
  PAG_NAME STRING,
  INFODT STRING,
  ENROLLDT STRING,
  BIRTHDT STRING,
  GENDER INT,
  ORIG_ENTRY STRING,
  LAST_UPDATE STRING,
  QUERY STRING,
  SITE_APRV STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE
 LOCATION '/input/random';



-- create motor_hy table 
DROP TABLE IF EXISTS motor_hy;
CREATE EXTERNAL TABLE motor_hy (
  REC_ID STRING,
  F_STATUS STRING,
  PATNO STRING,
  EVENT_ID STRING,
  PAG_NAME STRING,
  INFODT STRING,
  CMEDTM STRING,
  EXAMTM STRING,
  NP3SPCH STRING,
  NP3FACXP STRING,
  NP3RIGN STRING,
  NP3RIGRU STRING,
  NP3RIGLU STRING,
  PN3RIGRL STRING,
  NP3RIGLL STRING,
  NP3FTAPR STRING,
  NP3FTAPL STRING,
  NP3HMOVR STRING,
  NP3HMOVL STRING,
  NP3PRSPR STRING,
  NP3PRSPL STRING,
  NP3TTAPR STRING,
  NP3TTAPL STRING,
  NP3LGAGR STRING,
  NP3LGAGL STRING,
  NP3RISNG STRING,
  NP3GAIT STRING,
  NP3FRZGT STRING,
  NP3PSTBL STRING,
  NP3POSTR STRING,
  NP3BRADY STRING,
  NP3PTRMR STRING,
  NP3PTRML STRING,
  NP3KTRMR STRING,
  NP3KTRML STRING,
  NP3RTARU STRING,
  NP3RTALU STRING,
  NP3RTARL STRING,
  NP3RTALL STRING,
  NP3RTALJ STRING,
  NP3RTCON STRING,
  DYSKPRES STRING,
  DYSKIRAT STRING,
  NHY STRING,
  ANNUAL_TIME_BTW_DOSE_NUP STRING,
  ON_OFF_DOSE STRING,
  PD_MED_USE STRING,
  ORIG_ENTRY STRING,
  LAST_UPDATE STRING,
  QUERY STRING,
  SITE_APRV STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE
 LOCATION '/input/motor_hy';
 
 DROP TABLE IF EXISTS updrs_1;
 CREATE EXTERNAL TABLE updrs_1 (
  REC_ID STRING,
  F_STATUS STRING,
  PATNO STRING,
  EVENT_ID STRING,
  PAG_NAME STRING,
  INFODT STRING,
  NUPSOURC STRING,
  NP1COG STRING,
  NP1HALL STRING,
  NP1DPRS STRING,
  NP1ANXS STRING,
  NP1APAT STRING,
  NP1DDS STRING,
  ORIG_ENTRY STRING,
  LAST_UPDATE STRING,
  QUERY STRING,
  SITE_APRV STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE
 LOCATION '/input/updrs_1';
 
 DROP TABLE IF EXISTS updrs_1_q;
 CREATE EXTERNAL TABLE updrs_1_q (
  REC_ID STRING,
  F_STATUS STRING,
  PATNO STRING,
  EVENT_ID STRING,
  PAG_NAME STRING,
  INFODT STRING,
  NUPSOURC STRING,
  NP1SLPN STRING,
  NP1SLPD STRING,
  NP1PAIN STRING,
  NP1URIN STRING,
  NP1CNST STRING,
  NP1LTHD STRING,
  NP1FATG STRING,
  ORIG_ENTRY STRING,
  LAST_UPDATE STRING,
  QUERY STRING,
  SITE_APRV STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE
 LOCATION '/input/updrs_1_q';
 
 DROP TABLE IF EXISTS updrs_2;
 CREATE EXTERNAL TABLE updrs_2 (
  REC_ID STRING,
  F_STATUS STRING,
  PATNO STRING,
  EVENT_ID STRING,
  PAG_NAME STRING,
  INFODT STRING,
  NUPSOURC STRING,
  NP2SPCH STRING,
  NP2SALV STRING,
  NP2SWAL STRING,
  NP2EAT STRING,
  NP2DRES STRING,
  NP2HYGN STRING,
  NP2HWRT STRING,
  NP2HOBB STRING,
  NP2TURN STRING,
  NP2TRMR STRING,
  NP2RISE STRING,
  NP2WALK STRING,
  NP2FREZ STRING,
  ORIG_ENTRY STRING,
  LAST_UPDATE STRING,
  QUERY STRING,
  SITE_APRV STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE
 LOCATION '/input/updrs_2';
 
 DROP TABLE IF EXISTS updrs_4;
 CREATE EXTERNAL TABLE updrs_4 (
  REC_ID STRING,
  F_STATUS STRING,
  PATNO STRING,
  EVENT_ID STRING,
  PAG_NAME STRING,
  INFODT STRING,
  NP4WDYSK STRING,
  NP4DYSKI STRING,
  NP4OFF STRING,
  NP4FLCTI STRING,
  NP4FLCTX STRING,
  NP4DYSTN STRING,
  ORIG_ENTRY STRING,
  LAST_UPDATE STRING,
  QUERY STRING,
  SITE_APRV STRING)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
 STORED AS TEXTFILE
 LOCATION '/input/updrs_4';
 
 DROP TABLE IF EXISTS motor_adl;
 CREATE EXTERNAL TABLE motor_adl(
  rec_id string, 
  f_status string, 
  patno string, 
  event_id string, 
  pag_name string, 
  infodt string, 
  adl string, 
  orig_entry string, 
  last_update string, 
  query string, 
  site_aprv string)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE
 LOCATION '/input/motor_adl';
 
 DROP TABLE IF EXISTS gds;
 CREATE EXTERNAL TABLE gds(
  rec_id string, 
  f_status string, 
  patno string, 
  event_id string, 
  pag_name string, 
  infodt string, 
  gdssatis string, 
  gdsdropd string, 
  gdsempty string, 
  gdsbored string, 
  gdsgspir string, 
  gdsafrad string, 
  gdshappy string, 
  gdshlpls string, 
  gdshome string, 
  gdsmemry string, 
  gdsalive string, 
  gdswrtls string, 
  gdsenrgy string, 
  gdshopls string, 
  gdsbeter string, 
  orig_entry string, 
  last_update string, 
  query string, 
  site_aprv string)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE
 LOCATION '/input/gds';
 
 DROP TABLE IF EXISTS moca;
 CREATE EXTERNAL TABLE moca(
  rec_id string, 
  f_status string, 
  patno string, 
  event_id string, 
  pag_name string, 
  infodt string, 
  mcaalttm string, 
  mcacube string, 
  mcaclckc string, 
  mcaclckn string, 
  mcaclckh string, 
  mcalion string, 
  mcarhino string, 
  mcacamel string, 
  mcafdss string, 
  mcabds string, 
  mcavigil string, 
  mcaser7 string, 
  mcasntnc string, 
  mcavfnum string, 
  mcavf string, 
  mcaabstr string, 
  mcarec1 string, 
  mcarec2 string, 
  mcarec3 string, 
  mcarec4 string, 
  mcarec5 string, 
  mcadate string, 
  mcamonth string, 
  mcayr string, 
  mcaday string, 
  mcaplace string, 
  mcacity string, 
  mcatot string, 
  orig_entry string, 
  last_update string, 
  query string, 
  site_aprv string)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE
 LOCATION '/input/moca';
 
 DROP TABLE IF EXISTS scopa;
 CREATE EXTERNAL TABLE scopa(
  rec_id string, 
  f_status string, 
  patno string, 
  event_id string, 
  pag_name string, 
  infodt string, 
  ptcgboth string, 
  scau1 string, 
  scau2 string, 
  scau3 string, 
  scau4 string, 
  scau5 string, 
  scau6 string, 
  scau7 string, 
  scau8 string, 
  scau9 string, 
  scau10 string, 
  scau11 string, 
  scau12 string, 
  scau13 string, 
  scau14 string, 
  scau15 string, 
  scau16 string, 
  scau17 string, 
  scau18 string, 
  scau19 string, 
  scau20 string, 
  scau21 string, 
  scau22 string, 
  scau23 string, 
  scau23a string, 
  scau23at string, 
  scau24 string, 
  scau25 string, 
  scau26a string, 
  scau26at string, 
  scau26b string, 
  scau26bt string, 
  scau26c string, 
  scau26ct string, 
  scau26d string, 
  scau26dt string, 
  orig_entry string, 
  last_update string, 
  query string, 
  site_aprv string)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE
 LOCATION '/input/scopa';
 
 DROP TABLE IF EXISTS epworth;
 CREATE EXTERNAL TABLE epworth(
  rec_id string, 
  f_status string, 
  patno string, 
  event_id string, 
  pag_name string, 
  infodt string, 
  ptcgboth string, 
  ess1 string, 
  ess2 string, 
  ess3 string, 
  ess4 string, 
  ess5 string, 
  ess6 string, 
  ess7 string, 
  ess8 string, 
  orig_entry string, 
  last_update string, 
  query string, 
  site_aprv string)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE
 LOCATION '/input/epworth';
 
 DROP TABLE IF EXISTS upsit;
 CREATE EXTERNAL TABLE upsit(
  rec_id string, 
  f_status string, 
  patno string, 
  event_id string, 
  pag_name string, 
  infodt string, 
  upsitbk1 string, 
  upsitbk2 string, 
  upsitbk3 string, 
  upsitbk4 string, 
  normative_score string, 
  comm string, 
  orig_entry string, 
  last_update string, 
  query string, 
  site_aprv string)
 ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE
 LOCATION '/input/upsit';
 
 
 
 
 
-- ******************************************************
-- generate enrolled subjects
-- ******************************************************
DROP VIEW IF EXISTS enrolled;
CREATE VIEW enrolled
AS
SELECT screen.rec_id AS record_id, screen.patno AS patient_no, screen.apprdx AS diagnosis, screen.birthdt AS birthday, screen.gender AS gender, random.enrolldt AS enroll_date
FROM screen INNER JOIN random
ON (screen.patno = random.patno)
WHERE random.enrolldt != '';

DROP VIEW IF EXISTS enroll;
CREATE VIEW enroll
AS
SELECT enrolled.record_id, enrolled.patient_no, enrolled.diagnosis, (CAST(regexp_replace(enrolled.enroll_date, '(.*)-', '20') AS DOUBLE) - enrolled.birthday) AS age, enrolled.gender
FROM enrolled
WHERE enrolled.diagnosis = 1 OR enrolled.diagnosis = 2 OR enrolled.diagnosis = 4;


-- ******************************************************
-- convert relevant columns to INT from string
-- ******************************************************

DROP VIEW IF EXISTS motor_hy_new;
CREATE VIEW motor_hy_new
AS
SELECT regexp_replace(PATNO,'\\"','') AS patient_no, regexp_replace(NHY,'\\"','') AS hy, (CAST(regexp_replace(NP3SPCH,'\\"','') AS INT) + CAST(regexp_replace(NP3FACXP,'\\"','') AS INT) + CAST(regexp_replace(NP3RIGN,'\\"','') AS INT) + CAST(regexp_replace(NP3RIGRU,'\\"','') AS INT) + CAST(regexp_replace(NP3RIGLU,'\\"','') AS INT) + CAST(regexp_replace(PN3RIGRL,'\\"','') AS INT) + CAST(regexp_replace(NP3RIGLL,'\\"','') AS INT) + CAST(regexp_replace(NP3FTAPR,'\\"','') AS INT) + CAST(regexp_replace(NP3FTAPL,'\\"','') AS INT) + CAST(regexp_replace(NP3HMOVR,'\\"','') AS INT) + CAST(regexp_replace(NP3HMOVL,'\\"','') AS INT) + CAST(regexp_replace(NP3PRSPR,'\\"','') AS INT) + CAST(regexp_replace(NP3PRSPL,'\\"','') AS INT) + CAST(regexp_replace(NP3TTAPR,'\\"','') AS INT) + CAST(regexp_replace(NP3TTAPL,'\\"','') AS INT) + CAST(regexp_replace(NP3LGAGR,'\\"','') AS INT) + CAST(regexp_replace(NP3LGAGL,'\\"','') AS INT) + CAST(regexp_replace(NP3RISNG,'\\"','') AS INT) + CAST(regexp_replace(NP3GAIT,'\\"','') AS INT) + CAST(regexp_replace(NP3FRZGT,'\\"','') AS INT) + CAST(regexp_replace(NP3PSTBL,'\\"','') AS INT) + CAST(regexp_replace(NP3POSTR,'\\"','') AS INT) + CAST(regexp_replace(NP3BRADY,'\\"','') AS INT) + CAST(regexp_replace(NP3PTRMR,'\\"','') AS INT) + CAST(regexp_replace(NP3PTRML,'\\"','') AS INT) + CAST(regexp_replace(NP3KTRMR,'\\"','') AS INT) + CAST(regexp_replace(NP3KTRML,'\\"','') AS INT) + CAST(regexp_replace(NP3RTARU,'\\"','') AS INT) + CAST(regexp_replace(NP3RTALU,'\\"','') AS INT) + CAST(regexp_replace(NP3RTARL,'\\"','') AS INT) + CAST(regexp_replace(NP3RTALL,'\\"','') AS INT) + CAST(regexp_replace(NP3RTALJ,'\\"','') AS INT) + CAST(regexp_replace(NP3RTCON,'\\"','') AS INT)) AS updrs_3_score
FROM motor_hy;

DROP VIEW IF EXISTS updrs_1_new;
CREATE VIEW updrs_1_new
AS
SELECT regexp_replace(PATNO,'\\"','') AS patient_no, (CAST(regexp_replace(NP1COG,'\\"','') AS INT) + CAST(regexp_replace(NP1HALL,'\\"','') AS INT) + CAST(regexp_replace(NP1DPRS,'\\"','') AS INT) + CAST(regexp_replace(NP1ANXS,'\\"','') AS INT) + CAST(regexp_replace(NP1APAT,'\\"','') AS INT) + CAST(regexp_replace(NP1DDS,'\\"','') AS INT)) AS updrs_1_score
FROM updrs_1;

DROP VIEW IF EXISTS updrs_1_q_new;
CREATE VIEW updrs_1_q_new
AS
SELECT regexp_replace(PATNO,'\\"','') AS patient_no, (CAST(regexp_replace(NP1SLPN,'\\"','') AS INT) + CAST(regexp_replace(NP1SLPD,'\\"','') AS INT) + CAST(regexp_replace(NP1PAIN,'\\"','') AS INT) + CAST(regexp_replace(NP1URIN,'\\"','') AS INT) + CAST(regexp_replace(NP1CNST,'\\"','') AS INT) + CAST(regexp_replace(NP1LTHD,'\\"','') AS INT) + CAST(regexp_replace(NP1FATG,'\\"','') AS INT)) AS updrs_1_q_score
FROM updrs_1_q;

DROP VIEW IF EXISTS updrs_2_new;
CREATE VIEW updrs_2_new
AS
SELECT regexp_replace(PATNO,'\\"','') AS patient_no, (CAST(regexp_replace(NP2SPCH,'\\"','') AS INT) + CAST(regexp_replace(NP2SALV,'\\"','') AS INT) + CAST(regexp_replace(NP2SWAL,'\\"','') AS INT) + CAST(regexp_replace(NP2EAT,'\\"','') AS INT) + CAST(regexp_replace(NP2DRES,'\\"','') AS INT) + CAST(regexp_replace(NP2HYGN,'\\"','') AS INT) + CAST(regexp_replace(NP2HWRT,'\\"','') AS INT) + CAST(regexp_replace(NP2HOBB,'\\"','') AS INT) + CAST(regexp_replace(NP2TURN,'\\"','') AS INT) + CAST(regexp_replace(NP2TRMR,'\\"','') AS INT) + CAST(regexp_replace(NP2RISE,'\\"','') AS INT) + CAST(regexp_replace(NP2WALK,'\\"','') AS INT) + CAST(regexp_replace(NP2FREZ,'\\"','') AS INT)) AS updrs_2_score
FROM updrs_2;

DROP VIEW IF EXISTS updrs_4_new;
CREATE VIEW updrs_4_new
AS
SELECT regexp_replace(PATNO,'\\"','') AS patient_no, (CAST(regexp_replace(NP4WDYSK,'\\"','') AS INT) + CAST(regexp_replace(NP4DYSKI,'\\"','') AS INT) + CAST(regexp_replace(NP4OFF,'\\"','') AS INT) + CAST(regexp_replace(NP4FLCTI,'\\"','') AS INT) + CAST(regexp_replace(NP4FLCTX,'\\"','') AS INT) + CAST(regexp_replace(NP4DYSTN,'\\"','') AS INT)) AS updrs_4_score
FROM updrs_4;

DROP VIEW IF EXISTS motor_adl_new;
CREATE VIEW motor_adl_new 
AS 
SELECT regexp_replace(motor_adl.patno,'\\"','') AS patient_no, regexp_replace(motor_adl.adl,'\\"','') AS adl
FROM motor_adl;

DROP VIEW IF EXISTS gds_new;
CREATE VIEW gds_new 
AS 
SELECT regexp_replace(gds.patno,'\\"','') AS patient_no, (CAST(regexp_replace(gds.gdssatis,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsdropd,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsempty,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsbored,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsgspir,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsafrad,'\\"','') AS INT) + CAST(regexp_replace(gds.gdshappy,'\\"','') AS INT) + CAST(regexp_replace(gds.gdshlpls,'\\"','') AS INT) + CAST(regexp_replace(gds.gdshome,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsmemry,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsalive,'\\"','') AS INT) + CAST(regexp_replace(gds.gdswrtls,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsenrgy,'\\"','') AS INT) + CAST(regexp_replace(gds.gdshopls,'\\"','') AS INT) + CAST(regexp_replace(gds.gdsbeter,'\\"','') AS INT)) AS gds_score
FROM gds;

DROP VIEW IF EXISTS moca_new;
CREATE VIEW moca_new 
AS 
SELECT regexp_replace(moca.patno,'\\"','') AS patient_no, regexp_replace(moca.mcatot,'\\"','') AS moca_score
FROM moca;

DROP VIEW IF EXISTS scopa_new;
CREATE VIEW scopa_new 
AS 
SELECT regexp_replace(scopa.patno,'\\"','') AS patient_no, (CAST(regexp_replace(scopa.scau1,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau2,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau3,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau4,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau5,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau6,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau7,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau8,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau9,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau10,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau11,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau12,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau13,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau14,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau15,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau16,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau17,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau18,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau19,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau20,'\\"','') AS INT) + CAST(regexp_replace(scopa.scau21,'\\"','') AS INT)) AS scopa_score
FROM scopa;

DROP VIEW IF EXISTS epworth_new;
CREATE VIEW epworth_new 
AS 
SELECT regexp_replace(epworth.patno,'\\"','') AS patient_no, (CAST(regexp_replace(epworth.ess1,'\\"','') AS INT) + CAST(regexp_replace(epworth.ess2,'\\"','') AS INT) + CAST(regexp_replace(epworth.ess3,'\\"','') AS INT) + CAST(regexp_replace(epworth.ess4,'\\"','') AS INT) + CAST(regexp_replace(epworth.ess5,'\\"','') AS INT) + CAST(regexp_replace(epworth.ess6,'\\"','') AS INT) + CAST(regexp_replace(epworth.ess7,'\\"','') AS INT) + CAST(regexp_replace(epworth.ess8,'\\"','') AS INT)) AS epworth_score
FROM epworth;

DROP VIEW IF EXISTS upsit_new;
CREATE VIEW upsit_new 
AS 
SELECT regexp_replace(upsit.patno,'\\"','') AS patient_no, (CAST(regexp_replace(upsit.upsitbk1,'\\"','') AS INT) + CAST(regexp_replace(upsit.upsitbk2,'\\"','') AS INT) + CAST(regexp_replace(upsit.upsitbk3,'\\"','') AS INT) + CAST(regexp_replace(upsit.upsitbk4,'\\"','') AS INT)) AS upsit_score
FROM upsit;



DROP VIEW IF EXISTS enroll_hy;
CREATE VIEW enroll_hy
AS
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, CAST(motor_hy_new.hy AS INT) AS hy, motor_hy_new.updrs_3_score AS updrs_3_score
FROM enroll LEFT JOIN motor_hy_new;

DROP VIEW IF EXISTS enroll_updrs_1;
CREATE VIEW enroll_updrs_1
AS
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, (updrs_1_new.updrs_1_score + updrs_1_q_new.updrs_1_q_score) AS updrs_1_score
FROM enroll LEFT JOIN updrs_1_new ON (enroll.patient_no = updrs_1_new.patient_no) LEFT JOIN updrs_1_q_new ON (enroll.patient_no = updrs_1_q_new.patient_no);

DROP VIEW IF EXISTS enroll_updrs_2;
CREATE VIEW enroll_updrs_2
AS
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, updrs_2_new.updrs_2_score AS updrs_2_score
FROM enroll LEFT JOIN updrs_2_new
on (enroll.patient_no = updrs_2_new.patient_no);

DROP VIEW IF EXISTS enroll_updrs_4;
CREATE VIEW enroll_updrs_4
AS
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, updrs_4_new.updrs_4_score AS updrs_4_score
FROM enroll LEFT JOIN updrs_4_new
on (enroll.patient_no = updrs_4_new.patient_no);

DROP VIEW IF EXISTS enroll_adl;
CREATE VIEW enroll_adl 
AS 
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, CAST(motor_adl_new.adl AS INT) AS adl
FROM enroll LEFT JOIN motor_adl_new
on (enroll.patient_no = motor_adl_new.patient_no);

DROP VIEW IF EXISTS enroll_gds;
CREATE VIEW enroll_gds 
AS 
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, gds_new.gds_score AS gds_score
FROM enroll LEFT JOIN gds_new
on (enroll.patient_no = gds_new.patient_no);

DROP VIEW IF EXISTS enroll_moca;
CREATE VIEW enroll_moca 
AS 
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, CAST(moca_new.moca_score AS INT) AS moca_score
FROM enroll LEFT JOIN moca_new
on (enroll.patient_no = moca_new.patient_no);

DROP VIEW IF EXISTS enroll_scopa;
CREATE VIEW enroll_scopa 
AS 
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, scopa_new.scopa_score AS scopa_score
FROM enroll LEFT JOIN scopa_new
on (enroll.patient_no = scopa_new.patient_no);

DROP VIEW IF EXISTS enroll_epworth;
CREATE VIEW enroll_epworth
AS 
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, epworth_new.epworth_score AS epworth_score
FROM enroll LEFT JOIN epworth_new
on (enroll.patient_no = epworth_new.patient_no);

DROP VIEW IF EXISTS enroll_upsit;
CREATE VIEW enroll_upsit
AS 
SELECT enroll.record_id, enroll.patient_no, enroll.diagnosis, upsit_new.upsit_score AS upsit_score
FROM enroll LEFT JOIN upsit_new
on (enroll.patient_no = upsit_new.patient_no);




-- ******************************************************
-- feature construction: aggregate each patient's results by taking the mean
-- ******************************************************

DROP VIEW IF EXISTS enroll_hy_feature;
CREATE VIEW enroll_hy_feature
AS
SELECT patient_no, AVG(hy) AS hy, AVG(updrs_3_score) AS updrs_3_score
FROM enroll_hy
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_updrs_1_feature;
CREATE VIEW enroll_updrs_1_feature
AS
SELECT patient_no, AVG(updrs_1_score) AS updrs_1_score
FROM enroll_updrs_1
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_updrs_2_feature;
CREATE VIEW enroll_updrs_2_feature
AS
SELECT patient_no, AVG(updrs_2_score) AS updrs_2_score
FROM enroll_updrs_2
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_updrs_4_feature;
CREATE VIEW enroll_updrs_4_feature
AS
SELECT patient_no, AVG(updrs_4_score) AS updrs_4_score
FROM enroll_updrs_4
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_adl_feature;
CREATE VIEW enroll_adl_feature
AS
SELECT patient_no, AVG(adl) AS adl
FROM enroll_adl
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_gds_feature;
CREATE VIEW enroll_gds_feature
AS
SELECT patient_no, AVG(gds_score) AS gds_score
FROM enroll_gds
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_moca_feature;
CREATE VIEW enroll_moca_feature
AS
SELECT patient_no, AVG(moca_score) AS moca_score
FROM enroll_moca
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_scopa_feature;
CREATE VIEW enroll_scopa_feature
AS
SELECT patient_no, AVG(scopa_score) AS scopa_score
FROM enroll_scopa
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_epworth_feature;
CREATE VIEW enroll_epworth_feature
AS
SELECT patient_no, AVG(epworth_score) AS epworth_score
FROM enroll_epworth
GROUP BY patient_no;

DROP VIEW IF EXISTS enroll_upsit_feature;
CREATE VIEW enroll_upsit_feature
AS
SELECT patient_no, AVG(upsit_score) AS upsit_score
FROM enroll_upsit
GROUP BY patient_no;


DROP VIEW IF EXISTS enroll_features_clinical;
CREATE VIEW enroll_features_clinical
AS
SELECT enroll.record_id AS record_id, enroll.patient_no AS patient_no, enroll.diagnosis AS diagnosis, enroll.age AS age, CAST(enroll.gender AS INT) AS gender, enroll_updrs_1_feature.updrs_1_score AS updrs_1_score, enroll_updrs_2_feature.updrs_2_score AS updrs_2_score, enroll_hy_feature.updrs_3_score AS updrs_3_score, enroll_updrs_4_feature.updrs_4_score AS updrs_4_score, enroll_hy_feature.hy AS hy, enroll_adl_feature.adl AS adl, enroll_gds_feature.gds_score AS gds_score, enroll_moca_feature.moca_score AS moca_score, enroll_scopa_feature.scopa_score AS scopa_score, enroll_epworth_feature.epworth_score AS epworth_score, enroll_upsit_feature.upsit_score AS upsit_score
FROM enroll JOIN enroll_hy_feature ON (enroll.patient_no = enroll_hy_feature.patient_no) JOIN enroll_adl_feature ON (enroll.patient_no = enroll_adl_feature.patient_no) JOIN enroll_gds_feature ON (enroll.patient_no = enroll_gds_feature.patient_no) JOIN enroll_moca_feature ON (enroll.patient_no = enroll_moca_feature.patient_no) JOIN enroll_scopa_feature ON (enroll.patient_no = enroll_scopa_feature.patient_no) JOIN enroll_epworth_feature ON (enroll.patient_no = enroll_epworth_feature.patient_no) JOIN enroll_upsit_feature ON (enroll.patient_no = enroll_upsit_feature.patient_no) JOIN enroll_updrs_1_feature ON (enroll.patient_no = enroll_updrs_1_feature.patient_no) JOIN enroll_updrs_2_feature ON (enroll.patient_no = enroll_updrs_2_feature.patient_no) JOIN enroll_updrs_4_feature ON (enroll.patient_no = enroll_updrs_4_feature.patient_no);


-- ******************************************************
-- feature imputation: replace null values with average
-- ******************************************************
DROP VIEW IF EXISTS features_mean;
CREATE VIEW features_mean
AS
SELECT AVG(updrs_1_score) AS updrs_1_score_avg, AVG(updrs_2_score) AS updrs_2_score_avg, AVG(updrs_3_score) AS updrs_3_score_avg, AVG(updrs_4_score) AS updrs_4_score_avg, AVG(hy) AS hy_avg, AVG(adl) AS adl_avg, AVG(gds_score) AS gds_score_avg, AVG(moca_score) AS moca_score_avg, AVG(scopa_score) AS scopa_score_avg, AVG(epworth_score) AS epworth_score_avg, AVG(upsit_score) AS upsit_score_avg
FROM enroll_features_clinical;

DROP VIEW IF EXISTS enroll_features_clinical_imputed;
CREATE VIEW enroll_features_clinical_imputed
AS
SELECT patient_no, diagnosis, age, gender, CASE WHEN LENGTH(updrs_1_score) > 0 THEN updrs_1_score ELSE updrs_1_score_avg END AS updrs_1_score, CASE WHEN LENGTH(updrs_2_score) > 0 THEN updrs_2_score ELSE updrs_2_score_avg END AS updrs_2_score, CASE WHEN LENGTH(updrs_3_score) > 0 THEN updrs_3_score ELSE updrs_3_score_avg END AS updrs_3_score, CASE WHEN LENGTH(updrs_4_score) > 0 THEN updrs_4_score ELSE updrs_4_score_avg END AS updrs_4_score, CASE WHEN LENGTH(hy) > 0 THEN hy ELSE hy_avg END AS hy, CASE WHEN LENGTH(adl) > 0 THEN adl ELSE adl_avg END AS adl, CASE WHEN LENGTH(gds_score) > 0 THEN gds_score ELSE gds_score_avg END AS gds_score, CASE WHEN LENGTH(moca_score) > 0 THEN moca_score ELSE moca_score_avg END AS moca_score, CASE WHEN LENGTH(scopa_score) > 0 THEN scopa_score ELSE scopa_score_avg END AS scopa_score, CASE WHEN LENGTH(epworth_score) > 0 THEN epworth_score ELSE epworth_score_avg END AS epworth_score, CASE WHEN LENGTH(upsit_score) > 0 THEN upsit_score ELSE upsit_score_avg END AS upsit_score
FROM enroll_features_clinical CROSS JOIN features_mean;

-- save the final features into text file
INSERT OVERWRITE LOCAL DIRECTORY './'  
ROW FORMAT DELIMITED    
FIELDS TERMINATED BY ','  
STORED AS TEXTFILE  
SELECT * FROM enroll_features_clinical_imputed;