SET LINESIZE 160
SET PAGESIZE 50
SET NUMWIDTH 14
COLUMN gubun FORMAT A16

SELECT gubun,
       SUM(CASE WHEN region = '서울' THEN loan_jan_amt ELSE 0 END) AS "서울",
       SUM(CASE WHEN region = '부산' THEN loan_jan_amt ELSE 0 END) AS "부산",
       SUM(CASE WHEN region = '인천' THEN loan_jan_amt ELSE 0 END) AS "인천",
       SUM(CASE WHEN region = '광주' THEN loan_jan_amt ELSE 0 END) AS "광주",
       SUM(CASE WHEN region = '대전' THEN loan_jan_amt ELSE 0 END) AS "대전",
       SUM(CASE WHEN region = '대구' THEN loan_jan_amt ELSE 0 END) AS "대구",
       SUM(CASE WHEN region = '울산' THEN loan_jan_amt ELSE 0 END) AS "울산"
  FROM kor_loan_status
 WHERE period LIKE '2013%'
   AND region IN ('서울', '부산', '인천', '광주', '대전', '대구', '울산')
 GROUP BY gubun
 ORDER BY CASE gubun WHEN '주택담보대출' THEN 1 WHEN '기타대출' THEN 2 END;
