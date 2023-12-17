--�ֹ�         500����
--�ֹ���ǰ     600����
--�Ϲ��ֹ�     100��
--�Ϻ��ֹ���ǰ 120��
--��ǰ A% ��ü 15%

-----------------------------------------------------------------------
--  DDL
-----------------------------------------------------------------------
DROP TABLE YOON.��_56  ;

CREATE TABLE YOON.��_56 
  (����ȣ   VARCHAR2(6),
   ����     VARCHAR2(50),
   ����ó     VARCHAR2(20),
   CONSTRAINT ��_56_PK PRIMARY KEY (����ȣ)
   );


DROP TABLE YOON.�ֹ�_56 ;
CREATE TABLE YOON.�ֹ�_56 
  (�ֹ���ȣ  VARCHAR2(8),
   ����ȣ  VARCHAR2(6),
   �ֹ�����  VARCHAR2(8),
   �ֹ��ݾ�  NUMBER,
   CONSTRAINT �ֹ�_56_PK PRIMARY KEY(�ֹ���ȣ)
   );


DROP INDEX YOON.�ֹ�_56_X01 ;
CREATE INDEX YOON.�ֹ�_56_X01 ON YOON.�ֹ�_56(�ֹ�����);

DROP INDEX YOON.�ֹ�_56_X02;
CREATE INDEX YOON.�ֹ�_56_X02 ON YOON.�ֹ�_56(����ȣ, �ֹ�����);
 

DROP TABLE YOON.�ֹ���ǰ_56;
CREATE TABLE YOON.�ֹ���ǰ_56
   (�ֹ���ȣ  VARCHAR2(8),
    �Ϸù�ȣ  NUMBER,
    ��ǰ��ȣ  VARCHAR2(4),
    CONSTRAINT �ֹ���ǰ_56_PK PRIMARY KEY(�ֹ���ȣ, �Ϸù�ȣ)
    );


DROP TABLE YOON.��ǰ_56;
CREATE TABLE YOON.��ǰ_56
   (��ǰ��ȣ  VARCHAR2(4),
    ��ǰ��    VARCHAR2(20),
    CONSTRAINT ��ǰ_56_PK PRIMARY KEY(��ǰ��ȣ)
    );

DROP PUBLIC SYNONYM  ��_56    ; 
DROP PUBLIC SYNONYM  �ֹ�_56    ;
DROP PUBLIC SYNONYM  �ֹ���ǰ_56;
DROP PUBLIC SYNONYM  ��ǰ_56    ;
CREATE PUBLIC SYNONYM  ��_56       FOR     YOON.��_56     ; 
CREATE PUBLIC SYNONYM  �ֹ�_56       FOR     YOON.�ֹ�_56     ;
CREATE PUBLIC SYNONYM  �ֹ���ǰ_56   FOR     YOON.�ֹ���ǰ_56 ;
CREATE PUBLIC SYNONYM  ��ǰ_56       FOR     YOON.��ǰ_56     ;


--------- ��
INSERT /*+ APPEND */ INTO ��_56
SELECT LPAD(TO_CHAR(LEVEL), 6, '0')  ����ȣ,
       LPAD(TO_CHAR(LEVEL), 10, 'A') ����,
       '01012341234'                  ����ó
FROM DUAL
CONNECT BY LEVEL <= 100
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

--------- ��ǰ
INSERT /*+ APPEND */ INTO ��ǰ_56
SELECT CASE WHEN LEVEL <= 15 THEN LPAD(TO_CHAR(LEVEL), 4, 'A') 
                              ELSE LPAD(TO_CHAR(LEVEL), 4, '0')
       END ��ǰ��ȣ,
       LPAD(TO_CHAR(LEVEL), 4, '0') ��ǰ��
FROM DUAL
CONNECT BY LEVEL <= 100
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;


--------- �ֹ�
INSERT /*+ APPEND */ INTO �ֹ�_56
SELECT LPAD(TO_CHAR(ROWNUM), 7, '0')               �ֹ���ȣ,
       LPAD(TO_CHAR(MOD(ROWNUM, 100)+1), 6, '0')   ����ȣ,
       A.�ֹ�����, 
       MOD(ROWNUM, 100) + 10000                    �ֹ��ݾ�
FROM  ( 
       SELECT TO_CHAR(SYSDATE - (49000 - ROWNUM), 'YYYYMMDD') �ֹ����� 
       FROM DUAL
       CONNECT BY LEVEL <=50000
       ) A,
       (SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 100) -- 1�� 100�� �ֹ�
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

--------- �ֹ���ǰ
INSERT /*+ APPEND */ INTO �ֹ���ǰ_56
SELECT A.�ֹ���ȣ, 1 �Ϸù�ȣ, B.��ǰ��ȣ
FROM (SELECT MOD(ROWNUM, 100)+1 R_NUM, �ֹ���ȣ FROM �ֹ�_56 ) A,
     (SELECT ROWNUM R_NUM, ��ǰ��ȣ FROM ��ǰ_56) B
WHERE B.R_NUM = A.R_NUM
UNION ALL
SELECT A.�ֹ���ȣ, 2 �Ϸù�ȣ, B.��ǰ��ȣ
FROM (SELECT MOD(ROWNUM, 100)+1 R_NUM, �ֹ���ȣ FROM �ֹ�_56 WHERE MOD(TO_NUMBER(�ֹ���ȣ), 5) = 0 ) A,
     (SELECT ROWNUM R_NUM, ��ǰ��ȣ FROM ��ǰ_56) B
WHERE B.R_NUM = A.R_NUM
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;


SELECT COUNT(*) FROM �ֹ�_56; 
--5,000,000
SELECT COUNT(*) FROM �ֹ���ǰ_56;
--6,000,000
SELECT COUNT(*) FROM ��ǰ_56; 
--100


/*
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '��_56');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '�ֹ���ǰ_56');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '�ֹ�_56');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '��ǰ_56');
*/