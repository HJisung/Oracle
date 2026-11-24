SET LINESIZE 150
COLUMN job_name FORMAT A24
COLUMN enabled FORMAT A7
COLUMN next_run_kst FORMAT A20

BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'CH15_STATS_JOB',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'CH15_EXAMPLE1_PRC',
    start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Seoul',
    repeat_interval => 'FREQ=DAILY;BYHOUR=17;BYMINUTE=0;BYSECOND=0',
    enabled         => TRUE,
    auto_drop       => FALSE
  );
END;
/

SELECT job_name, enabled,
       TO_CHAR(next_run_date AT TIME ZONE 'Asia/Seoul', 'YYYY-MM-DD HH24:MI:SS') AS next_run_kst
  FROM user_scheduler_jobs
 WHERE job_name = 'CH15_STATS_JOB';
