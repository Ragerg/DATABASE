SELECT M1.INVOICE_NO ,M1.OUTBOUND_DATE ,M1.OUT_TYPE_DIV
      ,M2.LINE_NO ,M2.ITEM_CD ,M2.ORDER_QTY
  FROM LO_OUT_M M1
  JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
 WHERE M1.INVOICE_NO IN ('346724703834', '346724722535', '346724717915')
