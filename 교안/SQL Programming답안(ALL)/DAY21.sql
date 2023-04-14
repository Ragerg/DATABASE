--���������� �� �м��Լ� RANK / ROW_NUMBER ���� ������---------------------------------------------
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "����"
      ,ITEM_NM
      ,ORDER_QTY
  FROM (
        SELECT OUTBOUND_DATE
              ,ITEM_NM
              ,ORDER_QTY
              ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
              ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                       M1.OUTBOUND_DATE
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_NM  
               ) L1
       ) L2
 WHERE CHK <= 3;
 
/*MariaDB
������
*/    
----------------------------------------------------------------------------------------------------

 
 
 
 
--���������� �� �м��Լ� RANK / ROW_NUMBER / SUM / RATIO_TO_REPORT ���� ������---------------------
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "����"
      ,ITEM_NM
      ,ORDER_QTY
    --,ROUND((ORDER_QTY / DAY_QTY) * 100, 2) AS "������"
      ,ROUND(RATE * 100, 2)                  AS "������"
  FROM (
        SELECT OUTBOUND_DATE
              ,ITEM_NM
              ,ORDER_QTY
              ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
              ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
            --,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                       AS DAY_QTY
              ,RATIO_TO_REPORT(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)           AS RATE
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                       M1.OUTBOUND_DATE
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_NM  
               ) L1
       ) L2
 WHERE CHK <= 3;
 
/*MariaDB
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "����"
      ,ITEM_NM
      ,ORDER_QTY
      ,ROUND((ORDER_QTY / DAY_QTY) * 100, 2) AS "������"
  FROM (
        SELECT OUTBOUND_DATE
              ,ITEM_NM
              ,ORDER_QTY
              ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
              ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
              ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                       AS DAY_QTY
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,M2.ITEM_NM
                      ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                 GROUP BY M1.OUTBOUND_DATE
                         ,M2.ITEM_NM  
               ) L1
       ) L2
 WHERE CHK <= 3;
*/    
----------------------------------------------------------------------------------------------------
 
 
 
 
 
--3)���������� �� �м��Լ� RANK / ROW_NUMBER / SUM / RATIO_TO_REPORT ���� ������-------------------
SELECT CASE WHEN CHK = 1 THEN OUTBOUND_DATE END AS OUTBOUND_DATE
      ,RNK AS "����"
      ,ITEM_NM
      ,ORDER_QTY
      ,ROUND((ORDER_QTY / DAY_QTY) * 100, 2) AS "������"
      ,ROUND((ACC_QTY   / DAY_QTY) * 100, 2) AS "����������"
  FROM (
        SELECT OUTBOUND_DATE
              ,RNK
              ,CHK
              ,ITEM_NM
              ,ORDER_QTY
              ,DAY_QTY
              ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE ORDER BY RNK) AS ACC_QTY
          FROM (
                SELECT OUTBOUND_DATE
                      ,ITEM_NM
                      ,ORDER_QTY
                      ,RANK()       OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS RNK
                      ,ROW_NUMBER() OVER(PARTITION BY OUTBOUND_DATE ORDER BY ORDER_QTY DESC) AS CHK
                      ,SUM(ORDER_QTY) OVER(PARTITION BY OUTBOUND_DATE)                       AS DAY_QTY
                  FROM (
                        SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                               M1.OUTBOUND_DATE
                              ,M2.ITEM_NM
                              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
                          FROM LO_OUT_M M1
                               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                         WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-05'
                         GROUP BY M1.OUTBOUND_DATE
                                 ,M2.ITEM_NM  
                       ) L1
               ) L2
         WHERE CHK <= 3
       ) L3;
       
/*MariaDB
������
*/          
----------------------------------------------------------------------------------------------------





