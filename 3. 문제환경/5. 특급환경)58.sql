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
   출력 값 : 상품ID, 상태코드,  최대상품가격, 최소상품가격, 평균상품가격, 최종변경일자, 최종변경순번
   
※ 최종이란 변경일자가 가장 큰것 중 순번이 가장 큰것을 의미한다.
*/


DROP TABLE YOON.일자임시_59 ;
CREATE TABLE YOON.일자임시_59 AS
SELECT TO_CHAR(TO_DATE('20170319', 'YYYYMMDD') - LEVEL, 'YYYYMMDD') 날짜
FROM DUAL CONNECT BY LEVEL <= 138;

CREATE PUBLIC SYNONYM 일자임시_59 FOR YOON.일자임시_59;

DROP TABLE YOON.상품변경이력_59;
CREATE TABLE YOON.상품변경이력_59
  (
  상품ID       VARCHAR2(6)    ,
  변경일자     VARCHAR2(8)    ,
  순번         NUMBER         ,
  상태코드     VARCHAR2(2)    ,
  상품가격     NUMBER         ,
  CONSTRAINT PK_상품변경이력_59 PRIMARY KEY(상품ID, 변경일자, 순번)
  );

CREATE PUBLIC SYNONYM 상품변경이력_59 FOR YOON.상품변경이력_59;

INSERT INTO /*+ APPEND */ 상품변경이력_59
SELECT LPAD(TO_CHAR(A.상품ID), 6, '0') 상품ID,
       C.변경일자, B.순번, 
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1,10))), 2, '0') 상태코드,
       TRUNC(DBMS_RANDOM.VALUE(50000, 1000000)) 상품가격
FROM  (SELECT LEVEL 상품ID  FROM DUAL CONNECT BY LEVEL <= 1000) A,
      (SELECT LEVEL 순번    FROM DUAL CONNECT BY LEVEL <=  10) B,
      (SELECT 날짜 변경일자 FROM 일자임시_59 WHERE 날짜 >= '20161208') C
ORDER BY DBMS_RANDOM.RANDOM();
      
COMMIT;
      
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '상품변경이력_59');

SELECT COUNT(*) FROM 상품변경이력_59;

