/* 문제)  다음 조건을 보고 아래 OLTP용  SQL을 튜닝하시오.
T_CUST54   : 총  10만건
     CUST_NO    VARCHAR2(6)   <== PK
     CUST_NM    VARCHAR2(50)
     CUST_TYPE  VARCHAR2(4) 
     기타 추가 칼럼 많음
     
T_HOBBY54  : 총  30만건
   CUST_NO    VARCHAR2(6)    <== PK
   HOBBY_TYPE VARCHAR2(1)    <== PK
   기타 추가 칼럼 많음
   
T_ORDER54  : 총 300만건
   ORDER_NO   VARCHAR2(7)  <== PK
   CUST_NO    VARCHAR2(6)
   ORDER_DT   VARCHAR2(8)
   ORDER_TYPE VARCHAR2(3)
   기타 추가 칼럼 많음

CREATE INDEX YOON.IX_T_ORDER54_01 ON YOON.T_ORDER54(CUST_NO);
CREATE INDEX YOON.IX_T_CUST54_01 ON YOON.T_CUST54(CUST_TYPE);
*/
SELECT /*+ LEADING (C H O@T_ORDER54) USE_NL(H) */ 
       C.CUST_NO, C.CUST_NM, H.HOBBY_TYPE, H.C11
FROM T_CUST54 C,  T_HOBBY54 H
WHERE C.CUST_TYPE    = 'C050'
  AND H.CUST_NO = C.CUST_NO
  AND EXISTS (SELECT /*+ QB_NAME(T_ORDER54) UNNEST */ 1
              FROM T_ORDER54 O
              WHERE CUST_NO    = C.CUST_NO
               AND  ORDER_TYPE = '001'
               AND  ORDER_DT IS NULL );
/*
-------------------------------------------------------------------------------------
| Id  | Operation                      | Name            | Starts | A-Rows |Buffers |
-------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                 |      1 |     18 |  19497 |
|*  1 |  FILTER                        |                 |      1 |     18 |  19497 |
|   2 |   NESTED LOOPS                 |                 |      1 |   1500 |   3015 |
|   3 |    NESTED LOOPS                |                 |      1 |   1500 |   1515 |
|   4 |     TABLE ACCESS BY INDEX ROWID| T_CUST54        |      1 |    500 |    505 |
|*  5 |      INDEX RANGE SCAN          | IX_T_CUST54_01  |      1 |    500 |      5 |
|*  6 |     INDEX RANGE SCAN           | PK_HOBBY54      |    500 |   1500 |   1010 |
|   7 |    TABLE ACCESS BY INDEX ROWID | T_HOBBY54       |   1500 |   1500 |   1500 |
|*  8 |   TABLE ACCESS BY INDEX ROWID  | T_ORDER54       |    500 |      6 |  16482 |
|*  9 |    INDEX RANGE SCAN            | IX_T_ORDER54_01 |    500 |  14945 |   1537 |
-------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
--------------------------------------------------- 
   1 - filter( IS NOT NULL)
   5 - access("C"."CUST_TYPE"='C010')
   6 - access("H"."CUST_NO"="C"."CUST_NO")
   8 - filter(("ORDER_DT" IS NULL AND "ORDER_TYPE"='010'))
   9 - access("CUST_NO"=:B1)  */