DROP   INDEX YOON.IX_T_CUST54_01;
CREATE INDEX YOON.IX_T_CUST54_01 ON YOON.T_CUST54(CUST_TYPE, CUST_NO);

DROP   INDEX YOON.IX_T_ORDER54_01;
CREATE INDEX YOON.IX_T_ORDER54_01 ON YOON.T_ORDER54(CUST_NO, ORDER_TYPE, ORDER_DT);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CUST54');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_ORDER54');

ALTER SESSION SET STATISTICS_LEVEL=ALL;

/*==========================================================================================

      - 조인은  T_CUST54 에 대한 랜덤 액세스를 인덱스를 읽어 바로 시도
        PUSH_SUBQ 방식은 T_CUST54 인덱스와 T_ORDER54 인덱스를 필터링 후
        테이블 랜덤 액세스를 하기 때문에 랜덤 액세스 량을 줄일 수 있음
        하지만 push_subq 방식은 filtering 대상 인덱스의 root block을 buffer pining을 하지 않음
        
      - 조인은 T_ORDER54 테이블을 필터링 하기 전 
        T_CUST54 테이블에 랜덤액세스를 먼저 하기 때문에 테이블 랜덤액세스 량이 많이 발생
        대신 T_ORDER54의 인덱스 ROOT 블록을 BUFFER PINING 하기에 유리
      
      - 결론 : 두 방식의 차이는 크지 않으나, 이후 버전에서 PUSH_SUBQ
               서브쿼리의 인덱스를 BUFFER PINING 할 경우 PUSH_SUBQ가 훨씬 유리
               동, 문제 출제 시 PUSH_SUBQ로 작성할 것을 권장
==========================================================================================*/

SELECT /*+ LEADING (C) USE_NL(H)*/ C.CUST_NO, C.CUST_NM, H.HOBBY_TYPE, H.C11
FROM T_CUST54 C,  T_HOBBY54 H
WHERE C.CUST_TYPE    = 'C050'
  AND H.CUST_NO = C.CUST_NO
  AND EXISTS (SELECT /*+ NO_UNNEST PUSH_SUBQ*/ 1
              FROM T_ORDER54 O
              WHERE CUST_NO    = C.CUST_NO
               AND  ORDER_TYPE = '001'
               AND  ORDER_DT IS NULL);
/*
-----------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name            | Starts | A-Rows |   A-Time   | Buffers | Reads  |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                 |      1 |     15 |00:00:00.07 |    1540 |    330 |
|   1 |  NESTED LOOPS                 |                 |      1 |     15 |00:00:00.07 |    1540 |    330 |
|   2 |   NESTED LOOPS                |                 |      1 |     15 |00:00:00.06 |    1525 |    315 |
|   3 |    TABLE ACCESS BY INDEX ROWID| T_CUST54        |      1 |      5 |00:00:00.06 |    1512 |    315 |
|*  4 |     INDEX RANGE SCAN          | IX_T_CUST54_01  |      1 |      5 |00:00:00.06 |    1507 |    315 |
|*  5 |      INDEX RANGE SCAN         | IX_T_ORDER54_01 |    500 |      5 |00:00:00.06 |    1503 |    315 |
|*  6 |    INDEX RANGE SCAN           | PK_HOBBY54      |      5 |     15 |00:00:00.01 |      13 |      0 |
|   7 |   TABLE ACCESS BY INDEX ROWID | T_HOBBY54       |     15 |     15 |00:00:00.01 |      15 |     15 |
-----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("C"."CUST_TYPE"='C050')
       filter( IS NOT NULL)
   5 - access("CUST_NO"=:B1 AND "ORDER_TYPE"='001' AND "ORDER_DT" IS NULL)
   6 - access("H"."CUST_NO"="C"."CUST_NO")
  */

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST -ROWS'));
/*==========================================================================================
                조인 순서 조정
==========================================================================================*/
SELECT /*+ LEADING (C O@T_ORDER54 H) NL_SJ(O@T_ORDER54) USE_NL(H)*/ C.CUST_NO, C.CUST_NM, H.HOBBY_TYPE, H.C11
FROM T_CUST54 C,  T_HOBBY54 H
WHERE C.CUST_TYPE    = 'C050'
  AND H.CUST_NO = C.CUST_NO
  AND EXISTS (SELECT /*+ QB_NAME(T_ORDER54) UNNEST */ 1
              FROM T_ORDER54 O
              WHERE CUST_NO    = C.CUST_NO
               AND  ORDER_TYPE = '001'
               AND  ORDER_DT IS NULL
              );

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST -ROWS'));

/*
---------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name            | Starts | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                 |      1 |     15 |00:00:00.01 |    1538 |
|   1 |  NESTED LOOPS                  |                 |      1 |     15 |00:00:00.01 |    1538 |
|   2 |   NESTED LOOPS                 |                 |      1 |     15 |00:00:00.01 |    1523 |
|   3 |    NESTED LOOPS SEMI           |                 |      1 |      5 |00:00:00.01 |    1510 |
|   4 |     TABLE ACCESS BY INDEX ROWID| T_CUST54        |      1 |    500 |00:00:00.01 |     504 |
|*  5 |      INDEX RANGE SCAN          | IX_T_CUST54_01  |      1 |    500 |00:00:00.01 |       4 |
|*  6 |     INDEX RANGE SCAN           | IX_T_ORDER54_01 |    500 |      5 |00:00:00.01 |    1006 |
|*  7 |    INDEX RANGE SCAN            | PK_HOBBY54      |      5 |     15 |00:00:00.01 |      13 |
|   8 |   TABLE ACCESS BY INDEX ROWID  | T_HOBBY54       |     15 |     15 |00:00:00.01 |      15 |
---------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("C"."CUST_TYPE"='C050')
   6 - access("CUST_NO"="C"."CUST_NO" AND "ORDER_TYPE"='001' AND "ORDER_DT" IS NULL)
   7 - access("H"."CUST_NO"="C"."CUST_NO")
  */
