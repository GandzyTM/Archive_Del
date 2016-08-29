/* Создание ТС для архива и файла данных */

CREATE TABLESPACE EXAMPLE2 DATAFILE 
  'D:\ORACLE\ORADATA\ORCL12\EXAMPLE02.DBF' SIZE 5M REUSE AUTOEXTEND ON NEXT 2G MAXSIZE UNLIMITED
LOGGING
DEFAULT 
  ROW STORE COMPRESS ADVANCED
  NO INMEMORY
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

--------------------------------------------------

/* Создание таблицы архивных данных */

create table HR.TEST_arch as select * from HR.TEST where create_date < sysdate -3; -- необходимо указать период

--------------------------------------------------

