--실전문제① ▶ 분석함수 RANK / ROW_NUMBER 사용법 익히기---------------------------------------------
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "순위"
      ,ITEM_NM
      ,ORDER_QTY
  FROM (
        SELECT OUTBOUND_DATE
              ,ITEM_NM
              ,ORDER_QTY
              ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
              ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                       M1.OUTBOUND_DATE
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_NM  
               ) L1
       ) L2
 WHERE CHK <= 3;
 
/*MariaDB
동일함
*/    
----------------------------------------------------------------------------------------------------

 
 
 
 
--실전문제② ▶ 분석함수 RANK / ROW_NUMBER / SUM / RATIO_TO_REPORT 사용법 익히기---------------------
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "순위"
      ,ITEM_NM
      ,ORDER_QTY
    --,ROUND((ORDER_QTY / DAY_QTY) * 100, 2) AS "점유율"
      ,ROUND(RATE * 100, 2)                  AS "점유율"
  FROM (
        SELECT OUTBOUND_DATE
              ,ITEM_NM
              ,ORDER_QTY
              ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
              ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
            --,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                       AS DAY_QTY
              ,RATIO_TO_REPORT(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)           AS RATE
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                       M1.OUTBOUND_DATE
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_NM  
               ) L1
       ) L2
 WHERE CHK <= 3;
 
/*MariaDB
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "순위"
      ,ITEM_NM
      ,ORDER_QTY
      ,ROUND((ORDER_QTY / DAY_QTY) * 100, 2) AS "점유율"
  FROM (
        SELECT OUTBOUND_DATE
              ,ITEM_NM
              ,ORDER_QTY
              ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
              ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
              ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                       AS DAY_QTY
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_NM  
               ) L1
       ) L2
 WHERE CHK <= 3;
*/    
----------------------------------------------------------------------------------------------------
 
 
 
 
 
--3)실전문제③ ▶ 분석함수 RANK / ROW_NUMBER / SUM / RATIO_TO_REPORT 사용법 익히기-------------------
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "순위"
      ,ITEM_NM
      ,ORDER_QTY
      ,ROUND((ORDER_QTY / DAY_QTY) * 100, 2) AS "점유율"
      ,ROUND((ACC_QTY   / DAY_QTY) * 100, 2) AS "누적점유율"
  FROM (
        SELECT OUTBOUND_DATE
              ,RNK
              ,CHK
              ,ITEM_NM
              ,ORDER_QTY
              ,DAY_QTY
              ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE ORDER BY RNK) AS ACC_QTY
          FROM (
                SELECT OUTBOUND_DATE
                      ,ITEM_NM
                      ,ORDER_QTY
                      ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
                      ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
                      ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                       AS DAY_QTY
                  FROM (
                        SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                               M1.OUTBOUND_DATE
                              ,M2.ITEM_NM
                              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                          FROM LO_OUT_M M1
                               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                         GROUP BY M1.OUTBOUND_DATE
                                 ,M2.ITEM_NM  
                       ) L1
               ) L2
         WHERE CHK <= 3
       ) L3;
       
/*MariaDB
동일함
*/          
----------------------------------------------------------------------------------------------------





--실전문제④ ▶ 분석함수/집계함수 적용 및 데이터 늘리기 응용하기-------------------------------------
SELECT --■ 출고일자 ■
       CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN NO = 2 THEN '계' WHEN NO = 3 THEN '일평균' WHEN NO = 4 THEN 'Peak' END AS OUTBOUND_DATE 
       --■ SKU수 ■
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)       --1)날짜별(원본)
                  WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)   --2)계 --> 날짜별 중복을 제거한 전체 SKU수
                  WHEN NO = 3 THEN AVG(ITEM_CNT)       --3)일평균
                  WHEN NO = 4 THEN MAX(ITEM_CNT)       --4)Peak
             END) ITEM_CNT
       --■ ORDER수 ■   
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)      --1)날짜별(원본)
                  WHEN NO = 2 THEN SUM(ORDER_CNT)      --2)계
                  WHEN NO = 3 THEN AVG(ORDER_CNT)      --3)일평균
                  WHEN NO = 4 THEN MAX(ORDER_CNT)      --4)Peak
             END) ORDER_CNT
       --■ O.L.수 ■
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_LINE_CNT) --1)날짜별(원본)
                  WHEN NO = 2 THEN SUM(ORDER_LINE_CNT) --2)계
                  WHEN NO = 3 THEN AVG(ORDER_LINE_CNT) --3)일평균
                  WHEN NO = 4 THEN MAX(ORDER_LINE_CNT) --4)Peak
             END) ORDER_LINE_CNT
       --■ 출고수량 ■ 
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_QTY)      --1)날짜별(원본)
                  WHEN NO = 2 THEN SUM(ORDER_QTY)      --2)계
                  WHEN NO = 3 THEN AVG(ORDER_QTY)      --3)일평균
                  WHEN NO = 4 THEN MAX(ORDER_QTY)      --4)Peak
             END) ORDER_QTY 
  FROM (
        SELECT OUTBOUND_DATE                    AS OUTBOUND_DATE   -- 출고일자
              ,COUNT(DISTINCT ITEM_CD)          AS ITEM_CNT        -- SKU수
              ,COUNT(DISTINCT INVOICE_NO)       AS ORDER_CNT       -- ORDER수
              ,COUNT(1)                         AS ORDER_LINE_CNT  -- O.L.수
              ,SUM(ORDER_QTY)                   AS ORDER_QTY       -- 예정수량
              ,MIN(TOT_ITEM_CNT)                AS TOT_ITEM_CNT    -- 전체 SKU수
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                       M1.OUTBOUND_DATE
                      ,M1.INVOICE_NO
                      ,M2.ITEM_CD
                      ,M2.ORDER_QTY
                      ,COUNT(DISTINCT M2.ITEM_CD) OVER() AS TOT_ITEM_CNT  -- 전체 SKU수
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
               ) L1
         GROUP BY OUTBOUND_DATE
         ORDER BY OUTBOUND_DATE
       ) L2
       JOIN CS_NO C1 ON C1.NO <= 4   -- [1]원본 [2]합계 [3]평균 [4]피크
 GROUP BY CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN NO = 2 THEN '계' WHEN NO = 3 THEN '일평균' WHEN NO = 4 THEN 'Peak' END
         ,NO
 ORDER BY NO
         ,OUTBOUND_DATE;     
         
