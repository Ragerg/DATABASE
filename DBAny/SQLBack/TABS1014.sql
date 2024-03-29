--실전문제2
SELECT  INVOICE_NO
      , OUT_TYPE_DIV
      , OUT_BOX_DIV
      , (
         SELECT MAX(ORDER_QTY) AS MAX_ORDER_QTY
           FROM LO_OUT_D S1
          WHERE S1.INVOICE_NO = M1.INVOICE_NO
        ) /*
      , (
         SELECT MAX(LINE_NO)
           FROM LO_OUT_D S1
          WHERE S1.INVOICE_NO = M1.INVOICE_NO
        ) AS MAX_LINE_NO
        */
  FROM LO_OUT_M M1
 WHERE OUTBOUND_DATE = '2019-06-03'
   AND OUTBOUND_NO   BETWEEN 'D190603-897353' AND 'D190603-897360'
   
SELECT SYSDATE        AS CUR_DATETIME
      ,TRUNC(SYSDATE) AS CUR_DATE
      ,SYSDATE +1     AS TOMORROW
      ,SUBSTR('ABCD1234', 1, 5) AS VAL1
      ,LPAD(34, 5, '0') AS LEFT_PADDING
      ,SUBSTR(LPAD(34, 5, '0'), 1, 3) AS LEFT_PADDING_SUBSTR1
      ,SUBSTR(LPAD(34, 5, '0'), 4, 2) AS LEFT_PADDING_SUBSTR2
  FROM DUAL    
-----------------------------------------------------------------------
SELECT INVOICE_NO
      ,OUT_TYPE_DIV
      ,OUT_BOX_DIV
      ,SUBSTR(OUT_TYPE_DIV, 2, 2) AS SUB_VAL
      ,1   AS VAL1
      ,'A' AS VAL2
      ,OUT_TYPE_DIV || '-' || OUT_BOX_DIV AS AAA
      ,LENGTH(INVOICE_NO) AS BBB
      ,TO_CHAR(OUTBOUND_DATE, 'YYYY-MM') AS CCC
      ,TO_CHAR(OUTBOUND_DATE, 'YYYYMM') AS DDD
      ,TO_CHAR(OUTBOUND_DATE, 'YY-MM') AS EEE
      ,TO_CHAR(OUTBOUND_DATE, 'MM-DD') AS FFF
      ,TO_CHAR(OUTBOUND_DATE, 'WW') AS GGG--주차
      ,TO_CHAR(OUTBOUND_DATE, 'Q') AS HHH--분기
  FROM LO_OUT_M M1
 WHERE OUTBOUND_DATE = '2019-06-03'
   AND OUTBOUND_NO   BETWEEN 'D190603-897353' AND 'D190603-897360';
-----------------------------------------------------------------------

SELECT INVOICE_NO
      ,OUT_TYPE_DIV
      ,OUT_BOX_DIV
      ,TO_NUMBER(SUBSTR(VAL,  1,10)) AS MAX_ORDER_QTY
      ,TO_NUMBER(SUBSTR(VAL, 12,10)) AS MAX_LINE_NO
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
        )

        SELECT MAX(LPAD(ORDER_QTY, 3, '0') || LPAD(LINE_NO, 3, '0')) AS MAX_VAL
          FROM LO_OUT_D S1
         WHERE S1.INVOICE_NO = '346724738226';
-----------------------------------------------------------------------

--DAY7
--문1
-----------------------------------------------------------------------

SELECT  M1.BRAND_CD
      , M1.ITEM_CD
      , SUM(ORDER_QTY) AS SUM_QTY
      ,(
        SELECT S1.ITEM_NM
          FROM A_ITEM S1
         WHERE S1.BRAND_CD = M1.BRAND_CD
           AND S1.ITEM_CD  = M1.ITEM_CD
       ) AS ITEM_NM
      ,(
        SELECT S1.QTY_IN_BOX
          FROM A_ITEM S1
         WHERE S1.BRAND_CD = M1.BRAND_CD
           AND S1.ITEM_CD  = M1.ITEM_CD
       ) AS QTY_BOX  
  FROM A_OUT_D M1
 GROUP BY M1.BRAND_CD, M1.ITEM_CD 
 ORDER BY M1.BRAND_CD, M1.ITEM_CD;
-----------------------------------------------------------------------

SELECT M1.BRAND_CD
      ,M1.ITEM_CD
      ,M1.ITEM_NM
      ,M1.QTY_IN_BOX
      ,(
        SELECT SUM(S1.ORDER_QTY)
          FROM A_OUT_D S1
         WHERE S1.BRAND_CD = M1.BRAND_CD
           AND S1.ITEM_CD  = M1.ITEM_CD 
        )AS SUM_QTY   
  FROM A_ITEM M1
 GROUP BY M1.BRAND_CD, M1.ITEM_CD, M1.ITEM_NM, M1.QTY_IN_BOX
 ORDER BY M1.BRAND_CD, M1.ITEM_CD
 
 -----------------------------------------------------------------------
