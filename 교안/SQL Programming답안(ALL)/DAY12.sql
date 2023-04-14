--실전문제① ▶ 파티션 있는 누적수량 구하기 (분석함수 배제)------------------------------------------
SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
      ,SUM(ACC_ORDER_QTY) AS ACC_ORDER_QTY
  FROM (
        SELECT M1.INVOICE_NO, M1.LINE_NO, M1.ITEM_CD, M1.ITEM_NM, M1.ORDER_QTY, M2.LINE_NO AS ACC_LINE_NO, M2.ORDER_QTY AS ACC_ORDER_QTY
          FROM (
                SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
                  FROM LO_OUT_D
                 WHERE INVOICE_NO IN ('346724703845', '346724706214')
               ) M1
               JOIN (
                     SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
                       FROM LO_OUT_D
                      WHERE INVOICE_NO IN ('346724703845', '346724706214')
                    ) M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                        AND M2.LINE_NO   <= M1.LINE_NO
         ORDER BY M1.INVOICE_NO, M1.LINE_NO, M2.LINE_NO                
       ) L1
 GROUP BY INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
 ORDER BY INVOICE_NO, LINE_NO;
 
/*MariaDB
동일함
*/    
---------------------------------------------------------------------------------------------------- 





--실전문제② ▶ 파티션 없는 누적수량 구하기 (분석함수 배제)------------------------------------------
SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
      ,SUM(ACC_ORDER_QTY) AS ACC_ORDER_QTY
  FROM (
        SELECT M1.INVOICE_NO, M1.LINE_NO, M1.ITEM_CD, M1.ITEM_NM, M1.ORDER_QTY, M2.LINE_NO AS ACC_LINE_NO, M2.ORDER_QTY AS ACC_ORDER_QTY
          FROM (
                SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
                  FROM LO_OUT_D
                 WHERE INVOICE_NO IN ('346724703845', '346724706214')
               ) M1
               JOIN (
                     SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
                       FROM LO_OUT_D
                      WHERE INVOICE_NO IN ('346724703845', '346724706214')
                    ) M2 ON M2.INVOICE_NO || LPAD(M2.LINE_NO, 5, '0') <= M1.INVOICE_NO || LPAD(M1.LINE_NO, 5, '0')
         ORDER BY M1.INVOICE_NO, M1.LINE_NO, M2.INVOICE_NO || LPAD(M2.LINE_NO, 5, '0')              
       ) L1
 GROUP BY INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
 ORDER BY INVOICE_NO, LINE_NO; 
 
/*MariaDB
SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
      ,SUM(ACC_ORDER_QTY) AS ACC_ORDER_QTY
  FROM (
        SELECT M1.INVOICE_NO, M1.LINE_NO, M1.ITEM_CD, M1.ITEM_NM, M1.ORDER_QTY, M2.LINE_NO AS ACC_LINE_NO, M2.ORDER_QTY AS ACC_ORDER_QTY
          FROM (
                SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
                  FROM LO_OUT_D
                 WHERE INVOICE_NO IN ('346724703845', '346724706214')
               ) M1
               JOIN (
                     SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
                       FROM LO_OUT_D
                      WHERE INVOICE_NO IN ('346724703845', '346724706214')
                    ) M2 ON CONCAT(M2.INVOICE_NO, LPAD(M2.LINE_NO, 5, '0')) <= CONCAT(M1.INVOICE_NO, LPAD(M1.LINE_NO, 5, '0'))
         ORDER BY M1.INVOICE_NO, M1.LINE_NO, CONCAT(M1.INVOICE_NO, LPAD(M1.LINE_NO, 5, '0'))           
       ) L1
 GROUP BY INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
 ORDER BY INVOICE_NO, LINE_NO; 
*/    
---------------------------------------------------------------------------------------------------- 





--실전문제③ ▶ 어느 한 쪽에만 존재하는 집합 구하기--------------------------------------------------
SELECT L1.INVOICE_NO
      ,L1.LINE_NO
      ,L1.ITEM_CD
      ,L1.ITEM_NM
      ,L1.ORDER_QTY    AS ER_QTY
      ,L2.ORDER_QTY    AS LO_QTY
  FROM (
        SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
          FROM ER_OUT
         WHERE OUTBOUND_DATE  = :OUTBOUND_DATE
           AND OUTBOUND_BATCH = :OUTBOUND_BATCH
           AND ITEM_NM LIKE '%한입떡갈비%'
       ) L1
  LEFT JOIN (
             SELECT M2.INVOICE_NO, M2.LINE_NO, M2.ITEM_CD, M2.ITEM_NM, M2.ORDER_QTY
               FROM LO_OUT_M M1
                    JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                    AND M2.ITEM_NM LIKE '%한입떡갈비%'
              WHERE M1.OUTBOUND_DATE  = :OUTBOUND_DATE
                AND M1.OUTBOUND_BATCH = :OUTBOUND_BATCH
            ) L2 ON L2.INVOICE_NO = L1.INVOICE_NO
                AND L2.LINE_NO    = L1.LINE_NO
 WHERE L2.INVOICE_NO IS NULL                     
 ORDER BY L1.INVOICE_NO
         ,L1.LINE_NO;


