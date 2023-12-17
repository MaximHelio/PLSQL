CREATE INDEX YOON.IX_T_EMP23_02 ON YOON.T_EMP23(DIV_CODE, DEPT_CODE);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_EMP23');

SELECT /*+ INDEX(A IX_T_EMP23_02) */
        EMP_NO, EMP_NAME, DEPT_CODE, DIV_CODE
FROM T_EMP23 A
WHERE DEPT_CODE BETWEEN '09'  AND '11'
 AND  DIV_CODE = '028';


/*
----------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Starts | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |      1 |    326 |00:00:00.01 |     334 |
|   1 |  TABLE ACCESS BY INDEX ROWID| T_EMP23       |      1 |    326 |00:00:00.01 |     334 |
|*  2 |   INDEX RANGE SCAN          | IX_T_EMP23_02 |      1 |    326 |00:00:00.01 |       8 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("DIV_CODE"='028' AND "DEPT_CODE">='09' AND "DEPT_CODE"<='11')
*/


/* 2)아래의 SQL은 우리회사에서 가장 많이 수행되는
     TOP 1 SQL 이다.  튜닝하세요.
  - SQL 변경 또는 인덱스 변경 가능 */
CREATE INDEX YOON.IX_T_EMP23_03 ON YOON.T_EMP23(DIV_CODE, DEPT_CODE, EMP_NAME);

SELECT /*+ INDEX(A IX_T_EMP23_03) */
       EMP_NAME, DEPT_CODE, DIV_CODE
FROM T_EMP23 A
WHERE DEPT_CODE BETWEEN '09'  AND '11'
 AND  DIV_CODE = '028';
/*
--------------------------------------------------------------------------------------------
| Id  | Operation        | Name          | Starts | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT |               |      1 |    326 |00:00:00.10 |      12 |      7 |
|*  1 |  INDEX RANGE SCAN| IX_T_EMP23_03 |      1 |    326 |00:00:00.10 |      12 |      7 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("DIV_CODE"='028' AND "DEPT_CODE">='09' AND "DEPT_CODE"<='11')
 */
 
 SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST -ROWS'));