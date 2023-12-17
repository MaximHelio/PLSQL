/*  테이블 
       - 사원 (약10만건), 부서(100건)

    INDEX 
       - 사원PK : EMP_NO   
       - 부서PK : DEPT_CODE

아래 SQL을 튜닝 하세요. (인덱스 및 SQL 변경 가능)

  문제 1) E.DIV_CODE='01'의 결과 : 10건으로 가정하며, D.LOC='01'의 결과가 30건으로 
          가정하고  튜닝 하세요.
  문제 2) E.DIV_CODE='01'의 결과 : 100건으로 가정하며, D.LOC='01'의 결과가 3건으로
          가정하고 튜닝 하세요.

*/
SELECT  /*+ ORDERED USE_NL(D) */
        E.EMP_NO,  E.EMP_NAME,  E.DIV_CODE,  
        D.DEPT_CODE,  D.DEPT_NAME,  D.LOC
FROM  T_EMP  E,  T_DEPT  D
WHERE E.DIV_CODE    = '01'
 AND  D.DEPT_CODE   = E.DEPT_CODE
 AND  D.LOC         = '01';

/*
--------------------------------------------------------------------
| Id  | Operation                    | Name      |A-Rows | Buffers |
--------------------------------------------------------------------
|   0 | SELECT STATEMENT             |           |     1 |     965 |
|   1 |  NESTED LOOPS                |           |     1 |     965 |
|   2 |   NESTED LOOPS               |           |    10 |     955 |
|*  3 |    TABLE ACCESS FULL         | T_EMP     |    10 |     950 |
|*  4 |    INDEX UNIQUE SCAN         | PK_T_DEPT |    10 |       5 |
|*  5 |   TABLE ACCESS BY INDEX ROWID| T_DEPT    |     1 |      10 |
--------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - filter("E"."DIV_CODE"='01')
   4 - access("D"."DEPT_CODE"="E"."DEPT_CODE")
   5 - filter("D"."LOC"='01')
*/