/*MariaDB
1)
SET @OUTBOUND_DATE  = '2019-09-03';
SET @OUTBOUND_BATCH = '046';
SELECT L1.INVOICE_NO
      ,L1.LINE_NO
      ,L1.ITEM_CD
      ,L1.ITEM_NM
      ,L1.ORDER_QTY    AS ER_QTY
      ,L2.ORDER_QTY    AS LO_QTY
  FROM (
        SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
          FROM ER_OUT
         WHERE OUTBOUND_DATE  = @OUTBOUND_DATE
           AND OUTBOUND_BATCH = @OUTBOUND_BATCH
           AND ITEM_NM LIKE '%한입떡갈비%'
       ) L1
  LEFT JOIN (
             SELECT M2.INVOICE_NO, M2.LINE_NO, M2.ITEM_CD, M2.ITEM_NM, M2.ORDER_QTY
               FROM LO_OUT_M M1
                    JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                    AND M2.ITEM_NM LIKE '%한입떡갈비%'
              WHERE M1.OUTBOUND_DATE  = @OUTBOUND_DATE
                AND M1.OUTBOUND_BATCH = @OUTBOUND_BATCH
            ) L2 ON L2.INVOICE_NO = L1.INVOICE_NO
                AND L2.LINE_NO    = L1.LINE_NO
 WHERE L2.INVOICE_NO IS NULL                     
 ORDER BY L1.INVOICE_NO
         ,L1.LINE_NO;

2)공통
SELECT INVOICE_NO
      ,LINE_NO
      ,ITEM_CD
      ,ITEM_NM
      ,SUM(ER_QTY) AS ER_QTY
      ,SUM(LO_QTY) AS LO_QTY
  FROM (
        SELECT INVOICE_NO      ,   LINE_NO      ,   ITEM_CD      ,   ITEM_NM      , ORDER_QTY AS ER_QTY   ,   NULL AS LO_QTY
          FROM ER_OUT
         WHERE OUTBOUND_DATE  = '2019-09-03'
           AND OUTBOUND_BATCH = '046'
           AND ITEM_NM LIKE '%한입떡갈비%'
        UNION ALL
        SELECT M2.INVOICE_NO   ,   M2.LINE_NO   ,   M2.ITEM_CD   ,   M2.ITEM_NM   ,   NULL AS ER_QTY         ,   M2.ORDER_QTY AS LO_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_NM LIKE '%한입떡갈비%'
         WHERE M1.OUTBOUND_DATE  = '2019-09-03'
           AND M1.OUTBOUND_BATCH = '046'
       ) L1
 GROUP BY INVOICE_NO
         ,LINE_NO
         ,ITEM_CD
         ,ITEM_NM
 HAVING SUM(LO_QTY) IS NULL;
*/
----------------------------------------------------------------------------------------------------





--실전문제④ ▶ 양 쪽이 일치하지 않는 집합 구하기----------------------------------------------------
SELECT NVL(L1.INVOICE_NO, L2.INVOICE_NO) AS INVOICE_NO
      ,NVL(L1.LINE_NO, L2.LINE_NO)       AS LINE_NO
      ,NVL(L1.ITEM_CD, L2.ITEM_CD)       AS ITEM_CD
      ,NVL(L1.ITEM_NM, L2.ITEM_NM)       AS ITEM_NM
      ,L1.ORDER_QTY                      AS ER_QTY
      ,L2.ORDER_QTY                      AS LO_QTY
  FROM (
        SELECT INVOICE_NO, LINE_NO, ITEM_CD, ITEM_NM, ORDER_QTY
          FROM ER_OUT
         WHERE OUTBOUND_DATE  = :OUTBOUND_DATE
           AND OUTBOUND_BATCH = :OUTBOUND_BATCH
       ) L1
  FULL OUTER JOIN
       (
        SELECT M2.INVOICE_NO, M2.LINE_NO, M2.ITEM_CD, M2.ITEM_NM, M2.ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE  = :OUTBOUND_DATE
           AND M1.OUTBOUND_BATCH = :OUTBOUND_BATCH
       ) L2 ON L2.INVOICE_NO = L1.INVOICE_NO
           AND L2.LINE_NO    = L1.LINE_NO
 WHERE L1.ORDER_QTY != L2.ORDER_QTY
    OR L1.ORDER_QTY IS NULL
    OR L2.ORDER_QTY IS NULL
 ORDER BY NVL(L1.INVOICE_NO, L2.INVOICE_NO) DESC
         ,NVL(L1.LINE_NO, L2.LINE_NO);
         

/*MariaDB
SELECT INVOICE_NO
      ,LINE_NO
      ,ITEM_CD
      ,ITEM_NM
      ,SUM(ER_QTY) AS ER_QTY
      ,SUM(LO_QTY) AS LO_QTY
  FROM (
        SELECT INVOICE_NO      ,   LINE_NO      ,   ITEM_CD      ,   ITEM_NM      ,   ORDER_QTY AS ER_QTY    ,   NULL AS LO_QTY
          FROM ER_OUT
         WHERE OUTBOUND_DATE  = '2019-09-03'
           AND OUTBOUND_BATCH = '046'
        UNION ALL
        SELECT M2.INVOICE_NO   ,   M2.LINE_NO   ,   M2.ITEM_CD   ,   M2.ITEM_NM   ,   NULL AS ER_QTY         ,   M2.ORDER_QTY AS LO_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE  = '2019-09-03'
           AND M1.OUTBOUND_BATCH = '046'
       ) L1
 GROUP BY INVOICE_NO
         ,LINE_NO
         ,ITEM_CD
         ,ITEM_NM
 HAVING SUM(ER_QTY) != SUM(LO_QTY)
     OR SUM(ER_QTY) IS NULL
     OR SUM(LO_QTY) IS NULL
  ORDER BY INVOICE_NO DESC
          ,LINE_NO;
*/
----------------------------------------------------------------------------------------------------
