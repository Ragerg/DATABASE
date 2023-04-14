--실전문제① ▶ 상황에 따른 데이터 늘리기 연습하기---------------------------------------------------
SELECT LINE_NO
      ,ITEM_CD
      ,ITEM_NM
      ,ORDER_QTY
      ,NO
  FROM LO_OUT_D M1
       JOIN CS_NO C1 ON C1.NO <= CASE WHEN MOD(M1.ORDER_QTY, 2) = 0 THEN 1 ELSE 2 END
 WHERE INVOICE_NO = '346724702600'
 ORDER BY LINE_NO
         ,NO;
         
/*MariaDB
동일함
*/            
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 박스입수만큼 상품 혼적하기-----------------------------------------------------------
--1)
SELECT BOX_NO, LINE_NO, ITEM_NM, ORDER_QTY
      ,COUNT(1) AS QTY
  FROM (
        SELECT LINE_NO, ITEM_NM, ORDER_QTY, NO, ROWNUM AS RNUM
              ,CEIL(ROWNUM / :QTY_IN_BOX) AS BOX_NO
          FROM (
                SELECT LINE_NO, ITEM_NM, ORDER_QTY, NO
                  FROM LO_OUT_D M1
                       JOIN CS_NO C1 ON C1.NO <= M1.ORDER_QTY
                 WHERE INVOICE_NO = '346724706214'
                 ORDER BY LINE_NO, NO  
               )
       )
 GROUP BY BOX_NO, LINE_NO, ITEM_NM, ORDER_QTY
 ORDER BY BOX_NO, LINE_NO;


/*MariaDB
SET @QTY_IN_BOX = 25;
SET @ROWNUM = 0;
SELECT BOX_NO, LINE_NO, ITEM_NM, ORDER_QTY
      ,COUNT(1) AS QTY
  FROM (
        SELECT LINE_NO, ITEM_NM, ORDER_QTY, NO
								      ,@ROWNUM := @ROWNUM + 1 AS RNUM
              ,CEILING(@ROWNUM / @QTY_IN_BOX) AS BOX_NO
          FROM (
                SELECT LINE_NO, ITEM_NM, ORDER_QTY, NO
                  FROM LO_OUT_D M1
                       JOIN CS_NO C1 ON C1.NO <= M1.ORDER_QTY
                 WHERE INVOICE_NO = '346724706214'
                 ORDER BY LINE_NO, NO  
               ) L1
       ) L2
 GROUP BY BOX_NO, LINE_NO, ITEM_NM, ORDER_QTY
 ORDER BY BOX_NO, LINE_NO;
*/            
----------------------------------------------------------------------------------------------------





--실전문제③ ▶ 출고일자별 출고수량 소계 구하기------------------------------------------------------
SELECT OUT_DATE
      ,ITEM_CD
      ,ITEM_NM
      ,SUM_QTY
  FROM (
        SELECT OUTBOUND_DATE                  AS OUT_DATE
              ,CASE WHEN NO = 1 THEN ITEM_CD ELSE '소계' END AS ITEM_CD
              ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-'    END AS ITEM_NM
              ,SUM(SUM_QTY)                   AS SUM_QTY
              ,NO
          FROM (
                SELECT --+ ORDERED USE_NL(M2)
                       M1.OUTBOUND_DATE
                      ,M2.ITEM_CD
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS SUM_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                       AND M2.ITEM_NM LIKE '%동원참치%'
                 WHERE M1.OUTBOUND_DATE BETWEEN :OUTBOUND_DATE1 AND :OUTBOUND_DATE2
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_CD
                         ,M2.ITEM_NM
                 ORDER BY M1.OUTBOUND_DATE
               ) L1
               JOIN CS_NO C1 ON NO <= 2
         GROUP BY OUTBOUND_DATE
                 ,CASE WHEN NO = 1 THEN ITEM_CD ELSE '소계' END
                 ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-'    END
                 ,NO
         ORDER BY OUTBOUND_DATE, NO
       )
 ORDER BY OUT_DATE
         ,NO * (CASE WHEN :SORT = 1 THEN 1 ELSE -1 END)
         ,ITEM_CD;
         