SELECT M1.BRAND_CD
      ,M1.ITEM_CD
      ,C1.ITEM_NM
      ,C1.QTY_IN_BOX
      ,SUM(M1.ORDER_QTY)
  FROM A_OUT_D M1
       JOIN A_ITEM C1 ON C1.BRAND_CD = M1.BRAND_CD
                     AND C1.ITEM_CD  = M1.ITEM_CD
 GROUP BY M1.BRAND_CD, M1.ITEM_CD, C1.ITEM_NM, C1.QTY_IN_BOX
 ORDER BY M1.BRAND_CD, M1.ITEM_CD  
 
----------------------------------------------------------------------- 



 SELECT BRAND_CD
       ,ITEM_CD
       ,SUBSTR(VAL,  6,3) AS ITEM_NM
       ,SUBSTR(VAL, 19,1)AS QTY_IN_BOX
       ,SUM_QTY
   FROM (
        SELECT BRAND_CD
              ,ITEM_CD
              ,SUM(ORDER_QTY) AS SUM_QTY
              ,(
               SELECT LPAD(S1.ITEM_NM, 10, '0') || '-' || LPAD(S1.QTY_IN_BOX, 10, '0')
                 FROM A_ITEM S1
                WHERE S1.BRAND_CD = M1.BRAND_CD
                  AND S1.ITEM_CD  = M1.ITEM_CD
               ) AS VAL  
          FROM A_OUT_D M1
         GROUP BY BRAND_CD, ITEM_CD 
         ORDER BY BRAND_CD, ITEM_CD
        )    
        
-----------------------------------------------------------------------  
--문1, 2, 3

--7) 박스수가 가장 많은 TOP3만 표시함
SELECT * 
  FROM (
        --5)박스 수와 낱개수량을 함께 표시함 
        SELECT BRAND_CD
              ,ITEM_CD
              ,ITEM_NM
              ,SUM_QTY
              ,QTY_IN_BOX
              ,TRUNC(SUM_QTY / QTY_IN_BOX)  AS BOX_CNT
              ,MOD(SUM_QTY, QTY_IN_BOX)     AS PCS_CNT 
          FROM (
                --4)박스입수와 상품명을 분리함
                SELECT BRAND_CD 
                      ,ITEM_CD
                      ,SUM_QTY                           
                      ,SUBSTR(VAL, 4)               AS ITEM_NM
                      ,TO_NUMBER(SUBSTR(VAL,  1,3)) AS QTY_IN_BOX
                  FROM ( --3)박스입수와 상품명을 연결하여 하나의 컬럼으로 가져옴      
                         SELECT L1.BRAND_CD
                               ,L1.ITEM_CD
                               ,L1.SUM_QTY
                               ,( --2)상품명과 박스입수를 가져오는 스칼라쿼리   
                                 SELECT LPAD(S1.QTY_IN_BOX, 3, '0') || S1.ITEM_NM
                                   FROM A_ITEM S1
                                  WHERE S1.BRAND_CD = L1.BRAND_CD
                                    AND S1.ITEM_CD  = L1.ITEM_CD
                                ) AS VAL
                           FROM ( --1)브랜드/상품별 주문수량 합계를 구함 
                                 SELECT M1.BRAND_CD
                                       ,M1.ITEM_CD
                                       ,SUM(M1.ORDER_QTY) AS SUM_QTY
                                   FROM A_OUT_D M1
                                 GROUP BY M1.BRAND_CD, M1.ITEM_CD
                                 ORDER BY M1.BRAND_CD, M1.ITEM_CD
                                )L1
                        )  
               )
         ORDER BY BOX_CNT DESC --6)가장 많은 박스 수 부터 표시하기 위해 재정렬 
       )
  WHERE ROWNUM <=3;          

----------------------------------------------------------------------------------------

--실전문제1

SELECT ITEM_CD
      ,(
        SELECT ITEM_NM
          FROM CM_ITEM C1
         WHERE C1.ITEM_CD = M1.ITEM_CD 
       ) AS ITEM_NM
      ,ORDER_QTY
  FROM (
        SELECT ITEM_CD, SUM(ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_D 
         WHERE INVOICE_NO BETWEEN '346724706262' AND '346724706762'
         GROUP BY ITEM_CD
         ORDER BY ITEM_CD 
        ) M1


                                                                               
----------------------------------------------------------------------------------------

--실전문제2   


SELECT ROWNUM AS RNK
      ,ITEM_CD
      ,QTY_IN_BOX
      ,ORDER_QTY
      ,TRUNC(ORDER_QTY / QTY_IN_BOX)  AS BOX_CNT
      ,MOD(ORDER_QTY, QTY_IN_BOX)     AS PCS_CNT
      ,CEIL(ORDER_QTY / QTY_IN_BOX)   AS BOX_CNT_TOT
 FROM (
        SELECT ITEM_CD
              ,QTY_IN_BOX 
              ,SUM(ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_D
         WHERE INVOICE_NO BETWEEN '346724706262' AND '346724706762'  
         GROUP BY ITEM_CD, QTY_IN_BOX
         ORDER BY ORDER_QTY DESC
       )
 WHERE ROWNUM <= 5; 
                       
     