--실전문제① ▶ 규칙 찾기----------------------------------------------------------------------------
SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
  FROM (
        SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
              ,ROW_NUMBER() OVER(ORDER BY TO_NUMBER(BAY_CD) + TO_NUMBER(LEV_CD), BAY_CD DESC) AS RNUM
          FROM (
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '01' AS LEV_CD, '01-01-01-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '02' AS LEV_CD, '01-01-01-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '03' AS LEV_CD, '01-01-01-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '04' AS LEV_CD, '01-01-01-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '01' AS LEV_CD, '01-01-02-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '02' AS LEV_CD, '01-01-02-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '03' AS LEV_CD, '01-01-02-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '04' AS LEV_CD, '01-01-02-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '01' AS LEV_CD, '01-01-03-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '02' AS LEV_CD, '01-01-03-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '03' AS LEV_CD, '01-01-03-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '04' AS LEV_CD, '01-01-03-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '01' AS LEV_CD, '01-01-04-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '02' AS LEV_CD, '01-01-04-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '03' AS LEV_CD, '01-01-04-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '04' AS LEV_CD, '01-01-04-04' AS LOC_CD FROM DUAL   
               ) L1
       ) L2
 ORDER BY RNUM;

       
/*MariaDB
SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
  FROM (
        SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
              ,ROW_NUMBER() OVER(ORDER BY CONVERT(BAY_CD, INTEGER) + CONVERT(LEV_CD, INTEGER), BAY_CD DESC) AS RNUM
          FROM (
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '01' AS LEV_CD, '01-01-01-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '02' AS LEV_CD, '01-01-01-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '03' AS LEV_CD, '01-01-01-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '04' AS LEV_CD, '01-01-01-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '01' AS LEV_CD, '01-01-02-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '02' AS LEV_CD, '01-01-02-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '03' AS LEV_CD, '01-01-02-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '04' AS LEV_CD, '01-01-02-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '01' AS LEV_CD, '01-01-03-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '02' AS LEV_CD, '01-01-03-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '03' AS LEV_CD, '01-01-03-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '04' AS LEV_CD, '01-01-03-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '01' AS LEV_CD, '01-01-04-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '02' AS LEV_CD, '01-01-04-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '03' AS LEV_CD, '01-01-04-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '04' AS LEV_CD, '01-01-04-04' AS LOC_CD FROM DUAL   
               ) L1
       ) L2
 ORDER BY RNUM;
*/          
----------------------------------------------------------------------------------------------------




--실전문제② ▶ 데이터 늘리기 응용하기 (조건에 따른 복제 건수 달리하기)------------------------------
SELECT CASE WHEN NO = 3 THEN '합계' ELSE OUT_TYPE_DIV END  AS OUT_TYPE_DIV
      ,CASE WHEN NO = 1 THEN OUT_BOX_DIV WHEN NO = 2 THEN '소계' ELSE '-' END AS OUT_BOX_DIV
      ,SUM(ORDER_QTY) AS ORDER_QTY
  FROM (
        SELECT M1.OUT_TYPE_DIV
              ,M1.OUT_BOX_DIV
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
              ,COUNT(DISTINCT M1.OUT_BOX_DIV) OVER(PARTITION BY M1.OUT_TYPE_DIV) AS BOX_TYPE_CNT
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE  = '2019-09-03'
           AND M1.OUT_TYPE_DIV  IN ('M21', 'M22')
           AND M1.OUT_BOX_DIV LIKE 'F%'
         GROUP BY M1.OUT_TYPE_DIV
                 ,M1.OUT_BOX_DIV
       ) L1
       JOIN CS_NO C1 ON NO IN (1, CASE WHEN BOX_TYPE_CNT = 1 THEN NULL ELSE 2 END, 3)
 GROUP BY CASE WHEN NO = 3 THEN '합계' ELSE OUT_TYPE_DIV END
         ,CASE WHEN NO = 1 THEN OUT_BOX_DIV WHEN NO = 2 THEN '소계' ELSE '-' END
         ,NO
 ORDER BY CASE NO WHEN 3 THEN 2 ELSE 1 END
         ,OUT_TYPE_DIV
         ,NO
         ,OUT_BOX_DIV;
 
