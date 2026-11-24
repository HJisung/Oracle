SET SERVEROUTPUT ON
CREATE OR REPLACE PACKAGE ch12_hierarchy_pkg IS
  FUNCTION get_dep_hierarchy(p_department_id NUMBER) RETURN VARCHAR2;
  FUNCTION get_dep_hierarchy(p_department_id NUMBER, p_parent_id NUMBER) RETURN VARCHAR2;
END ch12_hierarchy_pkg;
/
CREATE OR REPLACE PACKAGE BODY ch12_hierarchy_pkg IS
  FUNCTION get_dep_hierarchy(p_department_id NUMBER) RETURN VARCHAR2 IS
    v_result VARCHAR2(32767);
  BEGIN
    SELECT department_id || ' ' || department_name INTO v_result
      FROM departments WHERE department_id = p_department_id;
    RETURN v_result;
  END;
  FUNCTION get_dep_hierarchy(p_department_id NUMBER, p_parent_id NUMBER) RETURN VARCHAR2 IS
    v_result VARCHAR2(32767);
  BEGIN
    v_result := get_dep_hierarchy(p_department_id);
    FOR d IN (SELECT department_id, department_name FROM departments WHERE parent_id = p_parent_id ORDER BY department_id) LOOP
      v_result := v_result || CHR(10) || d.department_id || ' ' || d.department_name;
    END LOOP;
    RETURN v_result;
  END;
END ch12_hierarchy_pkg;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE(ch12_hierarchy_pkg.get_dep_hierarchy(10));
  DBMS_OUTPUT.PUT_LINE(ch12_hierarchy_pkg.get_dep_hierarchy(10, 10));
END;
/
