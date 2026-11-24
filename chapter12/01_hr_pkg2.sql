SET SERVEROUTPUT ON
CREATE OR REPLACE PACKAGE hr_pkg2 IS
  FUNCTION fn_get_dep_name(p_id NUMBER) RETURN VARCHAR2;
  PROCEDURE new_dep_proc(p_id NUMBER, p_name VARCHAR2, p_parent_id NUMBER, p_manager_id NUMBER);
  PROCEDURE del_dep_proc(p_id NUMBER);
END hr_pkg2;
/
CREATE OR REPLACE PACKAGE BODY hr_pkg2 IS
  FUNCTION fn_get_dep_name(p_id NUMBER) RETURN VARCHAR2 IS
    v_name departments.department_name%TYPE;
  BEGIN
    SELECT department_name INTO v_name FROM departments WHERE department_id = p_id;
    RETURN v_name;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN '해당 부서 없음';
  END;
  PROCEDURE new_dep_proc(p_id NUMBER, p_name VARCHAR2, p_parent_id NUMBER, p_manager_id NUMBER) IS
  BEGIN
    INSERT INTO departments (department_id, department_name, parent_id, manager_id)
      VALUES (p_id, p_name, p_parent_id, p_manager_id);
  END;
  PROCEDURE del_dep_proc(p_id NUMBER) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = p_id;
    IF v_count > 0 THEN
      DBMS_OUTPUT.PUT_LINE('소속 사원이 있어 삭제할 수 없습니다.');
    ELSE
      DELETE FROM departments WHERE department_id = p_id;
      DBMS_OUTPUT.PUT_LINE('삭제된 부서: ' || SQL%ROWCOUNT);
    END IF;
  END;
END hr_pkg2;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE(hr_pkg2.fn_get_dep_name(10));
  hr_pkg2.del_dep_proc(10);
END;
/
