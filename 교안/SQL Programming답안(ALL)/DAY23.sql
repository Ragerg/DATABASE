--���������� �� ��Ģ ã��----------------------------------------------------------------------------
SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
  FROM (
        SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
              ,ROW_NUMBER() OVER(ORDER BY TO_NUMBER(BAY_CD) - TO_NUMBER(LEV_CD), BAY_CD DESC) AS RNUM
          FROM (
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '01' AS LEV_CD, '01-01-01-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '02' AS LEV_CD, '01-01-01-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '03' AS LEV_CD, '01-01-01-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '04' AS LEV_CD, '01-01-01-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '01' AS LEV_CD, '01-01-02-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '02' AS LEV_CD, '01-01-02-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '03' AS LEV_CD, '01-01-02-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '04' AS LEV_CD, '01-01-02-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '01' AS LEV_CD, '01-01-03-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '02' AS LEV_CD, '01-01-03-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '03' AS LEV_CD, '01-01-03-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '04' AS LEV_CD, '01-01-03-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '01' AS LEV_CD, '01-01-04-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '02' AS LEV_CD, '01-01-04-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '03' AS LEV_CD, '01-01-04-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '04' AS LEV_CD, '01-01-04-04' AS LOC_CD FROM DUAL   
               ) L1
       ) L2
 ORDER BY RNUM;
       
/*MariaDB
SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
  FROM (
        SELECT ZONE_CD, BANK_CD, BAY_CD, LEV_CD, LOC_CD
              ,ROW_NUMBER() OVER(ORDER BY CONVERT(BAY_CD, INTEGER) - CONVERT(LEV_CD, INTEGER), BAY_CD DESC) AS RNUM
          FROM (
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '01' AS LEV_CD, '01-01-01-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '02' AS LEV_CD, '01-01-01-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '03' AS LEV_CD, '01-01-01-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '01' AS BAY_CD, '04' AS LEV_CD, '01-01-01-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '01' AS LEV_CD, '01-01-02-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '02' AS LEV_CD, '01-01-02-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '03' AS LEV_CD, '01-01-02-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '02' AS BAY_CD, '04' AS LEV_CD, '01-01-02-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '01' AS LEV_CD, '01-01-03-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '02' AS LEV_CD, '01-01-03-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '03' AS LEV_CD, '01-01-03-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '03' AS BAY_CD, '04' AS LEV_CD, '01-01-03-04' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '01' AS LEV_CD, '01-01-04-01' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '02' AS LEV_CD, '01-01-04-02' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '03' AS LEV_CD, '01-01-04-03' AS LOC_CD FROM DUAL UNION ALL
                SELECT '01' AS ZONE_CD, '01' AS BANK_CD, '04' AS BAY_CD, '04' AS LEV_CD, '01-01-04-04' AS LOC_CD FROM DUAL   
               ) L1
       ) L2
 ORDER BY RNUM;
*/          
----------------------------------------------------------------------------------------------------





--���������� �� �ϳ��� SQL�� ��Ȳ�� ���� �����ϱ� (���� �ٸ� �÷����� ����)--------------------------
SELECT ITEM_CD, ITEM_NM, ORDER_QTY
  FROM (
        SELECT --+ ORDERED USE_NL(M2) INDEX(M2 LO_OUT_D_IDXPK)
               M2.ITEM_CD
              ,M2.ITEM_NM
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_NM    LIKE '%��ġ%'
         WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-05'
         GROUP BY M2.ITEM_CD
                 ,M2.ITEM_NM
       ) L1
 ORDER BY CASE WHEN ITEM_NM LIKE '����%' THEN ITEM_NM END
         ,ORDER_QTY DESC;
         
/*MariaDB
SELECT ITEM_CD, ITEM_NM, ORDER_QTY
  FROM (
        SELECT M2.ITEM_CD
              ,M2.ITEM_NM
              ,SUM(M2.ORDER_QTY) AS ORDER_QTY
          FROM LO_OUT_M M1
               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                               AND M2.ITEM_NM    LIKE '%��ġ%'
         WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-05'
         GROUP BY M2.ITEM_CD
                 ,M2.ITEM_NM
       ) L1
 ORDER BY CASE WHEN ITEM_NM LIKE '����%' THEN CONCAT('1', ITEM_NM) ELSE '2' END -- NULL�� �� ó�� ���� ���� �����ϱ� ����
         ,ORDER_QTY DESC;
*/            
---------------------------------------------------------------------------------------------------- 





