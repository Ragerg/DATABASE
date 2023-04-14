--���������� �� ������ ���� ���ϴ� �÷����� ǥ���ϰ� TOP-N �����ŭ ǥ���ϱ�-------------------------
SELECT *
  FROM (
        SELECT --+ ORDERED USE_NL(M2)
               M1.INVOICE_NO     ,M1.OUTBOUND_NO     ,M1.OUTBOUND_BATCH
              ,M2.ITEM_CD        ,M2.ITEM_NM         ,M2.ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_NM    LIKE '%�����%'
         WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE('2019-09-03', 'YYYY-MM-DD') AND TO_DATE('2019-09-10', 'YYYY-MM-DD')
         ORDER BY M2.ORDER_QTY DESC
       )
 WHERE ROWNUM <= 5;


/*MariaDB
SELECT M1.INVOICE_NO     ,M1.OUTBOUND_NO     ,M1.OUTBOUND_BATCH
      ,M2.ITEM_CD        ,M2.ITEM_NM         ,M2.ORDER_QTY
  FROM LO_OUT_M M1
       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                       AND M2.ITEM_NM    LIKE '%�����%'
 WHERE M1.OUTBOUND_DATE BETWEEN STR_TO_DATE('2019-09-03', '%Y-%m-%d') AND STR_TO_DATE('2019-09-10', '%Y-%m-%d')
 ORDER BY M2.ORDER_QTY DESC 
 LIMIT 5;
*/
----------------------------------------------------------------------------------------------------





--2) ���������� �� �����ͼ� ���̺��� ���ν��� ����ϱ�-----------------------------------------------
SELECT L1.ITEM_CD
      ,C1.ITEM_NM
      ,L1.ORDER_QTY
  FROM (
        SELECT M2.ITEM_CD 
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND M1.OUT_BOX_DIV = 'D5'
         GROUP BY M2.ITEM_CD
       ) L1
       JOIN CM_ITEM C1 ON C1.ITEM_CD = L1.ITEM_CD
 ORDER BY L1.ORDER_QTY DESC;
 
/*MariaDB
������
*/    
----------------------------------------------------------------------------------------------------





--3) ���������� �� OUTER ������ ������ ��������------------------------------------------------------
SELECT M1.INVOICE_NO   ,   M1.OUTBOUND_DATE   ,   M1.OUT_TYPE_DIV
      ,M2.LINE_NO      ,   M2.ITEM_CD         ,   C1.ITEM_NM        ,   M2.ORDER_QTY
      ,NVL(C2.CODE_NM, 'Failed...') AS TEMP_NM
      ,NVL(C3.CODE_NM, 'Failed...') AS OUT_TYPE_NM
  FROM LO_OUT_M M1
       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
       JOIN CM_ITEM  C1 ON C1.ITEM_CD    = M2.ITEM_CD
  LEFT JOIN CS_CODE  C2 ON C2.CODE_GRP   = 'LDIV011'
                       AND C2.CODE_CD    = M1.TEMP_DIV
  LEFT JOIN CS_CODE  C3 ON C3.CODE_GRP   = 'LDIV03'
                       AND C3.CODE_CD    = M1.OUT_TYPE_DIV
 WHERE M1.INVOICE_NO IN ('346724703834', '346724722535', '346724717915')
	ORDER BY M2.INVOICE_NO, M2.LINE_NO;
	
	
/*MariaDB
������
*/   
----------------------------------------------------------------------------------------------------





--���������� �� �߰��� ���� ��¥ ä���ֱ� (�м��Լ� ����)--------------------------------------------
--�ַ��1) �м��Լ� ���X
SELECT M1.ALL_DATE
      ,NVL(M2.SUM_QTY, 0) AS QTY
  FROM (
        SELECT TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') + NO - 1 AS ALL_DATE
          FROM CS_NO
         WHERE NO <= (SELECT :TODAY - TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') + 1
                        FROM DUAL
                     )
       ) M1 
       LEFT JOIN (
                  SELECT M1.OUTBOUND_DATE
                        ,SUM(M2.ORDER_QTY) AS SUM_QTY
                    FROM LO_OUT_M M1
                         JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                   WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') AND :TODAY
                   GROUP BY M1.OUTBOUND_DATE
                   ORDER BY M1.OUTBOUND_DATE
                 ) M2 ON M2.OUTBOUND_DATE = M1.ALL_DATE
 ORDER BY M1.ALL_DATE;

