SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE my_dep_hier_proc IS
  PROCEDURE print_children(p_parent NUMBER, p_level NUMBER) IS
    CURSOR c_dept IS
      SELECT department_id, department_name FROM departments
       WHERE (p_parent IS NULL AND parent_id IS NULL) OR parent_id = p_parent
       ORDER BY department_id;
  BEGIN
    FOR dept IN c_dept LOOP
      DBMS_OUTPUT.PUT_LINE(dept.department_id || ' ' ||
        RPAD(' ', 3 * (p_level - 1)) || dept.department_name || ' ' || p_level);
      print_children(dept.department_id, p_level + 1);
    END LOOP;
  END;
BEGIN
  print_children(NULL, 1);
END;
/
EXEC my_dep_hier_proc;
