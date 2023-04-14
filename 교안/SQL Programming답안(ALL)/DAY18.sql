--실전문제① ▶ UPDATE SET절에서 서브쿼리 사용하기---------------------------------------------------
UPDATE Z_DAY17_1
   SET UPDATE_COL2 = 0;
   
UPDATE --+ GATHER_PLAN_STATISTICS
       Z_DAY17_1 U1
   SET U1.UPDATE_COL2 = (
                          SELECT SUM(S1.SUM_QTY)
                            FROM Z_DAY17_1 S1
                           WHERE S1.OUTBOUND_DATE BETWEEN TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD') AND LAST_DAY(TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD'))
                             AND TO_CHAR(S1.OUTBOUND_DATE, 'D') = TO_CHAR(U1.OUTBOUND_DATE, 'D')
                             AND S1.OUTBOUND_DATE != U1.OUTBOUND_DATE
                         )
 WHERE U1.OUTBOUND_DATE BETWEEN TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD') AND LAST_DAY(TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD'));



SELECT OUT_DATE
  FROM (
        SELECT TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD') + NO - 1 AS OUT_DATE
          FROM CS_NO
         WHERE NO <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD')), 'DD'))
       ) S1
 WHERE TO_CHAR(S1.OUT_DATE, 'D') = TO_CHAR(:OUTBOUND_DATE, 'D')
   AND S1.OUT_DATE != :OUTBOUND_DATE
                                                         
                                                         
                                                         

UPDATE --+ GATHER_PLAN_STATISTICS
       Z_DAY17_1 U1
   SET U1.UPDATE_COL2 = (
                          SELECT SUM(S1.SUM_QTY)
                            FROM Z_DAY17_1 S1
                           WHERE S1.OUTBOUND_DATE IN (
                                                      SELECT OUT_DATE
                                                        FROM (
                                                              SELECT TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD') + NO - 1 AS OUT_DATE
                                                                FROM CS_NO
                                                               WHERE NO <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD')), 'DD'))
                                                             ) S1
                                                       WHERE TO_CHAR(S1.OUT_DATE, 'D') = TO_CHAR(U1.OUTBOUND_DATE, 'D')
                                                         AND S1.OUT_DATE != U1.OUTBOUND_DATE
                                                     )
                         )
 WHERE U1.OUTBOUND_DATE BETWEEN TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD') AND LAST_DAY(TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD'));



SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));   

SELECT SUBSTR(SQL_TEXT, 1, 600) SQL_TEXT,
       SQL_ID
FROM   V$SQLAREA
WHERE  UPPER(SQL_TEXT) LIKE '%GATHER_PLAN_STATISTICS%'
ORDER  BY FIRST_LOAD_TIME DESC;

/*MariaDB
UPDATE Z_DAY17_1 U1
   SET U1.UPDATE_COL2 = (
                          SELECT SUM(S1.SUM_QTY)
                            FROM Z_DAY17_1 S1
                           WHERE DAYOFWEEK(S1.OUTBOUND_DATE) = DAYOFWEEK(U1.OUTBOUND_DATE)
                             AND S1.OUTBOUND_DATE BETWEEN '2019-08-01' AND '2019-08-31'
                             AND S1.OUTBOUND_DATE != U1.OUTBOUND_DATE
                         )
 WHERE U1.OUTBOUND_DATE BETWEEN '2019-08-01' AND '2019-08-31';
*/    
----------------------------------------------------------------------------------------------------





--실전문제② ▶ DELETE 조건절에서 서브쿼리 사용하기--------------------------------------------------
DELETE 
  FROM Z_DAY17_1
 WHERE SUM_QTY < (
                  SELECT AVG(SUM_QTY)
                    FROM (
                          SELECT M1.OUTBOUND_DATE, SUM(M2.ORDER_QTY) AS SUM_QTY
                            FROM LO_OUT_M M1
                                 JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                           WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD') AND LAST_DAY(:YYYYMM || '01')
                           GROUP BY M1.OUTBOUND_DATE
                         )
                 )
   AND OUTBOUND_DATE BETWEEN '2019-08-01' AND '2019-08-31';


SELECT *
  FROM Z_DAY17_1
 WHERE OUTBOUND_DATE BETWEEN '2019-08-01' AND '2019-08-31';

/*MariaDB
SET @YYYYMM := '201907';   
DELETE 
  FROM Z_DAY17_1
 WHERE SUM_QTY < (
                  SELECT ROUND(SUM(M2.ORDER_QTY) / 
                                  DATEDIFF(LAST_DAY(CONVERT(CONCAT(@YYYYMM, '01'), DATE)), CONVERT(CONCAT(@YYYYMM, '01'), DATE)), 0)
                    FROM LO_OUT_M M1
                         JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                   WHERE M1.OUTBOUND_DATE BETWEEN CONVERT(CONCAT(@YYYYMM, '01'), DATE) AND LAST_DAY(CONVERT(CONCAT(@YYYYMM, '01'), DATE))
                 );
*/                    
----------------------------------------------------------------------------------------------------
