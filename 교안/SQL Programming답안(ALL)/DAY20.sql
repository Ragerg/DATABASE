--���������� �� �м��Լ� ROW_NUMBER / SUM / COUNT ���� ������--------------------------------------
SELECT OUTBOUND_DATE
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,ROW_NUMBER()   OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH)  AS "���ڴ��� ���� ����"
      ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH)  AS "���ڴ��� ������ ����"
      ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                          AS "���ں� �հ�"
      ,SUM(ORDER_QTY) OVER(ORDER BY OUTBOUND_DATE)                              AS "���ڼ� ����"
      ,SUM(ORDER_QTY) OVER()                                                    AS "��ü �հ�"
      ,COUNT(1)       OVER(PARTITION BY OUTBOUND_DATE)                          AS "���ڴ��� ���ڵ��"
      ,COUNT(1)       OVER()                                                    AS "��ü ���ڵ��"
  FROM (
        SELECT M1.OUTBOUND_DATE
              ,M1.OUTBOUND_BATCH
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND M1.OUT_TYPE_DIV        = 'M11'
         GROUP BY M1.OUTBOUND_DATE
                 ,M1.OUTBOUND_BATCH  
       ) L1;
       
/*MariaDB
������
*/          
----------------------------------------------------------------------------------------------------





--���������� �� �м��Լ� RANK ���� ������----------------------------------------------------------
SELECT OUTBOUND_DATE
      ,RANK() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS "���ڴ��� ���� ��ŷ"
      ,OUTBOUND_BATCH
      ,ORDER_QTY
  FROM (
        SELECT M1.OUTBOUND_DATE
              ,M1.OUTBOUND_BATCH
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND M1.OUT_TYPE_DIV        = 'M11'
         GROUP BY M1.OUTBOUND_DATE
                 ,M1.OUTBOUND_BATCH  
       ) L1;
       
/*MariaDB
������
*/          
----------------------------------------------------------------------------------------------------





--���������� �� �м��Լ� RANK / DENSE_RANK /SUM / LAG ���� ������----------------------------------
SELECT LAG(NULL, 1, OUTBOUND_DATE) OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH)         AS "�������"
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,DAY_QTY                                                                                      AS "���ں� ���� �հ�"
      ,DAY_RANK                                                                                     AS "���ں� ���� �հ� ��ŷ"
      ,TOT_RANK                                                                                     AS "��ü ��ŷ"
  FROM (
        SELECT OUTBOUND_DATE
              ,OUTBOUND_BATCH
              ,ORDER_QTY
              ,DAY_QTY
              ,DENSE_RANK() OVER(ORDER BY DAY_QTY DESC, OUTBOUND_DATE) AS DAY_RANK
              ,RANK()       OVER(ORDER BY ORDER_QTY DESC)              AS TOT_RANK
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M1.OUTBOUND_BATCH
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                      ,SUM(SUM(M2.ORDER_QTY)) OVER(PARTITION BY M1.OUTBOUND_DATE) AS DAY_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
                   AND M1.OUT_TYPE_DIV        = 'M11'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M1.OUTBOUND_BATCH  
               ) L1
       ) L2
 ORDER BY DAY_RANK 
         ,OUTBOUND_BATCH;


SELECT LAG(NULL, 1, OUTBOUND_DATE) OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH) AS OUT_DATE
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,DAY_QTY
      ,DENSE_RANK() OVER(ORDER BY DAY_QTY DESC, OUTBOUND_DATE) AS DAY_RANK
      ,RANK()       OVER(ORDER BY ORDER_QTY DESC)              AS TOT_RANK
  FROM (
        SELECT M1.OUTBOUND_DATE
              ,M1.OUTBOUND_BATCH
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
              ,SUM(SUM(M2.ORDER_QTY)) OVER(PARTITION BY M1.OUTBOUND_DATE) AS DAY_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
           AND M1.OUT_TYPE_DIV        = 'M11'
         GROUP BY M1.OUTBOUND_DATE
                 ,M1.OUTBOUND_BATCH  
       )
 ORDER BY DAY_RANK
         ,OUTBOUND_BATCH;
   
/*MariaDB
SELECT NVL(LAG('') OVER(PARTITION BY OUTBOUND_DATE ORDER BY OUTBOUND_BATCH), OUTBOUND_DATE)         AS "�������"
      ,OUTBOUND_BATCH
      ,ORDER_QTY
      ,DAY_QTY                                                                                      AS "���ں� ���� �հ�"
      ,DAY_RANK                                                                                     AS "���ں� ���� �հ� ��ŷ"
      ,TOT_RANK                                                                                     AS "��ü ��ŷ"
  FROM (
        SELECT OUTBOUND_DATE
              ,OUTBOUND_BATCH
              ,ORDER_QTY
              ,DAY_QTY
              ,DENSE_RANK() OVER(ORDER BY DAY_QTY DESC, OUTBOUND_DATE) AS DAY_RANK
              ,RANK() OVER(ORDER BY ORDER_QTY DESC)                    AS TOT_RANK
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M1.OUTBOUND_BATCH
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                      ,SUM(SUM(M2.ORDER_QTY)) OVER(PARTITION BY M1.OUTBOUND_DATE) AS DAY_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
                   AND M1.OUT_TYPE_DIV        = 'M11'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M1.OUTBOUND_BATCH  
               ) L1
       ) L2
 ORDER BY DAY_RANK
         ,OUTBOUND_BATCH;
*/            
----------------------------------------------------------------------------------------------------





--���������� �� �м��Լ� ROW_NUMBER / RATIO_TO_REPORT ���� ������----------------------------------
SELECT CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '��Ÿ' END AS OUTBOUND_DATE
      ,SUM(ORDER_QTY) AS ORDER_QTY
      ,SUM(RATE)      AS RATE
      ,MIN(RNK)       AS RNK
  FROM (
        SELECT OUTBOUND_DATE
              ,ORDER_QTY
              ,ROUND(RATIO_TO_REPORT(ORDER_QTY) OVER() * 100, 3) AS RATE
              ,ROW_NUMBER() OVER(ORDER BY ORDER_QTY DESC)        AS RNK
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK) INDEX(M1 LO_OUT_M_IDX01)
                       M1.OUTBOUND_DATE
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-15'
                 GROUP BY M1.OUTBOUND_DATE  
               ) L1       
       ) L2
 GROUP BY CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '��Ÿ' END 
 ORDER BY RNK;

 
/*MariaDB
SELECT CASE WHEN RNK <= 5 THEN DATE_FORMAT(OUTBOUND_DATE, '%Y-%m-%d') ELSE '��Ÿ' END AS OUTBOUND_DATE
    -- CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '��Ÿ' END AS OUTBOUND_DATE
      ,SUM(ORDER_QTY) AS ORDER_QTY
      ,SUM(RATE)      AS RATE
      ,MIN(RNK)       AS RNK
  FROM (
        SELECT OUTBOUND_DATE
              ,ORDER_QTY
              ,ROUND(ORDER_QTY / SUM(ORDER_QTY) OVER() * 100, 3) AS RATE
              ,ROW_NUMBER() OVER(ORDER BY ORDER_QTY DESC)        AS RNK
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-15'
                 GROUP BY M1.OUTBOUND_DATE  
               ) L1       
       ) L2
 GROUP BY CASE WHEN RNK <= 5 THEN DATE_FORMAT(OUTBOUND_DATE, '%Y-%m-%d') ELSE '��Ÿ' END 
      --  CASE WHEN RNK <= 5 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') ELSE '��Ÿ' END 
 ORDER BY RNK;
*/    
----------------------------------------------------------------------------------------------------