WHENEVER SQLERROR CONTINUE;
drop table n3c_gen_sql;
drop table n3c_cdm_tables;
drop table n3c_gen_create_sql;
drop table n3c_gen_sql_export;
WHENEVER SQLERROR EXIT SQL.SQLCODE;


------------------------------------------------------------------------------------------------------------------------------
--- CDM tables to include
------------------------------------------------------------------------------------------------------------------------------
create table n3c_cdm_tables(
    table_name varchar(255)
);

--Insert into N3C_CDM_TABLES (TABLE_NAME) values ('CDM_STATUS');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('CONDITION');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DEATH');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DEATH_CAUSE');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DEMOGRAPHIC');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DIAGNOSIS');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('DISPENSING');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('ENCOUNTER');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('ENROLLMENT');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('HARVEST');
--Insert into N3C_CDM_TABLES (TABLE_NAME) values ('HASH_TOKEN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('IMMUNIZATION');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('LAB_RESULT_CM');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('LDS_ADDRESS_HISTORY');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('MED_ADMIN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('OBS_CLIN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('OBS_GEN');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PCORNET_TRIAL');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PRESCRIBING');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PROCEDURES');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PROVIDER');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('PRO_CM');
Insert into N3C_CDM_TABLES (TABLE_NAME) values ('VITAL');


------------------------------------------------------------------------------------------------------------------------------
---- Save gen sql in table
-- replace *** with &
-- replace " with '
------------------------------------------------------------------------------------------------------------------------------
create table n3c_gen_sql(
    sql_str varchar(4000)
);

insert into n3c_gen_sql (select 'define encrypting_password=***1;' from dual);


------------------------------------------------------------------------------------------------------------------------------
--- DROP TABLE SQL
------------------------------------------------------------------------------------------------------------------------------
insert into n3c_gen_sql (select '-- drop tables' from dual);
insert into n3c_gen_sql (select 'WHENEVER SQLERROR CONTINUE;' from dual);

insert into n3c_gen_sql
with cdm_tables_w_patid
as
(
select distinct table_name
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in ( select table_name from N3C_CDM_TABLES)
)
select 'DROP TABLE '||table_name || ' purge ;' from cdm_tables_w_patid order by table_name
;

insert into n3c_gen_sql (select 'WHENEVER SQLERROR EXIT SQL.SQLCODE;' from dual);

commit;


------------------------------------------------------------------------------------------------------------------------------
--- CREATE TABLE SQL
------------------------------------------------------------------------------------------------------------------------------
create table n3c_gen_create_sql(
    sql_str varchar(4000)
);
insert into n3c_gen_create_sql (select '-- create tables' from dual);
insert into n3c_gen_create_sql
with cdm_tables_w_patid
as
(
select distinct table_name
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in (select table_name from N3C_CDM_TABLES)
    and column_name = 'PATID'
)
select 
'create table '|| table_name || ' nologging parallel as select ' || 
LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY column_id)
|| ' from '||owner||'.'|| table_name 
||' cdm join NIGHTHERONDATA.patient_mapping he on cdm.patid = he.patient_num where he.patient_ide_source='
|| '''' ||'Epic@kumed.com' ||'''' || ' ;' sql_str
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in (select table_name from cdm_tables_w_patid)
    and owner = 'PCORNET_CDM'
group by owner,table_name
order by owner,table_name
;
insert into n3c_gen_create_sql
with cdm_tables_w_patid
as
(
select distinct table_name
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in (select table_name from N3C_CDM_TABLES)
    and column_name = 'PATID'
)
,cdm_tables_wo_patid
as (
select table_name from N3C_CDM_TABLES where table_name not in (select table_name from cdm_tables_w_patid)
)
select 
'create table '|| table_name || ' nologging parallel as select ' || 
LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY column_id)
|| ' from '||owner||'.'|| table_name || ' ;' sql_str
from dba_tab_cols
where owner = 'PCORNET_CDM'
    and table_name in (select table_name from cdm_tables_wo_patid)
    and owner = 'PCORNET_CDM'
group by owner,table_name
order by owner,table_name
;