--���������� �� �м��Լ�/�����Լ� ���� �� ������ �ø��� �����ϱ�-------------------------------------
SELECT --�� ������� ��
       CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN NO = 2 THEN '��' WHEN NO = 3 THEN '�����' WHEN NO = 4 THEN 'Peak' END AS OUTBOUND_DATE 
       --�� SKU�� ��
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)       --1)��¥��(����)
                  WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)   --2)�� --> ��¥�� �ߺ��� ������ ��ü SKU��
                  WHEN NO = 3 THEN AVG(ITEM_CNT)       --3)�����
                  WHEN NO = 4 THEN MAX(ITEM_CNT)       --4)Peak
             END) ITEM_CNT
       --�� ORDER�� ��   
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)      --1)��¥��(����)
                  WHEN NO = 2 THEN SUM(ORDER_CNT)      --2)��
                  WHEN NO = 3 THEN AVG(ORDER_CNT)      --3)�����
                  WHEN NO = 4 THEN MAX(ORDER_CNT)      --4)Peak
             END) ORDER_CNT
       --�� O.L.�� ��
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_LINE_CNT) --1)��¥��(����)
                  WHEN NO = 2 THEN SUM(ORDER_LINE_CNT) --2)��
                  WHEN NO = 3 THEN AVG(ORDER_LINE_CNT) --3)�����
                  WHEN NO = 4 THEN MAX(ORDER_LINE_CNT) --4)Peak
             END) ORDER_LINE_CNT
       --�� ������ �� 
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_QTY)      --1)��¥��(����)
                  WHEN NO = 2 THEN SUM(ORDER_QTY)      --2)��
                  WHEN NO = 3 THEN AVG(ORDER_QTY)      --3)�����
                  WHEN NO = 4 THEN MAX(ORDER_QTY)      --4)Peak
             END) ORDER_QTY 
  FROM (
        SELECT OUTBOUND_DATE                    AS OUTBOUND_DATE   -- �������
              ,COUNT(DISTINCT ITEM_CD)          AS ITEM_CNT        -- SKU��
              ,COUNT(DISTINCT INVOICE_NO)       AS ORDER_CNT       -- ORDER��
              ,COUNT(1)                         AS ORDER_LINE_CNT  -- O.L.��
              ,SUM(ORDER_QTY)                   AS ORDER_QTY       -- ��������
              ,MIN(TOT_ITEM_CNT)                AS TOT_ITEM_CNT    -- ��ü SKU��
          FROM (
                SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
                       M1.OUTBOUND_DATE
                      ,M1.INVOICE_NO
                      ,M2.ITEM_CD
                      ,M2.ORDER_QTY
                      ,COUNT(DISTINCT M2.ITEM_CD) OVER() AS TOT_ITEM_CNT  -- ��ü SKU��
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
               ) L1
         GROUP BY OUTBOUND_DATE
         ORDER BY OUTBOUND_DATE
       ) L2
       JOIN CS_NO C1 ON C1.NO <= 4   -- [1]���� [2]�հ� [3]��� [4]��ũ
 GROUP BY CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN NO = 2 THEN '��' WHEN NO = 3 THEN '�����' WHEN NO = 4 THEN 'Peak' END
         ,NO
 ORDER BY NO
         ,OUTBOUND_DATE;     
         
/*MariaDB  �м��Լ� COUNT(DISTINCT) ���� �ȵ�
SELECT CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') WHEN NO = 2 THEN '��' WHEN NO = 3 THEN '�����' WHEN NO = 4 THEN 'Peak' END AS OUTBOUND_DATE -- �������
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)
                  WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)
                  WHEN NO = 3 THEN AVG(ITEM_CNT)
                  WHEN NO = 4 THEN MAX(ITEM_CNT)
             END) ITEM_CNT   -- SKU��
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)
                  WHEN NO = 2 THEN SUM(ORDER_CNT) 
                  WHEN NO = 3 THEN AVG(ORDER_CNT)
                  WHEN NO = 4 THEN MAX(ORDER_CNT)
             END) ORDER_CNT   -- ORDER��
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_LINE_CNT)
                  WHEN NO = 2 THEN SUM(ORDER_LINE_CNT)
                  WHEN NO = 3 THEN AVG(ORDER_LINE_CNT)
                  WHEN NO = 4 THEN MAX(ORDER_LINE_CNT)
             END) ORDER_LINE_CNT -- O.L.��
      ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_QTY)
                  WHEN NO = 2 THEN SUM(ORDER_QTY)
                  WHEN NO = 3 THEN AVG(ORDER_QTY)
                  WHEN NO = 4 THEN MAX(ORDER_QTY)
             END) ORDER_QTY -- ��������
  FROM (
        SELECT M1.OUTBOUND_DATE  -- �������
              ,M1.ITEM_CNT       -- SKU��
              ,M1.ORDER_CNT      -- ORDER��
              ,M1.ORDER_LINE_CNT -- O.L.��
              ,M1.ORDER_QTY      -- ��������
              ,M2.TOT_ITEM_CNT   -- ��ü SKU��
          FROM (
                SELECT M1.OUTBOUND_DATE
                      ,COUNT(DISTINCT M2.ITEM_CD)    AS ITEM_CNT
                      ,COUNT(DISTINCT M2.INVOICE_NO) AS ORDER_CNT
                      ,COUNT(1)                      AS ORDER_LINE_CNT
                      ,SUM(ORDER_QTY)                AS ORDER_QTY
                  FROM LO_OUT_M M1
                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
                 GROUP BY M1.OUTBOUND_DATE
               ) M1
               JOIN (-- �м��Լ����� COUNT(DISTINCT�� ����� �� ��� ��¿�� ���� �и���
                     SELECT COUNT(DISTINCT M2.ITEM_CD)    AS TOT_ITEM_CNT
                       FROM LO_OUT_M M1
					                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
					                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
                    ) M2 ON 1 = 1
         ORDER BY M1.OUTBOUND_DATE
       ) L2
       JOIN CS_NO C1 ON C1.NO <= 4   -- [1]���� [2]�հ� [3]��� [4]��ũ
 GROUP BY CASE WHEN NO = 1 THEN TO_CHAR(OUTBOUND_DATE, 'YYYY-MM-DD') WHEN NO = 2 THEN '��' WHEN NO = 3 THEN '�����' WHEN NO = 4 THEN 'Peak' END
         ,NO
 ORDER BY NO
         ,OUTBOUND_DATE;   
*/              
---------------------------------------------------------------------------------------------------- 



         
         
