--실전문제① ▶ 인라인뷰, 스칼라쿼리 함께 사용하기---------------------------------------------------
SELECT ITEM_CD
      ,(
        SELECT S1.ITEM_NM
          FROM CM_ITEM S1
         WHERE S1.ITEM_CD = L1.ITEM_CD 
       ) AS ITEM_NM
      ,ORDER_QTY
  FROM (
        SELECT ITEM_CD
              ,SUM(ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_D
         WHERE INVOICE_NO BETWEEN '346724706262' AND '346724706762'
         GROUP BY ITEM_CD
         ORDER BY ITEM_CD
       ) L1;
       
/*MariaDB
동일
*/          
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 인라인뷰를 활용한 단계적 쿼리 만들어 보기--------------------------------------------
SELECT ROWNUM                       AS RNK
      ,ITEM_CD
      ,QTY_IN_BOX
      ,ORDR_QTY                     AS ORDER_QTY
      ,TRUNC(ORDR_QTY / QTY_IN_BOX) AS BOX_CNT
      ,MOD(ORDR_QTY, QTY_IN_BOX)    AS PCS_CNT
      ,CEIL(ORDR_QTY / QTY_IN_BOX)  AS BOX_CNT_TOT
  FROM (
        SELECT ITEM_CD
              ,QTY_IN_BOX
              ,SUM(ORDER_QTY) AS ORDR_QTY
          FROM LO_OUT_D
         WHERE INVOICE_NO BETWEEN '346724706262' AND '346724706762'
         GROUP BY ITEM_CD
                 ,QTY_IN_BOX
         ORDER BY SUM(ORDER_QTY) DESC, ITEM_CD
       )
 WHERE ROWNUM <= 5;
 
/*MariaDB
SELECT @ROWNUM := @ROWNUM + 1             AS RNK
      ,ITEM_CD
      ,QTY_IN_BOX
      ,ORDR_QTY                           AS ORDER_QTY
      ,TRUNCATE(ORDR_QTY / QTY_IN_BOX, 0) AS BOX_CNT
      ,MOD(ORDR_QTY, QTY_IN_BOX)          AS PCS_CNT
      ,CEILING(ORDR_QTY / QTY_IN_BOX)     AS BOX_CNT_TOT
  FROM (
        SELECT ITEM_CD
              ,QTY_IN_BOX
              ,SUM(ORDER_QTY) AS ORDR_QTY
          FROM LO_OUT_D
         WHERE INVOICE_NO BETWEEN '346724706262' AND '346724706762'
         GROUP BY ITEM_CD
                 ,QTY_IN_BOX
         ORDER BY SUM(ORDER_QTY) DESC, ITEM_CD LIMIT 5
       ) L1
	WHERE (@ROWNUM := 0) = 0;
*/    
----------------------------------------------------------------------------------------------------
