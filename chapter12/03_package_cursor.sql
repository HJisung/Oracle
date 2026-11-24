SET SERVEROUTPUT ON
CREATE OR REPLACE PACKAGE ch12_exacur_pkg IS
  CURSOR pc_depname_cur(dep_id IN departments.department_id%TYPE) RETURN departments%ROWTYPE;
  PROCEDURE print_department(dep_id IN departments.department_id%TYPE);
END ch12_exacur_pkg;
/
CREATE OR REPLACE PACKAGE BODY ch12_exacur_pkg IS
  CURSOR pc_depname_cur(dep_id IN departments.department_id%TYPE) RETURN departments%ROWTYPE IS
    SELECT * FROM departments WHERE department_id = dep_id;
  PROCEDURE print_department(dep_id IN departments.department_id%TYPE) IS
    v_dept departments%ROWTYPE;
  BEGIN
    IF pc_depname_cur%ISOPEN THEN CLOSE pc_depname_cur; END IF;
    OPEN pc_depname_cur(dep_id);
    FETCH pc_depname_cur INTO v_dept;
    IF pc_depname_cur%FOUND THEN
      DBMS_OUTPUT.PUT_LINE(v_dept.department_id || ' ' || v_dept.department_name);
    ELSE
      DBMS_OUTPUT.PUT_LINE('해당 부서가 없습니다.');
    END IF;
    CLOSE pc_depname_cur;
  EXCEPTION WHEN OTHERS THEN
    IF pc_depname_cur%ISOPEN THEN CLOSE pc_depname_cur; END IF;
    RAISE;
  END;
END ch12_exacur_pkg;
/
EXEC ch12_exacur_pkg.print_department(10);
