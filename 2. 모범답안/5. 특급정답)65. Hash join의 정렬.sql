ALTER SESSION SET STATISTICS_LEVEL=ALL;

select /*+ ordered use_hash(b) index(a ix_t111) INDEX(B IX_T222) ALL_ROWS */ 
        A.OWNER, A.OBJECT_NAME, A.OBJECT_ID, 
        B.DATA_OBJECT_ID
from scott.t111 a, scott.t222 b 
where a.owner       = b.owner
 and  a.object_name = b.object_name
 and  a.object_id >= 85000
 and  b.data_object_id >= 914421;
 
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));

/*
PLAN_TABLE_OUTPUT
-----------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Starts | E-Rows | A-Rows |   A-Time   | Buffers |  OMem |  1Mem | Used-Mem |
-----------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |      1 |        |    288 |00:00:00.03 |     390 |       |       |          |
|*  1 |  HASH JOIN                   |         |      1 |    626 |    288 |00:00:00.03 |     390 |   748K|   748K| 1189K (0)|
|   2 |   TABLE ACCESS BY INDEX ROWID| T111    |      1 |    626 |    152 |00:00:00.01 |      13 |       |       |          |
|*  3 |    INDEX RANGE SCAN          | IX_T111 |      1 |    626 |    152 |00:00:00.01 |       2 |       |       |          |
|   4 |   TABLE ACCESS BY INDEX ROWID| T222    |      1 |   8220 |   8220 |00:00:00.01 |     377 |       |       |          |
|*  5 |    INDEX RANGE SCAN          | IX_T222 |      1 |   8220 |   8220 |00:00:00.01 |      23 |       |       |          |
-----------------------------------------------------------------------------------------------------------------------------
*/

