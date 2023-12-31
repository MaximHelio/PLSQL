-- 튜닝 전
SELECT A.고객번호,
       MIN(A.고객명)   고객명,
       MIN(A.연락처)   연락처,
       COUNT(*)        주문건수,
       SUM(B.주문금액) 주문금액
FROM 고객_56 A,  주문_56 B
WHERE 주문일자 BETWEEN TO_CHAR(SYSDATE -8, 'YYYYMMDD') 
                  AND  TO_CHAR(SYSDATE -1, 'YYYYMMDD')
 AND A.고객번호 = B.고객번호
 AND EXISTS (SELECT 1 
             FROM 주문_56 X, 주문상품_56 Y
             WHERE X.고객번호 = A.고객번호
              AND  X.주문일자 = TO_CHAR(SYSDATE, 'YYYYMMDD')
              AND  Y.주문번호 = X.주문번호
              AND  Y.상품번호 LIKE 'A%'
             )
GROUP BY A.고객번호
;

-- 튜닝 후
SELECT /*+ LEADING(A C B) USE_NL(C) USE_NL(B) INDEX(B 주문_X02) INDEX(C 고객_PK) */
       B.고객번호,
       MIN(C.고객명)   고객명,
       MIN(C.연락처)   연락처,
       COUNT(*)        주문건수,
       SUM(B.주문금액) 주문금액
FROM (SELECT /*+ NO_MERGE */ DISTINCT 고객번호
      FROM 주문_56 X
      WHERE 주문일자 = TO_CHAR(SYSDATE, 'YYYYMMDD')
       AND  EXISTS (SELECT 1 FROM 주문상품_56 
                    WHERE 주문번호 = X.주문번호 
                     AND  상품번호 LIKE 'A%'
                   )
      ) A, 주문_56 B, 고객_56 C
WHERE B.고객번호 = A.고객번호
 AND  B.주문일자 BETWEEN TO_CHAR(SYSDATE -8, 'YYYYMMDD') 
                  AND  TO_CHAR(SYSDATE -1, 'YYYYMMDD')
 AND  C.고객번호 = A.고객번호
GROUP BY B.고객번호
ORDER BY B.고객번호

/*
--------------------------------------------------------------------------------------
| Id  | Operation                           | Name       | A-Rows | Buffers | Reads  |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |            |     15 |     189 |     21 |
|   1 |  SORT GROUP BY                      |            |     15 |     189 |     21 |
|   2 |   NESTED LOOPS                      |            |    120 |     189 |     21 |
|   3 |    NESTED LOOPS                     |            |    120 |     129 |     21 |
|   4 |     NESTED LOOPS                    |            |     15 |      83 |      0 |
|   5 |      VIEW                           |            |     15 |      64 |      0 |
|   6 |       HASH UNIQUE                   |            |     15 |      64 |      0 |
|*  7 |        FILTER                       |            |     15 |      64 |      0 |
|   8 |         NESTED LOOPS SEMI           |            |     15 |      64 |      0 |
|   9 |          TABLE ACCESS BY INDEX ROWID| 주문_56    |    100 |       6 |      0 |
|* 10 |           INDEX RANGE SCAN          | 주문_56_X01|    100 |       4 |      0 |
|* 11 |          TABLE ACCESS BY INDEX ROWID| 주문상품_56|     15 |      58 |      0 |
|* 12 |           INDEX RANGE SCAN          | 주문상품_56|    117 |      24 |      0 |
|  13 |      TABLE ACCESS BY INDEX ROWID    | 고객_56    |     15 |      19 |      0 |
|* 14 |       INDEX UNIQUE SCAN             | 고객_56_PK |     15 |       4 |      0 |
|* 15 |     INDEX RANGE SCAN                | 주문_56_X02|    120 |      46 |     21 |
|  16 |    TABLE ACCESS BY INDEX ROWID      | 주문_56    |    120 |      60 |      0 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   7 - filter(TO_CHAR(SYSDATE@!-8,'YYYYMMDD')<=TO_CHAR(SYSDATE@!-1,'YYYYMMDD'))
  10 - access("주문일자"=TO_CHAR(SYSDATE@!,'YYYYMMDD'))
  11 - filter("상품번호" LIKE 'A%')
  12 - access("주문번호"="X"."주문번호")
  14 - access("C"."고객번호"="A"."고객번호")
  15 - access("B"."고객번호"="A"."고객번호" AND "B"."주문일자">=TO_CHAR(SYSDATE@!-8,'YYYYMMDD') AND 
              "B"."주문일자"<=TO_CHAR(SYSDATE@!-1,'YYYYMMDD'))

*/