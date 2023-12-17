
/*  2번

주문 
   주문번호(PK)
   회원번호
   주문상태
   ~~~
   (인덱스 : PK_주문(주문번호), IX01_주문(회원번호))
   
주문이력
   주문이력번호(PK)
   주문번호(FK)
   (인덱스 : PK_주문이력(주문이력번호), IX01_주문이력(주문번호))
   
결제이력
   결제이력번호(PK)
   주문이력번호(FK)
   카드번호
   결제일자
   ~~~
   (인덱스 : PK_결제이력(결제이력번호), IX01_결제이력(주문이력번호), IX02_결제이력(결제일자)
주문데이터 입력 시 최종 결제 카드번호 찾아야 함 
 - 모델 변경 불가
 - 인덱스 변경 가능
 - SQL 변경 가능
 - 힌트는 조인순서, 조인방법, 인덱스 관련만 지정 가능
*/
ALTER SESSION SET CURRENT_SCHEMA=YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE=2000000000;

CREATE  TABLE 주문_72
   (  주문번호           VARCHAR2(9)
    , 회원번호           VARCHAR2(9)
    , 주문상태코드       VARCHAR2(2)
    , C1                 VARCHAR2(100)
    , C2                 VARCHAR2(100)
    , C3                 VARCHAR2(100)
    , C4                 VARCHAR2(100)
    , C5                 VARCHAR2(100)
    , CONSTRAINT PK_주문_72 PRIMARY KEY(주문번호)) NOLOGGING;
 
CREATE TABLE 주문이력_72
    (  주문이력번호      VARCHAR2(10)
     , 주문번호          VARCHAR2(9)
     , CONSTRAINT PK_주문이력_72 PRIMARY KEY(주문이력번호)
    ) NOLOGGING;
    
CREATE TABLE 결제이력_72
    (  결제이력번호     VARCHAR2(10)
     , 주문이력번호     VARCHAR2(9)
     , 카드번호         VARCHAR2(10)
     , 결제일자         VARCHAR2(8)
     , C1                 VARCHAR2(100)
     , C2                 VARCHAR2(100)
     , C3                 VARCHAR2(100)
     , C4                 VARCHAR2(100)
     , C5                 VARCHAR2(100)
     , CONSTRAINT PK_결제이력_72 PRIMARY KEY(결제이력번호)) NOLOGGING;

DROP PUBLIC SYNONYM 주문_72     ;
DROP PUBLIC SYNONYM 주문이력_72 ;
DROP PUBLIC SYNONYM 결제이력_72 ;

CREATE PUBLIC SYNONYM 주문_72     FOR YOON.주문_72;
CREATE PUBLIC SYNONYM 주문이력_72 FOR YOON.주문이력_72;
CREATE PUBLIC SYNONYM 결제이력_72 FOR YOON.결제이력_72;

INSERT /*+ APPEND */ INTO 주문_72
SELECT   'O' || LPAD(ROWNUM, 7, '0')                                주문번호
       , 'C' || LPAD(ROUND(DBMS_RANDOM.VALUE(1, 50000)), 5, '0')    회원번호
       , TO_CHAR(ROUND(DBMS_RANDOM.VALUE(11,20)))                   주문상태코드
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C1
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C2
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C3
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C4
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C5       
FROM   DUAL
CONNECT BY LEVEL <= 1000000
ORDER BY DBMS_RANDOM.RANDOM()
;

CREATE INDEX IX01_주문_72 ON 주문_72(회원번호);

  
INSERT /*+ APPEND */ INTO 주문이력_72
SELECT   주문번호 || TO_CHAR(LVL)                     주문이력번호
       , 주문번호                                   
FROM     주문_72
    ,    (SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 2) 
ORDER BY DBMS_RANDOM.RANDOM()
;

CREATE INDEX IX01_주문이력_72 ON 주문이력_72(주문번호);

INSERT  /*+ APPEND */ INTO 결제이력_72
SELECT  주문이력번호 || LVL                                                               결제이력번호
      , 주문이력번호
      , 'CARD' || LPAD((ROUND(DBMS_RANDOM.VALUE(1,10000))), 5, '0')                       카드번호
      , TO_CHAR(TO_DATE('20191130', 'YYYYMMDD') - DBMS_RANDOM.VALUE(1, 100), 'YYYYMMDD')  결제일자 
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C1
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C2
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C3
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C4
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C5       
FROM    주문이력_72
      , (SELECT LEVEL LVL FROM DUAL CONNECT BY  LEVEL <= 2)
ORDER BY DBMS_RANDOM.RANDOM()
;

CREATE INDEX IX01_결제이력_72 ON 결제이력_72(주문이력번호);
CREATE INDEX IX02_결제이력_72 ON 결제이력_72(결제일자);


EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '주문_72');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '주문이력_72');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '결제이력_72');


