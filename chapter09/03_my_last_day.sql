-- 입력과 반환 형식은 YYYY-MM-DD로 통일한다.
CREATE OR REPLACE FUNCTION my_last_day(p_date IN VARCHAR2)
RETURN VARCHAR2
IS
BEGIN
  RETURN TO_CHAR(LAST_DAY(TO_DATE(p_date, 'FXYYYY-MM-DD')), 'YYYY-MM-DD');
END;
/

SELECT my_last_day('2024-02-10') AS leap_year,
       my_last_day('2025-02-10') AS common_year
  FROM dual;
