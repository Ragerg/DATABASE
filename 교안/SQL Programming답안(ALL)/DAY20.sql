--실전문제① ▶ 분석함수 ROW_NUMBER / SUM / COUNT 사용법 익히기--------------------------------------
SELECT OUTBOUND_DATE
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,ROW_NUMBER()   OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH)  AS "일자단위 차수 순서"
      ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH)  AS "일자단위 차수순 누계"
      ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                          AS "일자별 합계"
      ,SUM(ORDER_QTY) OVER(ORDER BY OUTBOUND_DATE)                              AS "일자순 누계"
      ,SUM(ORDER_QTY) OVER()                                                    AS "전체 합계"
      ,COUNT(1)       OVER(PARTITION BY OUTBOUND_DATE)                          AS "일자단위 레코드수"
      ,COUNT(1)       OVER()                                                    AS "전체 레코드수"
  FROM (
        SELECT M1.OUTBOUND_DATE
              ,M1.OUTBOUND_BATCH
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND M1.OUT_TYPE_DIV        = 'M11'
         GROUP BY M1.OUTBOUND_DATE
                 ,M1.OUTBOUND_BATCH  
       ) L1;
       
/*MariaDB
동일함
*/          
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 분석함수 RANK 사용법 익히기----------------------------------------------------------
SELECT OUTBOUND_DATE
      ,RANK() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS "일자단위 수량 랭킹"
      ,OUTBOUND_BATCH
      ,ORDER_QTY
  FROM (
        SELECT M1.OUTBOUND_DATE
              ,M1.OUTBOUND_BATCH
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND M1.OUT_TYPE_DIV        = 'M11'
         GROUP BY M1.OUTBOUND_DATE
                 ,M1.OUTBOUND_BATCH  
       ) L1;
       
/*MariaDB
동일함
*/          
----------------------------------------------------------------------------------------------------





--실전문제③ ▶ 분석함수 RANK / DENSE_RANK /SUM / LAG 사용법 익히기----------------------------------
SELECT LAG(NULL, 1, OUTBOUND_DATE) OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH)         AS "출고일자"
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,DAY_QTY                                                                                      AS "일자별 수량 합계"
      ,DAY_RANK                                                                                     AS "일자별 수량 합계 랭킹"
      ,TOT_RANK                                                                                     AS "전체 랭킹"
  FROM (
        SELECT OUTBOUND_DATE
              ,OUTBOUND_BATCH
              ,ORDER_QTY
              ,DAY_QTY
              ,DENSE_RANK() OVER(ORDER BY DAY_QTY DESC, OUTBOUND_DATE) AS DAY_RANK
              ,RANK()       OVER(ORDER BY ORDER_QTY DESC)              AS TOT_RANK
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M1.OUTBOUND_BATCH
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                      ,SUM(SUM(M2.ORDER_QTY)) OVER(PARTITION BY M1.OUTBOUND_DATE) AS DAY_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
                   AND M1.OUT_TYPE_DIV        = 'M11'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M1.OUTBOUND_BATCH  
               ) L1
       ) L2
 ORDER BY DAY_RANK 
         ,OUTBOUND_BATCH;


SELECT LAG(NULL, 1, OUTBOUND_DATE) OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH) AS OUT_DATE
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,DAY_QTY
      ,DENSE_RANK() OVER(ORDER BY DAY_QTY DESC, OUTBOUND_DATE) AS DAY_RANK
      ,RANK()       OVER(ORDER BY ORDER_QTY DESC)              AS TOT_RANK
  FROM (
        SELECT M1.OUTBOUND_DATE
              ,M1.OUTBOUND_BATCH
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
              ,SUM(SUM(M2.ORDER_QTY)) OVER(PARTITION BY M1.OUTBOUND_DATE) AS DAY_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND M1.OUT_TYPE_DIV        = 'M11'
         GROUP BY M1.OUTBOUND_DATE
                 ,M1.OUTBOUND_BATCH  
       )
 ORDER BY DAY_RANK
         ,OUTBOUND_BATCH;
   
/*MariaDB
SELECT NVL(LAG('') OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH), OUTBOUND_DATE)         AS "출고일자"
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,DAY_QTY                                                                                      AS "일자별 수량 합계"
      ,DAY_RANK                                                                                     AS "일자별 수량 합계 랭킹"
      ,TOT_RANK                                                                                     AS "전체 랭킹"
  FROM (
        SELECT OUTBOUND_DATE
              ,OUTBOUND_BATCH
              ,ORDER_QTY
              ,DAY_QTY
              ,DENSE_RANK() OVER(ORDER BY DAY_QTY DESC, OUTBOUND_DATE) AS DAY_RANK
              ,RANK() OVER(ORDER BY ORDER_QTY DESC)                    AS TOT_RANK
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M1.OUTBOUND_BATCH
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                      ,SUM(SUM(M2.ORDER_QTY)) OVER(PARTITION BY M1.OUTBOUND_DATE) AS DAY_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
                   AND M1.OUT_TYPE_DIV        = 'M11'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M1.OUTBOUND_BATCH  
               ) L1
       ) L2
 ORDER BY DAY_RANK
         ,OUTBOUND_BATCH;
*/            
----------------------------------------------------------------------------------------------------





--실전문제④ ▶ 분석함수 ROW_NUMBER / RATIO_TO_REPORT 사용법 익히기----------------------------------
SELECT CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '기타' END AS OUTBOUND_DATE
      ,SUM(ORDER_QTY) AS ORDER_QTY
      ,SUM(RATE)      AS RATE
      ,MIN(RNK)       AS RNK
  FROM (
        SELECT OUTBOUND_DATE
              ,ORDER_QTY
              ,ROUND(RATIO_TO_REPORT(ORDER_QTY) OVER() * 100, 3) AS RATE
              ,ROW_NUMBER() OVER(ORDER BY ORDER_QTY DESC)        AS RNK
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK) INDEX(M1 LO_OUT_M_IDX01)
                       M1.OUTBOUND_DATE
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-15'
                 GROUP BY M1.OUTBOUND_DATE  
               ) L1       
       ) L2
 GROUP BY CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '기타' END 
 ORDER BY RNK;

 
/*MariaDB
SELECT CASE WHEN RNK <= 5 THEN DATE_FORMAT(OUTBOUND_DATE, '%Y-%m-%d') ELSE '기타' END AS OUTBOUND_DATE
    -- CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '기타' END AS OUTBOUND_DATE
      ,SUM(ORDER_QTY) AS ORDER_QTY
      ,SUM(RATE)      AS RATE
      ,MIN(RNK)       AS RNK
  FROM (
        SELECT OUTBOUND_DATE
              ,ORDER_QTY
              ,ROUND(ORDER_QTY / SUM(ORDER_QTY) OVER() * 100, 3) AS RATE
              ,ROW_NUMBER() OVER(ORDER BY ORDER_QTY DESC)        AS RNK
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-15'
                 GROUP BY M1.OUTBOUND_DATE  
               ) L1       
       ) L2
 GROUP BY CASE WHEN RNK <= 5 THEN DATE_FORMAT(OUTBOUND_DATE, '%Y-%m-%d') ELSE '기타' END 
      --  CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '기타' END 
 ORDER BY RNK;
*/    
----------------------------------------------------------------------------------------------------