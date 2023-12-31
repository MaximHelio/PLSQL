/* 주문일자별  년월 RANGE PARTITION  
   튜닝 키
     - 인라인 뷰를 없애고  윈도우 함수로 변경
     - 인덱스 스캔이 아닌 파티션 풀 스캔으로 수정
     - LIKE가 아닌 BETWEEN 으로 수정
*/
ALTER SESSION SET STATISTICS_LEVEL = ALL;

TRUNCATE TABLE YOON.T_AGGRE61;

ALTER TABLE T_AGGRE61 NOLOGGING ;

INSERT /*+ APPEND */ INTO T_AGGRE61
SELECT /*+ ORDERED  USE_HASH(B) */
       A.CUST_NO, A.ORDER_DT, A.ORDER_SN, A.ORDER_AMT, 
       B.PROD_NO, B.PRICE, 
       COUNT(*) OVER(PARTITION BY B.CUST_NO, B.ORDER_DT)                   ORDER_CNT, 
       COUNT(DISTINCT B.PROD_NO) OVER (PARTITION BY B.CUST_NO, B.ORDER_DT) ORDER_PROD_CNT
FROM  T_ORDER61      PARTITION (PT201605) A,
      T_ORDER_PROD61 PARTITION (PT201605) B
WHERE A.ORDER_DT BETWEEN '20160501' AND '20160531'
 AND  B.CUST_NO   = A.CUST_NO
 AND  B.ORDER_DT  = A.ORDER_DT
 AND  B.ORDER_SN  = A.ORDER_SN
;

ALTER TABLE T_AGGRE61 LOGGING ;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS PARTITION LAST'));

/*
PLAN_TABLE_OUTPUT
---------------------------------------------------------------------------------------------------------
| Id  | Operation                 | Name           | Pstart| Pstop | A-Rows | Buffers | Reads  | Writes |
---------------------------------------------------------------------------------------------------------
|   0 | INSERT STATEMENT          |                |       |       |      0 |     133K|    265K|    264K|
|   1 |  LOAD AS SELECT           |                |       |       |      0 |     133K|    265K|    264K|
|   2 |   WINDOW SORT             |                |       |       |   9300K|   63883 |    265K|    201K|
|*  3 |    HASH JOIN              |                |       |       |   9300K|   63847 |  99775 |  35929 |
|   4 |     PARTITION RANGE SINGLE|                |     5 |     5 |   3100K|   12935 |  12918 |      0 |
|*  5 |      TABLE ACCESS FULL    | T_ORDER61      |     5 |     5 |   3100K|   12935 |  12918 |      0 |
|   6 |     PARTITION RANGE SINGLE|                |     5 |     5 |   9300K|   50912 |  50897 |      0 |
|*  7 |      TABLE ACCESS FULL    | T_ORDER_PROD61 |     5 |     5 |   9300K|   50912 |  50897 |      0 |
---------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("B"."CUST_NO"="A"."CUST_NO" AND "B"."ORDER_DT"="A"."ORDER_DT" AND "B"."ORDER_SN"="A"."ORDER_SN")
   5 - filter("A"."ORDER_DT"<='20160531')
   7 - filter("B"."ORDER_DT"<='20160531')
  
 */