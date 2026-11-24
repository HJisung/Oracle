SET LINESIZE 150
COLUMN job_name FORMAT A24
COLUMN program_name FORMAT A24
COLUMN schedule_name FORMAT A24
COLUMN enabled FORMAT A7
COLUMN next_run_kst FORMAT A20

BEGIN
  DBMS_SCHEDULER.CREATE_PROGRAM(
    program_name        => 'CH15_STATS_PROGRAM',
    program_type        => 'STORED_PROCEDURE',
    program_action      => 'CH15_EXAMPLE1_PRC',
    number_of_arguments => 0,
    enabled             => TRUE
  );

  DBMS_SCHEDULER.CREATE_SCHEDULE(
    schedule_name   => 'CH15_DAILY_SCHEDULE',
    start_date      => SYSTIMESTAMP AT TIME ZONE 'Asia/Seoul',
    repeat_interval => 'FREQ=DAILY;BYHOUR=17;BYMINUTE=0;BYSECOND=0'
  );

  DBMS_SCHEDULER.CREATE_JOB(
    job_name      => 'CH15_STATS_PROGRAM_JOB',
    program_name  => 'CH15_STATS_PROGRAM',
    schedule_name => 'CH15_DAILY_SCHEDULE',
    enabled       => TRUE,
    auto_drop     => FALSE
  );
END;
/

SELECT job_name, program_name, schedule_name, enabled,
       TO_CHAR(next_run_date AT TIME ZONE 'Asia/Seoul', 'YYYY-MM-DD HH24:MI:SS') AS next_run_kst
  FROM user_scheduler_jobs
 WHERE job_name = 'CH15_STATS_PROGRAM_JOB';
