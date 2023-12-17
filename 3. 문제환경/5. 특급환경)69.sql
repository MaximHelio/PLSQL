/*
��_69    100����
  ����ȣ      VARCHAR2(10)
  ����        VARCHAR2(50)
  �����ŷ��Ͻ�  DATE
  ��Ÿ ���
�ε���
   - PK      : ����ȣ
   - �ε���1 : �����ŷ��Ͻ�

�ֹ�
  �ֹ���ȣ      VARCHAR2(10)
  ����ȣ      VARCHAR2(10)
  �ŷ��Ͻ�      DATE
  ��Ÿ���
�� �ֹ��Ͻ� Į���� ���� ��Ƽ�� ����
�ε��� 
  - ����ȣ + �ŷ��Ͻ�
  - �ŷ��Ͻ�

����1) �Ʒ��� Query�� �̿��Ͽ� OLTP�� �κй��� ó���� ����ȭ�Ͽ� Ʃ���ϼ���.
����2) �Ʒ��� Query�� �̿��Ͽ� Batch ���α׷��� ����ȭ�Ͽ� Ʃ���ϼ���.
�� ���� ��� ��Ƽ������ ��Ʈ�� Ȱ���Ͽ� �����ȹ�� ���� �ϼ���.
*/

ALTER SESSION SET CURRENT_SCHEMA = YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY=MANUAL;
ALTER SESSION SET SORT_AREA_SIZE=1000000000;

DROP   TABLE ��_69 ;
CREATE TABLE ��_69 NOLOGGING  AS --    100����
SELECT      'C' || LPAD(LEVEL, 9, 0)                                              ����ȣ
         ,  'FDAASDFFDSA' || LPAD(LEVEL, 9, 0)                                    ����
         ,  TO_DATE('20190515', 'YYYYMMDD') + 
              CASE WHEN ROWNUM <= 1000  THEN ROUND(DBMS_RANDOM.VALUE(1, 30), 3)
                                        ELSE ROUND(DBMS_RANDOM.VALUE(-1, -365), 3) 
              END                                                                 �����ŷ��Ͻ�
         ,  'ASDFFDSASDFFDSASDF'                                                  C1
         ,  'ASDFFDSASDFFDSASDF'                                                  C2
         ,  'ASDFFDSASDFFDSASDF'                                                  C3
FROM DUAL
CONNECT BY LEVEL <= 1000000
ORDER BY DBMS_RANDOM.RANDOM()
;

ALTER TABLE ��_69
ADD CONSTRAINT PK_��_69 PRIMARY KEY(����ȣ);

CREATE INDEX IX_��_69_01 ON ��_69(�����ŷ��Ͻ�);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '��_69');

-- CREATE PUBLIC SYNONYM ��_69 FOR YOON.��_69;

DROP   TABLE �ֹ�_69;
CREATE TABLE �ֹ�_69
  (  ����ȣ      VARCHAR2(10)
   , �ֹ���ȣ      VARCHAR2(10)
   , �ŷ��Ͻ�      DATE
   , �ֹ��ݾ�      NUMBER
   , C1            VARCHAR2(30)
   , C2            VARCHAR2(30)
   , C3            VARCHAR2(30)
   , C4            VARCHAR2(30)
   , CONSTRAINT PK_�ֹ�_69 PRIMARY KEY(����ȣ, �ŷ��Ͻ�) 
     USING INDEX LOCAL
  ) NOLOGGING
  PARTITION BY RANGE(�ŷ��Ͻ�)
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

INSERT /*+ APPEND */ INTO �ֹ�_69
SELECT     C.����ȣ
         , 'O' || LPAD(ROWNUM, 9, 0)                    �ֹ���ȣ
         , ADD_MONTHS(C.�����ŷ��Ͻ�, (O.LVL-1) * -1)   �ŷ��Ͻ�
         , ROWNUM + 10000                               �ֹ��ݾ�
         , 'ASDFFDSAASDFFDSAASDF'                       C1 
         , 'ASDFFDSAASDFFDSAASDF'                       C2 
         , 'ASDFFDSAASDFFDSAASDF'                       C3 
         , 'ASDFFDSAASDFFDSAASDF'                       C4 
FROM       ��_69 C,
           (SELECT LEVEL LVL
            FROM DUAL
            CONNECT BY LEVEL <= 12) O 
ORDER BY DBMS_RANDOM.RANDOM() ;
COMMIT;

--CREATE PUBLIC SYNONYM �ֹ�_69 FOR YOON.�ֹ�_69;

--DROP   INDEX IX_�ֹ�_69_01 ;
CREATE INDEX IX_�ֹ�_69_01 ON �ֹ�_69(�ŷ��Ͻ�) LOCAL ;
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '�ֹ�_69') ;

  
/*  
SELECT    C.����ȣ, C.����, C.�����ŷ��Ͻ�
        , (SELECT AVG(�ֹ��ݾ�) 
           FROM   �ֹ�_69
           WHERE  �ŷ��Ͻ� >= TRUNC(ADD_MONTHS(SYSDATE, -1))
            AND   ����ȣ = C.����ȣ)  ����ֹ��ݾ�
        , (SELECT MAX(�ֹ��ݾ�) 
           FROM   �ֹ�_69
           WHERE  �ŷ��Ͻ� >= TRUNC(ADD_MONTHS(SYSDATE, -1))
            AND   ����ȣ = C.����ȣ)  �ְ��ֹ��ݾ�
        , (SELECT MIN(�ֹ��ݾ�) 
           FROM   �ֹ��ֹ�_69
           WHERE  �ŷ��Ͻ� >= TRUNC(ADD_MONTHS(SYSDATE, -1))
            AND   ����ȣ = C.����ȣ)  �ּ��ֹ��ݾ�            
  FROM    ��_69 C
WHERE     C.�����ŷ��Ͻ� >= TRUNC(ADD_MONTHS(SYSDATE, -1))
;
*/

