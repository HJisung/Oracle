SET SERVEROUTPUT ON
SET LINESIZE 140
COLUMN stage FORMAT A14
COLUMN message FORMAT A54

CREATE TABLE ch17_sales_detail (
  prod_name VARCHAR2(50 CHAR),
  channel_desc VARCHAR2(20 CHAR),
  cust_name VARCHAR2(100 CHAR),
  emp_name VARCHAR2(80 CHAR),
  sales_date DATE,
  sales_month VARCHAR2(6),
  sales_qty NUMBER,
  sales_amt NUMBER
);

CREATE OR REPLACE PACKAGE ch17_src_test_pkg IS
  PROCEDURE sales_detail_prc(ps_month IN VARCHAR2, pn_amt IN NUMBER, pn_rate IN NUMBER);
END ch17_src_test_pkg;
/

CREATE OR REPLACE PACKAGE BODY ch17_src_test_pkg IS
  PROCEDURE sales_detail_prc(ps_month IN VARCHAR2, pn_amt IN NUMBER, pn_rate IN NUMBER)
  IS
    c_routine CONSTANT VARCHAR2(30) := 'SALES_DETAIL_PRC';
    v_run_id RAW(16) := SYS_GUID();
    v_error VARCHAR2(512);
  BEGIN
    SAVEPOINT sales_detail_start;
    ch17_write_log(v_run_id, c_routine, 'START',
                   p_message => '대상 월: ' || ps_month);

    BEGIN
      DELETE FROM ch17_sales_detail WHERE sales_month = ps_month;
      ch17_write_log(v_run_id, c_routine, 'DELETE', SQL%ROWCOUNT);

      INSERT INTO ch17_sales_detail (
        prod_name, channel_desc, cust_name, emp_name, sales_date, sales_month, sales_qty, sales_amt
      )
      SELECT p.prod_name, ch.channel_desc, c.cust_name, e.emp_name,
             s.sales_date, s.sales_month, SUM(s.quantity_sold), SUM(s.amount_sold)
        FROM sales s
        JOIN products p ON p.prod_id = s.prod_id
        JOIN customers c ON c.cust_id = s.cust_id
        JOIN channels ch ON ch.channel_id = s.channel_id
        JOIN employees e ON e.employee_id = s.employee_id
       WHERE s.sales_month = ps_month
       GROUP BY p.prod_name, ch.channel_desc, c.cust_name, e.emp_name, s.sales_date, s.sales_month;
      ch17_write_log(v_run_id, c_routine, 'INSERT', SQL%ROWCOUNT);

      UPDATE ch17_sales_detail
         SET sales_amt = sales_amt * (1 - pn_rate / 100)
       WHERE sales_month = ps_month
         AND sales_amt > pn_amt;
      ch17_write_log(v_run_id, c_routine, 'UPDATE', SQL%ROWCOUNT);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        v_error := SQLERRM;
        ROLLBACK TO sales_detail_start;
        ch17_write_log(v_run_id, c_routine, 'ERROR', p_message => v_error);
        RAISE;
    END;

    ch17_write_log(v_run_id, c_routine, 'END');
  END sales_detail_prc;
END ch17_src_test_pkg;
/

EXEC ch17_src_test_pkg.sales_detail_prc('200112', 50, 32.5);

SELECT stage, rows_affected, message
  FROM ch17_debug_log
 WHERE routine_name = 'SALES_DETAIL_PRC'
 ORDER BY logged_at;
