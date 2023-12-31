/*==================================================
  테이블 생성 T_MANUF
  ================================================*/
ALTER SESSION SET WORKAREA_SIZE_POLICY=MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;


DROP TABLE YOON.T_MANUF;

CREATE TABLE YOON.T_MANUF
  (M_CODE   VARCHAR2(6),
   M_NAME   VARCHAR2(50)
   );

CREATE SYNONYM T_MANUF FOR YOON.T_MANUF;

INSERT /*+ APPEND */ INTO T_MANUF
SELECT CASE WHEN ROWNUM <= 100 THEN 'M' ELSE 'Z' END || LPAD(TRIM(TO_CHAR(ROWNUM)), 5, '0')
     , '12345678901234567890123456789012345678901234567890'
FROM DUAL  CONNECT BY LEVEL <= 10000
ORDER BY DBMS_RANDOM.RANDOM()
;

COMMIT;

CREATE UNIQUE INDEX YOON.PK_T_MANUF    ON YOON.T_MANUF  (M_CODE);

/*==================================================
  테이블 생성 T_PRODUCT
  ================================================*/
DROP TABLE YOON.T_PRODUCT;

CREATE TABLE YOON.T_PRODUCT
  (  M_CODE   VARCHAR2(6)
   , PROD_ID  VARCHAR2(7)
   , PROD_NM  VARCHAR2(50)
   , C2       VARCHAR2(50)
   , C3       VARCHAR2(50)
   , C4       VARCHAR2(50)
   , C5       VARCHAR2(50)
   );

CREATE PUBLIC SYNONYM T_PRODUCT FOR YOON.T_PRODUCT;

INSERT /*+ APPEND */ INTO T_PRODUCT
SELECT M_CODE
    , 'P'||LPAD(TRIM(TO_CHAR(ROWNUM)), 6, '0')
     , '12345678901234567890123456789012345678901234567890'
     , '12345678901234567890123456789012345678901234567890'
     , '12345678901234567890123456789012345678901234567890'
     , '12345678901234567890123456789012345678901234567890'
     , '12345678901234567890123456789012345678901234567890'
    FROM  T_MANUF A,
          (SELECT ROWNUM RNUM FROM DUAL CONNECT BY LEVEL <= 100) X
    WHERE M_CODE <= 'M00100'
ORDER BY DBMS_RANDOM.RANDOM()
;

COMMIT;

CREATE UNIQUE INDEX YOON.PK_T_PRODUCT  ON YOON.T_PRODUCT(M_CODE, PROD_ID);

/*==================================================
  테이블 생성 T_ORDER
  ================================================*/
DROP TABLE YOON.T_ORDER;

CREATE TABLE YOON.T_ORDER
  (  M_CODE    VARCHAR2(6)
   , PROD_ID   VARCHAR2(7)
   , CUST_ID   VARCHAR2(7)
   , ORDER_DT  VARCHAR2(8)
   , ORDER_QTY NUMBER
   , C1        VARCHAR2(50)
   , C2        VARCHAR2(50)
   , C3        VARCHAR2(50)
   , C4        VARCHAR2(50)
   , C5        VARCHAR2(50)
   );

CREATE PUBLIC SYNONYM T_ORDER FOR YOON.T_ORDER;

INSERT /*+ APPEND */ INTO T_ORDER 
SELECT M_CODE, PROD_ID
  ,  'C'||LPAD(TRIM(TO_CHAR(ROWNUM)), 6, '0') CUST_ID
   ,  CASE WHEN ROWNUM <= 100 THEN '20160412' ELSE '99991231' END ORDER_DT
   ,  CASE WHEN ROWNUM <=32 THEN 9000 + ROWNUM ELSE  10 END ORDER_QTY
   ,  PROD_NM, C2, C3, C4, C5
FROM T_PRODUCT
WHERE M_CODE <= 'M00100'
UNION ALL
SELECT M_CODE, PROD_ID
   ,  'C'||LPAD(TRIM(TO_CHAR(ROWNUM)), 6, '0') CUST_ID
   ,   '99991231' ORDER_DT
   ,   ROWNUM ORDER_QTY
   ,  PROD_NM, C2, C3, C4, C5
FROM T_PRODUCT
WHERE M_CODE > 'M00100'
ORDER BY DBMS_RANDOM.RANDOM()
;
COMMIT;

CREATE        INDEX YOON.IX_T_ORDER_01 ON YOON.T_ORDER  (PROD_ID);
CREATE        INDEX YOON.IX_T_ORDER_02 ON YOON.T_ORDER  (ORDER_DT, ORDER_QTY, PROD_ID);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_MANUF');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_PRODUCT');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_ORDER');


ALTER SESSION SET WORKAREA_SIZE_POLICY=AUTO;
