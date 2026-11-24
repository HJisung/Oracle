CREATE OR REPLACE FUNCTION my_initcap(p_text IN VARCHAR2)
RETURN VARCHAR2
IS
  v_result VARCHAR2(32767);
  v_char VARCHAR2(4);
  v_word_start BOOLEAN := TRUE;
BEGIN
  IF p_text IS NULL THEN
    RETURN NULL;
  END IF;

  FOR i IN 1..LENGTH(p_text) LOOP
    v_char := SUBSTR(p_text, i, 1);
    IF v_word_start THEN
      v_result := v_result || UPPER(v_char);
    ELSE
      v_result := v_result || LOWER(v_char);
    END IF;
    v_word_start := v_char = ' ';
  END LOOP;

  RETURN v_result;
END;
/

SELECT my_initcap('hELLO oRACLE') AS my_result,
       INITCAP('hELLO oRACLE') AS oracle_result
  FROM dual;
