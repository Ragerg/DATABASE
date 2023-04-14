--실전문제① ▶ 규칙 찾기----------------------------------------------------------------------------
SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
  FROM (
        SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
              ,ROW_NUMBER() OVER(ORDER BY TO_NUMBER(BAY_CD) - TO_NUMBER(LEV_CD), BAY_CD DESC) AS RNUM
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
              ,ROW_NUMBER() OVER(ORDER BY CONVERT(BAY_CD, INTEGER) - CONVERT(LEV_CD, INTEGER), BAY_CD DESC) AS RNUM
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





--실전문제② ▶ 하나의 SQL로 상황에 따라 정렬하기 (서로 다른 컬럼으로 정렬)--------------------------
SELECT ITEM_CD, ITEM_NM, ORDER_QTY
  FROM (
        SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
               M2.ITEM_CD
              ,M2.ITEM_NM
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_NM    LIKE '%참치%'
         WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-05'
         GROUP BY M2.ITEM_CD
                 ,M2.ITEM_NM
       ) L1
 ORDER BY CASE WHEN ITEM_NM LIKE '동원%' THEN ITEM_NM END
         ,ORDER_QTY DESC;
         
/*MariaDB
SELECT ITEM_CD, ITEM_NM, ORDER_QTY
  FROM (
        SELECT M2.ITEM_CD
              ,M2.ITEM_NM
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_NM    LIKE '%참치%'
         WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-05'
         GROUP BY M2.ITEM_CD
                 ,M2.ITEM_NM
       ) L1
 ORDER BY CASE WHEN ITEM_NM LIKE '동원%' THEN CONCAT('1', ITEM_NM) ELSE '2' END -- NULL이 맨 처음 오늘 것을 방지하기 위해
         ,ORDER_QTY DESC;
*/            
---------------------------------------------------------------------------------------------------- 





--실전문제③ ▶ FROM~TO 선분이력에서 해당 구간만 가져오기--------------------------------------------
SELECT NAME
      ,OPEN_DATE
      ,CLOSE_DATE
      ,GREATEST(OPEN_DATE , TO_DATE (:YYYYMM||'01', 'YYYY-MM-DD')) AS START_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(:YYYYMM||'01'))                  AS FINISH_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(:YYYYMM||'01')) - GREATEST(OPEN_DATE , TO_DATE (:YYYYMM||'01', 'YYYY-MM-DD')) + 1 AS DAYS
  FROM V_KT L1
 WHERE CLOSE_DATE >= TO_DATE (:YYYYMM||'01', 'YYYY-MM-DD')
   AND OPEN_DATE  <= LAST_DAY(:YYYYMM||'01');
   
/*MariaDB
SET @YYYYMM = '2019-11';
SELECT NAME
      ,OPEN_DATE
      ,CLOSE_DATE
      ,GREATEST(OPEN_DATE , CONVERT(CONCAT(@YYYYMM, '-01'), DATE))          AS START_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(CONVERT(CONCAT(@YYYYMM, '-01'), DATE)))   AS FINISH_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(CONVERT(CONCAT(@YYYYMM, '-01'), DATE))) - GREATEST(OPEN_DATE , CONVERT(CONCAT(@YYYYMM, '-01'), DATE)) + 1 AS DAYS
  FROM (
        SELECT '조민권' AS NAME, CONVERT('2019-09-01', DATE) AS OPEN_DATE, CONVERT('2019-12-05', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '고선주' AS NAME, CONVERT('2019-09-15', DATE) AS OPEN_DATE, CONVERT('9999-12-31', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '정의수' AS NAME, CONVERT('2019-09-10', DATE) AS OPEN_DATE, CONVERT('2019-10-30', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '유은별' AS NAME, CONVERT('2019-10-25', DATE) AS OPEN_DATE, CONVERT('2019-11-01', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '전정훈' AS NAME, CONVERT('2019-11-25', DATE) AS OPEN_DATE, CONVERT('9999-12-31', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '윤현수' AS NAME, CONVERT('2019-12-05', DATE) AS OPEN_DATE, CONVERT('9999-12-31', DATE) AS CLOSE_DATE
       ) L1
 WHERE CLOSE_DATE >= CONVERT(CONCAT(@YYYYMM, '-01'), DATE)
   AND OPEN_DATE  <= LAST_DAY(CONVERT(CONCAT(@YYYYMM, '-01'), DATE));
*/      
----------------------------------------------------------------------------------------------------