insert into n3c_gen_sql
select
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(
replace(sql_str,
     'TOKEN_ENCRYPTION_KEY,'    ,'')
    ,' PROVIDERID,'               ,' standard_HASH("***encrypting_password"||PROVIDERID,"SHA1") PROVIDERID,')
    ,'PROVIDER_NPI,'             ,'standard_HASH("***encrypting_password"||PROVIDER_NPI,"SHA1") PROVIDER_NPI,')
    ,'PATID,'                    ,'standard_HASH("***encrypting_password"||he.patient_ide,"SHA1") PATID,')
    ,'FACILITY_LOCATION,'        ,'standard_HASH("***encrypting_password"||FACILITY_LOCATION,"SHA1") FACILITY_LOCATION,')
    ,'FACILITYID,'               ,'standard_HASH("***encrypting_password"||FACILITYID,"SHA1") FACILITYID,')
    ,'RAW_PAYER_NAME_PRIMARY,'   ,'standard_HASH("***encrypting_password"||RAW_PAYER_NAME_PRIMARY,"SHA1") RAW_PAYER_NAME_PRIMARY,')
    ,'RAW_PAYER_ID_PRIMARY,'     ,'standard_HASH("***encrypting_password"||RAW_PAYER_ID_PRIMARY,"SHA1") RAW_PAYER_ID_PRIMARY,')
    ,'RAW_PAYER_NAME_SECONDARY,' ,'standard_HASH("***encrypting_password"||RAW_PAYER_NAME_SECONDARY,"SHA1") RAW_PAYER_NAME_SECONDARY,')
    ,'RAW_PAYER_ID_SECONDARY'   ,'standard_HASH("***encrypting_password"||RAW_PAYER_ID_SECONDARY,"SHA1") RAW_PAYER_ID_SECONDARY')
    ,'ADDRESS_USE,'              ,'standard_HASH("***encrypting_password"||ADDRESS_USE,"SHA1") ADDRESS_USE,')
    ,'ADDRESS_PREFERRED,'        ,'standard_HASH("***encrypting_password"||ADDRESS_PREFERRED,"SHA1") ADDRESS_PREFERRED,')
    ,'ADDRESS_CITY,'             ,'standard_HASH("***encrypting_password"||ADDRESS_CITY,"SHA1") ADDRESS_CITY,')
    ,'ENCOUNTERID,'              ,'standard_HASH("***encrypting_password"||ENCOUNTERID,"SHA1") ENCOUNTERID,')
    ,'VX_PROVIDERID,'            ,'standard_HASH("***encrypting_password"||VX_PROVIDERID,"SHA1") VX_PROVIDERID,')
    ,'MEDADMIN_PROVIDERID,'      ,'standard_HASH("***encrypting_password"||MEDADMIN_PROVIDERID,"SHA1") MEDADMIN_PROVIDERID,')
    ,'OBSCLIN_PROVIDERID,'       ,'standard_HASH("***encrypting_password"||OBSCLIN_PROVIDERID,"SHA1") OBSCLIN_PROVIDERID,')
    ,'OBSGEN_PROVIDERID,'        ,'standard_HASH("***encrypting_password"||OBSGEN_PROVIDERID,"SHA1") OBSGEN_PROVIDERID,')
    ,'RX_PROVIDERID,'            ,'standard_HASH("***encrypting_password"||RX_PROVIDERID,"SHA1") RX_PROVIDERID,')
    -- getting rid of fact counts and patient counts
    ,'RAW_MEDADMIN_MED_NAME,'    ,'NVL(SUBSTR(RAW_MEDADMIN_MED_NAME, 0, INSTR(RAW_MEDADMIN_MED_NAME, "[")-1),RAW_MEDADMIN_MED_NAME) RAW_MEDADMIN_MED_NAME,')
    ,'"'                         ,'''')
sql_str
from n3c_gen_create_sql;


insert into n3c_gen_sql (select 'exit;' from dual);
commit;


create table n3c_gen_sql_export
as
select replace(sql_str,'***','&') sql_str
from n3c_gen_sql;
exit;


