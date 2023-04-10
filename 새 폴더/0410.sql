--DAY 10
--------------------------------------------------------------------------------

--실전문제 1
SELECT M.INVOICE_NO
      ,M.OUTBOUND_DATE
      ,M.OUT_TYPE_DIV
      ,D.LINE_NO
      ,D.ITEM_CD
      ,I.ITEM_NM
      ,D.ORDER_QTY
  FROM LO_OUT_M M
       JOIN LO_OUT_D D  ON D.INVOICE_NO  = M.INVOICE_NO
       JOIN CM_ITEM  I  ON I.ITEM_CD     = D.ITEM_CD            
 WHERE M.INVOICE_NO IN('346724703834', '346724722535', '346724717915')
 ORDER BY INVOICE_NO
         ,LINE_NO;
         
--------------------------------------------------------------------------------

--실전문제 2
SELECT M.INVOICE_NO
      ,M.OUTBOUND_DATE
      ,D.LINE_NO
      ,I.ITEM_CD
      ,I.ITEM_CD
      ,D.ORDER_QTY
      ,C1.CODE_NM AS TEMP_NM
      ,C2.CODE_NM AS OUT_TYME_NM
  FROM LO_OUT_M M
       JOIN LO_OUT_D D   ON D.INVOICE_NO  = M.INVOICE_NO
       JOIN CM_ITEM  I   ON I.ITEM_CD     = D.ITEM_CD 
       JOIN CS_CODE  C1  ON C1.CODE_CD    = M.TEMP_DIV
                        AND C1.CODE_GRP   = 'LDIV0E1'
       JOIN CS_CODE  C2  ON C2.CODE_CD    = M.OUT_TYPE_DIV
                        AND C2.CODE_GRP   = 'LDIV03'
 WHERE M.INVOICE_NO IN('346724703834', '346724722535', '346724717915')
 ORDER BY INVOICE_NO
         ,LINE_NO;
      
        
SELECT CODE_GRP, CODE_CD, CODE_NM
  FROM CS_CODE;
 
 

SELECT OUT_TYPE_DIV
  FROM LO_OUT_M;

--------------------------------------------------------------------------------
--DAY 11
--------------------------------------------------------------------------------

--실전문제 1 
SELECT *  
  FROM (      
        SELECT --+ ORDERED USE_NL(D)
               M.INVOICE_NO ,M.OUTBOUND_NO ,M.OUTBOUND_BATCH
              ,D.ITEM_CD    ,D.ITEM_NM     ,D.ORDER_QTY
          FROM LO_OUT_M M
               JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
         WHERE M.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND D.ITEM_NM       LIKE '%골뱅이%'
         ORDER BY ORDER_QTY DESC 
       )
 WHERE ROWNUM <= 5;      

--------------------------------------------------------------------------------

--실전문제 2
SELECT D.ITEM_CD ,I.ITEM_NM
      ,SUM(D.ORDER_QTY) AS ORDER_QTY
  FROM LO_OUT_M M
       JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
       JOIN CM_ITEM  I ON I.ITEM_CD    = D.ITEM_CD
 WHERE M.OUTBOUND_DATE   BETWEEN TO_DATE('2019-09-03', 'YYYY-MM-DD') AND TO_DATE('2019-09-10', 'YYYY-MM-DD')
   AND M.OUT_BOX_DIV     = 'D5'
 GROUP BY  D.ITEM_CD
          ,I.ITEM_NM
 ORDER BY ORDER_QTY DESC;  

--------------------------------------------------------------------------------

--실전문제3
SELECT M.INVOICE_NO, M.OUTBOUND_DATE, M.OUT_TYPE_DIV
      ,D.LINE_NO   , D.ITEM_CD      , D.ORDER_QTY
      ,NVL(C1.CODE_NM, 'Failed...')  AS TEMP_NM        
      ,C2.CODE_NM AS OUT_TYME_NM
  FROM LO_OUT_M M
       JOIN LO_OUT_D D  ON D.INVOICE_NO   = M.INVOICE_NO
       JOIN CM_ITEM  I  ON I.ITEM_CD      = D.ITEM_CD
       LEFT JOIN CS_CODE  C1  ON C1.CODE_CD    = M.TEMP_DIV
                             AND C1.CODE_GRP   = 'LDIV011'
            JOIN CS_CODE  C2  ON C2.CODE_CD    = M.OUT_TYPE_DIV
                             AND C2.CODE_GRP   = 'LDIV03'
 WHERE M.INVOICE_NO IN('346724703834', '346724722535', '346724717915')
 ORDER BY INVOICE_NO
         ,LINE_NO;
 
