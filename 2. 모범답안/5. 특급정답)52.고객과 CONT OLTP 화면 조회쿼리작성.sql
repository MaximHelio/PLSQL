DROP INDEX YOON.IX_T_CUST52_01;
CREATE INDEX YOON.IX_T_CUST52_01 ON YOON.T_CUST52(CUST_NM);

DROP INDEX YOON.IX_T_CONT52_01;
CREATE INDEX YOON.IX_T_CONT52_01 ON YOON.T_CONT52(CUST_NO, CONT_DT);

DROP INDEX YOON.IX_T_CONT52_02;
CREATE INDEX YOON.IX_T_CONT52_02 ON YOON.T_CONT52(CONT_DT);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CONT52');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CUST52');

ALTER SESSION SET STATISTICS_LEVEL = ALL;
/* T_CUST52(CUST_NM)
   T_CONT52(CUST_NO + CONT_DT),  (CONT_DT)  */
   
SELECT /*+ ORDERED USE_NL(B) INDEX(A IX_T_CUST52_01) INDEX(B IX_T_CONT52_01)*/
      A.CUST_NO, A.CUST_NM, SUBSTR(A.JUMIN_NO, 1, 6) JUMIN_NO
     , TO_CHAR(B.CONT_DT, 'YYYY-MM-DD') CONT_DT
     , TO_CHAR(B.TERMI_DT, 'YYYY-MM-DD') TERMI_DT, B.TERMI_AMT
FROM T_CUST52 A, T_CONT52 B
WHERE :CUST_NM IS NOT NULL
 AND  CUST_NM = :CUST_NM
 AND  JUMIN_NO LIKE :JUMIN_NO ||'%'
 AND  B.CUST_NO = A.CUST_NO
 AND  B.CONT_DT BETWEEN to_date(:START_DT, 'YYYY.MM.DD') 
                AND TO_DATE(:END_DT ||' 235959', 'YYYY.MM.DD HH24MISS') 
 
UNION ALL
SELECT /*+ ORDERED USE_NL(A) INDEX(B IX_T_CONT52_02) */
       A.CUST_NO, A.CUST_NM,  SUBSTR(A.JUMIN_NO, 1, 6) JUMIN_NO
     , TO_CHAR(B.CONT_DT, 'YYYY-MM-DD') CONT_DT
     , TO_CHAR(B.TERMI_DT, 'YYYY-MM-DD') TERMI_DT, B.TERMI_AMT