/*MariaDB  분석함수 COUNT(DISTINCT) 지원 안됨
SELECT CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') WHEN NO = 2 THEN '계' WHEN NO = 3 THEN '일평균' WHEN NO = 4 THEN 'Peak' END AS OUTBOUND_DATE -- 출고일자
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)
                  WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)
                  WHEN NO = 3 THEN AVG(ITEM_CNT)
                  WHEN NO = 4 THEN MAX(ITEM_CNT)
             END) ITEM_CNT   -- SKU수
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)
                  WHEN NO = 2 THEN SUM(ORDER_CNT) 
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
  FROM (
        SELECT M1.OUTBOUND_DATE  -- 출고일자
              ,M1.ITEM_CNT       -- SKU수
              ,M1.ORDER_CNT      -- ORDER수
              ,M1.ORDER_LINE_CNT -- O.L.수
              ,M1.ORDER_QTY      -- 예정수량
              ,M2.TOT_ITEM_CNT   -- 전체 SKU수
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
                       FROM LO_OUT_M M1
					                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
					                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
                    ) M2 ON 1 = 1
         ORDER BY M1.OUTBOUND_DATE
       ) L2
       JOIN CS_NO C1 ON C1.NO <= 4   -- [1]원본 [2]합계 [3]평균 [4]피크
 GROUP BY CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') WHEN NO = 2 THEN '계' WHEN NO = 3 THEN '일평균' WHEN NO = 4 THEN 'Peak' END
         ,NO
 ORDER BY NO
         ,OUTBOUND_DATE;   
*/              
---------------------------------------------------------------------------------------------------- 



         
         
--실전문제⑤ ▶ 분석함수를 이용한 빠진 날짜 구하기---------------------------------------------------
SELECT OUTBOUND_DATE
  FROM (
        SELECT :OUTBOUND_DATE1 + NO - 1 AS OUTBOUND_DATE
          FROM CS_NO
         WHERE NO <= :OUTBOUND_DATE2 - :OUTBOUND_DATE1 + 1
       ) M1
 WHERE NOT EXISTS (SELECT 1
                     FROM LO_OUT_M S1
                    WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
                  );

                  
--최종) 차이나는 일수만큼 레코드를 복제하고 출고일자가 존재하는 날짜를 제외하여 최종 SKIP_DATE 구함
SELECT FROM_DATE + NO - 1 AS SKIP_DATE
  FROM (--L3) 복제범위가 되는 시작일자,종료일자를 구함 (레코드가 존재하는 일자도 함께 표시함 - 다음 단계에서 제외하기 위함) 
        SELECT CASE WHEN LAG_DATE IS NULL THEN :OUTBOUND_DATE1 ELSE OUTBOUND_DATE END AS FROM_DATE --첫번째 레코드만 조건의 첫번째 날짜를 세팅
              ,LEAD_DATE AS TO_DATE
              ,OUTBOUND_DATE AS EXISTS_DATE
          FROM (--L2) 이전날짜/이후날짜를 가져오되, NULL인 마지막 레코드는 조건의 마지막 날짜를 세팅 
                SELECT OUTBOUND_DATE
                      ,LAG (OUTBOUND_DATE) OVER(ORDER BY OUTBOUND_DATE) AS LAG_DATE
                      ,LEAD(OUTBOUND_DATE - 1, 1, :OUTBOUND_DATE2) OVER(ORDER BY OUTBOUND_DATE) AS LEAD_DATE
                  FROM (--L1) 출고가 존재하는 날짜만 가져옴
                        SELECT OUTBOUND_DATE
                          FROM (
                                SELECT :OUTBOUND_DATE1 + NO - 1 AS OUTBOUND_DATE
                                  FROM CS_NO
                                 WHERE NO <= :OUTBOUND_DATE2 - :OUTBOUND_DATE1 + 1
                               ) M1
                         WHERE EXISTS (SELECT 1
                                         FROM LO_OUT_M S1
                                        WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
                                      )
                       ) L1
               ) L2
       ) L3
       JOIN CS_NO C1 ON C1.NO <= CASE WHEN FROM_DATE = TO_DATE THEN 0 ELSE TO_DATE - FROM_DATE + 1 END
 WHERE FROM_DATE + NO - 1 != EXISTS_DATE; --복제 대상이된 레코드는 출고가 존재하는 출고일자를 의미하므로 여기서 제외시킴
 
 /*MariaDB
해야 함.. 
*/ 
----------------------------------------------------------------------------------------------------