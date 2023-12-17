/*
상품변경이력_59 테이블
  - (#)상품ID    VARCHAR2(6)
  - (#)변경일자  VARCHAR2(8)
  - (#)순번      NUMBER
  - 상태코드     VARCHAR2(3)
  - 상품가격     NUMBER
 
상품별 변경이력 1,000건
일평균 변경이력 10건
전체범위 처리 기준으로 SQL 작성

아래 요구사항에 맞는 SQL을 작성하세요.
필요 시 인덱스 재구성도 제시하세요.


1) 특정 상품에 해당하는 최종 건 찾기
   상품번호 변수   : PROD_ID
   출력 값 : 상품ID, 변경일자, 순번, 상태코드, 가격


2) 전체 상품에 최종 건 찾기
   출력 값 : 상품ID, 변경일자, 순번, 상태코드, 가격
   
3) 전체 상품별, 상태코드별 정보 출력
   출력 값 : 상품ID, 상태코드,  최대상품가격, 최소상품가격, 평균상품가격, 최종변경일자, 최종변경순번(최종변경일자의 최종순번),
             상품가격(최종변경일자의 최종변경순번의 상품가격)
   
※ 최종이란 변경일자가 가장 큰것 중 순번이 가장 큰것을 의미한다.
*/

ALTER SESSION SET STATISTICS_LEVEL=ALL;

--1번)
-- 인덱스 변경 무
SELECT *
FROM (SELECT /*+ INDEX_DESC(X PK_상품변경이력_59) */
             상품ID, 변경일자, 순번, 상태코드, 상품가격
           , ROW_NUMBER() OVER(PARTITION BY 상품ID ORDER BY 변경일자 DESC, 순번 DESC) R_NUM
      FROM 상품변경이력_59 X
      WHERE 상품ID = :PROD_ID
     )
WHERE R_NUM = 1
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));
/*
PLAN_TABLE_OUTPUT
---------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |              |      1 |        |      1 |00:00:00.01 |     514 |
|*  1 |  VIEW                          |              |      1 |   1010 |      1 |00:00:00.01 |     514 |
|*  2 |   WINDOW NOSORT                |              |      1 |   1010 |   1010 |00:00:00.01 |     514 |
|   3 |    TABLE ACCESS BY INDEX ROWID | 상품변경이력_|      1 |   1010 |   1010 |00:00:00.01 |     514 |
|*  4 |     INDEX RANGE SCAN DESCENDING| PK_상품변경이|      1 |   1010 |   1010 |00:00:00.01 |       9 |
---------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("R_NUM"=1)
   2 - filter(ROW_NUMBER() OVER ( PARTITION BY "상품ID" ORDER BY INTERNAL_FUNCTION("변경일자") DESC 
              ,INTERNAL_FUNCTION("순번") DESC )<=1)
   4 - access("상품ID"=:PROD_ID)
 */

 

--2번)
SELECT 상품ID, 변경일자, 순번, 상태코드, 상품가격
FROM  (SELECT 상품ID, 변경일자, 순번, 상태코드, 상품가격, 
         ROW_NUMBER() OVER(PARTITION BY 상품ID ORDER BY 변경일자 DESC, 순번 DESC) 최종
       FROM 상품변경이력_59 A
       )
WHERE 최종 = 1;

/*
PLAN_TABLE_OUTPUT
---------------------------------------------------------------------------------------------------------
| Id  | Operation                | Name      | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |           |      1 |        |   1000 |00:00:02.85 |    4487 |   4483 |
|*  1 |  VIEW                    |           |      1 |   1010K|   1000 |00:00:02.85 |    4487 |   4483 |
|*  2 |   WINDOW SORT PUSHED RANK|           |      1 |   1010K|   1010K|00:00:02.70 |    4487 |   4483 |
|   3 |    TABLE ACCESS FULL     | 상품변경이|      1 |   1010K|   1010K|00:00:00.17 |    4487 |   4483 |
---------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("최종"=1)
   2 - filter(ROW_NUMBER() OVER ( PARTITION BY "상품ID" ORDER BY INTERNAL_FUNCTION("변경일자") DESC 
              ,INTERNAL_FUNCTION("순번") DESC )<=1)
 
*/


--3번) MAX KEEP 사용 방법
SELECT 상품ID, 상태코드, 
       MAX(상품가격) 최고상품가격, MIN(상품가격) 최소상품가격, ROUND(AVG(상품가격)) 평균상품가격, 
       MAX(변경일자) 변경일자,  
       MAX(순번)     KEEP (DENSE_RANK LAST ORDER BY 변경일자) 최종순번 ,
       MAX(상품가격) KEEP (DENSE_RANK LAST ORDER BY 변경일자, 순번) 최종상품가격
FROM 상품변경이력_59
GROUP BY 상품ID, 상태코드
;

--3번) 윈도우함수
select 상품id, 상태코드, 변경일자 최종변경일자, 순번 최종순번, 상품가격 최종가격
from (
    select 상품id, 변경일자, 순번, 상태코드, 상품가격
         , max(상품가격) over (partition by 상품id, 상태코드 )       최대상품가격
         , min(상품가격) over (partition by 상품id, 상태코드 )       최소상품가격
        , round(avg(상품가격) over (partition by 상품id, 상태코드 )) 평균상품가격
         , row_number()  over (partition by 상품id, 상태코드 order by 변경일자 desc, 순번 desc) 최종변경회차
    from 상품변경이력_59
     )
where 최종변경회차 = 1
;

/*
--------------------------------------------------------------------------------
| Id  | Operation          | Name      |A-Rows |   A-Time   | Buffers | Reads  |
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |           |  9000 |00:00:02.72 |    4487 |   4480 |
|   1 |  SORT GROUP BY     |           |  9000 |00:00:02.72 |    4487 |   4480 |
|   2 |   TABLE ACCESS FULL| 상품변경이|  1010K|00:00:00.18 |    4487 |   4480 |
--------------------------------------------------------------------------------
*/
 
 
 
 
 
 
 
 
 
 
 
 
 
 