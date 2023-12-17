/*
고객_69    100만건
  고객번호      VARCHAR2(10)
  고객명        VARCHAR2(50)
  최종거래일시  DATE
  기타 등등
인덱스
   - PK      : 고객번호
   - 인덱스1 : 최종거래일시

주문
  주문번호      VARCHAR2(10)
  고객번호      VARCHAR2(10)
  거래일시      DATE
  기타등등
※ 주문일시 칼럼에 월별 파티션 구성
인덱스 
  - 고객번호 + 거래일시
  - 거래일시

문제1) 아래의 Query를 이용하여 OLTP의 부분범위 처리에 최적화하여 튜닝하세요.
문제2) 아래의 Query를 이용하여 Batch 프로그램에 최적화하여 튜닝하세요.
두 문제 모두 옵티마이저 힌트를 활용하여 실행계획을 고정 하세요.
*/

ALTER SESSION SET CURRENT_SCHEMA = YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY=MANUAL;
ALTER SESSION SET SORT_AREA_SIZE=1000000000;

DROP   TABLE 고객_69 ;
CREATE TABLE 고객_69 NOLOGGING  AS --    100만건
SELECT      'C' || LPAD(LEVEL, 9, 0)                                              고객번호
         ,  'FDAASDFFDSA' || LPAD(LEVEL, 9, 0)                                    고객명
         ,  TO_DATE('20190515', 'YYYYMMDD') + 
              CASE WHEN ROWNUM <= 1000  THEN ROUND(DBMS_RANDOM.VALUE(1, 30), 3)
                                        ELSE ROUND(DBMS_RANDOM.VALUE(-1, -365), 3) 
              END                                                                 최종거래일시
         ,  'ASDFFDSASDFFDSASDF'                                                  C1
         ,  'ASDFFDSASDFFDSASDF'                                                  C2
         ,  'ASDFFDSASDFFDSASDF'                                                  C3
FROM DUAL
CONNECT BY LEVEL <= 1000000
ORDER BY DBMS_RANDOM.RANDOM()
;

ALTER TABLE 고객_69
ADD CONSTRAINT PK_고객_69 PRIMARY KEY(고객번호);

CREATE INDEX IX_고객_69_01 ON 고객_69(최종거래일시);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '고객_69');

-- CREATE PUBLIC SYNONYM 고객_69 FOR YOON.고객_69;

DROP   TABLE 주문_69;
CREATE TABLE 주문_69
  (  고객번호      VARCHAR2(10)
   , 주문번호      VARCHAR2(10)
   , 거래일시      DATE
   , 주문금액      NUMBER
   , C1            VARCHAR2(30)
   , C2            VARCHAR2(30)
   , C3            VARCHAR2(30)
   , C4            VARCHAR2(30)
   , CONSTRAINT PK_주문_69 PRIMARY KEY(고객번호, 거래일시) 
     USING INDEX LOCAL
  ) NOLOGGING
  PARTITION BY RANGE(거래일시)
  (  PARTITION  PT201804 VALUES LESS THAN (TO_DATE('20180501', 'YYYYMMDD'))
   , PARTITION  PT201805 VALUES LESS THAN (TO_DATE('20180601', 'YYYYMMDD'))
   , PARTITION  PT201806 VALUES LESS THAN (TO_DATE('20180701', 'YYYYMMDD'))
   , PARTITION  PT201807 VALUES LESS THAN (TO_DATE('20180801', 'YYYYMMDD'))
   , PARTITION  PT201808 VALUES LESS THAN (TO_DATE('20180901', 'YYYYMMDD'))
   , PARTITION  PT201809 VALUES LESS THAN (TO_DATE('20181001', 'YYYYMMDD'))
   , PARTITION  PT201810 VALUES LESS THAN (TO_DATE('20181101', 'YYYYMMDD'))
   , PARTITION  PT201811 VALUES LESS THAN (TO_DATE('20181201', 'YYYYMMDD'))
   , PARTITION  PT201812 VALUES LESS THAN (TO_DATE('20190101', 'YYYYMMDD'))
   , PARTITION  PT201901 VALUES LESS THAN (TO_DATE('20190201', 'YYYYMMDD'))
   , PARTITION  PT201902 VALUES LESS THAN (TO_DATE('20190301', 'YYYYMMDD'))
   , PARTITION  PT201903 VALUES LESS THAN (TO_DATE('20190401', 'YYYYMMDD'))
   , PARTITION  PT201904 VALUES LESS THAN (TO_DATE('20190501', 'YYYYMMDD'))
   , PARTITION  PT201905 VALUES LESS THAN (TO_DATE('20190601', 'YYYYMMDD'))
   , PARTITION  PT201906 VALUES LESS THAN (TO_DATE('20190701', 'YYYYMMDD'))
   , PARTITION  PTMAX    VALUES LESS THAN (MAXVALUE)
 )  
;

INSERT /*+ APPEND */ INTO 주문_69
SELECT     C.고객번호
         , 'O' || LPAD(ROWNUM, 9, 0)                    주문번호
         , ADD_MONTHS(C.최종거래일시, (O.LVL-1) * -1)   거래일시
         , ROWNUM + 10000                               주문금액
         , 'ASDFFDSAASDFFDSAASDF'                       C1 
         , 'ASDFFDSAASDFFDSAASDF'                       C2 
         , 'ASDFFDSAASDFFDSAASDF'                       C3 
         , 'ASDFFDSAASDFFDSAASDF'                       C4 
FROM       고객_69 C,
           (SELECT LEVEL LVL
            FROM DUAL
            CONNECT BY LEVEL <= 12) O 
ORDER BY DBMS_RANDOM.RANDOM() ;
COMMIT;

--CREATE PUBLIC SYNONYM 주문_69 FOR YOON.주문_69;

--DROP   INDEX IX_주문_69_01 ;
CREATE INDEX IX_주문_69_01 ON 주문_69(거래일시) LOCAL ;
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '주문_69') ;

  
/*  
SELECT    C.고객번호, C.고객명, C.최종거래일시
        , (SELECT AVG(주문금액) 
           FROM   주문_69
           WHERE  거래일시 >= TRUNC(ADD_MONTHS(SYSDATE, -1))
            AND   고객번호 = C.고객번호)  평균주문금액
        , (SELECT MAX(주문금액) 
           FROM   주문_69
           WHERE  거래일시 >= TRUNC(ADD_MONTHS(SYSDATE, -1))
            AND   고객번호 = C.고객번호)  최고주문금액
        , (SELECT MIN(주문금액) 
           FROM   주문주문_69
           WHERE  거래일시 >= TRUNC(ADD_MONTHS(SYSDATE, -1))
            AND   고객번호 = C.고객번호)  최소주문금액            
  FROM    고객_69 C
WHERE     C.최종거래일시 >= TRUNC(ADD_MONTHS(SYSDATE, -1))
;
*/

