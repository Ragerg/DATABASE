--실전문제① ▶ 다양한 조건절 적용하기 + 정렬하기----------------------------------------------------
SELECT INVOICE_NO, OUTBOUND_DATE, OUT_TYPE_DIV, OUT_BOX_DIV, OUT_BOX_NM
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-02'
   AND OUT_TYPE_DIV  IN ('M15', 'M22')
   AND OUT_BOX_DIV   LIKE 'F%'
   AND ORDER_PLACE   = '52685'
 ORDER BY OUTBOUND_DATE, INVOICE_NO;
 
 /* MariaDB
 동일
 */
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 집계함수 적용하기 + 정렬하기---------------------------------------------------------
SELECT OUTBOUND_DATE
      ,COUNT(1)                    AS TOT_CNT
      ,COUNT(DISTINCT OUT_BOX_DIV) AS OUT_BOX_CNT
      ,MIN(OUT_BOX_DIV)            AS OUT_BOX_MIN
      ,MAX(OUT_BOX_DIV)            AS OUT_BOX_MAX
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-02'
   AND OUT_TYPE_DIV  IN ('M15', 'M22')
   AND OUT_BOX_DIV   LIKE 'F%'
   AND ORDER_PLACE   = '52685'
 GROUP BY OUTBOUND_DATE
 ORDER BY OUTBOUND_DATE;
 
 /* MariaDB
 동일
 */
----------------------------------------------------------------------------------------------------
