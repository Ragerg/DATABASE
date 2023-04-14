--���������� �� 3�� ���̺��� ������ ��������----------------------------------------------------
SELECT M1.INVOICE_NO   ,   M1.OUTBOUND_DATE   ,   M1.OUT_TYPE_DIV
      ,M2.LINE_NO      ,   M2.ITEM_CD         ,   C1.ITEM_NM        ,   M2.ORDER_QTY
  FROM LO_OUT_M M1
       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
       JOIN CM_ITEM  C1 ON C1.ITEM_CD    = M2.ITEM_CD
 WHERE M1.INVOICE_NO IN ('346724703834', '346724722535', '346724717915')
	ORDER BY M2.INVOICE_NO, M2.LINE_NO;
	
/*MariaDB
������
*/   	
----------------------------------------------------------------------------------------------------





--���������� �� �� SQL���� ������ ���̺��� 2ȸ �̻� ���ο� ������Ű�� ���� �����ϱ�------------------
SELECT M1.INVOICE_NO   ,   M1.OUTBOUND_DATE   ,   M1.OUT_TYPE_DIV
      ,M2.LINE_NO      ,   M2.ITEM_CD         ,   C1.ITEM_NM        ,   M2.ORDER_QTY
      ,C2.CODE_NM AS TEMP_NM
      ,C3.CODE_NM AS OUT_TYPE_NM
  FROM LO_OUT_M M1
       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
       JOIN CM_ITEM  C1 ON C1.ITEM_CD    = M2.ITEM_CD
       JOIN CS_CODE  C2 ON C2.CODE_GRP   = 'LDIV01'
                       AND C2.CODE_CD    = M1.TEMP_DIV
       JOIN CS_CODE  C3 ON C3.CODE_GRP   = 'LDIV03'
                       AND C3.CODE_CD    = M1.OUT_TYPE_DIV
 WHERE M1.INVOICE_NO IN ('346724703834', '346724722535', '346724717915')
	ORDER BY M2.INVOICE_NO, M2.LINE_NO;
	
/*MariaDB
������
*/   	
----------------------------------------------------------------------------------------------------