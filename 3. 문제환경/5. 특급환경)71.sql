ALTER SESSION SET CURRENT_SCHEMA=YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;

DROP   TABLE 배송이력_71;
CREATE TABLE 배송이력_71 
  (  배송번호             VARCHAR2(9)
   , 배송업체번호         VARCHAR2(4)
   , 배송유형             VARCHAR2(2)
   , 배송일자구분코드     VARCHAR2(1)
   , 배송완료일시         DATE
   , 배송회수완료일시     DATE
   , 반품배송완료일시     DATE
   , C1                   VARCHAR2(100)
   , C2                   VARCHAR2(100)
   , C3                   VARCHAR2(100)
   , C4                   VARCHAR2(100)
   , C5                   VARCHAR2(100)
   , C6                   VARCHAR2(100)
   , C7                   VARCHAR2(100)
   ) NOLOGGING;
   
INSERT /*+ APPEND */ INTO 배송이력_71
SELECT      'O' || LPAD(TO_CHAR(ROWNUM), 8, '0')                                                                 배송번호
          , 'C' || LPAD(ROUND(DBMS_RANDOM.VALUE(1, 100)), 3, '0')                                                배송업체번호
          , TO_CHAR(ROUND(DBMS_RANDOM.VALUE(10, 99)))                                                            배송유형
          , TO_CHAR(MOD(ROWNUM, 3))                                                                              배송일자구분코드 -- 0(배송완료일시), 1(배송회수완료일시), 2(반품배송완료일시)
          , CASE WHEN MOD(ROWNUM, 3) = 0 THEN TO_DATE('20190131', 'YYYYMMDD') - DBMS_RANDOM.VALUE(0, 3650) END   배송완료일시
          , CASE WHEN MOD(ROWNUM, 3) = 1 THEN TO_DATE('20190131', 'YYYYMMDD') - DBMS_RANDOM.VALUE(0, 3650) END   배송회수완료일시
          , CASE WHEN MOD(ROWNUM, 3) = 2 THEN TO_DATE('20190131', 'YYYYMMDD') - DBMS_RANDOM.VALUE(0, 3650) END   반품배송완료일시
          , 'FDSAASD' || TO_CHAR(ROWNUM) || 'FDSAADF'                                                            C1
          , 'DKDKDKD' || TO_CHAR(ROWNUM) || 'FDSAADF'                                                            C2
          , 'REWAFBG' || TO_CHAR(ROWNUM) || 'FDSAADF'                                                            C3
          , 'POPOPOP' || TO_CHAR(ROWNUM) || 'FDSAADF'                                                            C4
          , 'ASASASA' || TO_CHAR(ROWNUM) || 'FDSAADF'                                                            C5
          , '4334434' || TO_CHAR(ROWNUM) || 'FDSAADF'                                                            C6
          , 'HJHJHJH' || TO_CHAR(ROWNUM) || 'FDSAADF'                                                            C7
FROM       DUAL
CONNECT BY LEVEL <= 10000000
ORDER   BY DBMS_RANDOM.RANDOM()
;

DROP   PUBLIC SYNONYM 배송이력_71;
CREATE PUBLIC SYNONYM 배송이력_71 FOR YOON.배송이력_71;   
   
ALTER TABLE 배송이력_71 
ADD CONSTRAINT PK_배송이력_71 PRIMARY KEY(배송번호);

CREATE INDEX IX10_배송이력_71
ON 배송이력_71(배송업체번호, 배송완료일시, 배송회수완료일시, 반품배송완료일시);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '배송이력_71');