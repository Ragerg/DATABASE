--���������� �� �÷� ���� �ִ밪 ���ϱ� (���� �� �ִ밪�� �ƴ�)--------------------------------------
SELECT DAYY
      ,TO_DATE(SUBSTR(VALUE, 10, 8), 'YYYY-MM-DD')   AS OUTBOUND_DATE
      ,TO_NUMBER(SUBSTR(VALUE, 1, 9))                AS ORDER_QTY
  FROM (--���Ϻ� �ִ� ���Ϸ� ���ϱ� (�ش� ��¥�� �Բ� ����)
        SELECT DAY
              ,DAYY
              ,MAX(LPAD(ORDER_QTY, 9, '0') || TO_CHAR(OUTBOUND_DATE, 'YYYYMMDD')) AS VALUE
          FROM (--���ں� �� ���Ϸ� (������ ���ϵ� �Բ� ����)
                SELECT M1.OUTBOUND_DATE                 AS OUTBOUND_DATE
                      ,TO_CHAR(M1.OUTBOUND_DATE, 'D')   AS DAY
                      ,TO_CHAR(M1.OUTBOUND_DATE, 'DAY') AS DAYY
                      ,SUM(M2.ORDER_QTY)                AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE(:YYYYMM || '01', 'YYYY-MM-DD') AND  LAST_DAY(:YYYYMM || '01') 
                 GROUP BY M1.OUTBOUND_DATE
               )
         GROUP BY DAY, DAYY
       )
 ORDER BY DAY;
 
/*MariaDB
SET @YYYYMM := '201909';
SELECT SUBSTR(_UTF8'�Ͽ�ȭ�������', DAY, 1)            AS DAYY
      ,STR_TO_DATE(SUBSTR(VALUE, 10, 10), '%Y-%m-%d')   AS OUTBOUND_DATE
      ,CONVERT(SUBSTR(VALUE, 1, 9), INTEGER)            AS ORDER_QTY
  FROM (-- ���Ϻ� �ִ� ���Ϸ� ���ϱ� (�ش� ��¥�� �Բ� ����)
        SELECT DAY
              ,MAX(CONCAT(LPAD(ORDER_QTY, 9, '0'), DATE_FORMAT(OUTBOUND_DATE, '%Y-%m-%d'))) AS VALUE
          FROM (-- ���ں� �� ���Ϸ� (������ ���ϵ� �Բ� ����)
                SELECT M1.OUTBOUND_DATE            AS OUTBOUND_DATE
                      ,DAYOFWEEK(M1.OUTBOUND_DATE) AS DAY
                      ,SUM(M2.ORDER_QTY)           AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN CONVERT(CONCAT(@YYYYMM, '01'), DATE) AND  LAST_DAY(CONVERT(CONCAT(@YYYYMM, '01'), DATE)) 
                 GROUP BY M1.OUTBOUND_DATE
                         ,DAYOFWEEK(M1.OUTBOUND_DATE)
               ) L1
         GROUP BY DAY
       ) L2
 ORDER BY DAY;
*/    
----------------------------------------------------------------------------------------------------
 
 
 
 

--���������� �� �˻� ���� ������ ���� â���� ���̵�� �����ϱ�---------------------------------------
SELECT --+ GATHER_PLAN_STATISTICS
       MAX(ORDER_QTY)        AS MAX_QTY
      ,MIN(ORDER_QTY)        AS MIN_QTY
      ,TRUNC(AVG(ORDER_QTY)) AS AVG_QTY
  FROM (
        SELECT --+ ORDERED USE_NL(M2)
               OUTBOUND_DATE     AS OUTBOUND_DATE
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY 
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE IN (--������(2019-09-03) �������� �ֱ� 7��ġ
                                    SELECT OUTBOUND_DATE
                                      FROM (--CS_NO ���̺� ������
                                            SELECT :OUTBOUND_DATE + NO - 1 AS OUTBOUND_DATE
                                              FROM CS_NO
                                             WHERE NO <= 30 --������������ ROWNUM üũ�ϹǷ� ���ڰ� ũ���� �������
                                             ORDER BY NO
                                           ) M1
                                     WHERE EXISTS (SELECT 1
                                                     FROM LO_OUT_M S1
                                                    WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
                                                  )
                                       AND ROWNUM <= 7         
                                   )
         GROUP BY M1.OUTBOUND_DATE
       );
       
SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));
       
