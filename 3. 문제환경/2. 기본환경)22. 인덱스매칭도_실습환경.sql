ALTER SESSION SET WORKAREA_SIZE_POLICY=MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 1000000000;

DROP TABLE YOON.T_CUST22;
CREATE TABLE YOON.T_CUST22
  (CUST_NO       VARCHAR2(7),
   CUS_NM        VARCHAR2(50),
   CUST_CD       VARCHAR2(3),
   FLAG          VARCHAR2(3),
   DIV          VARCHAR2(2),
   C1            VARCHAR2(30),
   C2            VARCHAR2(30),
   C3            VARCHAR2(30),
   C4            VARCHAR2(30),
   C5            VARCHAR2(30),
   CONSTRAINT PK_T_CUST22 PRIMARY KEY (CUST_NO)
  );

CREATE PUBLIC SYNONYM T_CUST22 FOR YOON.T_CUST22;

INSERT /*+ APPEND */ INTO T_CUST22
SELECT LPAD(TO_CHAR(ROWNUM), 7, '0')                                    CUST_NO
     , RPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 65000))), 10, '0')       CUS_NM
     , LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 2000))) || '0', 3, '0')  CUST_CD
     , LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 100))) || '0', 3, '0')   FLAG
     , LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 100)))  || '0', 2, '0')  DIV
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C1
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C2
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C3
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C4
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C5
FROM DUAL
CONNECT BY LEVEL <= 2000000
ORDER BY DBMS_RANDOM.RANDOM()
;

COMMIT;

CREATE INDEX YOON.IX_T_CUST22_01 ON YOON.T_CUST22(CUST_CD, FLAG, DIV);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CUST22');

ALTER SESSION SET WORKAREA_SIZE_POLICY=AUTO;