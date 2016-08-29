/* Процедура удаления старых записей из таблицы DWH.BCL_STOREDBLOB и очистки ТП */

create or replace procedure DWH.STORED_DEL_VAL_p
as
  begin
  delete from DWH.STOREDBLOB where created < add_months(sysdate, -12*6); -- удаляет старые данные старше 6 лет с момента запуска;
  commit;
  execute immediate 'alter table DWH.STOREDBLOB enable row movement'; -- в случае если таблица заблокирована для передвижения записей необходимо разблокировать
  execute immediate 'alter table DWH.STOREDBLOB shrink space'; -- очищает табл пространство
  execute immediate 'alter table DWH.STOREDBLOB disable row movement'; -- включает обратно блокировку
end;
/

/* Само задание для запуска процедуры очистки таблицы */

BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
  (job_name => 'DWH.STORED_DEL_VAL');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
  (
  job_name => 'DWH.STORED_DEL_VAL'
  ,start_date => TO_TIMESTAMP_TZ('2016/08/20 11:11:48.677000 +05:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
  ,repeat_interval => 'FREQ=MONTHLY; BYDAY=-1SUN'  -- выполняется каждое последнее воскресенье
  ,end_date => TO_TIMESTAMP_TZ('2020/08/21 00:00:00.000000 +05:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
  ,job_class => 'DEFAULT_JOB_CLASS'
  ,job_type => 'STORED_PROCEDURE'
  ,job_action => 'DWH.STORED_DEL_VAL_P'
  ,comments => NULL
  );
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'RESTARTABLE'
  ,value => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'LOGGING_LEVEL'
  ,value => SYS.DBMS_SCHEDULER.LOGGING_RUNS);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'MAX_FAILURES');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'MAX_RUNS');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'STOP_ON_WINDOW_CLOSE'
  ,value => FALSE);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'JOB_PRIORITY'
  ,value => 3);
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'SCHEDULE_LIMIT');
  SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
  ( name => 'DWH.STORED_DEL_VAL'
  ,attribute => 'AUTO_DROP'
  ,value => FALSE);
END;