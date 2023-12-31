
DROP TABLE   YOON.T_CUST62;

CREATE TABLE YOON.T_CUST62
   (CUST_NO    VARCHAR2(7) ,
    CUST_NM    VARCHAR2(50),
    ADDR       VARCHAR2(100),
    TEL        VARCHAR2(11),
    CONSTRAINT PK_T_CUST62 PRIMARY KEY(CUST_NO)
    );
    
CREATE PUBLIC SYNONYM T_CUST62 FOR YOON.T_CUST62;

INSERT INTO T_CUST62
SELECT 'C' || LPAD(TO_CHAR(LEVEL), 6, '0')  CUST_NO , 
       'ABCDEF' || TO_CHAR(LEVEL)           CUST_NM ,
       '1234567ASDFFDSAASDFFDSAASDFFDSAA'   ADDR    ,
       '01012341234'                        TEL
FROM DUAL
CONNECT BY LEVEL <= 100000;

COMMIT;

DROP TABLE YOON.T_CONT62;
CREATE TABLE YOON.T_CONT62
  (CONT_NO   VARCHAR2(7)    ,
   CUST_NO   VARCHAR2(7)    ,
   CONT_DT   VARCHAR2(8)    ,
   CONSTRAINT PK_T_CONT62 PRIMARY KEY(CONT_NO)
  );
  
CREATE PUBLIC SYNONYM T_CONT62 FOR YOON.T_CONT62;

INSERT INTO T_CONT62
SELECT 'T'||LPAD(TO_CHAR(ROWNUM), 6, '0')             CONT_NO ,
       A.CUST_NO                                              ,
       TO_CHAR(TO_DATE('20170601', 'YYYYMMDD') - MOD(ROWNUM, 100), 'YYYYMMDD')  CONT_DT
FROM T_CUST62 A,
     (SELECT LEVEL FROM DUAL CONNECT BY LEVEL <= 3)
;

COMMIT;

DROP   TABLE YOON.T_ADD_SVC62;
CREATE TABLE YOON.T_ADD_SVC62
  (CONT_NO   VARCHAR2(7)    ,
   PROD_NO   VARCHAR2(4)    ,
   CONT_DT   VARCHAR2(8)    ,
   CONSTRAINT PK_T_ADD_SVC62 PRIMARY KEY(CONT_NO, PROD_NO)
  );
  
CREATE PUBLIC SYNONYM T_ADD_SVC62 FOR YOON.T_ADD_SVC62;

INSERT INTO T_ADD_SVC62
SELECT A.CONT_NO ,
       'P'||TO_CHAR(LVL) || LPAD(TO_CHAR(MOD(ROWNUM, 30)), 2, '0') PROD_NO ,
       TO_CHAR(TO_DATE('20170601', 'YYYYMMDD') - MOD(ROWNUM, 100), 'YYYYMMDD')             CONT_DT
FROM T_CONT62 A,
     (SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 9)
;

COMMIT;

CREATE INDEX YOON.IX_T_CONT62 ON YOON.T_CONT62(CONT_DT);

DROP   TABLE YOON.T_PRODUCT62;
CREATE TABLE YOON.T_PRODUCT62
   (PROD_NO    VARCHAR2(4),
    PROD_NM    VARCHAR2(50),
    CONSTRAINT PK_T_PRODUCT62 PRIMARY KEY(PROD_NO)
    );
    
CREATE PUBLIC SYNONYM T_PRODUCT62 FOR YOON.T_PRODUCT62;

INSERT INTO T_PRODUCT62
SELECT PROD_NO, 'ABCDEFGHIJK' || TO_CHAR(ROWNUM) PROD_NM
FROM (SELECT DISTINCT PROD_NO FROM T_ADD_SVC62)
;

COMMIT;

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CUST62');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CONT62');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_ADD_SVC62');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_PRODUCT62');

/*
2. 아래 SQL에 대해 최적화하고 필요하면 인덱스도 최적화 하세요.
   단, 통계정보 생성에 따른 실행 계획이 바뀌지 않도록 고정하세요.

<테이블 정보>

테이블 : 고객, 계약, 상품, 상품부가서비스

고객 : PK - 고객번호
계약 : PK - 계약번호
       IDX1 - 고객번호
상품 : PK - 계약번호 + 상품번호 + 가입일자
       IDX1 - 가입일자 + 계약번호
상품부가서비스  : PK - 계약번호 + 상품번호 + 가입일자 + 부가서비스ID
                 IDX - 계약번호 + 상품번호 


<SQL>






<실행계획>

고객, 계약,  상품부가서비스,상품 테이블 순으로 Join 됨

1) 고객과 계약 조인 결과 row수가 3건
2) 상품에서 조인된 이후 row수가 150K 개(100K가 넘는 row수), Table Access 도 150K
3) 상품부가서비스까지 조인된 row수가 30개



아래 SQL에 대해 최적화하고 필요하면 인덱스도 최적화 하세요.
단, 통계정보 생성에 따른 실행 계획이 바뀌지 않도록 고정하세요.
인데스 생성은 가능하며, 불필요한 인덱스 생성시 감점이 될 수도 있습니다.

테이블 정보
T_CUST61   : PK(고객번호)
T_PROD61   : PK(PROD_ID)
T_CONT61   : PK(계약번호 + 상품번호 + 가입일자),  인덱스(고객번호)
T_ADDSVC61 : PK(계약번호 + 상품번호 + 가입일자 + 부가서비스ID), 인덱스(계약번호 + 상품번호)


SELECT A.CUST_NO, A.CUST_NM, C.PROD_NO, C.CONT_DT, D.ADDSVC_NO
FROM T_CUST61 A, T_CONT61 B, T_PROD61 C, T_ADDSVC61 D
WHERE A.CUST_NO = :CUST_NO
 AND  C.CONT_DT BETWEEN :T1 AND :T2
 AND  D.CONT_NO = B.CONT_NO
 AND  C.CONT_NO = D.CONT_NO
 AND  C.PROD_NO = D.PROD_NO
 AND  C.CONT_DT = D.CONT_DT
;

*/