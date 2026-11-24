SET SERVEROUTPUT ON
SET LINESIZE 140
COLUMN routine_name FORMAT A24
COLUMN stage FORMAT A14
COLUMN message FORMAT A48

CREATE TABLE ch17_debug_log (
  run_id RAW(16) NOT NULL,
  routine_name VARCHAR2(40) NOT NULL,
  stage VARCHAR2(15) NOT NULL,
  rows_affected NUMBER,
  message VARCHAR2(1000 CHAR),
  logged_at TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE OR REPLACE PROCEDURE ch17_write_log (
  p_run_id IN RAW,
  p_routine_name IN VARCHAR2,
  p_stage IN VARCHAR2,
  p_rows_affected IN NUMBER DEFAULT NULL,
  p_message IN VARCHAR2 DEFAULT NULL
)
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO ch17_debug_log (run_id, routine_name, stage, rows_affected, message)
  VALUES (p_run_id, p_routine_name, p_stage, p_rows_affected, SUBSTR(p_message, 1, 1000));
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('로그 기록 실패: ' || SQLERRM);
END;
/

EXEC ch17_write_log(SYS_GUID(), 'LOGGER_TEST', 'DEMO', p_message => '독립 트랜잭션 로그');

SELECT routine_name, stage, message
  FROM ch17_debug_log
 WHERE routine_name = 'LOGGER_TEST'
 ORDER BY logged_at;