/*MariaDB
SET @SORT = 2;
SELECT OUT_DATE
      ,ITEM_CD
      ,ITEM_NM
      ,SUM_QTY
  FROM (
        SELECT OUTBOUND_DATE                  AS OUT_DATE
              ,CASE WHEN NO = 1 THEN ITEM_CD ELSE '소계' END AS ITEM_CD
              ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-'    END AS ITEM_NM
              ,SUM(SUM_QTY)                   AS SUM_QTY
              ,NO
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M2.ITEM_CD
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS SUM_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                       AND M2.ITEM_NM LIKE '%동원참치%'
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-04'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_CD
                         ,M2.ITEM_NM
                 ORDER BY M1.OUTBOUND_DATE  
               ) L1
               JOIN CS_NO C1 ON NO <= 2
         GROUP BY OUTBOUND_DATE
                 ,CASE WHEN NO = 1 THEN ITEM_CD ELSE '소계' END
                 ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-'    END
                 ,NO
       ) L2
 ORDER BY OUT_DATE
         ,NO * CASE WHEN @SORT = 1 THEN 1 ELSE -1 END
         ,ITEM_CD
         ,ITEM_NM;
*/            
----------------------------------------------------------------------------------------------------





--실전문제④ ▶ 출고일자별 출고수량 소계와 전체 합계 구하기------------------------------------------
SELECT OUT_DATE
      ,ITEM_CD
      ,ITEM_NM
      ,SUM_QTY
  FROM (
        SELECT CASE WHEN NO = 3 THEN '합계' ELSE TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') END AS OUT_DATE
              ,CASE WHEN NO = 1 THEN ITEM_CD WHEN NO = 2 THEN '소계' ELSE '-' END         AS ITEM_CD
              ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-' END                                 AS ITEM_NM
              ,SUM(SUM_QTY) AS SUM_QTY
              ,NO
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M2.ITEM_CD
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS SUM_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                       AND M2.ITEM_NM LIKE '%동원참치%'
                 WHERE M1.OUTBOUND_DATE BETWEEN :OUTBOUND_DATE1 AND :OUTBOUND_DATE2
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_CD
                         ,M2.ITEM_NM
                 ORDER BY M1.OUTBOUND_DATE  
               ) M1
               JOIN CS_NO C1 ON C1.NO <= 3
         GROUP BY CASE WHEN NO = 3 THEN '합계' ELSE TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') END
                 ,CASE WHEN NO = 1 THEN ITEM_CD WHEN NO = 2 THEN '소계' ELSE '-' END
                 ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-' END
                 ,NO
       ) L1
 ORDER BY (CASE WHEN NO = 3 THEN 3 ELSE 1 END) * (CASE WHEN :SORT = 1 THEN 1 ELSE -1 END)      
         ,OUT_DATE
         ,NO * (CASE WHEN :SORT = 1 THEN 1 ELSE -1 END)
         ,ITEM_CD;
         
/*MariaDB
SET @SORT = 2;
SELECT OUT_DATE
      ,ITEM_CD
      ,ITEM_NM
      ,SUM_QTY
  FROM (
        SELECT CASE WHEN NO = 3 THEN '합계' ELSE TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') END AS OUT_DATE
              ,CASE WHEN NO = 1 THEN ITEM_CD WHEN NO = 2 THEN '소계' ELSE '-' END         AS ITEM_CD
              ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-' END                                 AS ITEM_NM
              ,SUM(SUM_QTY)                           AS SUM_QTY
              ,NO
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M2.ITEM_CD
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS SUM_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                       AND M2.ITEM_NM LIKE '%동원참치%'
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-04'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_CD
                         ,M2.ITEM_NM
                 ORDER BY M1.OUTBOUND_DATE  
               ) M1
               JOIN CS_NO C1 ON C1.NO <= 3
         GROUP BY CASE WHEN NO = 3 THEN '합계' ELSE TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') END
                 ,CASE WHEN NO = 1 THEN ITEM_CD WHEN NO = 2 THEN '소계' ELSE '-' END
                 ,CASE WHEN NO = 1 THEN ITEM_NM ELSE '-' END
                 ,NO
       ) L1
 ORDER BY CASE WHEN NO = 3 THEN 3 ELSE 1 END * CASE WHEN @SORT = 1 THEN 1 ELSE -1 END      
         ,OUT_DATE
         ,NO * CASE WHEN @SORT = 1 THEN 1 ELSE -1 END
         ,ITEM_CD;
*/            
----------------------------------------------------------------------------------------------------

