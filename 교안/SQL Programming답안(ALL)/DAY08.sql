--실전문제① ▶ 요일을 표시하는 내장함수 사용하기----------------------------------------------------
SELECT INVOICE_NO
      ,OUTBOUND_DATE
      ,TO_CHAR(OUTBOUND_DATE, 'day') AS DAYY
      ,OUTBOUND_NO
  FROM LO_OUT_M 
 WHERE INVOICE_NO IN ('346724706214', '346724793596', '346724869970')
 ORDER BY OUTBOUND_DATE, INVOICE_NO;
 
 /* MariaDB
 SELECT INVOICE_NO
      ,OUTBOUND_DATE
      ,CONCAT(SUBSTR( _UTF8'일월화수목금토', DAYOFWEEK(OUTBOUND_DATE), 1), '요일') AS DAYY
      ,OUTBOUND_NO
  FROM LO_OUT_M 
 WHERE INVOICE_NO IN ('346724706214', '346724793596', '346724869970')
 ORDER BY OUTBOUND_DATE, INVOICE_NO;
 */
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 집계함수, 내장함수 응용하기----------------------------------------------------------
SELECT NVL(TO_CHAR(SUM(ORDER_QTY)), 'Empty..') AS ORDER_QTY
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706215';
 
  /* MariaDB
SELECT NVL(CONVERT(SUM(ORDER_QTY), CHAR), 'Empty..') AS ORDER_QTY
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706215';
 */
----------------------------------------------------------------------------------------------------