/*MariaDB -> COUNT(DISTINCT) 불허 --> 인라인뷰로 2단계 분리
SELECT CASE WHEN NO = 3 THEN '합계' ELSE OUT_TYPE_DIV END  AS OUT_TYPE_DIV
      ,CASE WHEN NO = 1 THEN OUT_BOX_DIV WHEN NO = 2 THEN '소계' ELSE '-' END AS OUT_BOX_DIV
      ,SUM(ORDER_QTY) AS ORDER_QTY
  FROM (
        SELECT OUT_TYPE_DIV
              ,OUT_BOX_DIV
              ,ORDER_QTY
              ,COUNT(OUT_BOX_DIV) OVER(PARTITION BY OUT_TYPE_DIV) AS BOX_TYPE_CNT
          FROM (
								        SELECT M1.OUT_TYPE_DIV
								              ,M1.OUT_BOX_DIV
								              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
								          FROM LO_OUT_M M1
								               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
								         WHERE M1.OUTBOUND_DATE  = '2019-09-03'
								           AND M1.OUT_TYPE_DIV  IN ('M21', 'M22')
								           AND M1.OUT_BOX_DIV LIKE 'F%'
								         GROUP BY M1.OUT_TYPE_DIV
								                 ,M1.OUT_BOX_DIV
               ) L1
       ) L1
       JOIN CS_NO C1 ON NO IN (1, CASE WHEN BOX_TYPE_CNT = 1 THEN NULL ELSE 2 END, 3)
 GROUP BY CASE WHEN NO = 3 THEN '합계' ELSE OUT_TYPE_DIV END
         ,CASE WHEN NO = 1 THEN OUT_BOX_DIV WHEN NO = 2 THEN '소계' ELSE '-' END
 ORDER BY OUT_TYPE_DIV, OUT_BOX_DIV;
*/    
----------------------------------------------------------------------------------------------------





--실전문제③ ▶ 분석함수 + 데이터 늘리기 응용하기----------------------------------------------------
--5) FROM날짜와 TO날짜 간격만큼 복제 후 예정수량 판단
SELECT M1.OUTBOUND_DATE
      ,NVL(SUM_QTY, 0) AS ORDER_QTY
  FROM (
        SELECT :OUTBOUND_DATE1 + NO - 1 AS OUTBOUND_DATE
          FROM CS_NO
         WHERE NO <= :OUTBOUND_DATE2 - :OUTBOUND_DATE1 + 1 
       ) M1 
  LEFT JOIN (
             SELECT --+ ORDERED USE_NL(M2)
                    M1.OUTBOUND_DATE
                   ,SUM(M2.ORDER_QTY) AS SUM_QTY
               FROM LO_OUT_M M1
                    JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
              WHERE M1.OUTBOUND_DATE BETWEEN :OUTBOUND_DATE1 AND :OUTBOUND_DATE2
              GROUP BY M1.OUTBOUND_DATE
            ) M2 ON M2.OUTBOUND_DATE = M1.OUTBOUND_DATE
 ORDER BY M1.OUTBOUND_DATE;

SELECT CALC_DATE AS OUTBOUND_DATE
      ,CASE WHEN OUTBOUND_DATE = CALC_DATE THEN ORDER_QTY ELSE 0 END AS ORDER_QTY
  FROM (--4) 
        SELECT FROM_DATE + NO - 1 AS CALC_DATE
              ,OUTBOUND_DATE
              ,ORDER_QTY
              ,NO
          FROM (--3) FROM날짜와 TO날짜를 완성한다.
                SELECT OUTBOUND_DATE
                      ,CASE WHEN LAG_DATE  IS NULL THEN :OUTBOUND_DATE1 ELSE OUTBOUND_DATE END AS FROM_DATE
                      ,CASE WHEN LEAD_DATE IS NULL THEN :OUTBOUND_DATE2 ELSE LEAD_DATE - 1 END AS TO_DATE
                      ,ORDER_QTY
                  FROM (--2) FROM날짜와 TO날짜를 확정하기 위해 이전값 이후값을 구한다.
                        SELECT OUTBOUND_DATE
                              ,ORDER_QTY
                              ,LAG(OUTBOUND_DATE)  OVER(ORDER BY OUTBOUND_DATE) AS LAG_DATE
                              ,LEAD(OUTBOUND_DATE) OVER(ORDER BY OUTBOUND_DATE) AS LEAD_DATE
                          FROM (--1) 존재하는 출고일자만으로 예정수량 합계를 구한다.
                                SELECT --+ ORDERED USE_NL(M2)
                                       M1.OUTBOUND_DATE
                                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                                  FROM LO_OUT_M M1
                                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                 WHERE M1.OUTBOUND_DATE BETWEEN :OUTBOUND_DATE1 AND :OUTBOUND_DATE2
                                 GROUP BY M1.OUTBOUND_DATE
                                 ORDER BY M1.OUTBOUND_DATE
                               ) L1
                       ) L2
               ) L3
               JOIN CS_NO C1 ON NO <= TO_DATE - FROM_DATE + 1
         ORDER BY CALC_DATE
       ) L4
 ORDER BY CALC_DATE;
 
