SET LINESIZE 110
COLUMN name FORMAT A32
COLUMN type FORMAT A18

-- 1. 정적으로 참조하는 객체는 데이터 딕셔너리의 의존성 정보로 찾는다.
SELECT DISTINCT name, type
  FROM user_dependencies
 WHERE referenced_owner = USER
   AND referenced_name = 'EMPLOYEES'
   AND referenced_type = 'TABLE'
   AND type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER', 'TYPE', 'TYPE BODY')
 ORDER BY type, name;

-- 2. 소스에서 EMPLOYEES가 쓰인 위치를 찾는다. 동적 SQL 문자열도 검색 대상이다.
-- 주석과 문자열도 일치할 수 있으므로 실제 참조인지는 해당 줄의 문맥을 확인한다.
SELECT name, type, MIN(line) AS first_match_line
  FROM user_source
 WHERE REGEXP_LIKE(text, '(^|[^[:alnum:]_$#])EMPLOYEES([^[:alnum:]_$#]|$)', 'i')
   AND type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY', 'TRIGGER', 'TYPE', 'TYPE BODY')
 GROUP BY name, type
 ORDER BY type, name;
