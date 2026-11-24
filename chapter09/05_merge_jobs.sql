CREATE OR REPLACE PROCEDURE my_new_job_proc2 (
  p_job_id IN jobs.job_id%TYPE,
  p_job_title IN jobs.job_title%TYPE,
  p_min_sal IN jobs.min_salary%TYPE,
  p_max_sal IN jobs.max_salary%TYPE
)
IS
BEGIN
  MERGE INTO jobs j
  USING (
    SELECT p_job_id AS job_id, p_job_title AS job_title,
           p_min_sal AS min_salary, p_max_sal AS max_salary
      FROM dual
  ) src
  ON (j.job_id = src.job_id)
  WHEN MATCHED THEN
    UPDATE SET j.job_title = src.job_title,
               j.min_salary = src.min_salary,
               j.max_salary = src.max_salary,
               j.update_date = SYSDATE
  WHEN NOT MATCHED THEN
    INSERT (job_id, job_title, min_salary, max_salary, create_date, update_date)
    VALUES (src.job_id, src.job_title, src.min_salary, src.max_salary, SYSDATE, SYSDATE);

  COMMIT;
END;
/

SHOW ERRORS PROCEDURE my_new_job_proc2