--------------------------------------------------------------------------------

--실전문제 4
SELECT DY.OUT_DATE
      ,NVL(M1.QTY, 0)
  FROM (
        SELECT TO_DATE('2019-09-01', 'YYYY-MM-DD') + LEVEL -1 AS OUT_DATE
          FROM DUAL
        CONNECT BY LEVEL <= (TO_DATE('2019-09-19', 'YYYY-MM-DD')
                          - TO_DATE('2019-09-01', 'YYYY-MM-DD') +1)
       ) DY 
       LEFT JOIN (
                  SELECT --+ ORDERED USE_NL(D)
                         M.OUTBOUND_DATE           AS OUT_DATE
                        ,SUM(D.ORDER_QTY)  AS QTY
                    FROM LO_OUT_M M
                         JOIN LO_OUT_D D  ON D.INVOICE_NO   = M.INVOICE_NO
                   WHERE M.OUTBOUND_DATE BETWEEN TO_DATE('2019-09-01', 'YYYY-MM-DD')  AND TO_DATE('2019-09-19', 'YYYY-MM-DD') 
                   GROUP BY M.OUTBOUND_DATE
                   ORDER BY OUT_DATE
                  ) M1 ON M1.OUT_DATE = DY.OUT_DATE
 ORDER BY DY.OUT_DATE;


SELECT M1.OUT_DATE
      ,NVL(M2.QTY, 0)
  FROM (
        SELECT TO_DATE('20190901', 'YYYY-MM-DD') + NO -1 AS OUT_DATE
          FROM CS_NO
         WHERE NO <= TO_DATE('20190919', 'YYYY-MM-DD') - TO_DATE('20190901', 'YYYY-MM-DD') +1                 
       ) M1
       LEFT JOIN (
                  SELECT --+ ORDERED USE_NL(D) INDEX(D LO_OUT_D_IDXPK)
                         M.OUTBOUND_DATE   AS OUT_DATE
                        ,SUM(D.ORDER_QTY)  AS QTY
                    FROM LO_OUT_M M
                         JOIN LO_OUT_D D  ON D.INVOICE_NO   = M.INVOICE_NO
                   WHERE M.OUTBOUND_DATE BETWEEN '20190901' AND '20190919'
                   GROUP BY M.OUTBOUND_DATE
                   ORDER BY OUT_DATE
                  ) M2 ON M2.OUT_DATE = M1.OUT_DATE
 ORDER BY M1.OUT_DATE;
                 
                  
SELECT NO
  FROM CS_NO
 WHERE NO <= TO_DATE('20190919', 'YYYY-MM-DD') - TO_DATE('20190901', 'YYYY-MM-DD') +1;  
 
 
--------------------------------------------------------------------------------
--DAY 12
--------------------------------------------------------------------------------
--실전문제1

SELECT INVOICE_NO ,LINE_NO ,ITEM_CD ,ITEM_NM ,ORDER_QTY
      ,SUM(ORDER_QTY) OVER(PARTITION BY INVOICE_NO ORDER BY LINE_NO) AS ACC_ORDER_QTY  --SUM+OVER => 분석함수 / GROUP BY 없음
  FROM LO_OUT_D
 WHERE INVOICE_NO IN ('346724703845', '346724706214');

--분석함수 쓰지 않는 경우 : SELF-JOIN
SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
      ,SUM(ACC_LINE_NO) AS ACC_ORDER_QTY
  FROM(    
        SELECT M1.INVOICE_NO ,M1.LINE_NO ,M1.ITEM_CD ,M1.ITEM_NM ,M1.ORDER_QTY 
              ,M2.LINE_NO   AS ACC_LINE_NO
              ,M2.ORDER_QTY AS ACC_ORDER_QTY
          FROM(    
                SELECT INVOICE_NO ,LINE_NO ,ITEM_CD ,ITEM_NM ,ORDER_QTY
                  FROM LO_OUT_D
                 WHERE INVOICE_NO IN ('346724703845', '346724706214')
              ) M1
              JOIN (
                    SELECT INVOICE_NO ,LINE_NO ,ITEM_CD ,ITEM_NM ,ORDER_QTY
                      FROM LO_OUT_D
                     WHERE INVOICE_NO IN ('346724703845', '346724706214')
                   ) M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                       AND M2.LINE_NO   <= M1.LINE_NO
         ORDER BY M1.INVOICE_NO , M1.LINE_NO, M2.LINE_NO
        ) L1
 GROUP BY INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY; 

