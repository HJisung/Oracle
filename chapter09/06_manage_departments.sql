SET SERVEROUTPUT ON

CREATE TABLE ch09_departments AS
SELECT department_id, department_name, parent_id
  FROM departments;

CREATE OR REPLACE PROCEDURE my_dept_manage_proc (
  p_department_id IN ch09_departments.department_id%TYPE,
  p_department_name IN ch09_departments.department_name%TYPE,
  p_parent_id IN ch09_departments.parent_id%TYPE,
  p_flag IN VARCHAR2
)
IS
  v_employee_count NUMBER;
BEGIN
  CASE LOWER(TRIM(p_flag))
    WHEN 'upsert' THEN
      MERGE INTO ch09_departments d
      USING (
        SELECT p_department_id AS department_id,
               p_department_name AS department_name,
               p_parent_id AS parent_id
          FROM dual
      ) src
      ON (d.department_id = src.department_id)
      WHEN MATCHED THEN
        UPDATE SET d.department_name = src.department_name, d.parent_id = src.parent_id
      WHEN NOT MATCHED THEN
        INSERT (department_id, department_name, parent_id)
        VALUES (src.department_id, src.department_name, src.parent_id);
    WHEN 'delete' THEN
      SELECT COUNT(*) INTO v_employee_count
        FROM employees
       WHERE department_id = p_department_id;

      IF v_employee_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('소속 사원이 있어 부서를 삭제할 수 없습니다.');
      ELSE
        DELETE FROM ch09_departments WHERE department_id = p_department_id;
      END IF;
    ELSE
      RAISE_APPLICATION_ERROR(-20001, '작업은 upsert 또는 delete를 입력하세요.');
  END CASE;
END;
/

EXEC my_dept_manage_proc(10, NULL, NULL, 'delete');

SELECT department_id, department_name, parent_id
  FROM ch09_departments
 WHERE department_id = 10;