--���������� �� FROM~TO �����̷¿��� �ش� ������ ��������--------------------------------------------
SELECT NAME
      ,OPEN_DATE
      ,CLOSE_DATE
      ,GREATEST(OPEN_DATE , TO_DATE (:YYYYMM||'01', 'YYYY-MM-DD')) AS START_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(:YYYYMM||'01'))                  AS FINISH_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(:YYYYMM||'01')) - GREATEST(OPEN_DATE , TO_DATE (:YYYYMM||'01', 'YYYY-MM-DD')) + 1 AS DAYS
  FROM V_KT L1
 WHERE CLOSE_DATE >= TO_DATE (:YYYYMM||'01', 'YYYY-MM-DD')
   AND OPEN_DATE  <= LAST_DAY(:YYYYMM||'01');
   
/*MariaDB
SET @YYYYMM = '2019-11';
SELECT NAME
      ,OPEN_DATE
      ,CLOSE_DATE
      ,GREATEST(OPEN_DATE , CONVERT(CONCAT(@YYYYMM, '-01'), DATE))          AS START_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(CONVERT(CONCAT(@YYYYMM, '-01'), DATE)))   AS FINISH_DATE
      ,LEAST(CLOSE_DATE, LAST_DAY(CONVERT(CONCAT(@YYYYMM, '-01'), DATE))) - GREATEST(OPEN_DATE , CONVERT(CONCAT(@YYYYMM, '-01'), DATE)) + 1 AS DAYS
  FROM (
        SELECT '���α�' AS NAME, CONVERT('2019-09-01', DATE) AS OPEN_DATE, CONVERT('2019-12-05', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '����' AS NAME, CONVERT('2019-09-15', DATE) AS OPEN_DATE, CONVERT('9999-12-31', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '���Ǽ�' AS NAME, CONVERT('2019-09-10', DATE) AS OPEN_DATE, CONVERT('2019-10-30', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '������' AS NAME, CONVERT('2019-10-25', DATE) AS OPEN_DATE, CONVERT('2019-11-01', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '������' AS NAME, CONVERT('2019-11-25', DATE) AS OPEN_DATE, CONVERT('9999-12-31', DATE) AS CLOSE_DATE
        UNION ALL
        SELECT '������' AS NAME, CONVERT('2019-12-05', DATE) AS OPEN_DATE, CONVERT('9999-12-31', DATE) AS CLOSE_DATE
       ) L1
 WHERE CLOSE_DATE >= CONVERT(CONCAT(@YYYYMM, '-01'), DATE)
   AND OPEN_DATE  <= LAST_DAY(CONVERT(CONCAT(@YYYYMM, '-01'), DATE));
*/      
----------------------------------------------------------------------------------------------------