/*MariaDB - 30���� �ҿ�
SET @OUTBOUND_DATE := '2019-09-03';
SET @ROWNUM := 0;
SELECT MAX(ORDER_QTY)        AS MAX_QTY
      ,MIN(ORDER_QTY)        AS MIN_QTY
      ,ROUND(AVG(ORDER_QTY), 0) AS AVG_QTY
  FROM (
        SELECT OUTBOUND_DATE     AS OUTBOUND_DATE
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY 
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE IN (
                                    SELECT OUTBOUND_DATE
                                      FROM (
																	                           -- ������(2019-09-03) �������� �ֱ� 7��ġ
								                                    SELECT OUTBOUND_DATE
								                                          ,@ROWNUM := @ROWNUM + 1 AS ROWNUM
								                                      FROM (-- CS_NO ���̺� ������
								                                            SELECT DATE_ADD(CONVERT(@OUTBOUND_DATE, DATE), INTERVAL + NO - 1 DAY) AS OUTBOUND_DATE
								                                              FROM CS_NO
								                                             WHERE NO <= 100
								                                             ORDER BY NO
								                                           ) S1
								                                     WHERE EXISTS (SELECT 1
								                                                     FROM LO_OUT_M S2
								                                                    WHERE S2.OUTBOUND_DATE = S1.OUTBOUND_DATE
								                                                  )
                                           ) L1
                                     WHERE ROWNUM <= 7
                                   )
         GROUP BY M1.OUTBOUND_DATE
       ) L1;
*/          
----------------------------------------------------------------------------------------------------





--���������� �� CASE���� Ȱ���� �����Լ� ��� ���� + �÷� ���� �ִ밪 ���ϱ�-------------------------
SELECT  ITEM_CD
       ,TO_DATE(SUBSTR(VAL, 4, 8), 'YYYY-MM-DD') AS MAX_DATE
       ,CASE WHEN SUBSTR(VAL, 1, 3) = 'ZZZ' THEN '001' ELSE SUBSTR(VAL, 1, 3) END AS MAX_BATCH
  FROM (
        SELECT M2.ITEM_CD
              ,MAX(CASE WHEN M1.OUTBOUND_BATCH = '001' THEN 'ZZZ' ELSE M1.OUTBOUND_BATCH END || TO_CHAR(M1.OUTBOUND_DATE, 'YYYYMMDD')) AS VAL
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_CD IN ('30500', '73510')
         WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE(TO_CHAR(:TODAY, 'YYYYMM') || '01', 'YYYY-MM-DD') AND :TODAY
         GROUP BY M2.ITEM_CD
       );
       
/*MariaDB
SET @TODAY = CONVERT('2019-09-19', DATE);
SELECT  ITEM_CD
       ,STR_TO_DATE(SUBSTR(VAL, 4, 10), '%Y-%m-%d') AS MAX_DATE
       ,CASE WHEN SUBSTR(VAL, 1, 3) = 'ZZZ' THEN '001' ELSE SUBSTR(VAL, 1, 3) END AS MAX_BATCH
  FROM (
        SELECT M2.ITEM_CD
              ,MAX(CONCAT(CASE WHEN M1.OUTBOUND_BATCH = '001' THEN 'ZZZ' ELSE M1.OUTBOUND_BATCH END, DATE_FORMAT(M1.OUTBOUND_DATE, '%Y-%m-%d'))) AS VAL
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_CD IN ('30500', '73510')
         WHERE M1.OUTBOUND_DATE BETWEEN CONVERT(CONCAT(DATE_FORMAT(@TODAY, '%Y%m'), '01'), DATE) AND @TODAY
         GROUP BY M2.ITEM_CD
       ) L1;
*/          
---------------------------------------------------------------------------------------------------- 





--���������� �� �����Լ�/�����Լ� ���� �� CASE���� Ȱ���� ���� �÷� �����---------------------------
--�������� �������� ������ ����
SELECT WEEK_OF_YEAR
      ,ORDER_QTY
      ,CASE WHEN ORDER_QTY >= 900000 THEN 'A'
            WHEN ORDER_QTY >= 800000 THEN 'B'
            WHEN ORDER_QTY >= 700000 THEN 'C'
            WHEN ORDER_QTY >= 600000 THEN 'D'
            ELSE 'F'
       END AS GRADE
  FROM (
        SELECT TO_CHAR(M1.OUTBOUND_DATE, 'IW') AS WEEK_OF_YEAR
              ,SUM(M2.ORDER_QTY)               AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE OUTBOUND_DATE BETWEEN '2019-01-01' AND '2019-12-31'
         GROUP BY TO_CHAR(M1.OUTBOUND_DATE, 'IW')
         ORDER BY TO_CHAR(M1.OUTBOUND_DATE, 'IW')
       );
       
/*MariaDB
--�������� �������� ������ ���� -> WEEK, WEEKOFYEAR ���� ����
SELECT WEEK_OF_YEAR
      ,ORDER_QTY
      ,CASE WHEN ORDER_QTY >= 900000 THEN 'A'
            WHEN ORDER_QTY >= 800000 THEN 'B'
            WHEN ORDER_QTY >= 700000 THEN 'C'
            WHEN ORDER_QTY >= 600000 THEN 'D'
            ELSE 'F'
       END AS GRADE
  FROM (
        SELECT WEEKOFYEAR(M1.OUTBOUND_DATE) AS WEEK_OF_YEAR
              ,SUM(M2.ORDER_QTY)            AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE OUTBOUND_DATE BETWEEN '2019-01-01' AND '2019-12-31'
         GROUP BY WEEKOFYEAR(M1.OUTBOUND_DATE)
         ORDER BY WEEKOFYEAR(M1.OUTBOUND_DATE)
       ) L1;
*/          
---------------------------------------------------------------------------------------------------- 