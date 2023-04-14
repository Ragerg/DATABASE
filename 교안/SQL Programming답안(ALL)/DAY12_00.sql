--실전문제① ▶ 하나의 SQL로 상황에 따라 정렬하기 (숫자)---------------------------------------------
SELECT OUTBOUND_DATE, INVOICE_NO, WORK_SEQ
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-04'
   AND SET_TYPE_CD   = '000581225'
   AND SET_QTY       = 3
 ORDER BY WORK_SEQ * DECODE(:SORT_TYPE, 1, 1, -1)
         ,INVOICE_NO;
  
/*MariaDB
SET @SORT_TYPE = 2;
SELECT OUTBOUND_DATE, INVOICE_NO, WORK_SEQ
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-04'
   AND SET_TYPE_CD   = '000581225'
   AND SET_QTY       = 3
 ORDER BY CASE WHEN @SORT_TYPE = 1 THEN WORK_SEQ ELSE -WORK_SEQ END
         ,INVOICE_NO;
*/     
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 하나의 SQL로 상황에 따라 정렬하기 (문자열)-------------------------------------------
SELECT INVOICE_NO, LINE_NO, ITEM_NM
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724704405'
 ORDER BY CASE WHEN :SORT_TYPE = 1 THEN ITEM_NM ELSE NULL    END ASC
         ,CASE WHEN :SORT_TYPE = 1 THEN NULL    ELSE ITEM_NM END DESC;

         
/*MariaDB
SET @SORT_TYPE = 2;
SELECT INVOICE_NO, LINE_NO, ITEM_NM
  FROM LO_OUT_D
 WHERE INVOICE_NO = '346724704405'
 ORDER BY CASE WHEN @SORT_TYPE = 1 THEN ITEM_NM ELSE NULL    END ASC
         ,CASE WHEN @SORT_TYPE = 1 THEN NULL    ELSE ITEM_NM END DESC;
*/            
----------------------------------------------------------------------------------------------------



