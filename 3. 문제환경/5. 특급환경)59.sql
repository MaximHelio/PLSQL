/* 상담이력
  - 하루 10만건 데이터 발생
  - 상담조직            : 100개
  - 고객명   카다널리티 : 월평균 5건
  - 전화번호 카디널리티 : 월평균 3건
  - INDEX               : 조직ID + 상담일시(LOCAL PARTITION INDEX)
  - 파티션 키           : 상담일시(연도별 파티션)
  - 상담일시  VARCHAR2(14)
  
  
*/

DROP TABLE YOON.상담이력_59;
CREATE TABLE YOON.상담이력_59
  (상담이력ID        VARCHAR2(10),    -- 상담이력_ID
   조직ID            VARCHAR2(3) ,   -- 상담일자
   상담일시          VARCHAR2(14),
   고객명            VARCHAR2(50),
   휴대폰번호        VARCHAR2(11),
   CONSTRAINT PK_상담이력_59 PRIMARY KEY(상담이력ID)
   )
   PARTITION BY RANGE (상담일시)				
  (				
	PARTITION	PT_2016     VALUES LESS THAN	('20170101000000'),
 	PARTITION	PT_2017 	VALUES LESS THAN	('20180101000000')
);				


DROP TABLE YOON.일자임시_59 ;
CREATE TABLE YOON.일자임시_59 AS
SELECT TO_CHAR(TO_DATE('20170319', 'YYYYMMDD') - LEVEL, 'YYYYMMDD') 날짜
FROM DUAL CONNECT BY LEVEL <= 138
ORDER BY DBMS_RANDOM.RANDOM();

CREATE PUBLIC SYNONYM 상담이력_59 FOR YOON.상담이력_59;
CREATE PUBLIC SYNONYM 일자임시_59 FOR YOON.일자임시_59;


----------------------------2016.11
INSERT INTO 상담이력_59 
SELECT '1' || LPAD(TO_CHAR(ROWNUM), 9, '0')                                                        상담이력ID,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1,100))), 3, '0')                                      조직ID    ,
       TO_CHAR(TO_DATE(A.날짜, 'YYYYMMDD') + DBMS_RANDOM.VALUE(9/24, 18/24), 'YYYYMMDDHH24MISS')   상담일시  ,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 20000))), 5, '0')                                   고객명    ,
       '010123' || LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 33333))), 5, '0')                       휴대폰번호
FROM (SELECT 날짜  FROM 일자임시_59 WHERE 날짜 BETWEEN '20161101' AND '20161131') A,
     (SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 100000)
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

----------------------------2016.12
INSERT INTO 상담이력_59 
SELECT '1' || LPAD(TO_CHAR(40000000 + ROWNUM), 9, '0')                                                        상담이력ID,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1,100))), 3, '0')                                      조직ID    ,
       TO_CHAR(TO_DATE(A.날짜, 'YYYYMMDD') + DBMS_RANDOM.VALUE(9/24, 18/24), 'YYYYMMDDHH24MISS')   상담일시  ,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 20000))), 5, '0')                                   고객명    ,
       '010123' || LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 33333))), 5, '0')                       휴대폰번호
FROM (SELECT 날짜  FROM 일자임시_59 WHERE 날짜 BETWEEN '20161201' AND '20161231') A,
     (SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 100000)
ORDER BY DBMS_RANDOM.RANDOM()
;

COMMIT;

----------------------------2017.01
INSERT INTO 상담이력_59 
SELECT '1' || LPAD(TO_CHAR(80000000 + ROWNUM), 9, '0')                                                        상담이력ID,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1,100))), 3, '0')                                      조직ID    ,
       TO_CHAR(TO_DATE(A.날짜, 'YYYYMMDD') + DBMS_RANDOM.VALUE(9/24, 18/24), 'YYYYMMDDHH24MISS')   상담일시  ,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 20000))), 5, '0')                                   고객명    ,
       '010123' || LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 33333))), 5, '0')                       휴대폰번호
FROM (SELECT 날짜  FROM 일자임시_59 WHERE 날짜 BETWEEN '20170101' AND '20170131') A,
     (SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 100000)
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

----------------------------2017.02
INSERT INTO 상담이력_59 
SELECT '1' || LPAD(TO_CHAR(120000000 + ROWNUM), 9, '0')                                                        상담이력ID,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1,100))), 3, '0')                                      조직ID    ,
       TO_CHAR(TO_DATE(A.날짜, 'YYYYMMDD') + DBMS_RANDOM.VALUE(9/24, 18/24), 'YYYYMMDDHH24MISS')   상담일시  ,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 20000))), 5, '0')                                   고객명    ,
       '010123' || LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 33333))), 5, '0')                       휴대폰번호
FROM (SELECT 날짜  FROM 일자임시_59 WHERE 날짜 BETWEEN '20170201' AND '20170231') A,
     (SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 100000)
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

----------------------------2017.03
INSERT INTO 상담이력_59 
SELECT '1' || LPAD(TO_CHAR(160000000 + ROWNUM), 9, '0')                                                        상담이력ID,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1,100))), 3, '0')                                      조직ID    ,
       TO_CHAR(TO_DATE(A.날짜, 'YYYYMMDD') + DBMS_RANDOM.VALUE(9/24, 18/24), 'YYYYMMDDHH24MISS')   상담일시  ,
       LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 20000))), 5, '0')                                   고객명    ,
       '010123' || LPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 33333))), 5, '0')                       휴대폰번호
FROM (SELECT 날짜  FROM 일자임시_59 WHERE 날짜 BETWEEN '20170301' AND '20170331') A,
     (SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 100000)
ORDER BY DBMS_RANDOM.RANDOM();
COMMIT;


SELECT COUNT(*) FROM 상담이력_59;