FROM T_CONT52 B, T_CUST52 A
WHERE :CUST_NM IS NULL
 AND  B.CONT_DT BETWEEN to_date(:START_DT, 'YYYY.MM.DD') 
                    AND TO_DATE(:END_DT ||' 235959', 'YYYY.MM.DD HH24MISS') 
 AND  A.CUST_NO = B.CUST_NO
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));
/*
이름을 넣지 않았을 때
:cust_nm : NULL
:jumin_no: NULL
:start_dt: '2016.04.18'
:end_dt  : '2016.04.19'

PLAN_TABLE_OUTPUT
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |                |      1 |        |   3000 |00:00:00.88 |   12014 |   2779 |
|   1 |  UNION-ALL                      |                |      1 |        |   3000 |00:00:00.88 |   12014 |   2779 |
|*  2 |   FILTER                        |                |      1 |        |      0 |00:00:00.01 |       0 |      0 |
|   3 |    NESTED LOOPS                 |                |      0 |        |      0 |00:00:00.01 |       0 |      0 |
|   4 |     NESTED LOOPS                |                |      0 |      2 |      0 |00:00:00.01 |       0 |      0 |
|*  5 |      TABLE ACCESS BY INDEX ROWID| T_CUST52       |      0 |      2 |      0 |00:00:00.01 |       0 |      0 |
|*  6 |       INDEX RANGE SCAN          | IX_T_CUST52_01 |      0 |      2 |      0 |00:00:00.01 |       0 |      0 |
|*  7 |      INDEX RANGE SCAN           | IX_T_CONT52_01 |      0 |      1 |      0 |00:00:00.01 |       0 |      0 |
|   8 |     TABLE ACCESS BY INDEX ROWID | T_CONT52       |      0 |      1 |      0 |00:00:00.01 |       0 |      0 |
|*  9 |   FILTER                        |                |      1 |        |   3000 |00:00:00.87 |   12014 |   2779 |
|  10 |    NESTED LOOPS                 |                |      1 |        |   3000 |00:00:00.87 |   12014 |   2779 |
|  11 |     NESTED LOOPS                |                |      1 |   1000 |   3000 |00:00:00.34 |    9014 |   1047 |
|  12 |      TABLE ACCESS BY INDEX ROWID| T_CONT52       |      1 |   1000 |   3000 |00:00:00.30 |    3012 |   1014 |
|* 13 |       INDEX RANGE SCAN          | IX_T_CONT52_02 |      1 |   1000 |   3000 |00:00:00.01 |      12 |      1 |
|* 14 |      INDEX UNIQUE SCAN          | PK_T_CUST      |   3000 |      1 |   3000 |00:00:00.03 |    6002 |     33 |
|  15 |     TABLE ACCESS BY INDEX ROWID | T_CUST52       |   3000 |      1 |   3000 |00:00:00.53 |    3000 |   1732 |
---------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter((:CUST_NM IS NOT NULL AND TO_DATE(:START_DT,'YYYYMMDD')<=TO_DATE(:END_DT,'YYYYMMDD')+1))
   5 - filter("JUMIN_NO" LIKE :JUMIN_NO||'%')
   6 - access("CUST_NM"=:CUST_NM)
   7 - access("B"."CUST_NO"="A"."CUST_NO" AND "B"."CONT_DT">=TO_DATE(:START_DT,'YYYYMMDD') AND 
              "B"."CONT_DT"<=TO_DATE(:END_DT,'YYYYMMDD')+1)
   9 - filter((TO_DATE(:START_DT,'YYYYMMDD')<=TO_DATE(:END_DT,'YYYYMMDD')+1 AND :CUST_NM IS NULL))
  13 - access("B"."CONT_DT">=TO_DATE(:START_DT,'YYYYMMDD') AND "B"."CONT_DT"<=TO_DATE(:END_DT,'YYYYMMDD')+1)
  14 - access("A"."CUST_NO"="B"."CUST_NO")
 


---------------------------------------- 이름을 넣었을 때
BIND 변수
:cust_nm : '0000855215'
:jumin_no: '0000000432128'
:start_dt: '20160418'
:end_dt  : '20160424'

PLAN_TABLE_OUTPUT
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |                |      1 |        |      1 |00:00:00.01 |      11 |      2 |
|   1 |  UNION-ALL                      |                |      1 |        |      1 |00:00:00.01 |      11 |      2 |
|*  2 |   FILTER                        |                |      1 |        |      1 |00:00:00.01 |      11 |      2 |
|   3 |    NESTED LOOPS                 |                |      1 |        |      1 |00:00:00.01 |      11 |      2 |
|   4 |     NESTED LOOPS                |                |      1 |      1 |      1 |00:00:00.01 |      10 |      2 |
|*  5 |      TABLE ACCESS BY INDEX ROWID| T_CUST52       |      1 |      1 |      1 |00:00:00.01 |       6 |      2 |
|*  6 |       INDEX RANGE SCAN          | IX_T_CUST52_01 |      1 |      2 |      2 |00:00:00.01 |       4 |      1 |
|*  7 |      INDEX RANGE SCAN           | IX_T_CONT52_01 |      1 |      1 |      1 |00:00:00.01 |       4 |      0 |
|   8 |     TABLE ACCESS BY INDEX ROWID | T_CONT52       |      1 |      1 |      1 |00:00:00.01 |       1 |      0 |
|*  9 |   FILTER                        |                |      1 |        |      0 |00:00:00.01 |       0 |      0 |
|  10 |    NESTED LOOPS                 |                |      0 |        |      0 |00:00:00.01 |       0 |      0 |
|  11 |     NESTED LOOPS                |                |      0 |   9007 |      0 |00:00:00.01 |       0 |      0 |
|  12 |      TABLE ACCESS BY INDEX ROWID| T_CONT52       |      0 |   9007 |      0 |00:00:00.01 |       0 |      0 |
|* 13 |       INDEX RANGE SCAN          | IX_T_CONT52_02 |      0 |   9007 |      0 |00:00:00.01 |       0 |      0 |
|* 14 |      INDEX UNIQUE SCAN          | PK_T_CUST      |      0 |      1 |      0 |00:00:00.01 |       0 |      0 |
|  15 |     TABLE ACCESS BY INDEX ROWID | T_CUST52       |      0 |      1 |      0 |00:00:00.01 |       0 |      0 |
---------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter((:CUST_NM IS NOT NULL AND TO_DATE(:START_DT,'YYYYMMDD')<=TO_DATE(:END_DT,'YYYYMMDD')+1))
   5 - filter("JUMIN_NO" LIKE :JUMIN_NO||'%')
   6 - access("CUST_NM"=:CUST_NM)
   7 - access("B"."CUST_NO"="A"."CUST_NO" AND "B"."CONT_DT">=TO_DATE(:START_DT,'YYYYMMDD') AND 
              "B"."CONT_DT"<=TO_DATE(:END_DT,'YYYYMMDD')+1)
   9 - filter((TO_DATE(:START_DT,'YYYYMMDD')<=TO_DATE(:END_DT,'YYYYMMDD')+1 AND :CUST_NM IS NULL))
  13 - access("B"."CONT_DT">=TO_DATE(:START_DT,'YYYYMMDD') AND "B"."CONT_DT"<=TO_DATE(:END_DT,'YYYYMMDD')+1)
  14 - access("A"."CUST_NO"="B"."CUST_NO")
 
*/
