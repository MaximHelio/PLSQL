/* IX_T1 : ACNO+TRD (LOCAL)
PK_T1 : TRD+COL1+ACNO (LOCAL)
IX_T2 : ACNO+TRD(LOCAL) 

채점기준
1. row_number()를 활용했느냐?  (5점) 
   row_number() 활용 시 결과가 다르게 나오기 때문에, rank() 함수를 활용해야 함.
   아마도 문제를 기억에 의존해서 복기 하는 과정에서 문제가 틀려졌던 것 같음.
   이 문제에서는 rank()를 활용해야 함.
2. 한번만 테이블을 읽었느냐?  (5점)
3. Exists  acno 테이블이 들어갔느냐? (5점)
*/

ALTER SESSION SET STATISTICS_LEVEL=ALL;

--TRUNCATE TABLE YOON.T3;
ALTER TABLE YOON.T3 NOLOGGING ;

INSERT /*+ APPEND */ INTO T3
SELECT /*+ LEADING(B@STUDY X) USE_HASH(X) */ *
FROM (SELECT /*+ FULL(A) */  A.*,
            ROW_NUMBER() OVER(PARTITION BY ACNO ORDER BY TRD DESC) R_NUM
      FROM  T1_63 A 
      WHERE TRD >= '20170617'
       AND  TRD <  '20171217'
     )X
WHERE X.R_NUM   = 1
 AND  EXISTS (SELECT /*+ UNNEST QB_NAME(STUDY) INDEX(B IX_T2) */ 1
              FROM T2_63 B
              WHERE ACNO = X.ACNO
               AND  TRD  = '20171217'
              )
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS PARTITION LAST'));

/*
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name     |Pstart| Pstop | A-Rows |Buffers | Reads  |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |          |      |       |    100 |    134K|    136K|
|*  1 |  HASH JOIN                  |          |      |       |    100 |    134K|    136K|
|   2 |   SORT UNIQUE               |          |      |       |    100 |   5004 |   5004 |
|   3 |    PARTITION RANGE SINGLE   |          |   12 |    12 |    999K|   5004 |   5004 |
|*  4 |     INDEX RANGE SCAN        | PK_T2_63 |   12 |    12 |    999K|   5004 |   5004 |
|*  5 |   VIEW                      |          |      |       |   1000 |    129K|    131K|
|*  6 |    WINDOW SORT PUSHED RANK  |          |      |       |    105K|    129K|    131K|
|   7 |     PARTITION RANGE ITERATOR|          |    6 |    12 |   6000K|    129K|    129K|
|*  8 |      TABLE ACCESS FULL      | T1_63    |    6 |    12 |   6000K|    129K|    129K|
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("ACNO"="X"."ACNO")
   4 - access("TRD"='20171217')
   5 - filter("X"."R_NUM"=1)
   6 - filter(ROW_NUMBER() OVER ( PARTITION BY "ACNO" ORDER BY INTERNAL_FUNCTION("TRD") DESC )<=1)
   8 - filter(("TRD">='20170617' AND "TRD"<'20171217'))
 
*/

