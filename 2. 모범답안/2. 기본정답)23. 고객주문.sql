DROP INDEX YOON.IX_T_고객23 ;
DROP INDEX YOON.IX_T_주문23 ;

CREATE INDEX YOON.IX_T_고객23 ON YOON.T_고객23(고객성향코드);
CREATE INDEX YOON.IX_T_주문23 ON YOON.T_주문23(고객번호, 상품코드, 주문일자);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_고객23');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_주문23');

ALTER SESSION SET STATISTICS_LEVEL=ALL;

SELECT /*+ ORDERED USE_NL(O) INDEX(C IX_T_고객23) INDEX(D IX_T_주문23) */
       C.고객번호, C.고객명, C.C1
     , O.주문번호, O.상품코드, O.주문일자, O.주문수량
FROM T_고객23 C, T_주문23 O
WHERE C.고객성향코드 = '920'
 AND  O.고객번호     = C.고객번호
 AND  O.주문일자     BETWEEN '20170101' AND '20170131'
 AND  O.상품코드     = 'P103';
 
 SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST'));
 
 /*                                                                                                                                                                                                                                                                                                        
--------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |           |      1 |        |     13 |00:00:00.02 |     313 |     20 |
|   1 |  NESTED LOOPS                 |           |      1 |        |     13 |00:00:00.02 |     313 |     20 |
|   2 |   NESTED LOOPS                |           |      1 |    109 |     13 |00:00:00.02 |     300 |      7 |
|   3 |    TABLE ACCESS BY INDEX ROWID| T_고객23  |      1 |    106 |    101 |00:00:00.01 |      94 |      0 |
|*  4 |     INDEX RANGE SCAN          | IX_T_고객2|      1 |    106 |    101 |00:00:00.01 |       3 |      0 |
|*  5 |    INDEX RANGE SCAN           | IX_T_주문2|    101 |      1 |     13 |00:00:00.01 |     206 |      7 |
|   6 |   TABLE ACCESS BY INDEX ROWID | T_주문23  |     13 |      1 |     13 |00:00:00.01 |      13 |     13 |
--------------------------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):                                                           
---------------------------------------------------                                                           
4 - access("C"."고객성향코드"='920')                                                                          
5 - access("O"."고객번호"="C"."고객번호" AND "O"."상품코드"='P103' AND "O"."주문일자">='20170101' AND                                                                   
"O"."주문일자"<='20170131')                                                                                                                                             
 */