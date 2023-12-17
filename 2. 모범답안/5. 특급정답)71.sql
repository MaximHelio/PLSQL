/*
1. 칼럼 추가하는 방법 : 2번
   1-1. 칼럼추가 : 배송일자구분코드
        배송완료일시가    NOT NULL 이면 '0'
        배송회수완료일시  NOT NULL 이면 '1'
        반품배송완료일시  NOT NULL 이면 '2'
   1-2. 칼럼 추가하지 않는 방법 : 1, 3번
   ※ 세가지 방법 모두 정답입니다.
      하지만 칼럼도 추가하지 않고 SQL도 단순한 3번이 가장 좋네요.  ^^

2. 인덱스변경 : IX10_배송이력_71(배송업체번호, 배송유형, 배송회수반품완료일자);
    - IX10_배송이력_71 : 기존(배송업체번호, 배송완료일시, 배송회수완료일시, 반품배송완료일시) + 추가(배송유형, 배송일자구분코드)

3. SQL 변경
*/
ALTER SESSION SET CURRENT_SCHEMA=YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;

DROP   INDEX IX10_배송이력_71;
CREATE INDEX IX10_배송이력_71
--ON 배송이력_71(배송업체번호, 배송유형, 배송완료일시, 배송회수완료일시, 반품배송완료일시, 배송일자구분코드 ); --  최적의 INDEX
ON 배송이력_71( 배송업체번호, 배송완료일시, 배송회수완료일시, 반품배송완료일시, 배송유형, 배송일자구분코드);


EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '배송이력_71');

ALTER SESSION SET STATISTICS_LEVEL=ALL;

--------------------  
--- 1.번 UNION ALL 
SELECT    배송번호, 배송업체번호, 배송유형, 배송완료일시, 배송회수완료일시, 반품배송완료일시
       ,  C1, C2
FROM      배송이력_71
WHERE     배송업체번호 = 'C033'  
 AND      배송유형     = '82' 
 AND      배송완료일시     BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
 AND      배송회수완료일시 IS NULL
 AND      반품배송완료일시 IS NULL
UNION ALL
SELECT    배송번호, 배송업체번호, 배송유형, 배송완료일시, 배송회수완료일시, 반품배송완료일시
       ,  C1, C2
FROM      배송이력_71
WHERE     배송업체번호 = 'C033'  
 AND      배송유형     = '82' 
 AND      배송완료일시     IS NULL
 AND      배송회수완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
 AND      반품배송완료일시 IS NULL
UNION ALL
SELECT    배송번호, 배송업체번호, 배송유형, 배송완료일시, 배송회수완료일시, 반품배송완료일시
       ,  C1, C2
FROM      배송이력_71
WHERE     배송업체번호 = 'C033'  
 AND      배송유형     = '82' 
 AND      배송완료일시     IS NULL
 AND      배송회수완료일시 IS NULL
 AND      반품배송완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
;

--  2. 배송일자구분코드를 추가하여 활용
SELECT    /*+ USE_CONCAT */
          배송번호, 배송업체번호, 배송유형, 배송완료일시, 배송회수완료일시, 반품배송완료일시
       ,  C1, C2
FROM      배송이력_71
WHERE     배송업체번호 = 'C033'  
 AND      배송유형     = '82' 
 AND      (
             (     배송일자구분코드 = '0' 
               AND 배송완료일시     BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND 배송회수완료일시 IS NULL
               AND 반품배송완료일시 IS NULL
              )
           OR
           (     배송일자구분코드   = '1' 
               AND 배송완료일시     IS NULL
               AND 배송회수완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND 반품배송완료일시 IS NULL
              )
           OR(     배송일자구분코드 = '2' 
               AND 배송완료일시     IS NULL
               AND 배송회수완료일시 IS NULL
               AND 반품배송완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
              )

          )
;


--  3. 아무 칼럼도 추가하지 않고
SELECT    /*+ USE_CONCAT */
          배송번호, 배송업체번호, 배송유형, 배송완료일시, 배송회수완료일시, 반품배송완료일시
       ,  C1, C2
FROM      배송이력_71
WHERE     배송업체번호 = 'C033'  
 AND      배송유형     = '82' 
 AND      (
             (     배송완료일시     BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND 배송회수완료일시 IS NULL
               AND 반품배송완료일시 IS NULL
              )
           OR
           (       배송완료일시     IS NULL
               AND 배송회수완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND 반품배송완료일시 IS NULL
              )
           OR(     배송완료일시     IS NULL
               AND 배송회수완료일시 IS NULL
               AND 반품배송완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
              )

          )
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));

