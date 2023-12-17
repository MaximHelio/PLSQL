/*
테이블 정보 
고객_56(10,000건, 실제 테스트 데이터는 100건만 만들었으나, 1만건으로 간주하고...)
   고객번호     VARCHAR2(6)   <== PK
   고객명      VARCHAR2(50)
   연락처      VARCHAR2(20)
   기타 칼럼...

상품_56(100건)
   상품번호    VARCHAR2(4)  <== PK
   상품명      VARCHAR2(20)
   
주문_56(500만건)
   주문번호    VARCHAR2(8)   <== PK
   고객번호    VARCHAR2(6)
   주문일자    VARCHAR2(8)                                                                    
   주문금액    NUMBER
   기타 칼럼...
   인덱스 (주문일자),  (고객번호+주문일자);

주문상품_56(600만건)
   주문번호      VARCHAR2(8) <== PK1
   일련번호      NUMBER      <== PK2
   상품번호      VARCHAR2(4)
   기타 칼럼...
   
※ 1일주문건수 : 100건

아래 SQL을 튜닝하세요. ^^
인덱스 변경 불가능
*/
SELECT /*+ NO_QUERY_TRANSFORMATION LEADING(B) USE_NL(A) */
       A.고객번호,
       MIN(A.고객명)   고객명,
       MIN(A.연락처)   연락처,
       COUNT(*)        주문건수,
       SUM(B.주문금액) 주문금액
FROM 고객_56 A,  주문_56 B
WHERE 주문일자 BETWEEN TO_CHAR(SYSDATE -8, 'YYYYMMDD') 
                  AND  TO_CHAR(SYSDATE -1, 'YYYYMMDD')
 AND A.고객번호 = B.고객번호
 AND EXISTS (SELECT 1 FROM 주문_56 X, 주문상품_56 Y
             WHERE X.고객번호 = A.고객번호
              AND  X.주문일자 = TO_CHAR(SYSDATE, 'YYYYMMDD')
              AND  Y.주문번호 = X.주문번호
              AND  Y.상품번호 LIKE 'A%'
             )
GROUP BY A.고객번호
;

/* 
----------------------------------------------------------------------------------
| Id  | Operation                        | Name       |A-Rows | Buffers | Reads  |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                 |            |    15 |    1711 |     97 |
|   1 |  HASH GROUP BY                   |            |    15 |    1711 |     97 |
|*  2 |   FILTER                         |            |   120 |    1711 |     97 |
|*  3 |    FILTER                        |            |   800 |     814 |      0 |
|   4 |     NESTED LOOPS                 |            |   800 |     814 |      0 |
|   5 |      NESTED LOOPS                |            |   800 |      14 |      0 |
|   6 |       TABLE ACCESS BY INDEX ROWID| 주문_56    |   800 |      10 |      0 |
|*  7 |        INDEX RANGE SCAN          | 주문_56_X01|   800 |       5 |      0 |
|*  8 |       INDEX UNIQUE SCAN          | 고객_56_PK |   800 |       4 |      0 |
|   9 |      TABLE ACCESS BY INDEX ROWID | 고객_56    |   800 |     800 |      0 |
|  10 |    NESTED LOOPS                  |            |    15 |     897 |     97 |
|  11 |     NESTED LOOPS                 |            |   145 |     752 |     97 |
|  12 |      TABLE ACCESS BY INDEX ROWID | 주문_56    |   128 |     603 |     97 |
|* 13 |       INDEX RANGE SCAN           | 주문_56_X02|   128 |     475 |     97 |
|* 14 |      INDEX RANGE SCAN            | 주문상품_56|   145 |     149 |      0 |
|* 15 |     TABLE ACCESS BY INDEX ROWID  | 주문상품_56|    15 |     145 |      0 |
----------------------------------------------------------------------------------

 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   6 - access("A"."고객번호"="B"."고객번호")
       filter("A"."고객번호"="B"."고객번호")
   8 - access("주문일자">=TO_CHAR(SYSDATE@!-8,'YYYYMMDD') AND "주문일자"<=TO_CHAR(SYSDATE@!-1,'YYYYMMDD'))
   9 - access("ITEM_1"="A"."고객번호")
       filter("ITEM_1"="A"."고객번호")
  11 - filter(TO_CHAR(SYSDATE@!-8,'YYYYMMDD')<=TO_CHAR(SYSDATE@!-1,'YYYYMMDD'))
  15 - access("X"."주문일자"=TO_CHAR(SYSDATE@!,'YYYYMMDD'))
  16 - access("Y"."주문번호"="X"."주문번호")
  17 - filter("Y"."상품번호" LIKE 'A%')
*/