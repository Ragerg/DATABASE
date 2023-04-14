--실전문제① ▶ 컬럼 개수만큼 레코드 늘리기----------------------------------------------------------
SELECT CASE C1.NO WHEN 1 THEN UOM1
                  WHEN 2 THEN UOM2
                  WHEN 3 THEN UOM3
                  ELSE UOM4
       END AS UOM
  FROM (
        SELECT 'PCS' AS UOM1, 'CASE' AS UOM2, 'BOX' AS UOM3, 'PLT' AS UOM4
          FROM DUAL
       ) M1 JOIN CS_NO C1 ON C1.NO <= 4;
       
/*MariaDB
동일함
*/      

SELECT /*UOM 
      ,*/VAL
  FROM (
        SELECT 'PCS' AS UOM1, 'CASE' AS UOM2, 'BOX' AS UOM3, 'PLT' AS UOM4
          FROM DUAL
       )
UNPIVOT (VAL FOR UOM IN (UOM1, UOM2, UOM3, UOM4));       
----------------------------------------------------------------------------------------------------





--실전문제② ▶ 박스입수 단위로 데이터 늘리기--------------------------------------------------------
--1)
SELECT ITEM_NM
      ,ORDER_QTY
      ,NO AS BOX_NO
      ,CASE WHEN CHECK_VAL >= 0 THEN :QTY_IN_BOX ELSE MOD(ORDER_QTY, :QTY_IN_BOX) END  AS QTY
  FROM (
        SELECT ITEM_NM
              ,NO
              ,ORDER_QTY
              ,ORDER_QTY - (NO * :QTY_IN_BOX) AS CHECK_VAL
          FROM LO_OUT_D M1
               JOIN CS_NO C1 ON NO <= CEIL(ORDER_QTY / :QTY_IN_BOX)
         WHERE INVOICE_NO = '346724706214'
         ORDER BY ITEM_NM
                 ,NO  
       );
       
--2)   
SELECT ITEM_NM
      ,ORDER_QTY
      ,BOX_NO
      ,COUNT(1) AS QTY
  FROM (
        SELECT ITEM_NM
              ,NO
              ,ORDER_QTY
              ,CEIL(NO / :QTY_IN_BOX) AS BOX_NO
          FROM LO_OUT_D M1
               JOIN CS_NO C1 ON C1.NO <= M1.ORDER_QTY
         WHERE INVOICE_NO = '346724706214'
         ORDER BY ITEM_NM
                 ,NO  
       )
 GROUP BY ITEM_NM
         ,ORDER_QTY
         ,BOX_NO
 ORDER BY ITEM_NM
         ,BOX_NO;
         

/*MariaDB
SET @QTY_IN_BOX = 10;
SELECT ITEM_NM
      ,ORDER_QTY
      ,BOX_NO
      ,COUNT(1) AS QTY
  FROM (
        SELECT ITEM_NM
              ,NO
              ,ORDER_QTY
              ,CEILING(NO / @QTY_IN_BOX) AS BOX_NO
          FROM LO_OUT_D M1
               JOIN CS_NO C1 ON C1.NO <= M1.ORDER_QTY
         WHERE INVOICE_NO = '346724706214'
         ORDER BY ITEM_NM
                 ,NO  
       ) L1
 GROUP BY ITEM_NM
         ,ORDER_QTY
         ,BOX_NO
 ORDER BY ITEM_NM
         ,BOX_NO;
*/            
----------------------------------------------------------------------------------------------------





--실전문제③ ▶ 수량의 범위에 따른 데이터 늘리기-----------------------------------------------------
SELECT C1.NO
      ,L1.ITEM_CD
      ,L1.ITEM_NM
      ,L1.ORDER_QTY
  FROM (
        SELECT ITEM_CD, ITEM_NM, ORDER_QTY
          FROM (
                SELECT M2.ITEM_CD, M2.ITEM_NM, SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                       AND M2.ITEM_NM    LIKE '%동원%'
                 WHERE M1.OUTBOUND_DATE  = '2019-09-04'
                   AND M1.OUTBOUND_BATCH = '018'
                 GROUP BY M2.ITEM_CD, M2.ITEM_NM
                 HAVING SUM(M2.ORDER_QTY) < 1000
                 ORDER BY SUM(M2.ORDER_QTY) DESC
               )
         WHERE ROWNUM <= 5
       ) L1
       JOIN CS_NO C1 ON C1.NO <= CEIL(L1.ORDER_QTY / 100);
       
/*MariaDB
SET @ROWNUM = 0;
SELECT NO
      ,ITEM_CD
      ,ITEM_NM
      ,ORDER_QTY
  FROM (
        SELECT ITEM_CD, ITEM_NM, ORDER_QTY
          FROM (
                SELECT @ROWNUM := @ROWNUM + 1 AS ROWNUM
																      ,ITEM_CD, ITEM_NM, ORDER_QTY
                  FROM (
								                SELECT M2.ITEM_CD, M2.ITEM_NM, SUM(M2.ORDER_QTY) AS ORDER_QTY
								                  FROM LO_OUT_M M1
								                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
								                                       AND M2.ITEM_NM    LIKE '%동원%'
								                 WHERE M1.OUTBOUND_DATE  = '2019-09-04'
								                   AND M1.OUTBOUND_BATCH = '018'
								                 GROUP BY M2.ITEM_CD, M2.ITEM_NM
								                 HAVING SUM(M2.ORDER_QTY) < 1000
								                 ORDER BY SUM(M2.ORDER_QTY) DESC
                       ) L1
               ) L2
         WHERE ROWNUM <= 5
       ) L3
       JOIN CS_NO C1 ON C1.NO <= CEILING(ORDER_QTY / 100);
*/          
----------------------------------------------------------------------------------------------------





--실전문제④ ▶ 전체 합계만 구하기-------------------------------------------------------------------
SELECT CASE WHEN NO = 1 THEN ITEM_NM ELSE '합계' END AS ITEM
      ,SUM(ORDER_QTY) AS ORDER_QTY
  FROM LO_OUT_D M1
       JOIN CS_NO C1 ON C1.NO <= 2
 WHERE INVOICE_NO = '346724706214'
 GROUP BY CASE WHEN NO = 1 THEN ITEM_NM ELSE '합계' END
         ,NO
 ORDER BY NO
         ,ITEM;

SELECT ITEM_NM
      ,SUM(ORDER_QTY)
      ,NO
  FROM (
        SELECT CASE WHEN NO = 1 THEN ITEM_NM ELSE '합계' END AS ITEM_NM
              ,ORDER_QTY
              ,NO
          FROM (
                SELECT ITEM_NM
                      ,ORDER_QTY
                      ,NO
                  FROM (
                        SELECT '힝힝힝' || ITEM_NM AS ITEM_NM
                              ,SUM(ORDER_QTY) AS ORDER_QTY
                          FROM LO_OUT_D
                         WHERE INVOICE_NO = '346724706214'
                         GROUP BY ITEM_NM
                       ) M1
                       JOIN CS_NO C1 ON NO <= 2
                 ORDER BY NO, ITEM_NM
               )
       )
 GROUP BY ITEM_NM
         ,NO
 ORDER BY NO, ITEM_NM;

/*MariaDB
동일함
*/            
----------------------------------------------------------------------------------------------------
