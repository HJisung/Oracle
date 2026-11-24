SET LINESIZE 150
COLUMN next_run_kst FORMAT A20
COLUMN run_interval FORMAT A70

DECLARE
  v_job BINARY_INTEGER;
  v_seoul_now DATE := CAST(SYSTIMESTAMP AT TIME ZONE 'Asia/Seoul' AS DATE);
  v_server_now DATE := SYSDATE;
  -- DBMS_JOB의 DATE 값은 DB 서버의 현지 시각을 사용한다.
  v_offset_minutes PLS_INTEGER := ROUND((v_server_now - v_seoul_now) * 1440);
  v_next_run DATE := TRUNC(v_seoul_now) + 17 / 24 + v_offset_minutes / 1440;
  v_interval VARCHAR2(200);
BEGIN
  IF v_next_run <= v_server_now THEN
    v_next_run := v_next_run + 1;
  END IF;

  v_interval := 'TRUNC(SYSDATE - (' || v_offset_minutes || '/1440)) + 1 + 17/24 + ('
                || v_offset_minutes || '/1440)';
  DBMS_JOB.SUBMIT(
    job       => v_job,
    what      => 'CH15_EXAMPLE1_PRC;',
    next_date => v_next_run,
    interval  => v_interval
  );
  COMMIT;
END;
/

SELECT job,
       TO_CHAR(FROM_TZ(CAST(next_date AS TIMESTAMP), TO_CHAR(SYSTIMESTAMP, 'TZH:TZM'))
                 AT TIME ZONE 'Asia/Seoul', 'YYYY-MM-DD HH24:MI:SS') AS next_run_kst,
       interval AS run_interval
  FROM user_jobs
 WHERE what = 'CH15_EXAMPLE1_PRC;'
 ORDER BY job;
