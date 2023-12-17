--주문         500만건
--주문상품     600만건
--일벌주문     100건
--일별주문상품 120건
--상품 A% 전체 15%

-----------------------------------------------------------------------
--  DDL
-----------------------------------------------------------------------
DROP TABLE YOON.고객_56  ;

CREATE TABLE YOON.고객_56 
  (고객번호   VARCHAR2(6),
   고객명     VARCHAR2(50),
   연락처     VARCHAR2(20),
   CONSTRAINT 고객_56_PK PRIMARY KEY (고객번호)
   );


DROP TABLE YOON.주문_56 ;
CREATE TABLE YOON.주문_56 
  (주문번호  VARCHAR2(8),
   고객번호  VARCHAR2(6),
   주문일자  VARCHAR2(8),
   주문금액  NUMBER,
   CONSTRAINT 주문_56_PK PRIMARY KEY(주문번호)
   );


DROP INDEX YOON.주문_56_X01 ;
CREATE INDEX YOON.주문_56_X01 ON YOON.주문_56(주문일자);

DROP INDEX YOON.주문_56_X02;
CREATE INDEX YOON.주문_56_X02 ON YOON.주문_56(고객번호, 주문일자);
 

DROP TABLE YOON.주문상품_56;
CREATE TABLE YOON.주문상품_56
   (주문번호  VARCHAR2(8),
    일련번호  NUMBER,
    상품번호  VARCHAR2(4),
    CONSTRAINT 주문상품_56_PK PRIMARY KEY(주문번호, 일련번호)
    );


DROP TABLE YOON.상품_56;
CREATE TABLE YOON.상품_56
   (상품번호  VARCHAR2(4),
    상품명    VARCHAR2(20),
    CONSTRAINT 상품_56_PK PRIMARY KEY(상품번호)
    );

DROP PUBLIC SYNONYM  고객_56    ; 
DROP PUBLIC SYNONYM  주문_56    ;
DROP PUBLIC SYNONYM  주문상품_56;
DROP PUBLIC SYNONYM  상품_56    ;
CREATE PUBLIC SYNONYM  고객_56       FOR     YOON.고객_56     ; 
CREATE PUBLIC SYNONYM  주문_56       FOR     YOON.주문_56     ;
CREATE PUBLIC SYNONYM  주문상품_56   FOR     YOON.주문상품_56 ;
CREATE PUBLIC SYNONYM  상품_56       FOR     YOON.상품_56     ;


--------- 고객
INSERT /*+ APPEND */ INTO 고객_56
SELECT LPAD(TO_CHAR(LEVEL), 6, '0')  고객번호,
       LPAD(TO_CHAR(LEVEL), 10, 'A') 고객명,
       '01012341234'                  연락처
FROM DUAL
CONNECT BY LEVEL <= 100
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

--------- 상품
INSERT /*+ APPEND */ INTO 상품_56
SELECT CASE WHEN LEVEL <= 15 THEN LPAD(TO_CHAR(LEVEL), 4, 'A') 
                              ELSE LPAD(TO_CHAR(LEVEL), 4, '0')
       END 상품번호,
       LPAD(TO_CHAR(LEVEL), 4, '0') 상품명
FROM DUAL
CONNECT BY LEVEL <= 100
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;


--------- 주문
INSERT /*+ APPEND */ INTO 주문_56
SELECT LPAD(TO_CHAR(ROWNUM), 7, '0')               주문번호,
       LPAD(TO_CHAR(MOD(ROWNUM, 100)+1), 6, '0')   고객번호,
       A.주문일자, 
       MOD(ROWNUM, 100) + 10000                    주문금액
FROM  ( 
       SELECT TO_CHAR(SYSDATE - (49000 - ROWNUM), 'YYYYMMDD') 주문일자 
       FROM DUAL
       CONNECT BY LEVEL <=50000
       ) A,
       (SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 100) -- 1일 100건 주문
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

--------- 주문상품
INSERT /*+ APPEND */ INTO 주문상품_56
SELECT A.주문번호, 1 일련번호, B.상품번호
FROM (SELECT MOD(ROWNUM, 100)+1 R_NUM, 주문번호 FROM 주문_56 ) A,
     (SELECT ROWNUM R_NUM, 상품번호 FROM 상품_56) B
WHERE B.R_NUM = A.R_NUM
UNION ALL
SELECT A.주문번호, 2 일련번호, B.상품번호
FROM (SELECT MOD(ROWNUM, 100)+1 R_NUM, 주문번호 FROM 주문_56 WHERE MOD(TO_NUMBER(주문번호), 5) = 0 ) A,
     (SELECT ROWNUM R_NUM, 상품번호 FROM 상품_56) B
WHERE B.R_NUM = A.R_NUM
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;


SELECT COUNT(*) FROM 주문_56; 
--5,000,000
SELECT COUNT(*) FROM 주문상품_56;
--6,000,000
SELECT COUNT(*) FROM 상품_56; 
--100


/*
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '고객_56');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '주문상품_56');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '주문_56');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '상품_56');
*/