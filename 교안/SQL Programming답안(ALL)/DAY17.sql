/*

CREATE INDEX EDU_USER.LO_OUT_M_IDX99 ON EDU_USER.LO_OUT_M
(OUT_TYPE_DIV, OUTBOUND_DATE)
LOGGING
TABLESPACE TS_EDU_BASE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
           
CREATE INDEX EDU_USER.LO_OUT_M_IDX98 ON EDU_USER.LO_OUT_M
(OUTBOUND_BATCH, OUTBOUND_DATE)
LOGGING
TABLESPACE TS_EDU_BASE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
           
           
           
           
CREATE INDEX EDU_USER.LO_OUT_D_IDX98 ON EDU_USER.LO_OUT_D
(INVOICE_NO, ORDER_QTY)
LOGGING
TABLESPACE TS_EDU_BASE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
           
*/



ALTER SYSTEM FLUSH BUFFER_CACHE;



--���������� �� ����ӵ� ����Ű��------------------------------------------------------------------
SELECT --+ GATHER_PLAN_STATISTICS
       SUM(M2.ORDER_QTY) AS SUM_QTY
  FROM LO_OUT_M M1
       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                       AND M2.ORDER_QTY  >= 100
 WHERE M1.OUTBOUND_DATE  BETWEEN '2019-01-01' AND '2019-09-30'
   AND M1.OUTBOUND_BATCH = '046';
   
/*MariaDB
������ (��Ʈ ����)
*/
----------------------------------------------------------------------------------------------------

SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));



/*

CREATE INDEX EDU_USER.LO_OUT_D_IDX99 ON EDU_USER.LO_OUT_D
(OUT_TYPE_DIV_D)
LOGGING
TABLESPACE TS_EDU_BASE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );
           
*/



--���������� �� ����ð� üũ �� ����ӵ� ����Ű��-------------------------------------------------
/*
ȭ�� ����� �޺��ڽ��� ��� ���̺���� OUT_TYPE_DIV_D ���� ��� ǥ���ϱ� ���� SQL �ۼ��ϱ�
*/
SELECT --+ GATHER_PLAN_STATISTICS INDEX_FFS(LO_OUT_D)
       DISTINCT 
       OUT_TYPE_DIV_D
  FROM LO_OUT_D
 WHERE OUT_TYPE_DIV_D > ' '
 ORDER BY OUT_TYPE_DIV_D; 
 
 
SELECT --+ GATHER_PLAN_STATISTICS
       C1.CODE_CD
  FROM CS_CODE C1
 WHERE C1.CODE_GRP = 'LDIV03'
   AND EXISTS (SELECT --+ INDEX(S1 LO_OUT_D_IDX99)
                      1
                 FROM LO_OUT_D S1
                WHERE S1.OUT_TYPE_DIV_D = C1.CODE_CD);

                
/*MariaDB
������(��Ʈ ����)
*/                   
----------------------------------------------------------------------------------------------------





--���������� �� ���� ���� SQL �ۼ��ϱ�---------------------------------------------------------------
/*
ȭ�� ����� �޺��ڽ��� ��� ���̺���� OUT_TYPE_DIV_D ���� ��� ǥ���ϱ� ���� SQL �ۼ��ϱ�
*/
SELECT --+ GATHER_PLAN_STATISTICS
       DISTINCT 
       M1.OUT_TYPE_DIV_D
      ,C1.CODE_NM
  FROM LO_OUT_D M1
       JOIN CS_CODE C1 ON C1.CODE_GRP = 'LDIV03'
                      AND C1.CODE_CD  = M1.OUT_TYPE_DIV_D
 ORDER BY M1.OUT_TYPE_DIV_D;

SELECT *
  FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));
  
  
SELECT CODE_CD AS OUT_TYPE_DIV_D
      ,CODE_NM
  FROM CS_CODE C1
 WHERE CODE_GRP = 'LDIV03'
   AND EXISTS (
               SELECT 1
                 FROM LO_OUT_D S1
                WHERE S1.OUT_TYPE_DIV_D = C1.CODE_CD
              )
 ORDER BY CODE_CD;
 
/*MariaDB
������
*/    
---------------------------------------------------------------------------------------------------- 