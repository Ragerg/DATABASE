--실전문제① ▶ 하나의 SQL로 상황에 따라 정렬하기 (날짜)---------------------------------------------
SELECT OUTBOUND_DATE, INVOICE_NO, WORK_SEQ
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-04'
   AND SET_TYPE_CD   = '000581225'
   AND SET_QTY       = 3
  ORDER BY TO_NUMBER(TO_CHAR(OUTBOUND_DATE, 'YYYYMMDD')) * CASE WHEN :SORT_TYPE = 1 THEN 1 ELSE -1 END
          ,CASE WHEN :SORT_TYPE = 1 THEN WORK_SEQ ELSE -WORK_SEQ END;
          
/*MariaDB
SET @SORT_TYPE = 1;
SELECT OUTBOUND_DATE, INVOICE_NO, WORK_SEQ
  FROM LO_OUT_M
 WHERE OUTBOUND_DATE BETWEEN '2019-06-03' AND '2019-06-04'
   AND SET_TYPE_CD   = '000581225'
   AND SET_QTY       = 3
  ORDER BY CONVERT(DATE_FORMAT(OUTBOUND_DATE, '%Y%m%d'), INTEGER) * CASE WHEN @SORT_TYPE = 1 THEN 1 ELSE -1 END
          ,CASE WHEN @SORT_TYPE = 1 THEN WORK_SEQ ELSE -WORK_SEQ END;
*/             
----------------------------------------------------------------------------------------------------



 

--평가문제② ▶ 단계적 인라인뷰 적용하기 및 SQL의 최종 이해------------------------------------------
--순위를 부여하기
SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA,  SCORE
      ,ROWNUM AS RNK
  FROM (--40개 상품을 구하기
        SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA,  SCORE
          FROM (--가중치를 부여한 점수를 더하여 100점 만점의 최종 점수를 구하기
                SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA
                      ,CNT_SCORE + QTY_SCORE + QTYA_SCORE AS SCORE
                  FROM (--3가지 항목에 대한 가중치를 부여하여 점수를 구하기 ex)70%-20%-10%
                        SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA,  CNT_POINT,  QTY_POINT,  QTYA_POINT
                              ,ROUND(CNT_POINT  * 0.7, 2) AS CNT_SCORE
                              ,ROUND(QTY_POINT  * 0.2, 2) AS QTY_SCORE
                              ,ROUND(QTYA_POINT * 0.1, 2) AS QTYA_SCORE
                          FROM (--상대평가에 의한 점수 부여하기
                                SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA
                                      ,ROUND(ORDER_CNT  / MAX_ORDER_CNT  * 100, 2) AS CNT_POINT
                                      ,ROUND(ORDER_QTY  / MAX_ORDER_QTY  * 100, 2) AS QTY_POINT
                                      ,ROUND(ORDER_QTYA / MAX_ORDER_QTYA * 100, 2) AS QTYA_POINT
                                  FROM (--로케이션할당 기준항목인 피킹횟수/주문수량/회당피킹수량에 대해 상대평가에 의한 점수부여를 위해 각 항목별 최대값을 구하기
                                        SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY, ORDER_QTYA
                                              ,RANK() OVER(ORDER BY ORDER_CNT DESC) AS RNK_CNT
                                              ,RANK() OVER(ORDER BY ORDER_QTY DESC) AS RNK_QTY
                                              ,MAX(ORDER_CNT)  OVER()               AS MAX_ORDER_CNT
                                              ,MAX(ORDER_QTY)  OVER()               AS MAX_ORDER_QTY
                                              ,MAX(ORDER_QTYA) OVER()               AS MAX_ORDER_QTYA
                                          FROM (--상품별 회당 피킹수량 구하기
                                                SELECT ITEM_CD
                                                      ,COUNT(DISTINCT M1.INVOICE_NO)                               AS ORDER_CNT
                                                      ,SUM(M2.ORDER_QTY)                                           AS ORDER_QTY
                                                      ,ROUND(SUM(M2.ORDER_QTY) / COUNT(DISTINCT M1.INVOICE_NO), 2) AS ORDER_QTYA
                                                  FROM LO_OUT_M M1
                                                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-30'
                                                 GROUP BY ITEM_CD
                                              ) S1
                                       ) S2
                               ) S3
                       ) S4
                 ORDER BY SCORE DESC
               ) S5
         WHERE ROWNUM <= 40
       ) S6;
       
/*MariaDB
SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA,  SCORE, RNK
  FROM (-- 40개 상품을 구하기
        SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA,  SCORE
              ,ROW_NUMBER() OVER(ORDER BY SCORE DESC) AS RNK
          FROM (-- 가중치를 부여한 점수를 더하여 100점 만점의 최종 점수를 구하기
                SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA
                      ,CNT_SCORE + QTY_SCORE + QTYA_SCORE AS SCORE
                  FROM (-- 3가지 항목에 대한 가중치를 부여하여 점수를 구하기 ex)70%-20%-10%
                        SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA,  CNT_POINT,  QTY_POINT,  QTYA_POINT
                              ,ROUND(CNT_POINT  * 0.7, 2) AS CNT_SCORE
                              ,ROUND(QTY_POINT  * 0.2, 2) AS QTY_SCORE
                              ,ROUND(QTYA_POINT * 0.1, 2) AS QTYA_SCORE
                          FROM (-- 상대평가에 의한 점수 부여하기
                                SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY,  ORDER_QTYA
                                      ,ROUND(ORDER_CNT  / MAX_ORDER_CNT  * 100, 2) AS CNT_POINT
                                      ,ROUND(ORDER_QTY  / MAX_ORDER_QTY  * 100, 2) AS QTY_POINT
                                      ,ROUND(ORDER_QTYA / MAX_ORDER_QTYA * 100, 2) AS QTYA_POINT
                                  FROM (-- 로케이션할당 기준항목인 피킹횟수/주문수량/회당피킹수량에 대해 상대평가에 의한 점수부여를 위해 각 항목별 최대값을 구하기
                                        SELECT ITEM_CD,  ORDER_CNT,  ORDER_QTY, ORDER_QTYA
                                              ,RANK() OVER(ORDER BY ORDER_CNT DESC) AS RNK_CNT
                                              ,RANK() OVER(ORDER BY ORDER_QTY DESC) AS RNK_QTY
                                              ,MAX(ORDER_CNT)  OVER()               AS MAX_ORDER_CNT
                                              ,MAX(ORDER_QTY)  OVER()               AS MAX_ORDER_QTY
                                              ,MAX(ORDER_QTYA) OVER()               AS MAX_ORDER_QTYA
                                          FROM (-- 상품별 회당 피킹수량 구하기
                                                SELECT ITEM_CD
                                                      ,COUNT(DISTINCT M1.INVOICE_NO)                               AS ORDER_CNT
                                                      ,SUM(M2.ORDER_QTY)                                           AS ORDER_QTY
                                                      ,ROUND(SUM(M2.ORDER_QTY) / COUNT(DISTINCT M1.INVOICE_NO), 2) AS ORDER_QTYA
                                                  FROM LO_OUT_M M1
                                                       JOIN LO_OUT_D M2 ON M2.INVOICE_NO = M1.INVOICE_NO
                                                 WHERE M1.OUTBOUND_DATE BETWEEN '2019-09-01' AND '2019-09-30'
                                                 GROUP BY ITEM_CD
                                              ) S1
                                       ) S2
                               ) S3
                       ) S4
               ) S5
       ) S6
 WHERE RNK <= 40;
*/          
----------------------------------------------------------------------------------------------------