/*MariaDB
SET @OUTBOUND_DATE1 = CONVERT('2019-09-07', DATE);
SET @OUTBOUND_DATE2 = CONVERT('2019-09-12', DATE);
SELECT CALC_DATE AS OUTBOUND_DATE
      ,CASE WHEN OUTBOUND_DATE = CALC_DATE THEN ORDER_QTY ELSE 0 END AS ORDER_QTY
  FROM (-- 4) 
        SELECT DATE_ADD(FROM_DATE,  INTERVAL (NO - 1) DAY) AS CALC_DATE
              ,OUTBOUND_DATE
              ,ORDER_QTY
              ,NO
          FROM (-- 3) FROM날짜와 TO날짜를 완성한다.
                SELECT OUTBOUND_DATE
                      ,CASE WHEN LAG_DATE  IS NULL THEN @OUTBOUND_DATE1 ELSE OUTBOUND_DATE END AS FROM_DATE
                      ,CASE WHEN LEAD_DATE IS NULL THEN @OUTBOUND_DATE2 ELSE DATE_SUB(LEAD_DATE, INTERVAL 1 DAY) END AS TO_DATE
                      ,ORDER_QTY
                  FROM (-- 2) FROM날짜와 TO날짜를 확정하기 위해 이전값 이후값을 구한다.
                        SELECT OUTBOUND_DATE
                              ,ORDER_QTY
                              ,LAG(OUTBOUND_DATE)  OVER(ORDER BY OUTBOUND_DATE) AS LAG_DATE
                              ,LEAD(OUTBOUND_DATE) OVER(ORDER BY OUTBOUND_DATE) AS LEAD_DATE
                          FROM (-- 1) 존재하는 출고일자만으로 예정수량 합계를 구한다.
                                SELECT M1.OUTBOUND_DATE
                                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                                  FROM LO_OUT_M M1
                                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                 WHERE M1.OUTBOUND_DATE BETWEEN @OUTBOUND_DATE1 AND @OUTBOUND_DATE2
                                 GROUP BY M1.OUTBOUND_DATE
                                 ORDER BY M1.OUTBOUND_DATE
                               ) L1
                       ) L2
               ) L3
               JOIN CS_NO C1 ON NO <= DATEDIFF(TO_DATE, FROM_DATE) + 1
         ORDER BY CALC_DATE
       ) L4
 ORDER BY CALC_DATE;
*/    
----------------------------------------------------------------------------------------------------





--실전문제④ ▶ CASE문을 활용한 집계함수 사용 원리 + 컬럼 연계 최대값 구하기-------------------------
SELECT :TODAY                                                        AS TODAY
      ,SUM(CASE WHEN OUTBOUND_DATE = :TODAY      THEN ORDER_QTY END) AS TODAY_QTY --당일 출고수량 합계
      ,SUM(CASE WHEN :TODAY - OUTBOUND_DATE <= 7 THEN ORDER_QTY END) AS WEEK_QTY  --최근 일주일 출고수량 합계
      ,SUM(ORDER_QTY)                                                AS MON_QTY   --당월 출고수량 합계
      ,TO_DATE  (SUBSTR(MAX(QTY_ || DATE_), 11,  8), 'YYYY-MM-DD')   AS MAX_DATE  --최대 출고수량의 출고일자
      ,TO_NUMBER(SUBSTR(MAX(QTY_ || DATE_),  1, 10))                 AS MAX_QTY   --최대 출고수량
  FROM (
        SELECT OUTBOUND_DATE
              ,ORDER_QTY
              ,TO_CHAR(OUTBOUND_DATE, 'YYYYMMDD') AS DATE_
              ,LPAD(ORDER_QTY, 10, '0')           AS QTY_
          FROM (
                SELECT --+ ORDERED USE_NL(M2)
                       M1.OUTBOUND_DATE
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE OUTBOUND_DATE BETWEEN TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') AND :TODAY
                 GROUP BY M1.OUTBOUND_DATE
               ) L1
       ) L2;

/*MariaDB
SET @TODAY = CONVERT('2019-09-19', DATE);
SELECT @TODAY                                                                 AS TODAY
      ,SUM(CASE WHEN OUTBOUND_DATE = @TODAY   THEN ORDER_QTY END)             AS TODAY_QTY -- 당일 출고수량 합계
      ,SUM(CASE WHEN DATEDIFF(@TODAY, OUTBOUND_DATE) <= 7 THEN ORDER_QTY END) AS WEEK_QTY  -- 최근 일주일 출고수량 합계
      ,SUM(ORDER_QTY)                                                         AS MON_QTY   -- 당월 출고수량 합계
      ,CONVERT(SUBSTR(MAX(CONCAT(QTY_, DATE_)), 11, 10), DATE)                AS MAX_DATE  -- 최대 출고수량의 출고일자
      ,CONVERT(SUBSTR(MAX(CONCAT(QTY_, DATE_)),  1, 10), INTEGER)             AS MAX_QTY   -- 최대 출고수량
  FROM (
        SELECT OUTBOUND_DATE
              ,ORDER_QTY
              ,TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') AS DATE_
              ,LPAD(ORDER_QTY, 10, '0')             AS QTY_
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE OUTBOUND_DATE BETWEEN CONVERT(CONCAT(DATE_FORMAT(@TODAY, '%Y-%m'), '-01'), DATE) AND @TODAY
                 GROUP BY M1.OUTBOUND_DATE
               ) L1
       ) L2;
*/          
----------------------------------------------------------------------------------------------------
