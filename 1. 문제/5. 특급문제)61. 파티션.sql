/* 
 CREATE TABLE YOON.T_ORDER61
   (CUST_NO     VARCHAR2(6)   ,
    ORDER_DT    VARCHAR2(8)   ,
    ORDER_SN    NUMBER        ,
    ORDER_AMT   NUMBER DEFAULT 0,
    CONSTRAINT PK_T_ORDER61 PRIMARY KEY(CUST_NO, ORDER_DT, ORDER_SN)
   );
 CREATE TABLE YOON.T_ORDER_PROD61
   (CUST_NO     VARCHAR2(6)   ,
    ORDER_DT    VARCHAR2(8)   ,
    ORDER_SN    NUMBER        ,
    PROD_NO     VARCHAR2(5)   ,
    PRICE       NUMBER DEFAULT 0  ,
    AMT         NUMBER ,
    CONSTRAINT PK_T_ORDER_PROD61 PRIMARY KEY(CUST_NO, ORDER_DT, ORDER_SN, PROD_NO)
   );
T_ORDER61,  T_ORDER_PROD61은 ORDER_DT로 월별 파티션되어 있음.
파티션명칭 : PTYYYYMM
아래 SQL을 보고 튜닝하세요.
※ 실제 오라클에 환경 구성을 하고 아래의 SQL을 수행해도 아래와 같은 실행계획은 나오지 않습니다.
   아래와 같이 실행계획이 나왔다고 가정하고 최적의 튜닝을 수행해 보세요.

*/
INSERT INTO T_AGGRE61
SELECT /*+ NO_QUERY_TRANSFORMATION  
           LEADING(C A B) USE_NL(A)  USE_NL(B) 
           INDEX(A PK_T_ORDER61) INDEX(B PK_T_ORDER_PROD61) */ 
       A.CUST_NO, A.ORDER_DT, A.ORDER_SN, A.ORDER_AMT, 
       B.PROD_NO, B.PRICE, 
       C.ORDER_CNT, C.ORDER_PROD_CNT
FROM T_ORDER61 A,  T_ORDER_PROD61 B,
     (SELECT /*+ INDEX(X IX_T_ORDER_PROD61) */
             CUST_NO, ORDER_DT, COUNT(*) ORDER_CNT, COUNT(DISTINCT PROD_NO) ORDER_PROD_CNT
      FROM  T_ORDER_PROD61 X
      WHERE ORDER_DT LIKE '201605%'
      GROUP BY CUST_NO, ORDER_DT
      ) C
WHERE B.ORDER_DT  LIKE '201605%'
 AND  A.CUST_NO  = C.CUST_NO
 AND  A.ORDER_DT = C.ORDER_DT
 AND  B.CUST_NO  = A.CUST_NO
 AND  B.ORDER_DT = A.ORDER_DT
 AND  B.ORDER_SN = A.ORDER_SN 
;
COMMIT;


/*PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------
| Id  | Operation                         | Name              | A-Rows | Buffers |
----------------------------------------------------------------------------------
|   0 | INSERT STATEMENT                  |                   |      0 |    1567K|
|   1 |  LOAD TABLE CONVENTIONAL          |                   |      0 |    1567K|
|   2 |   NESTED LOOPS                    |                   |    930K|    1499K|
|   3 |    NESTED LOOPS                   |                   |    930K|     569K|
|   4 |     NESTED LOOPS                  |                   |    310K|     196K|
|   5 |      VIEW                         |                   |  31000 |     101K|
|   6 |       SORT GROUP BY               |                   |  31000 |     101K|
|   7 |        TABLE ACCESS BY INDEX ROWID| T_ORDER_PROD61    |    930K|     101K|
|*  8 |         INDEX RANGE SCAN          | IX_T_ORDER_PROD61 |    930K|    2594 |
|   9 |      TABLE ACCESS BY INDEX ROWID  | T_ORDER61         |    310K|   95306 |
|* 10 |       INDEX RANGE SCAN            | PK_T_ORDER61      |    310K|   63175 |
|* 11 |     INDEX RANGE SCAN              | PK_T_ORDER_PROD61 |    930K|     372K|
|  12 |    TABLE ACCESS BY INDEX ROWID    | T_ORDER_PROD61    |    930K|     930K|
----------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   8 - access("ORDER_DT" LIKE '201605%')
       filter("ORDER_DT" LIKE '201605%')
  10 - access("A"."CUST_NO"="C"."CUST_NO" AND "A"."ORDER_DT"="C"."ORDER_DT")
       filter("A"."ORDER_DT" LIKE '201605%')
  11 - access("B"."CUST_NO"="A"."CUST_NO" AND "B"."ORDER_DT"="A"."ORDER_DT" AND "B"."ORDER_SN"="A"."ORDER_SN")
       filter("B"."ORDER_DT" LIKE '201605%')

*/