--------------------------------------------------------------------------------

--실전문제2
SELECT INVOICE_NO ,LINE_NO ,ITEM_CD ,ITEM_NM ,ORDER_QTY
      ,SUM(ORDER_QTY) OVER(ORDER BY INVOICE_NO, LINE_NO) AS ACC_ORDER_QTY 
  FROM LO_OUT_D
 WHERE INVOICE_NO IN ('346724703845', '346724706214'); 
--------------------------------------------------------------------------------

--실전문제3
SELECT L1.INVOICE_NO
      ,L1.LINE_NO
      ,L1.ITEM_CD
      ,L1.ITEM_NM
      ,L1.ORDER_QTY AS ER_QTY
      ,L2.ORDER_QTY AS LO_QTY
  FROM (
        SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
          FROM ER_OUT
         WHERE OUTBOUND_DATE  = '2019-09-03'
           AND OUTBOUND_BATCH = '046' 
           AND ITEM_NM LIKE '%한입떡갈비%'
       ) L1
       LEFT JOIN (
                  SELECT M2.INVOICE_NO, M2.LINE_NO, M2.ITEM_CD, M2.ITEM_NM , M2.ORDER_QTY
                    FROM LO_OUT_M M1
                         JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                         AND M2.ITEM_NM LIKE '%한입떡갈비%'
                 ) L2 ON L2.INVOICE_NO = L1.INVOICE_NO
                     AND L2.LINE_NO    = L1.LINE_NO
 WHERE L2.INVOICE_NO IS NULL
 ORDER BY L1.INVOICE_NO
         ,L1.LINE_NO;
 
--------------------------------------------------------------------------------
--DAY 00.점검
--------------------------------------------------------------------------------
--실전문제1

SELECT OUTBOUND_DATE
      ,INVOICE_NO
      ,WORK_SEQ
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-04'
   AND SET_TYPE_CD   = '000581225'
   AND SET_QTY       = 3
 ORDER BY CASE TO_NUMBER(:SORT_TYPE)  WHEN 1 THEN WORK_SEQ
                                      WHEN 2 THEN -WORK_SEQ
          END
          ,INVOICE_NO;
          
--------------------------------------------------------------------------------
--실전문제2

SELECT INVOICE_NO
      ,LINE_NO
      ,ITEM_NM
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724704405'
 ORDER BY CASE TO_NUMBER(:SORT_TYPE)  WHEN 1 THEN ITEM_NM END
         ,CASE TO_NUMBER(:SORT_TYPE)  WHEN 2 THEN ITEM_NM END DESC;
         
--------------------------------------------------------------------------------
--DAY13
--------------------------------------------------------------------------------
--실전문제1

SELECT --+ ORDERED USE_NL(D)
       M.OUTBOUND_DATE
      ,SUM(ORDER_QTY) AS SUM_QTY
  FROM LO_OUT_M M
       JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
 WHERE M.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-30'    
 GROUP BY M.OUTBOUND_DATE      
 ORDER BY SUM_QTY DESC;
 
--------------------------------------------------------------------------------
--실전문제2-1
SELECT --+ ORDERED USE_NL(D)
       SUM(CASE TO_CHAR(OUTBOUND_DATE, 'DY') WHEN '일' THEN ORDER_QTY END) AS SUN
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'DY') WHEN '월' THEN ORDER_QTY END) AS MON
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'DY') WHEN '화' THEN ORDER_QTY END) AS TUE
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'DY') WHEN '수' THEN ORDER_QTY END) AS WED
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'DY') WHEN '목' THEN ORDER_QTY END) AS THU
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'DY') WHEN '금' THEN ORDER_QTY END) AS FRI
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'DY') WHEN '토' THEN ORDER_QTY END) AS SAT
  FROM LO_OUT_M M
       JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
 WHERE M.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-30';
 
 
