CREATE INDEX YOON.IX_T_CONT62_02    ON YOON.T_CONT62   (CUST_NO);
CREATE INDEX YOON.IX_T_ADD_SVC62_02 ON YOON.T_ADD_SVC62(CONT_NO, CONT_DT);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CONT62');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_ADD_SVC62');

ALTER SESSION SET STATISTICS_LEVEL=ALL;

SELECT /*+ LEADING(A B) USE_NL(B) USE_NL(C) 
           INDEX(A PK_T_CUST62) INDEX(B IX_T_CONT62_02) 
           INDEX(C T_ADD_SVC62) */
       A.CUST_NO, A.CUST_NM,
       B.CONT_NO, B.CONT_DT,
       C.CONT_DT,
       C.PROD_NO, 
       D. PROD_NM 
FROM T_CUST62    A 
   , T_CONT62    B 
   , T_ADD_SVC62 C
   , T_PRODUCT62 D  
WHERE A.CUST_NO = 'C000427'
 AND B.CUST_NO = A.CUST_NO
 AND C.CONT_NO = B.CONT_NO
 AND C.CONT_DT = '20170505'
 AND D.PROD_NO = C.PROD_NO
;

/*  스칼러 서브쿼리 (T_PRODUCT62를 Scholar Sub-Query로 사용할지에 대한 고민)
8i, 9i는 cache entry 256개
10g 이상 _query_execution_cache_max_size 만큼 (65,536개)
즉 10g 이상일 경우 메인쿼리에서 반환하는 값이 65,536개 미만이고, 중복값이 많을 경우에 주로 효과
*/
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));

/*
--------------------------------------------------------------------------
| Id  | Operation                      | Name           |A-Rows |Buffers |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                |     9 |     47 |
|   1 |  TABLE ACCESS BY INDEX ROWID   | T_PRODUCT62    |     9 |     13 |
|*  2 |   INDEX UNIQUE SCAN            | PK_T_PRODUCT62 |     9 |      4 |
|   3 |  NESTED LOOPS                  |                |     9 |     47 |
|   4 |   NESTED LOOPS                 |                |    27 |     20 |
|   5 |    NESTED LOOPS                |                |     3 |     11 |
|   6 |     TABLE ACCESS BY INDEX ROWID| T_CUST62       |     1 |      3 |
|*  7 |      INDEX UNIQUE SCAN         | PK_T_CUST62    |     1 |      2 |
|   8 |     TABLE ACCESS BY INDEX ROWID| T_CONT62       |     3 |      8 |
|*  9 |      INDEX RANGE SCAN          | IX_T_CONT62_02 |     3 |      5 |
|* 10 |    INDEX RANGE SCAN            | PK_T_ADD_SVC62 |    27 |      9 |
|* 11 |   TABLE ACCESS BY INDEX ROWID  | T_ADD_SVC62    |     9 |     27 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("PROD_NO"=:B1)
   7 - access("A"."CUST_NO"='C000427')
   9 - access("B"."CUST_NO"='C000427')
  10 - access("C"."CONT_NO"="B"."CONT_NO")
  11 - filter("C"."CONT_DT"='20170505')
 
*/