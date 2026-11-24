SET LINESIZE 140
COLUMN job_title FORMAT A30

CREATE OR REPLACE FUNCTION ch16_job_title(p_job_id IN jobs.job_id%TYPE)
RETURN VARCHAR2 RESULT_CACHE
IS
  v_job_title jobs.job_title%TYPE;
BEGIN
  SELECT j.job_title INTO v_job_title
    FROM jobs j
   WHERE j.job_id = p_job_id;
  RETURN v_job_title;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/

SHOW ERRORS FUNCTION ch16_job_title

SELECT ch16_job_title('IT_PROG') AS job_title FROM dual;
