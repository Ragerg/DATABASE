--���������� �� ������ ǥ���ϴ� �����Լ� ����ϱ�----------------------------------------------------
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
      ,CONCAT(SUBSTR( _UTF8'�Ͽ�ȭ�������', DAYOFWEEK(OUTBOUND_DATE), 1), '����') AS DAYY
      ,OUTBOUND_NO
  FROM LO_OUT_M 
 WHERE INVOICE_NO IN ('346724706214', '346724793596', '346724869970')
 ORDER BY OUTBOUND_DATE, INVOICE_NO;
 */
----------------------------------------------------------------------------------------------------





--���������� �� �����Լ�, �����Լ� �����ϱ�----------------------------------------------------------
SELECT NVL(TO_CHAR(SUM(ORDER_QTY)), 'Empty..') AS ORDER_QTY
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706215';
 
  /* MariaDB
SELECT NVL(CONVERT(SUM(ORDER_QTY), CHAR), 'Empty..') AS ORDER_QTY
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724706215';
 */
----------------------------------------------------------------------------------------------------