SELECT SUN, MON, TUE, WED, THU, FRI, SAT
 FROM (
        SELECT --+ ORDERED USE_NL(D)
               TO_CHAR(M.OUTBOUND_DATE, 'D') AS DY
              ,SUM(D.ORDER_QTY)              AS ORDER_QTY
          FROM LO_OUT_M M
               JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
         WHERE M.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-30'
         GROUP BY TO_CHAR(OUTBOUND_DATE, 'D')
       )
 PIVOT (SUM(ORDER_QTY)  FOR DY IN(1 AS SUN, 2 AS MON, 3 AS TUE, 4 AS WED, 5 AS THU, 6 AS FRI, 7 AS SAT));      
  
 
--실전문제2-2

SELECT --+ ORDERED USE_NL(D)
       TO_CHAR(OUTBOUND_DATE, 'DAY') AS DAY
      ,SUM(ORDER_QTY)                AS ORDER_QTY
  FROM LO_OUT_M M
       JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
 WHERE M.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-30'
 GROUP BY TO_CHAR(OUTBOUND_DATE, 'DAY')
         ,TO_CHAR(OUTBOUND_DATE, 'D')
 ORDER BY TO_CHAR(OUTBOUND_DATE, 'D');
 
 
 
 
 
 
-------------------------------------------------------------------------------- 
--실전문제3

SELECT --+ ORDERED USE_NL(D)
       SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '01' THEN ORDER_QTY END) AS M01
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '02' THEN ORDER_QTY END) AS M02
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '03' THEN ORDER_QTY END) AS M03
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'Q')  WHEN '1'  THEN ORDER_QTY END) AS Q1
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '04' THEN ORDER_QTY END) AS M04
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '05' THEN ORDER_QTY END) AS M05
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '06' THEN ORDER_QTY END) AS M06
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'Q')  WHEN '2'  THEN ORDER_QTY END) AS Q2
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '07' THEN ORDER_QTY END) AS M07
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '08' THEN ORDER_QTY END) AS M08
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '09' THEN ORDER_QTY END) AS M09
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'Q')  WHEN '3'  THEN ORDER_QTY END) AS Q3
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '10' THEN ORDER_QTY END) AS M10
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '11' THEN ORDER_QTY END) AS M11
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'MM') WHEN '12' THEN ORDER_QTY END) AS M12
      ,SUM(CASE TO_CHAR(OUTBOUND_DATE, 'Q')  WHEN '4'  THEN ORDER_QTY END) AS Q4
  FROM LO_OUT_M M
       JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
 WHERE M.OUTBOUND_DATE BETWEEN '2019-01-01' AND '2019-12-31';  
 
 
 
 
 
 
 
--------------------------------------------------------------------------------
--실전문제4
SELECT RNUM ,ITEM_CD ,ITEM_NM 
      ,SUM(ORDER_QTY) AS ORDER_QTY
  FROM(
       SELECT CASE WHEN ROWNUM <= 5 THEN ROWNUM  ELSE 0               END AS RNUM
             ,CASE WHEN ROWNUM <= 5 THEN ITEM_CD ELSE '99999'         END AS ITEM_CD
             ,CASE WHEN ROWNUM <= 5 THEN ITEM_NM ELSE 'TOP5제외 합계' END AS ITEM_NM
             ,ORDER_QTY 
        FROM(
             SELECT --+ ORDERED USE_NL(D)
                   D.ITEM_CD
                  ,D.ITEM_NM
                  ,SUM(ORDER_QTY) AS ORDER_QTY
              FROM LO_OUT_M M
                   JOIN LO_OUT_D D ON D.INVOICE_NO = M.INVOICE_NO
             WHERE M.OUTBOUND_DATE BETWEEN '2019-06-01' AND '2019-06-30'
               AND D.ITEM_NM LIKE '%참치%'
             GROUP BY D.ITEM_CD, D.ITEM_NM
             ORDER BY ORDER_QTY DESC
            ) 
      )
 GROUP BY RNUM ,ITEM_CD ,ITEM_NM
 ORDER BY CASE WHEN RNUM IN (1,2,3,4,5) THEN 1 ELSE 2 END
         ,RNUM;    