--실전문제④ ▶ 분석함수/집계함수 적용 및 데이터 늘리기 응용하기-------------------------------------
SELECT --최종 Avg:중간값 (일평균 대비 중값값의 비율) 구하기
       CASE WHEN NO_2 = 1 THEN OUTBOUND_DATE           ELSE 'Avg:중간값'                                               END AS OUTBOUND_DATE   --출고일자
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ITEM_CNT)       ELSE ROUND(NXT_ITEM_CNT       / ITEM_CNT       * 100, 1) || '%' END AS ITEM_CNT        --SKU수
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ORDER_CNT)      ELSE ROUND(NXT_ORDER_CNT      / ORDER_CNT      * 100, 1) || '%' END AS ORDER_CNT       --ORDER수
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ORDER_LINE_CNT) ELSE ROUND(NXT_ORDER_LINE_CNT / ORDER_LINE_CNT * 100, 1) || '%' END AS ORDER_LINE_CNT  --O.L.수
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ORDER_QTY)      ELSE ROUND(NXT_ORDER_QTY      / ORDER_QTY      * 100, 1) || '%' END AS ORDER_QTY       --출고수량
    --,DECODE(NO_2, 2, 5, NO_1) AS NO
  FROM (--L4 Avg:중간값 (일평균 대비 중값값의 비율)을 구하기 위해 --> 일평균 레코드와 중간값 레코드를 복제
        SELECT L3.*
              ,CASE WHEN NO = 2 THEN LEAD(ITEM_CNT)       OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ITEM_CNT --마지막에 복제한 일평균을 중간값과 동일한 5로 인식하게 함
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_CNT)      OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ORDER_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_LINE_CNT) OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ORDER_LINE_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_QTY)      OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ORDER_QTY
              ,NO AS NO_2
          FROM (--L3 중간값 (일평균과 PEAK값의 중간값)
                SELECT CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '중간값' END AS OUTBOUND_DATE
                      ,ROUND(AVG(ITEM_CNT))                   AS ITEM_CNT
                      ,ROUND(AVG(ORDER_CNT))                  AS ORDER_CNT
                      ,ROUND(AVG(ORDER_LINE_CNT))             AS ORDER_LINE_CNT
                      ,ROUND(AVG(ORDER_QTY))                  AS ORDER_QTY
                      ,MAX(NO_1 + NO - 1)                     AS NO_1
                  FROM (--L2 계/평균/Peak
                        SELECT CASE NO WHEN 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN 2 THEN '계' WHEN 3 THEN '일평균' WHEN 4 THEN 'Peak' END AS OUTBOUND_DATE --출고일자
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)
                                          WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)
                                          WHEN NO = 3 THEN AVG(ITEM_CNT)
                                          WHEN NO = 4 THEN MAX(ITEM_CNT)
                                     END) ITEM_CNT   --SKU수
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)
                                          WHEN NO = 2 THEN SUM(ORDER_CNT)
                                          WHEN NO = 3 THEN AVG(ORDER_CNT)
                                          WHEN NO = 4 THEN MAX(ORDER_CNT)
                                     END) ORDER_CNT   --ORDER수
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_LINE_CNT)
                                          WHEN NO = 2 THEN SUM(ORDER_LINE_CNT)
                                          WHEN NO = 3 THEN AVG(ORDER_LINE_CNT)
                                          WHEN NO = 4 THEN MAX(ORDER_LINE_CNT)
                                     END) ORDER_LINE_CNT --O.L.수
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_QTY)
                                          WHEN NO = 2 THEN SUM(ORDER_QTY)
                                          WHEN NO = 3 THEN AVG(ORDER_QTY)
                                          WHEN NO = 4 THEN MAX(ORDER_QTY)
                                     END) ORDER_QTY --예정수량
                              , NO AS NO_1
                          FROM (--L1 기본값 및 총SKU수/총오더수 구하기
                                SELECT OUTBOUND_DATE                    AS OUTBOUND_DATE   --출고일자
                                      ,COUNT(DISTINCT ITEM_CD)          AS ITEM_CNT        --SKU수
                                      ,COUNT(DISTINCT INVOICE_NO)       AS ORDER_CNT       --ORDER수
                                      ,COUNT(1)                         AS ORDER_LINE_CNT  --O.L.수
                                      ,SUM(ORDER_QTY)                   AS ORDER_QTY       --예정수량
                                      ,MIN(TOT_ITEM_CNT)                AS TOT_ITEM_CNT    --전체 SKU수
                                  FROM (
                                        SELECT --+ ORDERED USE_NL(M2)
                                               M1.OUTBOUND_DATE
                                              ,M1.INVOICE_NO
                                              ,M2.ITEM_CD
                                              ,M2.ORDER_QTY
                                              ,COUNT(DISTINCT M2.ITEM_CD   ) OVER() AS TOT_ITEM_CNT  --전체 SKU수
                                              ,COUNT(DISTINCT M2.INVOICE_NO) OVER() AS TOT_ORDER_CNT --전체 오더수
                                          FROM LO_OUT_M M1
                                               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                         WHERE M1.OUTBOUND_DATE BETWEEN :OUTBOUND_DATE1 AND :OUTBOUND_DATE2
                                       )
                                 GROUP BY OUTBOUND_DATE
                                 ORDER BY OUTBOUND_DATE
                               ) L1
                               JOIN CS_NO C1 ON C1.NO <= 4   --[1]원본 [2]합계 [3]평균 [4]피크
                         GROUP BY CASE NO WHEN 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN 2 THEN '계' WHEN 3 THEN '일평균' WHEN 4 THEN 'Peak' END
                                 ,NO
                         ORDER BY NO
                                 ,OUTBOUND_DATE
                       ) L2
                       JOIN CS_NO C2 ON C2.NO <= CASE NO_1 WHEN 1 THEN 1 --[원본]은 복제안함
                                                           WHEN 2 THEN 1 --[계]는 복제안함
                                                           ELSE        2 --[일평균]/[Peak]만 복제함
                                                  END
                 GROUP BY CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '중간값' END
                 ORDER BY NO_1
                         ,OUTBOUND_DATE
               ) L3
               JOIN CS_NO C3 ON C3.NO IN (1, CASE NO_1 WHEN 3 THEN 2 END) --[일평균]만 복제 / [나머지]는 복제 안함
         ORDER BY NO, NO_1, OUTBOUND_DATE
       ) L4;
 
