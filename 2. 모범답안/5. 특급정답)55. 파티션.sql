/*
1. 문제 핵심
   - CON_DT는 SYSDATE 까지 조회
   - Filter 조건으로  CON_DT || CON_TM 조건 추가 
   - 인덱스 : 파티션은 프러닝이 일어나기에  LOCAL 인덱스가 유리

:CONSULTANT_ID  <== T295
*/

DROP INDEX YOON.IX_T_CONSULT55_01 ;
CREATE INDEX YOON.IX_T_CONSULT55_01 ON YOON.T_CONSULT55(CONSULTANT_ID, CON_DT, CON_TM) LOCAL;

-- 1번
SELECT /*+ INDEX (A IX_T_CONSULT55_01) */
       :CONSULTANT_ID CONSULTANT_ID
    ,  COUNT(*)                                                                   상담건수    
    ,  NVL(SUM(CASE WHEN RSLT_CD = '0900' THEN 1 END), 0)                         상담완료건수 
    ,  NVL(SUM(CASE WHEN RSLT_CD = '0900' AND AFTRSLT_CD = '21' THEN 1 END), 0)   부서이관건수
    ,  COUNT(DISTINCT CUST_ID)                                                   상담고객수
FROM T_CONSULT55 A
WHERE CONSULTANT_ID = :CONSULTANT_ID
 AND  CON_DT BETWEEN TO_CHAR(SYSDATE, 'YYYYMM') || '01' AND TO_CHAR(SYSDATE, 'YYYYMMDD')
 AND  CON_DT || CON_TM <= TO_CHAR(SYSDATE, 'YYYYMMDD') || '1200' 
; 
--2번
/*
  - 인덱스 : CONSULTANT_ID, CON_DT, CON_TM
  - 파티션 : CON_DT
  - 인덱스(LOCAL? GLOBAL?)   LOCAL 인덱스

-----------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                              | Name              | Starts | Pstart| Pstop | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                   |      1 |       |       |      1 |00:00:00.01 |     734 |
|   1 |  SORT AGGREGATE                        |                   |      1 |       |       |      1 |00:00:00.01 |     734 |
|   2 |   VIEW                                 | VW_DAG_0          |      1 |       |       |    736 |00:00:00.01 |     734 |
|   3 |    HASH GROUP BY                       |                   |      1 |       |       |    736 |00:00:00.01 |     734 |
|*  4 |     FILTER                             |                   |      1 |       |       |    736 |00:00:00.01 |     734 |
|   5 |      PARTITION RANGE ITERATOR          |                   |      1 |   KEY |   KEY |    736 |00:00:00.01 |     734 |
|   6 |       TABLE ACCESS BY LOCAL INDEX ROWID| T_CONSULT55       |      1 |   KEY |   KEY |    736 |00:00:00.01 |     734 |
|*  7 |        INDEX RANGE SCAN                | IX_T_CONSULT55_01 |      1 |   KEY |   KEY |    736 |00:00:00.01 |       7 |
-----------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
   4 - filter(TO_CHAR(SYSDATE@!,'YYYYMM')||'01'<=TO_CHAR(SYSDATE@!,'YYYYMMDD'))
   7 - access("CONSULTANT_ID"=:CONSULTANT_ID AND "CON_DT">=TO_CHAR(SYSDATE@!,'YYYYMM')||'01' AND 
              "CON_DT"<=TO_CHAR(SYSDATE@!,'YYYYMMDD'))
       filter("CON_DT"||"CON_TM"<=TO_CHAR(SYSDATE@!,'YYYYMMDD')||'1200')
  */