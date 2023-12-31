/*
  테이블  T_EMP23
           EMP_NO      VARCHAR2(5)
           EMP_NAME    VARCHAR2(50)
           DEPT_CODE   VARCHAR2(2)
           DIV_CODE    VARCHAR2(2)
   
 인덱스 정보 YOON.T_EMP23(DEPT_CODE)
 
 DEPT_CODE : 99종류
 DIV_CODE  : 999종류
 전체 데이터 건수 1,000만건
 최종 결과치 : 326

*/

ALTER SESSION SET STATISTICS_LEVEL = ALL;

/* 1)아래의 실행계획을 보고,  튜닝하세요.
  - SQL 변경 또는 인덱스 변경 가능 */

SELECT EMP_NO, EMP_NAME, DEPT_CODE, DIV_CODE
FROM T_EMP23
WHERE DEPT_CODE BETWEEN '09'  AND '11'
 AND  DIV_CODE = '028';

/* 2)아래의 SQL은 우리회사에서 가장 많이 수행되는
     TOP 1 SQL 이다.  아래 SQL 하나만을 위해 최적의 튜닝을 하세요.
  - SQL 변경 또는 인덱스 변경 가능 */

SELECT EMP_NAME, DEPT_CODE, DIV_CODE
FROM T_EMP23
WHERE DEPT_CODE BETWEEN '09'  AND '11'
 AND  DIV_CODE = '028';


SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));

/*
PLAN_TABLE_OUTPUT
---------------------------------------------------------------------------------------
| Id  | Operation         | Name    | Starts | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |         |      1 |    285 |00:00:01.51 |     100K|    100K|
|*  1 |  TABLE ACCESS FULL| T_EMP23 |      1 |    285 |00:00:01.51 |     100K|    100K|
---------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - filter(("DIV_CODE"='028' AND "DEPT_CODE"<='11' AND "DEPT_CODE">='09'))
 */