/*MariaDB
SELECT CASE WHEN NO_2 = 1 THEN OUTBOUND_DATE           ELSE 'Avg:중간값'                                                           END AS OUTBOUND_DATE         -- 출고일자
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ITEM_CNT, CHAR)       ELSE CONCAT(ROUND(NXT_ITEM_CNT       / ITEM_CNT       * 100, 1), '%') END AS ITEM_CNT        -- SKU수
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ORDER_CNT, CHAR)      ELSE CONCAT(ROUND(NXT_ORDER_CNT      / ORDER_CNT      * 100, 1), '%') END AS ORDER_CNT       -- ORDER수
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ORDER_LINE_CNT, CHAR) ELSE CONCAT(ROUND(NXT_ORDER_LINE_CNT / ORDER_LINE_CNT * 100, 1), '%') END AS ORDER_LINE_CNT  -- O.L.수
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ORDER_QTY, CHAR)      ELSE CONCAT(ROUND(NXT_ORDER_QTY      / ORDER_QTY      * 100, 1), '%') END AS ORDER_QTY       -- 출고수량
   -- ,DECODE(NO_2, 2, 5, NO_1) AS NO
  FROM (-- L4
        SELECT L3.*
              ,CASE WHEN NO = 2 THEN LEAD(ITEM_CNT)       OVER(ORDER BY NO, NO_1) END AS NXT_ITEM_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_CNT)      OVER(ORDER BY NO, NO_1) END AS NXT_ORDER_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_LINE_CNT) OVER(ORDER BY NO, NO_1) END AS NXT_ORDER_LINE_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_QTY)      OVER(ORDER BY NO, NO_1) END AS NXT_ORDER_QTY
              ,NO AS NO_2
          FROM (-- L3 중간값
                SELECT CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '중간값' END AS OUTBOUND_DATE
                      ,ROUND(AVG(ITEM_CNT))                   AS ITEM_CNT
                      ,ROUND(AVG(ORDER_CNT))                  AS ORDER_CNT
                      ,ROUND(AVG(ORDER_LINE_CNT))             AS ORDER_LINE_CNT
                      ,ROUND(AVG(ORDER_QTY))                  AS ORDER_QTY
                      ,MAX(NO_1 + NO - 1)                     AS NO_1
                  FROM (-- L2 계/평균/Peak
                        SELECT CASE NO WHEN 1 THEN CONVERT(OUTBOUND_DATE, CHAR) WHEN 2 THEN '계' WHEN 3 THEN '일평균' WHEN 4 THEN 'Peak' END AS OUTBOUND_DATE -- 출고일자
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)
                                          WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)
                                          WHEN NO = 3 THEN AVG(ITEM_CNT)
                                          WHEN NO = 4 THEN MAX(ITEM_CNT)
                                     END) ITEM_CNT   -- SKU수
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)
                                          WHEN NO = 2 THEN MIN(TOT_ORDER_CNT)
                                          WHEN NO = 3 THEN AVG(ORDER_CNT)
                                          WHEN NO = 4 THEN MAX(ORDER_CNT)
                                     END) ORDER_CNT   -- ORDER수
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_LINE_CNT)
                                          WHEN NO = 2 THEN SUM(ORDER_LINE_CNT)
                                          WHEN NO = 3 THEN AVG(ORDER_LINE_CNT)
                                          WHEN NO = 4 THEN MAX(ORDER_LINE_CNT)
                                     END) ORDER_LINE_CNT -- O.L.수
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_QTY)
                                          WHEN NO = 2 THEN SUM(ORDER_QTY)
                                          WHEN NO = 3 THEN AVG(ORDER_QTY)
                                          WHEN NO = 4 THEN MAX(ORDER_QTY)
                                     END) ORDER_QTY -- 예정수량
                              , NO AS NO_1
                          FROM (-- L1
																								        SELECT M1.OUTBOUND_DATE  -- 출고일자
																								              ,M1.ITEM_CNT       -- SKU수
																								              ,M1.ORDER_CNT      -- ORDER수
																								              ,M1.ORDER_LINE_CNT -- O.L.수
																								              ,M1.ORDER_QTY      -- 예정수량
																								              ,M2.TOT_ITEM_CNT   -- 전체 SKU수
																								              ,M2.TOT_ORDER_CNT  -- 전체 입고처수
																								          FROM (
																								                SELECT M1.OUTBOUND_DATE
																								                      ,COUNT(DISTINCT M2.ITEM_CD)    AS ITEM_CNT
																								                      ,COUNT(DISTINCT M2.INVOICE_NO) AS ORDER_CNT
																								                      ,COUNT(1)                      AS ORDER_LINE_CNT
																								                      ,SUM(ORDER_QTY)                AS ORDER_QTY
																								                  FROM LO_OUT_M M1
																								                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
																								                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
																								                 GROUP BY M1.OUTBOUND_DATE
																								               ) M1
																								               JOIN (-- 분석함수에서 COUNT(DISTINCT를 사용할 수 없어서 어쩔수 없이 분리함
																								                     SELECT COUNT(DISTINCT M2.ITEM_CD)    AS TOT_ITEM_CNT
																								                           ,COUNT(DISTINCT M2.INVOICE_NO) AS TOT_ORDER_CNT
																								                       FROM LO_OUT_M M1
																													                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
																													                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
																								                    ) M2 ON 1 = 1
																								         ORDER BY M1.OUTBOUND_DATE
                               ) L1
                               JOIN CS_NO C1 ON C1.NO <= 4   -- [1]원본 [2]합계 [3]평균 [4]피크
                         GROUP BY CASE NO WHEN 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN 2 THEN '계' WHEN 3 THEN '일평균' WHEN 4 THEN 'Peak' END
                                 ,NO
                         ORDER BY NO
                                 ,OUTBOUND_DATE
                       ) L2
                       JOIN CS_NO C2 ON C2.NO <= CASE NO_1 WHEN 1 THEN 1 WHEN 2 THEN 1 ELSE 2 END
                 GROUP BY CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '중간값' END
                 ORDER BY NO_1
                         ,OUTBOUND_DATE
               ) L3
               JOIN CS_NO C3 ON C3.NO <= CASE NO_1 WHEN 3 THEN 2 WHEN 5 THEN 2 ELSE 1 END
         ORDER BY NO, NO_1, OUTBOUND_DATE
       ) L4
 WHERE NOT (NO_1 = 5 AND NO_2 = 2);
*/    
----------------------------------------------------------------------------------------------------