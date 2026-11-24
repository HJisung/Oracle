CREATE OR REPLACE TYPE nt_ch11_emp IS TABLE OF VARCHAR2(80);
/
SELECT type_name, typecode FROM user_types WHERE type_name = 'NT_CH11_EMP';
