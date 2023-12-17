/*  DT   : �Ϸ���� 100���� (DT CARDINALITY 1,000,000)
    CNO  : �Ϸ���� 3��
    PRCD : �Ϸ���� 100��
    
�ε��� : PK �� ���� (CNO + DT, SEQ, PRCD)
*/
ALTER SESSION SET WORKAREA_SIZE_POLICY='MANUAL';
ALTER SESSION SET SORT_AREA_SIZE=2000000000;

DROP TABLE YOON.T_TAB64 ;
CREATE TABLE YOON.T_TAB64 
  ( CNO    NUMBER         NOT NULL
  , DT     VARCHAR2(8)    NOT NULL
  , SEQ    NUMBER         NOT NULL
  , PRCD   VARCHAR2(7)    NOT NULL
  , ORDQ   NUMBER
  , ORDP   NUMBER
  , DCSSCD VARCHAR2(7)  
  , CLCD   VARCHAR2(7)
  , CONSTRAINT PK_T_64 PRIMARY KEY(CNO, DT, SEQ, PRCD)
  ) NOLOGGING;
  
INSERT /*+ APPEND */ INTO YOON.T_TAB64 A 
SELECT A.CNO,  B.DT
     , ROW_NUMBER() OVER (PARTITION BY A.CNO, B.DT  ORDER BY PRCD)   SEQ
     , PRCD
     , TRUNC(DBMS_RANDOM.VALUE(1, 10))                               ORDQ
     , TRUNC(DBMS_RANDOM.VALUE(100000, 500000))                      ORDP 
     , 'D' || TO_CHAR(50000 - TO_NUMBER(SUBSTR(PRCD, 2)))            DSSCD
     , 'D' || TO_CHAR(50000 - TO_NUMBER(SUBSTR(PRCD, 2)))            CLCD
FROM (SELECT MOD(ROWNUM, 333333)+1                                     CNO
          ,  'P' || LPAD(MOD(ROWNUM, 100000) +1, 6, '0')                PRCD 
      FROM DUAL
      CONNECT BY LEVEL <= 1000000
     ) A,
     (SELECT TO_CHAR(TO_DATE('20171231', 'YYYYMMDD') + ROWNUM, 'YYYYMMDD') DT 
      FROM DUAL
      CONNECT BY LEVEL <= 50
     ) B
;

COMMIT;

ALTER SESSION SET WORKAREA_SIZE_POLICY='AUTO';
CREATE PUBLIC SYNONYM T_TAB64 FOR YOON.T_TAB64;

/*
SELECT * FROM DBA_TEMP_FILES;

ALTER TEMP FILE 'C:\APP\SEO\ORADATA\ORCLL\TEMP01.DBF'
RESIZE 327670M;

ALTER TABLESPACE TEMP
ADD TEMPFILE 'C:\APP\SEO\ORADATA\ORCLL\TEMP02.DBF' SIZE 10240M;
*/


SELECT * FROM T_TAB64 WHERE ROWNUM <= 100;

select  *
from t_tab64
where dt = '20180101'
;

select *
from t_tab64
where prcd = 'P100000'
 and  dt = '20180101'
;
