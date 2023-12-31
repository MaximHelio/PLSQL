/*
고객_57
   고객번호  VARCHAR2(6)  <== PK
   고객명    VARCHAR2(50)
   연락처    VARCHAR2(20)
   기타 칼럼...
   
상품_57
   상품번호 VARCHAR2(4)  <== PK                                                                    
   상품명   VARCHAR2(20)                                                                   
   기타 칼럼...

주문_57 PK(주문번호),  인덱스(주문일자), 전체 500만건
   주문번호  VARCHAR2(8),   <---- PK
   고객번호  VARCHAR2(6),
   주문일자  VARCHAR2(8),
   주문금액  NUMBER
   
주문상품_57  PK(주문번호 + 일련번호), 전체 (600만건)
    주문번호  VARCHAR2(8),  
    일련번호  NUMBER,
    상품번호  VARCHAR2(4)
    
일벌주문 건수     100건
일별주문 상품     120건   
상품번호 like A%    전체 15%

아래 SQL을 튜닝하세요.
인덱스 변경 가능
*/

SELECT /*+ LEADING(B C A D) USE_NL(C) USE_NL(A) USE_NL(C) */
       A.고객번호, 고객명,
       B.주문번호, 주문일자,
       C.일련번호,
       D.상품번호, 상품명
FROM 고객_57 A, 주문_57 B, 주문상품_57 C, 상품_57 D
WHERE B.주문일자 BETWEEN '20170719' AND '20170729'
 AND  D.상품번호 LIKE 'A%'
 AND  C.상품번호 = D.상품번호
 AND  C.주문번호 = B.주문번호
 AND  B.고객번호 = A.고객번호
;

/*
PLAN_TABLE_OUTPUT
--------------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |            |      1 |        |    187 |00:00:00.01 |     710 |
|*  1 |  HASH JOIN                      |            |      1 |      4 |    187 |00:00:00.01 |     710 |
|   2 |   TABLE ACCESS BY INDEX ROWID   | 상품_57    |      1 |      2 |     15 |00:00:00.01 |       2 |
|*  3 |    INDEX RANGE SCAN             | 상품_57_PK |      1 |      2 |     15 |00:00:00.01 |       1 |
|   4 |   NESTED LOOPS                  |            |      1 |        |    187 |00:00:00.01 |     708 |
|   5 |    NESTED LOOPS                 |            |      1 |    240 |    187 |00:00:00.01 |     521 |
|   6 |     NESTED LOOPS                |            |      1 |    240 |    187 |00:00:00.01 |     516 |
|   7 |      TABLE ACCESS BY INDEX ROWID| 주문_57    |      1 |    239 |   1100 |00:00:00.01 |      16 |
|*  8 |       INDEX RANGE SCAN          | 주문_57_X01|      1 |    239 |   1100 |00:00:00.01 |       8 |
|*  9 |      TABLE ACCESS BY INDEX ROWID| 주문상품_57|   1100 |      1 |    187 |00:00:00.01 |     500 |
|* 10 |       INDEX RANGE SCAN          | 주문상품_57|   1100 |      1 |   1320 |00:00:00.01 |      55 |
|* 11 |     INDEX UNIQUE SCAN           | 고객_57_PK |    187 |      1 |    187 |00:00:00.01 |       5 |
|  12 |    TABLE ACCESS BY INDEX ROWID  | 고객_57    |    187 |      1 |    187 |00:00:00.01 |     187 |
--------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("C"."상품번호"="D"."상품번호")
   3 - access("D"."상품번호" LIKE 'A%')
       filter("D"."상품번호" LIKE 'A%')
   8 - access("B"."주문일자">='20170719' AND "B"."주문일자"<='20170729')
   9 - filter("C"."상품번호" LIKE 'A%')
  10 - access("C"."주문번호"="B"."주문번호")
  11 - access("B"."고객번호"="A"."고객번호")
 

*/