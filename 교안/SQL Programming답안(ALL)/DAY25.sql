--���������� �� PROCEDURE�� ������ ���� �����ϱ�-----------------------------------------------------
CREATE OR REPLACE PROCEDURE EDU_USER.CREATE_GUGUDAN_SKP (
  P_USER_ID              IN  VARCHAR2
 ,P_GUGUDAN1             IN  NUMBER
 ,P_GUGUDAN2             IN  NUMBER
   
 ,O_MSG                 OUT VARCHAR2
) AS
/*--------------------------------------------------------------------------------------------------
 * SP ��        : CREATE_GUGUDAN
 * ��ɼ���     : ���ÿ� ���α׷� 
 * ���UNIT     
 * �ۼ���       : �Ƽ���ũ
 * ������       : �Ƽ���ũ
 * �ۼ�����     : 2019-12-06
 * ��������     :                                
 * RETURN VALUE : 
--------------------------------------------------------------------------------------------------*/

--��������------------------------------------------------------------------------------------------
V_STRING    VARCHAR2(100);
----------------------------------------------------------------------------------------------------

BEGIN

  --0.�Ķ���Ͱ� üũ-------------------------------------------------------------------------------
  IF NOT(P_GUGUDAN1 BETWEEN 1 AND 9) OR NOT(P_GUGUDAN2 BETWEEN 1 AND 9) THEN
    O_MSG := '������ ���� ������ �ƴմϴ�.';
    RETURN;
  END IF;

  IF P_GUGUDAN1 > P_GUGUDAN2 THEN
    O_MSG := '������ ù��° ���ڰ� �ι�° ���ں��� Ŭ �� �����ϴ�.';
    RETURN;
  END IF;
  --------------------------------------------------------------------------------------------------
  
  

  --1. �ش� ID�� ���� ����--------------------------------------------------------------------------
  BEGIN
  
    DELETE ZZ_TEST_GUGUDAN
     WHERE USER_ID = P_USER_ID;
  
  EXCEPTION
    WHEN OTHERS THEN
      O_MSG := '1[' || SQLCODE || '] ' || SQLERRM;
      RETURN;
  END;
  --------------------------------------------------------------------------------------------------
  
  
/*  
  --3.LOOP ������ ������ �ۼ� �� ����---------------------------------------------------------------
  FOR I IN P_GUGUDAN1..P_GUGUDAN2
  LOOP
  
    FOR J IN 1..9
    LOOP
    
      V_STRING := TO_CHAR(I) || '��' || TO_CHAR(J) || '=' || TO_CHAR(I*J);

      --DML�ۼ�-------------------------------------------------------------------------------------
      BEGIN
      
        INSERT INTO ZZ_TEST_GUGUDAN
               (USER_ID  , CONTENTS, REG_DATETIME)
        VALUES (P_USER_ID, V_STRING, SYSDATE);
      
      EXCEPTION
        WHEN OTHERS THEN
          O_MSG := '1[' || SQLCODE || '] ' || SQLERRM;
          ROLLBACK;
          RETURN;
      
      END;
      ----------------------------------------------------------------------------------------------
      
    END LOOP;
    
  END LOOP;
  --------------------------------------------------------------------------------------------------
*/

  
  BEGIN

    INSERT INTO ZZ_TEST_GUGUDAN
          (USER_ID  , CONTENTS, REG_DATETIME)
    SELECT P_USER_ID AS USER_ID
          ,TO_CHAR(M1.NO) || '��' || TO_CHAR(M2.NO) || '=' || TO_CHAR(M1.NO*M2.NO) AS CONTENTS
          ,SYSDATE   AS REG_DATETIME
      FROM CS_NO M1
           JOIN CS_NO M2 ON M2.NO <= 9
     WHERE M1.NO BETWEEN P_GUGUDAN1 AND P_GUGUDAN2
     ORDER BY M1.NO, M2.NO;
  
  EXCEPTION
    WHEN OTHERS THEN
      O_MSG := '1[' || SQLCODE || '] ' || SQLERRM;
      ROLLBACK;
      RETURN;
  
  END;



  O_MSG := 'OK';
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    O_MSG := '[' || SQLCODE || '] ' || SQLERRM;
    ROLLBACK;
END;
/
----------------------------------------------------------------------------------------------------