/*MariaDB
SET @TODAY = '2019-09-19';
SELECT M1.ALL_DATE
      ,NVL(M2.SUM_QTY, 0) AS QTY
  FROM (
        SELECT LAST_DAY(CAST(@TODAY AS DATE) - INTERVAL 1 MONTH) + INTERVAL NO DAY AS ALL_DATE
          FROM CS_NO
         WHERE NO <= CAST(TO_CHAR(CAST(@TODAY AS DATE), 'dd') AS INTEGER)
       ) M1 
       LEFT JOIN (
                  SELECT M1.OUTBOUND_DATE
                        ,SUM(M2.ORDER_QTY) AS SUM_QTY
                    FROM LO_OUT_M M1
                         JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                   WHERE M1.OUTBOUND_DATE BETWEEN LAST_DAY(CAST(@TODAY AS DATE) - INTERVAL 1 MONTH) + INTERVAL 1 DAY AND CAST(@TODAY AS DATE)
                   GROUP BY M1.OUTBOUND_DATE
                   ORDER BY M1.OUTBOUND_DATE
                 ) M2 ON M2.OUTBOUND_DATE = M1.ALL_DATE
 ORDER BY M1.ALL_DATE;
*/   


--�ַ��2) �м��Լ� ���O
SELECT OUTBOUND_DATE + NO - 1 AS OUT_DATE
      ,CASE WHEN NO > 1 THEN 0 ELSE SUM_QTY END AS QTY
  FROM (
        SELECT OUTBOUND_DATE
              ,SUM_QTY
              ,NEXT_DATE - OUTBOUND_DATE AS GAP
          FROM (
                SELECT OUTBOUND_DATE
                      ,SUM_QTY
                      ,LEAD(OUTBOUND_DATE, 1, OUTBOUND_DATE + 1) OVER(ORDER BY OUTBOUND_DATE) AS NEXT_DATE
                  FROM (
                        SELECT M1.OUTBOUND_DATE
                              ,SUM(M2.ORDER_QTY) AS SUM_QTY
                          FROM LO_OUT_M M1
                               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                         WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') AND :TODAY
                         GROUP BY M1.OUTBOUND_DATE
                         ORDER BY M1.OUTBOUND_DATE
                       ) L1
               ) L2
       ) L3
       JOIN CS_NO C1 ON C1.NO <= L3.GAP
 ORDER BY OUTBOUND_DATE + NO;
 
/*MariaDB
SET @TODAY = '2019-09-19';
SELECT OUTBOUND_DATE + INTERVAL NO-1 DAY        AS OUT_DATE
      ,CASE WHEN NO > 1 THEN 0 ELSE SUM_QTY END AS QTY
  FROM (
        SELECT OUTBOUND_DATE
              ,SUM_QTY
              ,NEXT_DATE - OUTBOUND_DATE AS GAP
          FROM (
                SELECT OUTBOUND_DATE
                      ,SUM_QTY
                      ,NVL(LEAD(OUTBOUND_DATE, 1) OVER(ORDER BY OUTBOUND_DATE), OUTBOUND_DATE + INTERVAL 1 DAY) AS NEXT_DATE
                  FROM (
                        SELECT M1.OUTBOUND_DATE
                              ,SUM(M2.ORDER_QTY) AS SUM_QTY
                          FROM LO_OUT_M M1
                               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                         WHERE M1.OUTBOUND_DATE BETWEEN LAST_DAY(CAST(@TODAY AS DATE) - INTERVAL 1 MONTH) + INTERVAL 1 DAY AND CAST(@TODAY AS DATE)
                         GROUP BY M1.OUTBOUND_DATE
                         ORDER BY M1.OUTBOUND_DATE
                       ) L1
               ) L2
       ) L3
       JOIN CS_NO C1 ON C1.NO <= L3.GAP
 ORDER BY OUTBOUND_DATE + INTERVAL NO DAY;
*/ 
----------------------------------------------------------------------------------------------------
