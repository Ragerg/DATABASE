--DAY 10
--------------------------------------------------------------------------------
SELECT M1.INVOICE_NO ,M1.OUTBOUND_DATE ,M1.OUT_TYPE_DIV
      ,M2.LINE_NO ,M2.ITEM_CD ,M2.ORDER_QTY
  FROM LO_OUT_M M1
       JOIN LO_OUT_D M2   ON M2.INVOICE_NO = M1.INVOICE_NO
 WHERE M1.INVOICE_NO IN ('346724703834', '346724722535', '346724717915');
--------------------------------------------------------------------------------

--문1
SELECT M1.BRAND_CD, M1.OUTBOUND_DATE, M1.INVOICE_NO, M2.LINE_NO, M2.ORDER_QTY
  FROM A_OUT_M M1
       JOIN A_OUT_D M2  ON M2.BRAND_CD = M1.BRAND_CD
                       AND M2.INVOICE_NO = M1.INVOICE_NO
                       AND M2.ITEM_CD      IN('B', 'D')
 WHERE M1.OUTBOUND_DATE = '2023-01-04';
   
--문2
SELECT M1.BRAND_CD
      ,M1.OUTBOUND_DATE
      ,M2.ITEM_CD
      ,SUM(M2.ORDER_QTY) AS SUM_QTY
  FROM A_OUT_M M1
       JOIN A_OUT_D M2  ON M2.BRAND_CD   = M1.BRAND_CD
                       AND M2.INVOICE_NO = M1.INVOICE_NO
                       AND M2.ITEM_CD      IN('B', 'D')
 WHERE M1.OUTBOUND_DATE BETWEEN '2023-01-03' AND '2023-01-04'
 GROUP BY M1.BRAND_CD, M1.OUTBOUND_DATE, M2.ITEM_CD
 ORDER BY BRAND_CD, OUTBOUND_DATE;

--문3
SELECT INVOICE_NO, ORDER_NM
  FROM (
        SELECT M1.INVOICE_NO , M1.ORDER_NM
              ,SUM(M2.ORDER_QTY) AS SUM_QTY
          FROM A_OUT_M M1
          JOIN A_OUT_D M2  ON M2.BRAND_CD   = M1.BRAND_CD
                          AND M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.BRAND_CD = '1001'
           AND M1.OUTBOUND_DATE BETWEEN '2023-01-04' AND '2023-01-05'
         GROUP BY M1.INVOICE_NO, M1.ORDER_NM
         ORDER BY SUM_QTY DESC
        )
 WHERE ROWNUM = 1;        

--문4
SELECT M1.BRAND_CD
      ,M1.OUTBOUND_DATE
      ,M1.INVOICE_NO
      ,M2.ITEM_CD
      ,M3.ITEM_NM
      ,M2.ORDER_QTY
  FROM A_OUT_M M1
       JOIN A_OUT_D M2   ON M2.BRAND_CD   = M1.BRAND_CD
                        AND M2.INVOICE_NO = M1.INVOICE_NO
                        AND M2.ORDER_QTY >= 3
       JOIN A_ITEM  M3   ON M3.BRAND_CD   = M2.BRAND_CD
                        AND M3.ITEM_CD    = M2.ITEM_CD
 WHERE M1.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'
 ORDER BY BRAND_CD, OUTBOUND_DATE;

--문5
SELECT M1.BRAND_CD
      ,M1.ITEM_CD
      ,SUM(M1.ORDER_QTY)
      ,M2.ITEM_NM
      ,M2.QTY_IN_BOX
  FROM A_OUT_D M1
       JOIN A_ITEM M2  ON M2.BRAND_CD   = M1.BRAND_CD
                      AND M2.ITEM_CD    = M1.ITEM_CD
       JOIN A_OUT_M M3 ON M3.BRAND_CD   = M1.BRAND_CD
                      AND M3.INVOICE_NO = M1.INVOICE_NO
 WHERE M3.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'                     
 GROUP BY M1.BRAND_CD, M1.ITEM_CD, M2.ITEM_NM, M2.QTY_IN_BOX
 ORDER BY BRAND_CD, ITEM_CD;
 
 
SELECT M1.BRAND_CD, M1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX, M1.SUM_QTY
  FROM (
        SELECT M1.BRAND_CD
              ,M2.ITEM_CD
              ,SUM(M2.ORDER_QTY) AS SUM_QTY
          FROM A_OUT_M M1
               JOIN A_OUT_D M2  ON M2.BRAND_CD   = M1.BRAND_CD
                               AND M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'
         GROUP BY M1.BRAND_CD, M2.ITEM_CD
       ) M1
        JOIN A_ITEM C1  ON C1.BRAND_CD = M1.BRAND_CD
                       AND C1.ITEM_CD  = M1.ITEM_CD
 ORDER BY M1.BRAND_CD, M1.ITEM_CD;                   
 
 
 
