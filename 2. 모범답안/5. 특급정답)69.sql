--1, 2번  모두 아래의 Query를 사용하되  옵티마이즈 힌트만 수정

ALTER SESSION SET STATISTICS_LEVEL = ALL;

SELECT    /*+  FIRST_ROWS LEADING(C) USE_NL(O)    INDEX(C) INDEX(O) */
          C.고객번호, MAX(C.고객명) 고객명, MAX(C.최종거래일시) 최종거래일시
        , AVG(O.주문금액)  평균주문금액
        , MAX(O.주문금액)  최고주문금액
        , MIN(주문금액)    최소주문금액            
  FROM    고객_69 C
        , 주문_69 O 
WHERE     C.최종거래일시 BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
 AND      O.고객번호(+)  = C.고객번호
 AND      O.거래일시(+)  BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
GROUP BY  C.고객번호
;

/*
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |             |      1 |        |       |       |   1000 |00:00:00.02 |    5979 |
|   1 |  HASH GROUP BY                       |             |      1 |  75859 |       |       |   1000 |00:00:00.02 |    5979 |
|   2 |   NESTED LOOPS OUTER                 |             |      1 |  94658 |       |       |   1000 |00:00:00.01 |    5979 |
|   3 |    TABLE ACCESS BY INDEX ROWID       | 고객_69     |      1 |  75859 |       |       |   1000 |00:00:00.01 |    1006 |
|*  4 |     INDEX RANGE SCAN                 | IX_고객_69_0|      1 |  75859 |       |       |   1000 |00:00:00.01 |       6 |
|   5 |    PARTITION RANGE ITERATOR          |             |   1000 |      1 |    14 |    15 |   1000 |00:00:00.01 |    4973 |
|   6 |     TABLE ACCESS BY LOCAL INDEX ROWID| 주문_69     |   2000 |      1 |    14 |    15 |   1000 |00:00:00.01 |    4973 |
|*  7 |      INDEX RANGE SCAN                | PK_주문_69  |   2000 |      1 |    14 |    15 |   1000 |00:00:00.01 |    4024 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("C"."최종거래일시">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND "C"."최종거래일시"<=TO_DATE(' 
              2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
   7 - access("O"."고객번호"="C"."고객번호" AND "O"."거래일시">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND 
              "O"."거래일시"<=TO_DATE(' 2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
 
*/

--2. 전체범위 처리
SELECT    /*+  ALL_ROWS LEADING(C) USE_HASH(O)    INDEX(C) FULL(O) */
          C.고객번호, MAX(C.고객명) 고객명, MAX(C.최종거래일시) 최종거래일시
        , AVG(O.주문금액)  평균주문금액
        , MAX(O.주문금액)  최고주문금액
        , MIN(주문금액)    최소주문금액            
  FROM    고객_69 C
        , 주문_69 O 
WHERE     C.최종거래일시 BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
 AND      O.고객번호(+)  = C.고객번호
 AND      O.거래일시(+)  BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
GROUP BY  C.고객번호
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS PARTITION LAST'));

/*
 
 --2번
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Starts | E-Rows | Pstart| Pstop | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |      1 |        |       |       |   1000 |00:00:00.04 |    1592 |
|   1 |  HASH GROUP BY                |             |      1 |  75936 |       |       |   1000 |00:00:00.04 |    1592 |
|*  2 |   HASH JOIN OUTER             |             |      1 |  94776 |       |       |   1000 |00:00:00.03 |    1592 |
|   3 |    TABLE ACCESS BY INDEX ROWID| 고객_69     |      1 |  75936 |       |       |   1000 |00:00:00.01 |     943 |
|*  4 |     INDEX RANGE SCAN          | IX_고객_69_0|      1 |  75936 |       |       |   1000 |00:00:00.01 |       6 |
|   5 |    PARTITION RANGE ITERATOR   |             |      1 |    493K|    14 |    15 |   1000 |00:00:00.01 |     649 |
|*  6 |     TABLE ACCESS FULL         | 주문_69     |      2 |    493K|    14 |    15 |   1000 |00:00:00.01 |     649 |
-----------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("O"."고객번호"="C"."고객번호")
   4 - access("C"."최종거래일시">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND 
              "C"."최종거래일시"<=TO_DATE(' 2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
   6 - filter(("O"."거래일시">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND "O"."거래일시"<=TO_DATE(' 
              2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss')))
 
 */