--���������� �� �м��Լ�/�����Լ� ���� �� ������ �ø��� �����ϱ�-------------------------------------
SELECT --���� Avg:�߰��� (����� ��� �߰����� ����) ���ϱ�
       CASE WHEN NO_2 = 1 THEN OUTBOUND_DATE           ELSE 'Avg:�߰���'                                               END AS OUTBOUND_DATE   --�������
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ITEM_CNT)       ELSE ROUND(NXT_ITEM_CNT       / ITEM_CNT       * 100, 1) || '%' END AS ITEM_CNT        --SKU��
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ORDER_CNT)      ELSE ROUND(NXT_ORDER_CNT      / ORDER_CNT      * 100, 1) || '%' END AS ORDER_CNT       --ORDER��
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ORDER_LINE_CNT) ELSE ROUND(NXT_ORDER_LINE_CNT / ORDER_LINE_CNT * 100, 1) || '%' END AS ORDER_LINE_CNT  --O.L.��
      ,CASE WHEN NO_2 = 1 THEN TO_CHAR(ORDER_QTY)      ELSE ROUND(NXT_ORDER_QTY      / ORDER_QTY      * 100, 1) || '%' END AS ORDER_QTY       --������
    --,DECODE(NO_2, 2, 5, NO_1) AS NO
  FROM (--L4 Avg:�߰��� (����� ��� �߰����� ����)�� ���ϱ� ���� --> ����� ���ڵ�� �߰��� ���ڵ带 ����
        SELECT L3.*
              ,CASE WHEN NO = 2 THEN LEAD(ITEM_CNT)       OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ITEM_CNT --�������� ������ ������� �߰����� ������ 5�� �ν��ϰ� ��
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_CNT)      OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ORDER_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_LINE_CNT) OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ORDER_LINE_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_QTY)      OVER(ORDER BY CASE WHEN NO_1 = 3 AND NO = 2 THEN 5 ELSE NO_1 END, NO DESC) END AS NXT_ORDER_QTY
              ,NO AS NO_2
          FROM (--L3 �߰��� (����հ� PEAK���� �߰���)
                SELECT CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '�߰���' END AS OUTBOUND_DATE
                      ,ROUND(AVG(ITEM_CNT))                   AS ITEM_CNT
                      ,ROUND(AVG(ORDER_CNT))                  AS ORDER_CNT
                      ,ROUND(AVG(ORDER_LINE_CNT))             AS ORDER_LINE_CNT
                      ,ROUND(AVG(ORDER_QTY))                  AS ORDER_QTY
                      ,MAX(NO_1 + NO - 1)                     AS NO_1
                  FROM (--L2 ��/���/Peak
                        SELECT CASE NO WHEN 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN 2 THEN '��' WHEN 3 THEN '�����' WHEN 4 THEN 'Peak' END AS OUTBOUND_DATE --�������
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)
                                          WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)
                                          WHEN NO = 3 THEN AVG(ITEM_CNT)
                                          WHEN NO = 4 THEN MAX(ITEM_CNT)
                                     END) ITEM_CNT   --SKU��
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)
                                          WHEN NO = 2 THEN SUM(ORDER_CNT)
                                          WHEN NO = 3 THEN AVG(ORDER_CNT)
                                          WHEN NO = 4 THEN MAX(ORDER_CNT)
                                     END) ORDER_CNT   --ORDER��
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_LINE_CNT)
                                          WHEN NO = 2 THEN SUM(ORDER_LINE_CNT)
                                          WHEN NO = 3 THEN AVG(ORDER_LINE_CNT)
                                          WHEN NO = 4 THEN MAX(ORDER_LINE_CNT)
                                     END) ORDER_LINE_CNT --O.L.��
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_QTY)
                                          WHEN NO = 2 THEN SUM(ORDER_QTY)
                                          WHEN NO = 3 THEN AVG(ORDER_QTY)
                                          WHEN NO = 4 THEN MAX(ORDER_QTY)
                                     END) ORDER_QTY --��������
                              , NO AS NO_1
                          FROM (--L1 �⺻�� �� ��SKU��/�ѿ����� ���ϱ�
                                SELECT OUTBOUND_DATE                    AS OUTBOUND_DATE   --�������
                                      ,COUNT(DISTINCT ITEM_CD)          AS ITEM_CNT        --SKU��
                                      ,COUNT(DISTINCT INVOICE_NO)       AS ORDER_CNT       --ORDER��
                                      ,COUNT(1)                         AS ORDER_LINE_CNT  --O.L.��
                                      ,SUM(ORDER_QTY)                   AS ORDER_QTY       --��������
                                      ,MIN(TOT_ITEM_CNT)                AS TOT_ITEM_CNT    --��ü SKU��
                                  FROM (
                                        SELECT --+ ORDERED USE_NL(M2)
                                               M1.OUTBOUND_DATE
                                              ,M1.INVOICE_NO
                                              ,M2.ITEM_CD
                                              ,M2.ORDER_QTY
                                              ,COUNT(DISTINCT M2.ITEM_CD   ) OVER() AS TOT_ITEM_CNT  --��ü SKU��
                                              ,COUNT(DISTINCT M2.INVOICE_NO) OVER() AS TOT_ORDER_CNT --��ü ������
                                          FROM LO_OUT_M M1
                                               JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                         WHERE M1.OUTBOUND_DATE BETWEEN :OUTBOUND_DATE1 AND :OUTBOUND_DATE2
                                       )
                                 GROUP BY OUTBOUND_DATE
                                 ORDER BY OUTBOUND_DATE
                               ) L1
                               JOIN CS_NO C1 ON C1.NO <= 4   --[1]���� [2]�հ� [3]��� [4]��ũ
                         GROUP BY CASE NO WHEN 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN 2 THEN '��' WHEN 3 THEN '�����' WHEN 4 THEN 'Peak' END
                                 ,NO
                         ORDER BY NO
                                 ,OUTBOUND_DATE
                       ) L2
                       JOIN CS_NO C2 ON C2.NO <= CASE NO_1 WHEN 1 THEN 1 --[����]�� ��������
                                                           WHEN 2 THEN 1 --[��]�� ��������
                                                           ELSE        2 --[�����]/[Peak]�� ������
                                                  END
                 GROUP BY CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '�߰���' END
                 ORDER BY NO_1
                         ,OUTBOUND_DATE
               ) L3
               JOIN CS_NO C3 ON C3.NO IN (1, CASE NO_1 WHEN 3 THEN 2 END) --[�����]�� ���� / [������]�� ���� ����
         ORDER BY NO, NO_1, OUTBOUND_DATE
       ) L4;
 