/*
-- 변경 전
---------------------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |      1 |        |      6 |00:00:00.16 |    1244 |   1229 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      6 |      6 |00:00:00.16 |    1244 |   1229 |
|*  2 |   INDEX RANGE SCAN          | IX10_배송이력|      1 |    820 |    873 |00:00:00.09 |     371 |    369 |
---------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("배송유형"='82')
   2 - access("배송업체번호"='C033')
       filter((("배송완료일시">=TO_DATE('20190101') AND "배송완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss')) OR ("반품배송완료일시">=TO_DATE('20190101') AND "반품배송완료일시"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss')) OR ("배송회수완료일시">=TO_DATE('20190101') AND "배송회수완료일시"<=TO_DATE(' 
              2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))))
 
--- 1.번 UNION ALL 
-----------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
-----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |      1 |        |      6 |00:00:00.01 |      20 |     15 |
|   1 |  UNION-ALL                    |              |      1 |        |      6 |00:00:00.01 |      20 |     15 |
|*  2 |   FILTER                      |              |      1 |        |      2 |00:00:00.01 |       7 |      5 |
|   3 |    TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      1 |      2 |00:00:00.01 |       7 |      5 |
|*  4 |     INDEX RANGE SCAN          | IX10_배송이력|      1 |      1 |      2 |00:00:00.01 |       5 |      3 |
|*  5 |   FILTER                      |              |      1 |        |      2 |00:00:00.01 |       6 |      5 |
|   6 |    TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      1 |      2 |00:00:00.01 |       6 |      5 |
|*  7 |     INDEX RANGE SCAN          | IX10_배송이력|      1 |      1 |      2 |00:00:00.01 |       4 |      3 |
|*  8 |   FILTER                      |              |      1 |        |      2 |00:00:00.01 |       7 |      5 |
|   9 |    TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      1 |      2 |00:00:00.01 |       7 |      5 |
|* 10 |     INDEX RANGE SCAN          | IX10_배송이력|      1 |      1 |      2 |00:00:00.01 |       5 |      3 |
-----------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(TO_DATE('20190101')<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
   4 - access("배송업체번호"='C033' AND "배송완료일시">=TO_DATE('20190101') AND "배송회수완료일시" IS NULL AND "반품배송완료일시" IS 
              NULL AND "배송유형"='82' AND "배송일자구분코드"='0' AND "배송완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss'))
       filter(("배송유형"='82' AND "배송회수완료일시" IS NULL AND "반품배송완료일시" IS NULL AND "배송일자구분코드"='0'))
   5 - filter(TO_DATE('20190101')<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
   7 - access("배송업체번호"='C033' AND "배송완료일시" IS NULL AND "배송회수완료일시">=TO_DATE('20190101') AND "반품배송완료일시" IS 
              NULL AND "배송유형"='82' AND "배송일자구분코드"='1' AND "배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss'))
       filter(("배송유형"='82' AND "반품배송완료일시" IS NULL AND "배송일자구분코드"='1' AND "배송회수완료일시">=TO_DATE('20190101') 
              AND "배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
   8 - filter(TO_DATE('20190101')<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
  10 - access("배송업체번호"='C033' AND "배송완료일시" IS NULL AND "배송회수완료일시" IS NULL AND 
              "반품배송완료일시">=TO_DATE('20190101') AND "배송유형"='82' AND "배송일자구분코드"='2' AND "반품배송완료일시"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("배송유형"='82' AND "배송회수완료일시" IS NULL AND "배송일자구분코드"='2' AND "반품배송완료일시">=TO_DATE('20190101') 
              AND "반품배송완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
 
--  2. 배송일자구분코드를 추가하여 활용
-------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |              |      1 |        |      6 |00:00:00.01 |      20 |
|   1 |  CONCATENATION               |              |      1 |        |      6 |00:00:00.01 |      20 |
|   2 |   TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      1 |      2 |00:00:00.01 |       7 |
|*  3 |    INDEX RANGE SCAN          | IX10_배송이력|      1 |      1 |      2 |00:00:00.01 |       5 |
|*  4 |   TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      1 |      2 |00:00:00.01 |       6 |
|*  5 |    INDEX RANGE SCAN          | IX10_배송이력|      1 |      1 |      2 |00:00:00.01 |       4 |
|*  6 |   TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      1 |      2 |00:00:00.01 |       7 |
|*  7 |    INDEX RANGE SCAN          | IX10_배송이력|      1 |      1 |      2 |00:00:00.01 |       5 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("배송업체번호"='C033' AND "배송완료일시" IS NULL AND "배송회수완료일시">=TO_DATE('20190101') AND 
              "반품배송완료일시" IS NULL AND "배송유형"='82' AND "배송일자구분코드"='1' AND "배송회수완료일시"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("배송유형"='82' AND "반품배송완료일시" IS NULL AND "배송일자구분코드"='1' AND 
              "배송회수완료일시">=TO_DATE('20190101') AND "배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss')))
   4 - filter((LNNVL("배송완료일시" IS NULL) OR LNNVL("반품배송완료일시" IS NULL) OR LNNVL("배송일자구분코드"='1') 
              OR LNNVL("배송회수완료일시">=TO_DATE('20190101')) OR LNNVL("배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))))
   5 - access("배송업체번호"='C033' AND "배송완료일시">=TO_DATE('20190101') AND "배송회수완료일시" IS NULL AND 
              "반품배송완료일시" IS NULL AND "배송유형"='82' AND "배송일자구분코드"='0' AND "배송완료일시"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("배송유형"='82' AND "배송회수완료일시" IS NULL AND "반품배송완료일시" IS NULL AND "배송일자구분코드"='0'))
   6 - filter(((LNNVL("배송회수완료일시" IS NULL) OR LNNVL("반품배송완료일시" IS NULL) OR 
              LNNVL("배송일자구분코드"='0') OR LNNVL("배송완료일시">=TO_DATE('20190101')) OR LNNVL("배송완료일시"<=TO_DATE(' 
              2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))) AND (LNNVL("배송완료일시" IS NULL) OR 
              LNNVL("반품배송완료일시" IS NULL) OR LNNVL("배송일자구분코드"='1') OR LNNVL("배송회수완료일시">=TO_DATE('20190101')) 
              OR LNNVL("배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))))
   7 - access("배송업체번호"='C033' AND "배송완료일시" IS NULL AND "배송회수완료일시" IS NULL AND 
              "반품배송완료일시">=TO_DATE('20190101') AND "배송유형"='82' AND "배송일자구분코드"='2' AND "반품배송완료일시"<=TO_DATE(' 
              2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("배송유형"='82' AND "배송회수완료일시" IS NULL AND "배송일자구분코드"='2' AND 
              "반품배송완료일시">=TO_DATE('20190101') AND "반품배송완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss')))
              
 --  3. 아무 칼럼도 추가하지 않고             
-------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |              |      1 |        |      6 |00:00:00.01 |      20 |
|   1 |  CONCATENATION               |              |      1 |        |      6 |00:00:00.01 |      20 |
|   2 |   TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      2 |      2 |00:00:00.01 |       7 |
|*  3 |    INDEX RANGE SCAN          | IX10_배송이력|      1 |      2 |      2 |00:00:00.01 |       5 |
|*  4 |   TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      2 |      2 |00:00:00.01 |       7 |
|*  5 |    INDEX RANGE SCAN          | IX10_배송이력|      1 |      2 |      2 |00:00:00.01 |       5 |
|*  6 |   TABLE ACCESS BY INDEX ROWID| 배송이력_71  |      1 |      2 |      2 |00:00:00.01 |       6 |
|*  7 |    INDEX RANGE SCAN          | IX10_배송이력|      1 |      2 |      2 |00:00:00.01 |       4 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("배송업체번호"='C033' AND "배송완료일시" IS NULL AND "배송회수완료일시">=TO_DATE('20190101') AND 
              "반품배송완료일시" IS NULL AND "배송유형"='82' AND "배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))
       filter(("배송유형"='82' AND "반품배송완료일시" IS NULL AND "배송회수완료일시">=TO_DATE('20190101') AND 
              "배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
   4 - filter((LNNVL("배송완료일시" IS NULL) OR LNNVL("반품배송완료일시" IS NULL) OR 
              LNNVL("배송회수완료일시">=TO_DATE('20190101')) OR LNNVL("배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))))
   5 - access("배송업체번호"='C033' AND "배송완료일시" IS NULL AND "배송회수완료일시" IS NULL AND 
              "반품배송완료일시">=TO_DATE('20190101') AND "배송유형"='82' AND "반품배송완료일시"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("배송유형"='82' AND "배송회수완료일시" IS NULL AND "반품배송완료일시">=TO_DATE('20190101') AND 
              "반품배송완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
   6 - filter(((LNNVL("배송회수완료일시" IS NULL) OR LNNVL("배송완료일시" IS NULL) OR 
              LNNVL("반품배송완료일시">=TO_DATE('20190101')) OR LNNVL("반품배송완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))) AND (LNNVL("배송완료일시" IS NULL) OR LNNVL("반품배송완료일시" IS NULL) OR 
              LNNVL("배송회수완료일시">=TO_DATE('20190101')) OR LNNVL("배송회수완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss')))))
   7 - access("배송업체번호"='C033' AND "배송완료일시">=TO_DATE('20190101') AND "배송회수완료일시" IS NULL AND 
              "반품배송완료일시" IS NULL AND "배송유형"='82' AND "배송완료일시"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss'))
       filter(("배송유형"='82' AND "배송회수완료일시" IS NULL AND "반품배송완료일시" IS NULL))
 
 
*/