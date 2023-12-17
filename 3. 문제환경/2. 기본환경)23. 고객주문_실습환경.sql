DROP   TABLE YOON.T_绊按23;
CREATE TABLE YOON.T_绊按23
  (绊按锅龋      VARCHAR2(7),
   绊按疙        VARCHAR2(50),
   绊按己氢内靛  VARCHAR2(3),
   C1            VARCHAR2(30),
   C2            VARCHAR2(30),
   C3            VARCHAR2(30),
   C4            VARCHAR2(30),
   C5            VARCHAR2(30),
   CONSTRAINT PK_T_绊按23 PRIMARY KEY (绊按锅龋)
  );

CREATE PUBLIC SYNONYM T_绊按23 FOR YOON.T_绊按23;

INSERT /*+ APPEND */ INTO T_绊按23
SELECT LPAD(TO_CHAR(ROWNUM), 7, '0')                                    绊按锅龋
     , RPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 65000))), 10, '0')       绊按疙
     , LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 200))) || '0', 3, '0')   绊按己氢内靛
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C1
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C2
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C3
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C4
     , 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                                     C5
FROM DUAL
CONNECT BY LEVEL <= 20000
ORDER BY DBMS_RANDOM.RANDOM();;

COMMIT;

DROP   TABLE YOON.T_DATE23;
CREATE TABLE YOON.T_DATE23 AS
SELECT TO_CHAR(TO_DATE('20170101', 'YYYYMMDD') + LEVEL, 'YYYYMMDD') WORK_DATE
FROM DUAL
CONNECT BY LEVEL <= 100
ORDER BY DBMS_RANDOM.RANDOM();

CREATE PUBLIC SYNONYM T_DATE23 FOR YOON.T_DATE23;

DROP TABLE  YOON.T_林巩23 ;
CREATE TABLE YOON.T_林巩23 AS
SELECT  'O' || LPAD(TO_CHAR(ROWNUM), 7, '0')                                    林巩锅龋
      ,  C.绊按锅龋
      , 'P' || LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 200))) || '0', 3, '0')   惑前内靛
      ,  D.WORK_DATE                                                            林巩老磊
      , ROUND(DBMS_RANDOM.VALUE(1, 3))                                          林巩荐樊        
FROM T_绊按23 C, T_DATE23 D
ORDER BY DBMS_RANDOM.RANDOM();;

CREATE PUBLIC SYNONYM T_林巩23 FOR YOON.T_林巩23;

ALTER TABLE YOON.T_林巩23 
ADD CONSTRAINT PK_T_林巩23 PRIMARY KEY(林巩锅龋)
;

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_绊按23');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_林巩23');