--���������� �� �м��Լ��� �̿��� ���� ��¥ ���ϱ�---------------------------------------------------
SELECT OUTBOUND_DATE
  FROM (
        SELECT :OUTBOUND_DATE1 + NO - 1 AS OUTBOUND_DATE
          FROM CS_NO
         WHERE NO <= :OUTBOUND_DATE2 - :OUTBOUND_DATE1 + 1
       ) M1
 WHERE NOT EXISTS (SELECT 1
                     FROM LO_OUT_M S1
                    WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
                  );

                  
--����) ���̳��� �ϼ���ŭ ���ڵ带 �����ϰ� ������ڰ� �����ϴ� ��¥�� �����Ͽ� ���� SKIP_DATE ����
SELECT FROM_DATE + NO - 1 AS SKIP_DATE
  FROM (--L3) ���������� �Ǵ� ��������,�������ڸ� ���� (���ڵ尡 �����ϴ� ���ڵ� �Բ� ǥ���� - ���� �ܰ迡�� �����ϱ� ����) 
        SELECT CASE WHEN LAG_DATE IS NULL THEN :OUTBOUND_DATE1 ELSE OUTBOUND_DATE END AS FROM_DATE --ù��° ���ڵ常 ������ ù��° ��¥�� ����
              ,LEAD_DATE AS TO_DATE
              ,OUTBOUND_DATE AS EXISTS_DATE
          FROM (--L2) ������¥/���ĳ�¥�� ��������, NULL�� ������ ���ڵ�� ������ ������ ��¥�� ���� 
                SELECT OUTBOUND_DATE
                      ,LAG (OUTBOUND_DATE) OVER(ORDER BY OUTBOUND_DATE) AS LAG_DATE
                      ,LEAD(OUTBOUND_DATE - 1, 1, :OUTBOUND_DATE2) OVER(ORDER BY OUTBOUND_DATE) AS LEAD_DATE
                  FROM (--L1) ��� �����ϴ� ��¥�� ������
                        SELECT OUTBOUND_DATE
                          FROM (
                                SELECT :OUTBOUND_DATE1 + NO - 1 AS OUTBOUND_DATE
                                  FROM CS_NO
                                 WHERE NO <= :OUTBOUND_DATE2 - :OUTBOUND_DATE1 + 1
                               ) M1
                         WHERE EXISTS (SELECT 1
                                         FROM LO_OUT_M S1
                                        WHERE S1.OUTBOUND_DATE = M1.OUTBOUND_DATE
                                      )
                       ) L1
               ) L2
       ) L3
       JOIN CS_NO C1 ON C1.NO <= CASE WHEN FROM_DATE = TO_DATE THEN 0 ELSE TO_DATE - FROM_DATE + 1 END
 WHERE FROM_DATE + NO - 1 != EXISTS_DATE; --���� ����̵� ���ڵ�� ��� �����ϴ� ������ڸ� �ǹ��ϹǷ� ���⼭ ���ܽ�Ŵ
 
 /*MariaDB
�ؾ� ��.. 
*/ 
----------------------------------------------------------------------------------------------------