--���������� �� ���� ���賻�� �����ϱ�---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE EDU_USER.CREATE_RESULT_YM_SKP (
  P_USER_ID        IN  VARCHAR2
 ,P_YM1            IN  VARCHAR2
 ,P_YM2            IN  VARCHAR2
   
 ,O_MSG            OUT VARCHAR2
) AS
/*--------------------------------------------------------------------------------------------------
 * SP ��        : CREATE_RESULT_YM_SKP
 * ��ɼ���     : ��������(ZZ_TEST_PROCEDURE) ����
 * ���UNIT     
 * �ۼ���       : �Ƽ���ũ
 * ������       : �Ƽ���ũ
 * �ۼ�����     : 2019-12-06
 * ��������     :                                
 * RETURN VALUE : 
--------------------------------------------------------------------------------------------------*/

--��������------------------------------------------------------------------------------------------
V_REG_DATETIME      ZZ_TEST_PROCEDURE.REG_DATETIME%TYPE;
----------------------------------------------------------------------------------------------------

BEGIN

  V_REG_DATETIME := SYSDATE;

  --0.�Ķ���Ͱ� üũ-------------------------------------------------------------------------------
  IF P_USER_ID IS NULL THEN
    O_MSG := 'USER_ID ���� NULL�Դϴ�. Ȯ���� �ٽ� �����ϼ���!';
    RETURN;
  END IF;
  --------------------------------------------------------------------------------------------------
  
  

  --1. �ش� ID�� ���� ����--------------------------------------------------------------------------
  BEGIN
  
    DELETE ZZ_TEST_PROCEDURE
     WHERE USER_ID = P_USER_ID;
  
  EXCEPTION
    WHEN OTHERS THEN
      O_MSG := '1[' || SQLCODE || '] ' || SQLERRM;
      RETURN;
  END;
  --------------------------------------------------------------------------------------------------



  --2. ���� ����------------------------------------------------------------------------------------
  BEGIN
  
    INSERT INTO ZZ_TEST_PROCEDURE
           (USER_ID
           ,YM
           ,TOT_QTY
           ,M12_QTY
           ,M22_QTY
           ,ETC_QTY
           )
    SELECT P_USER_ID                                                                  AS USER_ID
          ,TO_CHAR(M1.OUTBOUND_DATE, 'YYYYMM')                                        AS YM
          ,SUM(M2.ORDER_QTY)                                                          AS TOT_QTY
          ,SUM(CASE M1.OUT_TYPE_DIV WHEN 'M12' THEN M2.ORDER_QTY END)                 AS M12_QTY
          ,SUM(CASE M1.OUT_TYPE_DIV WHEN 'M22' THEN M2.ORDER_QTY END)                 AS M22_QTY
          ,SUM(CASE WHEN M1.OUT_TYPE_DIV NOT IN ('M12', 'M22') THEN M2.ORDER_QTY END) AS ETC_QTY
      FROM LO_OUT_M M1
           JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
     WHERE M1.OUTBOUND_DATE BETWEEN TO_DATE(P_YM1 || '01', 'YYYY-MM-DD') AND LAST_DAY(TO_DATE(P_YM2 || '01', 'YYYY-MM-DD'))
     GROUP BY TO_CHAR(M1.OUTBOUND_DATE, 'YYYYMM')
     ORDER BY TO_CHAR(M1.OUTBOUND_DATE, 'YYYYMM');
    
    ---------------------------------------------- 
    IF SQL%ROWCOUNT = 0 THEN
      O_MSG := '���� �����Ͱ� �������� �ʽ��ϴ�.';
      ROLLBACK;
      RETURN;
    END IF;
    ---------------------------------------------- 
    
  EXCEPTION
    WHEN OTHERS THEN
      O_MSG := '2[' || SQLCODE || '] ' || SQLERRM;
      ROLLBACK;
      RETURN;
  END;
  --------------------------------------------------------------------------------------------------

  --3. ����Ͻ� ������Ʈ----------------------------------------------------------------------------
  BEGIN
  
    UPDATE ZZ_TEST_PROCEDURE
       SET REG_DATETIME = V_REG_DATETIME
     WHERE USER_ID      = P_USER_ID;
    
    ---------------------------------------------- 
    IF SQL%ROWCOUNT = 0 THEN
      O_MSG := '���� �����Ͱ� �������� �ʽ��ϴ�.';
      ROLLBACK;
      RETURN;
    END IF;
    ---------------------------------------------- 
    
  EXCEPTION
    WHEN OTHERS THEN
      O_MSG := '3[' || SQLCODE || '] ' || SQLERRM;
      ROLLBACK;
      RETURN;
  END;
  --------------------------------------------------------------------------------------------------

  O_MSG := 'OK';
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    O_MSG := '[' || SQLCODE || '] ' || SQLERRM;
    ROLLBACK;
END;
/
----------------------------------------------------------------------------------------------------