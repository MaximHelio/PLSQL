/*
1. 인덱스 설정 및 SORT
  - 인덱스를 통해 읽는 BLOCK 개수 감소
  - SORT 대체 효과 (인덱스에 REG_DTM 칼럼 추가 필요)
  - 메인 쿼리의 ORDER BY절은 RNUM 활용 시 불필요한 소트 수행
    반드시 안쪽 블록의 ORDER BY 절과 동일해야 함.
2. STOP KEY를 발생 시켜야 한다. => SORT 튜닝의 원리
  - stop key 발생은 꼭 "rownum" 칼럼 활용,  
    아래의 예제에서 사용자가 만든 칼럼 rnum 사용하면 안됨.
3. PL/SQL을 일반 스칼라서브쿼리로 변경
  - PL/SQL과 SQL은 실행엔진이 달라 SQL 실행을 잠시 중단 후 
    PL/SQL 엔진 영역에서 수행 후 다시 SQL 영역으로 변경
    => 이를 CONTEXT SWITCH라 한다.
    동 상황이 수행속도 저하를 초래하여, SQL문에 사용자정의 함수
    호출은 특별한 경우를 제외하고는 사용을 자제해야 한다.
4. 스칼라 서브쿼리
   - 인라인뷰 안쪽이 아닌 최종 결과 출력 영역으로 수정
   - 또한 인라인뷰는 캐싱을 하는데, 동일 사용자가 거의 없을 경우는
     JOIN으로 처리하는 것이 유리하며, 이때 OUTER JOIN 필수
*/

DROP INDEX YOON.IX_T_BBM60_01 ;
CREATE INDEX YOON.IX_T_BBM60_01 ON YOON.T_BBM60(BBM_TYP, DEL_YN, REG_DTM);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_BBM60');
ALTER SESSION SET STATISTICS_LEVEL=ALL;

SELECT /*+ ORDERED USE_NL(X) */
       Y.BBM_NO, Y.BBM_TITL, Y.BBM_CONT, 
       X.USRNM  REG_NM,
       REG_DTM, RNUM
FROM  (SELECT K.*, ROWNUM RNUM
       FROM (SELECT /*+ INDEX_DESC(A IX_T_BBM60_01) */
                    BBM_NO, BBM_TITL, BBM_CONT, REG_DTM, REG_NO
             FROM T_BBM60 A 
             WHERE BBM_TYP = 'NOR'
               AND DEL_YN  = 'N'
             ORDER BY REG_DTM DESC) K
       WHERE ROWNUM <= 20) Y,
       T_USR60 X 
WHERE Y.RNUM >= 11
 AND  X.USRNO(+) = Y.REG_NO
ORDER BY REG_DTM DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));
/* 
-------------------------------------------------------------------------------------------------------------
| Id  | Operation                         | Name          | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                  |               |      1 |        |     10 |00:00:00.01 |      46 |
|   1 |  NESTED LOOPS OUTER               |               |      1 |     20 |     10 |00:00:00.01 |      46 |
|*  2 |   VIEW                            |               |      1 |     20 |     10 |00:00:00.01 |      24 |
|*  3 |    COUNT STOPKEY                  |               |      1 |        |     20 |00:00:00.01 |      24 |
|   4 |     VIEW                          |               |      1 |     20 |     20 |00:00:00.01 |      24 |
|   5 |      COUNT                        |               |      1 |        |     20 |00:00:00.01 |      24 |
|   6 |       TABLE ACCESS BY INDEX ROWID | T_BBM60       |      1 |     20 |     20 |00:00:00.01 |      24 |
|*  7 |        INDEX RANGE SCAN DESCENDING| IX_T_BBM60_01 |      1 |     20 |     20 |00:00:00.01 |       4 |
|   8 |   TABLE ACCESS BY INDEX ROWID     | T_USR60       |     10 |      1 |     10 |00:00:00.01 |      22 |
|*  9 |    INDEX UNIQUE SCAN              | PK_T_USR60    |     10 |      1 |     10 |00:00:00.01 |      12 |
-------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter("Y"."RNUM">=11)
   3 - filter(ROWNUM<=20)
   7 - access("BBM_TYP"='NOR' AND "DEL_YN"='N')
   9 - access("X"."USRNO"="Y"."REG_NO") 
   
AUTOTRACE 결과
Statistics
----------------------------------------------------------
          1  recursive calls
          0  db block gets
         46  consistent gets
          0  physical reads
          0  redo size
       1136  bytes sent via SQL*Net to client
        420  bytes received via SQL*Net from client
          2  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
         10  rows processed
*/