/*MariaDB
SELECT CASE WHEN NO_2 = 1 THEN OUTBOUND_DATE           ELSE 'Avg:�߰���'                                                           END AS OUTBOUND_DATE         -- �������
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ITEM_CNT, CHAR)       ELSE CONCAT(ROUND(NXT_ITEM_CNT       / ITEM_CNT       * 100, 1), '%') END AS ITEM_CNT        -- SKU��
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ORDER_CNT, CHAR)      ELSE CONCAT(ROUND(NXT_ORDER_CNT      / ORDER_CNT      * 100, 1), '%') END AS ORDER_CNT       -- ORDER��
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ORDER_LINE_CNT, CHAR) ELSE CONCAT(ROUND(NXT_ORDER_LINE_CNT / ORDER_LINE_CNT * 100, 1), '%') END AS ORDER_LINE_CNT  -- O.L.��
      ,CASE WHEN NO_2 = 1 THEN CONVERT(ORDER_QTY, CHAR)      ELSE CONCAT(ROUND(NXT_ORDER_QTY      / ORDER_QTY      * 100, 1), '%') END AS ORDER_QTY       -- ������
   -- ,DECODE(NO_2, 2, 5, NO_1) AS NO
  FROM (-- L4
        SELECT L3.*
              ,CASE WHEN NO = 2 THEN LEAD(ITEM_CNT)       OVER(ORDER BY NO, NO_1) END AS NXT_ITEM_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_CNT)      OVER(ORDER BY NO, NO_1) END AS NXT_ORDER_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_LINE_CNT) OVER(ORDER BY NO, NO_1) END AS NXT_ORDER_LINE_CNT
              ,CASE WHEN NO = 2 THEN LEAD(ORDER_QTY)      OVER(ORDER BY NO, NO_1) END AS NXT_ORDER_QTY
              ,NO AS NO_2
          FROM (-- L3 �߰���
                SELECT CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '�߰���' END AS OUTBOUND_DATE
                      ,ROUND(AVG(ITEM_CNT))                   AS ITEM_CNT
                      ,ROUND(AVG(ORDER_CNT))                  AS ORDER_CNT
                      ,ROUND(AVG(ORDER_LINE_CNT))             AS ORDER_LINE_CNT
                      ,ROUND(AVG(ORDER_QTY))                  AS ORDER_QTY
                      ,MAX(NO_1 + NO - 1)                     AS NO_1
                  FROM (-- L2 ��/���/Peak
                        SELECT CASE NO WHEN 1 THEN CONVERT(OUTBOUND_DATE, CHAR) WHEN 2 THEN '��' WHEN 3 THEN '�����' WHEN 4 THEN 'Peak' END AS OUTBOUND_DATE -- �������
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ITEM_CNT)
                                          WHEN NO = 2 THEN MIN(TOT_ITEM_CNT)
                                          WHEN NO = 3 THEN AVG(ITEM_CNT)
                                          WHEN NO = 4 THEN MAX(ITEM_CNT)
                                     END) ITEM_CNT   -- SKU��
                              ,ROUND(CASE WHEN NO = 1 THEN SUM(ORDER_CNT)
                                          WHEN NO = 2 THEN MIN(TOT_ORDER_CNT)
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
                              , NO AS NO_1
                          FROM (-- L1
																								        SELECT M1.OUTBOUND_DATE  -- �������
																								              ,M1.ITEM_CNT       -- SKU��
																								              ,M1.ORDER_CNT      -- ORDER��
																								              ,M1.ORDER_LINE_CNT -- O.L.��
																								              ,M1.ORDER_QTY      -- ��������
																								              ,M2.TOT_ITEM_CNT   -- ��ü SKU��
																								              ,M2.TOT_ORDER_CNT  -- ��ü �԰�ó��
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
																								                           ,COUNT(DISTINCT M2.INVOICE_NO) AS TOT_ORDER_CNT
																								                       FROM LO_OUT_M M1
																													                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
																													                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-03' AND '2019-09-10'
																								                    ) M2 ON 1 = 1
																								         ORDER BY M1.OUTBOUND_DATE
                               ) L1
                               JOIN CS_NO C1 ON C1.NO <= 4   -- [1]���� [2]�հ� [3]��� [4]��ũ
                         GROUP BY CASE NO WHEN 1 THEN TO_CHAR(OUTBOUND_DATE) WHEN 2 THEN '��' WHEN 3 THEN '�����' WHEN 4 THEN 'Peak' END
                                 ,NO
                         ORDER BY NO
                                 ,OUTBOUND_DATE
                       ) L2
                       JOIN CS_NO C2 ON C2.NO <= CASE NO_1 WHEN 1 THEN 1 WHEN 2 THEN 1 ELSE 2 END
                 GROUP BY CASE WHEN NO = 1 THEN OUTBOUND_DATE ELSE '�߰���' END
                 ORDER BY NO_1
                         ,OUTBOUND_DATE
               ) L3
               JOIN CS_NO C3 ON C3.NO <= CASE NO_1 WHEN 3 THEN 2 WHEN 5 THEN 2 ELSE 1 END
         ORDER BY NO, NO_1, OUTBOUND_DATE
       ) L4
 WHERE NOT (NO_1 = 5 AND NO_2 = 2);
*/    
----------------------------------------------------------------------------------------------------