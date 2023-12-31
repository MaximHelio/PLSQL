/*T_CUST62 : PK (CUST_NO)
    CUST_NO    VARCHAR2(7)  <== PK
    CUST_NM    VARCHAR2(50)
    ADDR       VARCHAR2(100)
    TEL        VARCHAR2(11)
    
T_CONT62 : PK(CONT_NO) 
   CONT_NO   VARCHAR2(7)    <== PK
   CUST_NO   VARCHAR2(7)
   CONT_DT   VARCHAR2(8)

T_ADD_SVC62 : PK(CONT_NO, PROD_NO)
  (CONT_NO   VARCHAR2(7)   <== PK
   PROD_NO   VARCHAR2(4)   <== PK
   CONT_DT   VARCHAR2(8)
  
T_PRODUCT62 : PK(PROD_NO)  
   PROD_NO    VARCHAR2(4)  <== PK
   PROD_NM    VARCHAR2(50)

인덱스 : T_CONT62(CONT_DT) 
아래의 SQL과 실행계획을 보고 튜닝 하세요.
통계정보 갱신 시 발생할 수 있는 실행계획 변경을 예방하기위해
옵티마이저 힌트를 통해 실행계획을 고정하세요.
인덱스를 추가할 수 있습니다.  단 불필요한 인덱스 추가 시 감점이 있을 수 있습니다.
*/
SELECT /*+ NO_QUERY_TRANSFORMATION */
       A.CUST_NO, A.CUST_NM,
       B.CONT_NO, B.CONT_DT,
       C.CONT_DT,
       D.PROD_NO, D.PROD_NM
FROM T_CUST62    A 
   , T_CONT62    B 
   , T_ADD_SVC62 C
   , T_PRODUCT62 D
WHERE A.CUST_NO = 'C000427'
 AND B.CUST_NO = A.CUST_NO
 AND C.CONT_DT = '20170505'
 AND C.CONT_NO = B.CONT_NO
 AND D.PROD_NO = C.PROD_NO 
;
----------------------------------------------------------------------------
| Id  | Operation                       | Name           | A-Rows |Buffers |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |                |      9 |   1310 |
|   1 |  NESTED LOOPS                   |                |      9 |   1310 |
|   2 |   NESTED LOOPS                  |                |      9 |   1301 |
|   3 |    NESTED LOOPS                 |                |      9 |   1297 |
|   4 |     NESTED LOOPS                |                |      3 |   1261 |
|   5 |      TABLE ACCESS BY INDEX ROWID| T_CUST62       |      1 |      3 |
|*  6 |       INDEX UNIQUE SCAN         | PK_T_CUST62    |      1 |      2 |
|*  7 |      TABLE ACCESS FULL          | T_CONT62       |      3 |   1258 |
|*  8 |     TABLE ACCESS BY INDEX ROWID | T_ADD_SVC62    |      9 |     36 |
|*  9 |      INDEX RANGE SCAN           | PK_T_ADD_SVC62 |     27 |      9 |
|* 10 |    INDEX UNIQUE SCAN            | PK_T_PRODUCT62 |      9 |      4 |
|  11 |   TABLE ACCESS BY INDEX ROWID   | T_PRODUCT62    |      9 |      9 |
----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
   6 - access("A"."CUST_NO"='C000427')
   7 - filter("B"."CUST_NO"='C000427')
   8 - filter("C"."CONT_DT"='20170505')
   9 - access("C"."CONT_NO"="B"."CONT_NO")
  10 - access("D"."PROD_NO"="C"."PROD_NO")
 