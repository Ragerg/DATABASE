--실전문제① ▶ 트랜잭션 테이블의 레코드 건수 적게 읽기----------------------------------------------
SELECT OUTBOUND_DATE
  FROM (
        SELECT TO_DATE('20180615', 'YYYY-MM-DD') + NO AS OUTBOUND_DATE
          FROM CS_NO
         WHERE NO BETWEEN 1 AND 10
       ) M1
 WHERE EXISTS (SELECT 1
                 FROM LO_OUT_M S1
                WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
              );
              

SELECT DISTINCT OUTBOUND_DATE
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN TO_DATE('20180615', 'YYYY-MM-DD') + 1 AND TO_DATE('20180615', 'YYYY-MM-DD') + 100
 ORDER BY OUTBOUND_DATE;
 
/*MariaDB
SELECT OUTBOUND_DATE
  FROM (
        SELECT DATE_ADD(CONVERT('2018-06-15', DATE), INTERVAL+NO DAY) AS OUTBOUND_DATE
          FROM CS_NO
         WHERE NO BETWEEN 1 AND 10
       ) M1
 WHERE EXISTS (SELECT 1
                 FROM LO_OUT_M S1
                WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
              );
*/ 
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 스칼라쿼리를 활용한 컬럼 연계 최대값 구하기------------------------------------------
SELECT INVOICE_NO
      ,OUT_TYPE_DIV
      ,OUT_BOX_DIV
      ,TO_NUMBER(SUBSTR(VAL, 12, 10)) AS MAX_LINE_NO
      ,TO_NUMBER(SUBSTR(VAL,  1, 10)) AS MAX_ORDER_QTY
  FROM (
        SELECT INVOICE_NO
              ,OUT_TYPE_DIV
              ,OUT_BOX_DIV
              ,(
                SELECT MAX(LPAD(ORDER_QTY, 10, '0') || '-' || LPAD(LINE_NO, 10, '0'))
                  FROM LO_OUT_D S1
                 WHERE S1.INVOICE_NO = M1.INVOICE_NO 
               ) AS VAL
          FROM LO_OUT_M M1
         WHERE OUTBOUND_DATE = '2019-06-03'
           AND OUTBOUND_NO   BETWEEN 'D190603-897353' AND 'D190603-897360'
       );
       
/*MariaDB
SELECT INVOICE_NO
      ,OUT_TYPE_DIV
      ,OUT_BOX_DIV
      ,CAST(SUBSTR(VAL, 12, 10) AS INTEGER) AS MAX_LINE_NO
      ,CAST(SUBSTR(VAL,  1, 10) AS INTEGER) AS MAX_ORDER_QTY
  FROM (
        SELECT INVOICE_NO
              ,OUT_TYPE_DIV
              ,OUT_BOX_DIV
              ,(
                SELECT MAX(CONCAT(LPAD(ORDER_QTY, 10, '0'), '-', LPAD(LINE_NO, 10, '0')))
                  FROM LO_OUT_D S1
                 WHERE S1.INVOICE_NO = M1.INVOICE_NO 
               ) AS VAL
          FROM LO_OUT_M M1
         WHERE OUTBOUND_DATE = '2019-06-03'
           AND OUTBOUND_NO   BETWEEN 'D190603-897353' AND 'D190603-897360'
       ) L1;
*/       
----------------------------------------------------------------------------------------------------
