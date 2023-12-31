/* 아래 SQL은 OLTP 에서 자주 사용되는구문이다. trace를 보고 튜닝을 하시오. (인덱스 변경 가능)
테이블 정보
 - T_ORDER53   : 0.1 억 건 (20090101 이후 200,000건)
 - T_PRODUCT53 : 10,000건
 - T_MANUF53   : 50건
인덱스 
  PRODUCT53 : PK_T_PRODUCT53(PROD_ID);
  T_MANUF53 : PK_T_MANUF53(M_CODE);  
*/
SELECT /*+ ORDERED USE_NL(B C) */
       DISTINCT B.M_CODE, C.M_NM
FROM T_ORDER53 A, 
     T_PRODUCT53 B, 
     T_MANUF53 C
WHERE A.ORDER_DT >= '20090101'
AND A.PROD_ID    = B.PROD_ID
AND B.M_CODE     = C.M_CODE;
/*
---------------------------------------------------------------------------------------
| Id  | Operation                       | Name            | A-Rows | Buffers | Reads  |
---------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |                 |     50 |   40579 |  40161 |
|   1 |  HASH UNIQUE                    |                 |     50 |   40579 |  40161 |
|   2 |   NESTED LOOPS                  |                 |    200 |   40579 |  40161 |
|   3 |    NESTED LOOPS                 |                 |    200 |   40379 |  40161 |
|   4 |     NESTED LOOPS                |                 |    200 |   40375 |  40161 |
|   5 |      VIEW                       | VW_DTP_377C5901 |    200 |   40166 |  40161 |
|   6 |       HASH UNIQUE               |                 |    200 |   40166 |  40161 |
|*  7 |        TABLE ACCESS FULL        | T_ORDER53       |    200K|   40166 |  40161 |
|   8 |      TABLE ACCESS BY INDEX ROWID| T_PRODUCT53     |    200 |     209 |      0 |
|*  9 |       INDEX UNIQUE SCAN         | PK_T_PRODUCT53  |    200 |       9 |      0 |
|* 10 |     INDEX UNIQUE SCAN           | PK_T_MANUF53    |    200 |       4 |      0 |
|  11 |    TABLE ACCESS BY INDEX ROWID  | T_MANUF53       |    200 |     200 |      0 |
---------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   7 - filter("A"."ORDER_DT">='20090101')
   9 - access("ITEM_1"="B"."PROD_ID")
  10 - access("B"."M_CODE"="C"."M_CODE")
*/