--문6
SELECT BRAND_CD
      ,ITEM_CD
      ,ITEM_NM
      ,QTY_IN_BOX
      ,SUM_QTY
      ,TRUNC(SUM_QTY/ QTY_IN_BOX) AS BOX_CNT
      ,MOD(SUM_QTY , QTY_IN_BOX) AS PCS_CNT
 FROM (
        SELECT M1.BRAND_CD
              ,M1.ITEM_CD
              ,SUM(M1.ORDER_QTY) AS SUM_QTY
              ,M2.ITEM_NM
              ,M2.QTY_IN_BOX
          FROM A_OUT_D M1
               JOIN A_ITEM  M2  ON M2.BRAND_CD   = M1.BRAND_CD
                               AND M2.ITEM_CD    = M1.ITEM_CD
               JOIN A_OUT_M M3  ON M3.BRAND_CD   = M1.BRAND_CD
                               AND M3.INVOICE_NO = M1.INVOICE_NO
         WHERE M3.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'                     
         GROUP BY M1.BRAND_CD, M1.ITEM_CD, M2.ITEM_NM, M2.QTY_IN_BOX
         ORDER BY BRAND_CD, ITEM_CD
       );

--문7
SELECT *
  FROM (
        SELECT BRAND_CD
              ,ITEM_CD
              ,ITEM_NM
              ,QTY_IN_BOX
              ,SUM_QTY
              ,TRUNC(SUM_QTY/ QTY_IN_BOX) AS BOX_CNT
              ,MOD(SUM_QTY , QTY_IN_BOX) AS PCS_CNT
         FROM (
                SELECT M1.BRAND_CD
                      ,M1.ITEM_CD
                      ,SUM(M1.ORDER_QTY) AS SUM_QTY
                      ,M2.ITEM_NM
                      ,M2.QTY_IN_BOX
                  FROM A_OUT_D M1
                       JOIN A_ITEM  M2  ON M2.BRAND_CD   = M1.BRAND_CD
                                       AND M2.ITEM_CD    = M1.ITEM_CD
                       JOIN A_OUT_M M3  ON M3.BRAND_CD   = M1.BRAND_CD
                                       AND M3.INVOICE_NO = M1.INVOICE_NO
                 WHERE M3.OUTBOUND_DATE BETWEEN '2023-01-01' AND '2023-01-04'                     
                 GROUP BY M1.BRAND_CD, M1.ITEM_CD, M2.ITEM_NM, M2.QTY_IN_BOX
                 ORDER BY BRAND_CD, ITEM_CD
               )
          ORDER BY BOX_CNT DESC
         )
 WHERE ROWNUM <= 3;         

--------------------------------------------------------------------------------
SELECT LEVEL + :TODAY AS DY
  FROM DUAL 
CONNECT BY LEVEL <= 10;

SELECT INVOICE_NO, LINE_NO, ITEM_CD, ORDER_QTY, NO
  FROM LO_OUT_D M1
       JOIN CS_NO C1 ON C1.NO <= 2 
 WHERE INVOICE_NO = '346724706214'
 ORDER BY LINE_NO, NO;
 
SELECT CASE NO WHEN 1 THEN INVOICE_NO ELSE '합계' END AS INVOICE_NO
      ,CASE NO WHEN 1 THEN LINE_NO    ELSE 0      END AS LINE_NO
      ,CASE NO WHEN 1 THEN ITEM_CD    ELSE '-'    END AS ITEM_CD
      ,SUM(ORDER_QTY) AS SUM_QTY
--      ,NO
  FROM LO_OUT_D M1
       JOIN CS_NO C1 ON C1.NO <= 2
 WHERE INVOICE_NO = '346724706214'
 GROUP BY CASE NO WHEN 1 THEN INVOICE_NO ELSE '합계' END 
         ,CASE NO WHEN 1 THEN LINE_NO    ELSE 0      END 
         ,CASE NO WHEN 1 THEN ITEM_CD    ELSE '-'    END 
         ,NO
 ORDER BY NO
         ,INVOICE_NO
         ,LINE_NO;
 
SELECT INVOICE_NO, LINE_NO, ITEM_CD, ORDER_QTY, NO
  FROM LO_OUT_D M1
       JOIN CS_NO C1 ON C1.NO <= M1.ORDER_QTY
 WHERE INVOICE_NO = '346724706214'
 ORDER BY LINE_NO, NO;