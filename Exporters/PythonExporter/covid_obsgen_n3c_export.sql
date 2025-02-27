drop table if exists cdm60_limited_dataset_n3c.OBS_GEN_n3c;
create table cdm60_limited_dataset_n3c.OBS_GEN_n3c as
SELECT 
  OBSGENID,
  OBS_GEN.PATID,
  ENCOUNTERID,
  OBSGEN_PROVIDERID,
  OBSGEN_START_DATE,
  OBSGEN_START_TIME,
  OBSGEN_STOP_DATE,
  OBSGEN_STOP_TIME,
  OBSGEN_TYPE,
  OBSGEN_CODE,
  OBSGEN_RESULT_QUAL,
  OBSGEN_RESULT_TEXT,
  OBSGEN_RESULT_NUM,
  OBSGEN_RESULT_MODIFIER,
  OBSGEN_RESULT_UNIT,
  OBSGEN_TABLE_MODIFIED,
  OBSGEN_ID_MODIFIED,
  OBSGEN_SOURCE,
  OBSGEN_ABN_IND,
  null as RAW_OBSGEN_NAME,
  null as RAW_OBSGEN_CODE,
  null as RAW_OBSGEN_TYPE,
  null as RAW_OBSGEN_RESULT,
  null as RAW_OBSGEN_UNIT
FROM cdm60_limited_dataset_n3c.OBS_GEN JOIN cdm60_limited_dataset_n3c.N3C_COHORT ON OBS_GEN.PATID = N3C_COHORT.PATID
 WHERE OBSGEN_START_DATE >= '2018-01-01'
;

-- export to csv with header with always quotes and sep by pipe
\copy cdm60_limited_dataset_n3c.OBS_GEN_n3c to 'OBS_GEN.csv' with csv header quote as '"' delimiter '|';
