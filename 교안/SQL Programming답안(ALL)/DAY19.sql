--실전문제① ▶ 분석함수 MIN/MAX 사용법 익히기-------------------------------------------------------
SELECT INVOICE_NO
      ,LINE_NO
      ,ITEM_NM
      ,ORDER_QTY
      ,MIN(ORDER_QTY) OVER(PARTITION BY INVOICE_NO) AS MIN_1
      ,MIN(ORDER_QTY) OVER()                        AS MIN_2
      ,MAX(ORDER_QTY) OVER(PARTITION BY INVOICE_NO) AS MAX_1
      ,MAX(ORDER_QTY) OVER()                        AS MAX_2
  FROM LO_OUT_D
 WHERE INVOICE_NO IN ('346724703845', '346724706214', '346724706225');
 
/*MariaDB
동일함
*/    
----------------------------------------------------------------------------------------------------