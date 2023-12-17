
/*  2��

�ֹ� 
   �ֹ���ȣ(PK)
   ȸ����ȣ
   �ֹ�����
   ~~~
   (�ε��� : PK_�ֹ�(�ֹ���ȣ), IX01_�ֹ�(ȸ����ȣ))
   
�ֹ��̷�
   �ֹ��̷¹�ȣ(PK)
   �ֹ���ȣ(FK)
   (�ε��� : PK_�ֹ��̷�(�ֹ��̷¹�ȣ), IX01_�ֹ��̷�(�ֹ���ȣ))
   
�����̷�
   �����̷¹�ȣ(PK)
   �ֹ��̷¹�ȣ(FK)
   ī���ȣ
   ��������
   ~~~
   (�ε��� : PK_�����̷�(�����̷¹�ȣ), IX01_�����̷�(�ֹ��̷¹�ȣ), IX02_�����̷�(��������)
�ֹ������� �Է� �� ���� ���� ī���ȣ ã�ƾ� �� 
 - �� ���� �Ұ�
 - �ε��� ���� ����
 - SQL ���� ����
 - ��Ʈ�� ���μ���, ���ι��, �ε��� ���ø� ���� ����
*/
ALTER SESSION SET CURRENT_SCHEMA=YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE=2000000000;

CREATE  TABLE �ֹ�_72
   (  �ֹ���ȣ           VARCHAR2(9)
    , ȸ����ȣ           VARCHAR2(9)
    , �ֹ������ڵ�       VARCHAR2(2)
    , C1                 VARCHAR2(100)
    , C2                 VARCHAR2(100)
    , C3                 VARCHAR2(100)
    , C4                 VARCHAR2(100)
    , C5                 VARCHAR2(100)
    , CONSTRAINT PK_�ֹ�_72 PRIMARY KEY(�ֹ���ȣ)) NOLOGGING;
 
CREATE TABLE �ֹ��̷�_72
    (  �ֹ��̷¹�ȣ      VARCHAR2(10)
     , �ֹ���ȣ          VARCHAR2(9)
     , CONSTRAINT PK_�ֹ��̷�_72 PRIMARY KEY(�ֹ��̷¹�ȣ)
    ) NOLOGGING;
    
CREATE TABLE �����̷�_72
    (  �����̷¹�ȣ     VARCHAR2(10)
     , �ֹ��̷¹�ȣ     VARCHAR2(9)
     , ī���ȣ         VARCHAR2(10)
     , ��������         VARCHAR2(8)
     , C1                 VARCHAR2(100)
     , C2                 VARCHAR2(100)
     , C3                 VARCHAR2(100)
     , C4                 VARCHAR2(100)
     , C5                 VARCHAR2(100)
     , CONSTRAINT PK_�����̷�_72 PRIMARY KEY(�����̷¹�ȣ)) NOLOGGING;

DROP PUBLIC SYNONYM �ֹ�_72     ;
DROP PUBLIC SYNONYM �ֹ��̷�_72 ;
DROP PUBLIC SYNONYM �����̷�_72 ;

CREATE PUBLIC SYNONYM �ֹ�_72     FOR YOON.�ֹ�_72;
CREATE PUBLIC SYNONYM �ֹ��̷�_72 FOR YOON.�ֹ��̷�_72;
CREATE PUBLIC SYNONYM �����̷�_72 FOR YOON.�����̷�_72;

INSERT /*+ APPEND */ INTO �ֹ�_72
SELECT   'O' || LPAD(ROWNUM, 7, '0')                                �ֹ���ȣ
       , 'C' || LPAD(ROUND(DBMS_RANDOM.VALUE(1, 50000)), 5, '0')    ȸ����ȣ
       , TO_CHAR(ROUND(DBMS_RANDOM.VALUE(11,20)))                   �ֹ������ڵ�
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C1
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C2
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C3
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C4
       , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                     C5       
FROM   DUAL
CONNECT BY LEVEL <= 1000000
ORDER BY DBMS_RANDOM.RANDOM()
;

CREATE INDEX IX01_�ֹ�_72 ON �ֹ�_72(ȸ����ȣ);

  
INSERT /*+ APPEND */ INTO �ֹ��̷�_72
SELECT   �ֹ���ȣ || TO_CHAR(LVL)                     �ֹ��̷¹�ȣ
       , �ֹ���ȣ                                   
FROM     �ֹ�_72
    ,    (SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 2) 
ORDER BY DBMS_RANDOM.RANDOM()
;

CREATE INDEX IX01_�ֹ��̷�_72 ON �ֹ��̷�_72(�ֹ���ȣ);

INSERT  /*+ APPEND */ INTO �����̷�_72
SELECT  �ֹ��̷¹�ȣ || LVL                                                               �����̷¹�ȣ
      , �ֹ��̷¹�ȣ
      , 'CARD' || LPAD((ROUND(DBMS_RANDOM.VALUE(1,10000))), 5, '0')                       ī���ȣ
      , TO_CHAR(TO_DATE('20191130', 'YYYYMMDD') - DBMS_RANDOM.VALUE(1, 100), 'YYYYMMDD')  �������� 
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C1
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C2
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C3
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C4
      , 'FDSAASDFFDSAASDFFD' || TO_CHAR(ROWNUM)                                           C5       
FROM    �ֹ��̷�_72
      , (SELECT LEVEL LVL FROM DUAL CONNECT BY  LEVEL <= 2)
ORDER BY DBMS_RANDOM.RANDOM()
;

CREATE INDEX IX01_�����̷�_72 ON �����̷�_72(�ֹ��̷¹�ȣ);
CREATE INDEX IX02_�����̷�_72 ON �����̷�_72(��������);


EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '�ֹ�_72');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '�ֹ��̷�_72');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '�����̷�_72');


