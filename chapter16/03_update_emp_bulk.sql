SET SERVEROUTPUT ON
SET LINESIZE 140
COLUMN job_title FORMAT A30

BEGIN
  UPDATE emp_bulk
     SET job_title = ch16_job_title(job_id);
  DBMS_OUTPUT.PUT_LINE('갱신 건수: ' || SQL%ROWCOUNT);
END;
/

SELECT employee_id, job_id, job_title
  FROM (SELECT employee_id, job_id, job_title
          FROM emp_bulk
         ORDER BY employee_id)
 WHERE ROWNUM <= 8;
