ALTER SESSION SET CURRENT_SCHEMA=YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;

DROP   TABLE ����̷�_71;
CREATE TABLE ����̷�_71 
  (  ��۹�ȣ             VARCHAR2(9)
   , ��۾�ü��ȣ         VARCHAR2(4)
   , �������             VARCHAR2(2)
   , ������ڱ����ڵ�     VARCHAR2(1)
   , ��ۿϷ��Ͻ�         DATE
   , ���ȸ���Ϸ��Ͻ�     DATE
   , ��ǰ��ۿϷ��Ͻ�     DATE
   , C1                   VARCHAR2(100)
   , C2                   VARCHAR2(100)
   , C3                   VARCHAR2(100)
   , C4                   VARCHAR2(100)
   , C5                   VARCHAR2(100)
   , C6                   VARCHAR2(100)
   , C7                   VARCHAR2(100)
   ) NOLOGGING;
   
INSERT /*+ APPEND */ INTO ����̷�_71
SELECT      'O' || LPAD(TO_CHAR(ROWNUM), 8, '0')                                                                 ��۹�ȣ
          , 'C' || LPAD(ROUND(DBMS_RANDOM.VALUE(1, 100)), 3, '0')                                                ��۾�ü��ȣ
          , TO_CHAR(ROUND(DBMS_RANDOM.VALUE(10, 99)))                                                            �������
          , TO_CHAR(MOD(ROWNUM, 3))                                                                              ������ڱ����ڵ� -- 0(��ۿϷ��Ͻ�), 1(���ȸ���Ϸ��Ͻ�), 2(��ǰ��ۿϷ��Ͻ�)
          , CASE WHEN MOD(ROWNUM, 3) = 0 THEN TO_DATE('20190131', 'YYYYMMDD') - DBMS_RANDOM.VALUE(0, 3650) END   ��ۿϷ��Ͻ�
          , CASE WHEN MOD(ROWNUM, 3) = 1 THEN TO_DATE('20190131', 'YYYYMMDD') - DBMS_RANDOM.VALUE(0, 3650) END   ���ȸ���Ϸ��Ͻ�
          , CASE WHEN MOD(ROWNUM, 3) = 2 THEN TO_DATE('20190131', 'YYYYMMDD') - DBMS_RANDOM.VALUE(0, 3650) END   ��ǰ��ۿϷ��Ͻ�
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

DROP   PUBLIC SYNONYM ����̷�_71;
CREATE PUBLIC SYNONYM ����̷�_71 FOR YOON.����̷�_71;   
   
ALTER TABLE ����̷�_71 
ADD CONSTRAINT PK_����̷�_71 PRIMARY KEY(��۹�ȣ);

CREATE INDEX IX10_����̷�_71
ON ����̷�_71(��۾�ü��ȣ, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '����̷�_71');