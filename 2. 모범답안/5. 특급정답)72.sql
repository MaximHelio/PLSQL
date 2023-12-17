ALTER SESSION SET STATISTICS_LEVEL=ALL;
--------- 변경 전
SELECT X.카드번호
FROM   (SELECT   C.카드번호, ROWNUM RNUM
        FROM     주문_72     A
               , 주문이력_72 B
               , 결제이력_72 C
        WHERE    A.회원번호     = 'C13991'
         AND     A.주문상태코드 = '12'
         AND     B.주문번호     = A.주문번호
         AND     C.주문이력번호 = B.주문이력번호
        ORDER BY C.결제일자 DESC
       ) X 
WHERE  RNUM = 1;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));

/*
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------
| Id  | Operation                         | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                  |              |      1 |        |      1 |00:00:00.01 |      87 |
|*  1 |  VIEW                             |              |      1 |      8 |      1 |00:00:00.01 |      87 |
|   2 |   SORT ORDER BY                   |              |      1 |      8 |     20 |00:00:00.01 |      87 |
|   3 |    COUNT                          |              |      1 |        |     20 |00:00:00.01 |      87 |
|   4 |     NESTED LOOPS                  |              |      1 |        |     20 |00:00:00.01 |      87 |
|   5 |      NESTED LOOPS                 |              |      1 |      8 |     20 |00:00:00.01 |      67 |
|   6 |       NESTED LOOPS                |              |      1 |      4 |     10 |00:00:00.01 |      44 |
|*  7 |        TABLE ACCESS BY INDEX ROWID| 주문_72      |      1 |      2 |      5 |00:00:00.01 |      22 |
|*  8 |         INDEX RANGE SCAN          | IX01_주문_72 |      1 |     20 |     19 |00:00:00.01 |       3 |
|   9 |        TABLE ACCESS BY INDEX ROWID| 주문이력_72  |      5 |      2 |     10 |00:00:00.01 |      22 |
|* 10 |         INDEX RANGE SCAN          | IX01_주문이력|      5 |      2 |     10 |00:00:00.01 |      12 |
|* 11 |       INDEX RANGE SCAN            | IX01_결제이력|     10 |      2 |     20 |00:00:00.01 |      23 |
|  12 |      TABLE ACCESS BY INDEX ROWID  | 결제이력_72  |     20 |      2 |     20 |00:00:00.01 |      20 |
------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("RNUM"=1)
   7 - filter("A"."주문상태코드"='12')
   8 - access("A"."회원번호"='C13991')
  10 - access("B"."주문번호"="A"."주문번호")
  11 - access("C"."주문이력번호"="B"."주문이력번호")
 
*/

/* 
답안 
  1. 인덱스 수정 
     - IX01_주문_72     : 회원번호     => 회원번호, 주문상태코드
     - IX01_결제이력_72 : 주문이력번호 => 주문이력번호, 결제일자
  
  2. SQL 수정
     - 옵타마이즈 힌트 활용
     - 문제는 ROWNUM과 ORDER BY가 같은 레벨의 SQL로 되어 있어
       요구사항과 다른 출력값이 나온다.
       따라서 아래와 같이 인라인뷰에서 SORT를 하고, 메인 쿼리절에서
       ROWNUM <= 1 이렇게 SQL 수정 필요
       즉, 문제에서 제시된 SQL과 다른 결과값이 나온다.
       문제에서 제시된 SQL은 함정
       
*/
DROP    INDEX IX01_주문_72;
CREATE  INDEX IX01_주문_72     ON 주문_72(회원번호, 주문상태코드);

DROP    INDEX IX01_결제이력_72 ;
CREATE  INDEX IX01_결제이력_72 ON 결제이력_72(주문이력번호, 결제일자);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '주문_72');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '결제이력_72');

SELECT X.카드번호
FROM   (SELECT   /*+ ORDERED USE_NL(B) USE_NL(C) 
                     INDEX(A IX01_주문_72) INDEX(B IX01_주문이력_71)
                     INDEX_DESC(C IX01_결제이력_72) */
                 C.카드번호
        FROM     주문_72     A
               , 주문이력_72 B
               , 결제이력_72 C
        WHERE    A.회원번호     = 'C13991'
         AND     A.주문상태코드 = '12'
         AND     B.주문번호     = A.주문번호
         AND     C.주문이력번호 = B.주문이력번호
        ORDER BY C.결제일자 DESC
       ) X 
WHERE  ROWNUM = 1;
/*
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation                         | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                  |              |      1 |        |      1 |00:00:00.01 |      33 |      3 |
|*  1 |  COUNT STOPKEY                    |              |      1 |        |      1 |00:00:00.01 |      33 |      3 |
|   2 |   VIEW                            |              |      1 |      9 |      1 |00:00:00.01 |      33 |      3 |
|*  3 |    SORT ORDER BY STOPKEY          |              |      1 |      9 |      1 |00:00:00.01 |      33 |      3 |
|   4 |     NESTED LOOPS                  |              |      1 |        |      8 |00:00:00.01 |      33 |      3 |
|   5 |      NESTED LOOPS                 |              |      1 |      9 |      8 |00:00:00.01 |      25 |      3 |
|   6 |       NESTED LOOPS                |              |      1 |      4 |      4 |00:00:00.01 |      15 |      2 |
|   7 |        TABLE ACCESS BY INDEX ROWID| 주문_72      |      1 |      2 |      2 |00:00:00.01 |       5 |      2 |
|*  8 |         INDEX RANGE SCAN          | IX01_주문_72 |      1 |      2 |      2 |00:00:00.01 |       3 |      2 |
|   9 |        TABLE ACCESS BY INDEX ROWID| 주문이력_72  |      2 |      2 |      4 |00:00:00.01 |      10 |      0 |
|* 10 |         INDEX RANGE SCAN          | IX01_주문이력|      2 |      2 |      4 |00:00:00.01 |       6 |      0 |
|* 11 |       INDEX RANGE SCAN DESCENDING | IX01_결제이력|      4 |      2 |      8 |00:00:00.01 |      10 |      1 |
|  12 |      TABLE ACCESS BY INDEX ROWID  | 결제이력_72  |      8 |      2 |      8 |00:00:00.01 |       8 |      0 |
---------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter(ROWNUM=1)
   3 - filter(ROWNUM=1)
   8 - access("A"."회원번호"='C13991' AND "A"."주문상태코드"='12')
  10 - access("B"."주문번호"="A"."주문번호")
  11 - access("C"."주문이력번호"="B"."주문이력번호")
 
 
*/