SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE ch10_iud_dep_proc (
  p_department_id IN ch10_departments.department_id%TYPE,
  p_department_name IN ch10_departments.department_name%TYPE,
  p_flag IN VARCHAR2
) IS
  v_count NUMBER;
  e_has_employees EXCEPTION;
BEGIN
  IF p_flag = 'I' THEN
    INSERT INTO ch10_departments VALUES (p_department_id, p_department_name);
  ELSIF p_flag = 'U' THEN
    UPDATE ch10_departments SET department_name = p_department_name
     WHERE department_id = p_department_id;
  ELSIF p_flag = 'D' THEN
    SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = p_department_id;
    IF v_count > 0 THEN RAISE e_has_employees; END IF;
    DELETE FROM ch10_departments WHERE department_id = p_department_id;
  END IF;
  COMMIT;
EXCEPTION
  WHEN e_has_employees THEN
    DBMS_OUTPUT.PUT_LINE('소속 사원이 있어 부서를 삭제할 수 없습니다.');
    ROLLBACK;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE || ': ' || SQLERRM);
    ROLLBACK;
END;
/
EXEC ch10_iud_dep_proc(10, NULL, 'D');
