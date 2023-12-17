/*
1. Į�� �߰��ϴ� ��� : 2��
   1-1. Į���߰� : ������ڱ����ڵ�
        ��ۿϷ��Ͻð�    NOT NULL �̸� '0'
        ���ȸ���Ϸ��Ͻ�  NOT NULL �̸� '1'
        ��ǰ��ۿϷ��Ͻ�  NOT NULL �̸� '2'
   1-2. Į�� �߰����� �ʴ� ��� : 1, 3��
   �� ������ ��� ��� �����Դϴ�.
      ������ Į���� �߰����� �ʰ� SQL�� �ܼ��� 3���� ���� ���׿�.  ^^

2. �ε������� : IX10_����̷�_71(��۾�ü��ȣ, �������, ���ȸ����ǰ�Ϸ�����);
    - IX10_����̷�_71 : ����(��۾�ü��ȣ, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�) + �߰�(�������, ������ڱ����ڵ�)

3. SQL ����
*/
ALTER SESSION SET CURRENT_SCHEMA=YOON;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;

DROP   INDEX IX10_����̷�_71;
CREATE INDEX IX10_����̷�_71
--ON ����̷�_71(��۾�ü��ȣ, �������, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�, ������ڱ����ڵ� ); --  ������ INDEX
ON ����̷�_71( ��۾�ü��ȣ, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�, �������, ������ڱ����ڵ�);


EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '����̷�_71');

ALTER SESSION SET STATISTICS_LEVEL=ALL;

--------------------  
--- 1.�� UNION ALL 
SELECT    ��۹�ȣ, ��۾�ü��ȣ, �������, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�
       ,  C1, C2
FROM      ����̷�_71
WHERE     ��۾�ü��ȣ = 'C033'  
 AND      �������     = '82' 
 AND      ��ۿϷ��Ͻ�     BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
 AND      ���ȸ���Ϸ��Ͻ� IS NULL
 AND      ��ǰ��ۿϷ��Ͻ� IS NULL
UNION ALL
SELECT    ��۹�ȣ, ��۾�ü��ȣ, �������, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�
       ,  C1, C2
FROM      ����̷�_71
WHERE     ��۾�ü��ȣ = 'C033'  
 AND      �������     = '82' 
 AND      ��ۿϷ��Ͻ�     IS NULL
 AND      ���ȸ���Ϸ��Ͻ� BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
 AND      ��ǰ��ۿϷ��Ͻ� IS NULL
UNION ALL
SELECT    ��۹�ȣ, ��۾�ü��ȣ, �������, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�
       ,  C1, C2
FROM      ����̷�_71
WHERE     ��۾�ü��ȣ = 'C033'  
 AND      �������     = '82' 
 AND      ��ۿϷ��Ͻ�     IS NULL
 AND      ���ȸ���Ϸ��Ͻ� IS NULL
 AND      ��ǰ��ۿϷ��Ͻ� BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
;

--  2. ������ڱ����ڵ带 �߰��Ͽ� Ȱ��
SELECT    /*+ USE_CONCAT */
          ��۹�ȣ, ��۾�ü��ȣ, �������, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�
       ,  C1, C2
FROM      ����̷�_71
WHERE     ��۾�ü��ȣ = 'C033'  
 AND      �������     = '82' 
 AND      (
             (     ������ڱ����ڵ� = '0' 
               AND ��ۿϷ��Ͻ�     BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND ���ȸ���Ϸ��Ͻ� IS NULL
               AND ��ǰ��ۿϷ��Ͻ� IS NULL
              )
           OR
           (     ������ڱ����ڵ�   = '1' 
               AND ��ۿϷ��Ͻ�     IS NULL
               AND ���ȸ���Ϸ��Ͻ� BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND ��ǰ��ۿϷ��Ͻ� IS NULL
              )
           OR(     ������ڱ����ڵ� = '2' 
               AND ��ۿϷ��Ͻ�     IS NULL
               AND ���ȸ���Ϸ��Ͻ� IS NULL
               AND ��ǰ��ۿϷ��Ͻ� BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
              )

          )
;


--  3. �ƹ� Į���� �߰����� �ʰ�
SELECT    /*+ USE_CONCAT */
          ��۹�ȣ, ��۾�ü��ȣ, �������, ��ۿϷ��Ͻ�, ���ȸ���Ϸ��Ͻ�, ��ǰ��ۿϷ��Ͻ�
       ,  C1, C2
FROM      ����̷�_71
WHERE     ��۾�ü��ȣ = 'C033'  
 AND      �������     = '82' 
 AND      (
             (     ��ۿϷ��Ͻ�     BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND ���ȸ���Ϸ��Ͻ� IS NULL
               AND ��ǰ��ۿϷ��Ͻ� IS NULL
              )
           OR
           (       ��ۿϷ��Ͻ�     IS NULL
               AND ���ȸ���Ϸ��Ͻ� BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
               AND ��ǰ��ۿϷ��Ͻ� IS NULL
              )
           OR(     ��ۿϷ��Ͻ�     IS NULL
               AND ���ȸ���Ϸ��Ͻ� IS NULL
               AND ��ǰ��ۿϷ��Ͻ� BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
              )

          )
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));

/*
-- ���� ��
---------------------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |      1 |        |      6 |00:00:00.16 |    1244 |   1229 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      6 |      6 |00:00:00.16 |    1244 |   1229 |
|*  2 |   INDEX RANGE SCAN          | IX10_����̷�|      1 |    820 |    873 |00:00:00.09 |     371 |    369 |
---------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("�������"='82')
   2 - access("��۾�ü��ȣ"='C033')
       filter((("��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss')) OR ("��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss')) OR ("���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101') AND "���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 
              2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))))
 
--- 1.�� UNION ALL 
-----------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
-----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |      1 |        |      6 |00:00:00.01 |      20 |     15 |
|   1 |  UNION-ALL                    |              |      1 |        |      6 |00:00:00.01 |      20 |     15 |
|*  2 |   FILTER                      |              |      1 |        |      2 |00:00:00.01 |       7 |      5 |
|   3 |    TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      1 |      2 |00:00:00.01 |       7 |      5 |
|*  4 |     INDEX RANGE SCAN          | IX10_����̷�|      1 |      1 |      2 |00:00:00.01 |       5 |      3 |
|*  5 |   FILTER                      |              |      1 |        |      2 |00:00:00.01 |       6 |      5 |
|   6 |    TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      1 |      2 |00:00:00.01 |       6 |      5 |
|*  7 |     INDEX RANGE SCAN          | IX10_����̷�|      1 |      1 |      2 |00:00:00.01 |       4 |      3 |
|*  8 |   FILTER                      |              |      1 |        |      2 |00:00:00.01 |       7 |      5 |
|   9 |    TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      1 |      2 |00:00:00.01 |       7 |      5 |
|* 10 |     INDEX RANGE SCAN          | IX10_����̷�|      1 |      1 |      2 |00:00:00.01 |       5 |      3 |
-----------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter(TO_DATE('20190101')<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
   4 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "���ȸ���Ϸ��Ͻ�" IS NULL AND "��ǰ��ۿϷ��Ͻ�" IS 
              NULL AND "�������"='82' AND "������ڱ����ڵ�"='0' AND "��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss'))
       filter(("�������"='82' AND "���ȸ���Ϸ��Ͻ�" IS NULL AND "��ǰ��ۿϷ��Ͻ�" IS NULL AND "������ڱ����ڵ�"='0'))
   5 - filter(TO_DATE('20190101')<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
   7 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�" IS NULL AND "���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101') AND "��ǰ��ۿϷ��Ͻ�" IS 
              NULL AND "�������"='82' AND "������ڱ����ڵ�"='1' AND "���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss'))
       filter(("�������"='82' AND "��ǰ��ۿϷ��Ͻ�" IS NULL AND "������ڱ����ڵ�"='1' AND "���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101') 
              AND "���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
   8 - filter(TO_DATE('20190101')<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
  10 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�" IS NULL AND "���ȸ���Ϸ��Ͻ�" IS NULL AND 
              "��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "�������"='82' AND "������ڱ����ڵ�"='2' AND "��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("�������"='82' AND "���ȸ���Ϸ��Ͻ�" IS NULL AND "������ڱ����ڵ�"='2' AND "��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101') 
              AND "��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
 
--  2. ������ڱ����ڵ带 �߰��Ͽ� Ȱ��
-------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |              |      1 |        |      6 |00:00:00.01 |      20 |
|   1 |  CONCATENATION               |              |      1 |        |      6 |00:00:00.01 |      20 |
|   2 |   TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      1 |      2 |00:00:00.01 |       7 |
|*  3 |    INDEX RANGE SCAN          | IX10_����̷�|      1 |      1 |      2 |00:00:00.01 |       5 |
|*  4 |   TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      1 |      2 |00:00:00.01 |       6 |
|*  5 |    INDEX RANGE SCAN          | IX10_����̷�|      1 |      1 |      2 |00:00:00.01 |       4 |
|*  6 |   TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      1 |      2 |00:00:00.01 |       7 |
|*  7 |    INDEX RANGE SCAN          | IX10_����̷�|      1 |      1 |      2 |00:00:00.01 |       5 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�" IS NULL AND "���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101') AND 
              "��ǰ��ۿϷ��Ͻ�" IS NULL AND "�������"='82' AND "������ڱ����ڵ�"='1' AND "���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("�������"='82' AND "��ǰ��ۿϷ��Ͻ�" IS NULL AND "������ڱ����ڵ�"='1' AND 
              "���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101') AND "���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss')))
   4 - filter((LNNVL("��ۿϷ��Ͻ�" IS NULL) OR LNNVL("��ǰ��ۿϷ��Ͻ�" IS NULL) OR LNNVL("������ڱ����ڵ�"='1') 
              OR LNNVL("���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101')) OR LNNVL("���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))))
   5 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "���ȸ���Ϸ��Ͻ�" IS NULL AND 
              "��ǰ��ۿϷ��Ͻ�" IS NULL AND "�������"='82' AND "������ڱ����ڵ�"='0' AND "��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("�������"='82' AND "���ȸ���Ϸ��Ͻ�" IS NULL AND "��ǰ��ۿϷ��Ͻ�" IS NULL AND "������ڱ����ڵ�"='0'))
   6 - filter(((LNNVL("���ȸ���Ϸ��Ͻ�" IS NULL) OR LNNVL("��ǰ��ۿϷ��Ͻ�" IS NULL) OR 
              LNNVL("������ڱ����ڵ�"='0') OR LNNVL("��ۿϷ��Ͻ�">=TO_DATE('20190101')) OR LNNVL("��ۿϷ��Ͻ�"<=TO_DATE(' 
              2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))) AND (LNNVL("��ۿϷ��Ͻ�" IS NULL) OR 
              LNNVL("��ǰ��ۿϷ��Ͻ�" IS NULL) OR LNNVL("������ڱ����ڵ�"='1') OR LNNVL("���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101')) 
              OR LNNVL("���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))))
   7 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�" IS NULL AND "���ȸ���Ϸ��Ͻ�" IS NULL AND 
              "��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "�������"='82' AND "������ڱ����ڵ�"='2' AND "��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 
              2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("�������"='82' AND "���ȸ���Ϸ��Ͻ�" IS NULL AND "������ڱ����ڵ�"='2' AND 
              "��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss')))
              
 --  3. �ƹ� Į���� �߰����� �ʰ�             
-------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name         | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |              |      1 |        |      6 |00:00:00.01 |      20 |
|   1 |  CONCATENATION               |              |      1 |        |      6 |00:00:00.01 |      20 |
|   2 |   TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      2 |      2 |00:00:00.01 |       7 |
|*  3 |    INDEX RANGE SCAN          | IX10_����̷�|      1 |      2 |      2 |00:00:00.01 |       5 |
|*  4 |   TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      2 |      2 |00:00:00.01 |       7 |
|*  5 |    INDEX RANGE SCAN          | IX10_����̷�|      1 |      2 |      2 |00:00:00.01 |       5 |
|*  6 |   TABLE ACCESS BY INDEX ROWID| ����̷�_71  |      1 |      2 |      2 |00:00:00.01 |       6 |
|*  7 |    INDEX RANGE SCAN          | IX10_����̷�|      1 |      2 |      2 |00:00:00.01 |       4 |
-------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�" IS NULL AND "���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101') AND 
              "��ǰ��ۿϷ��Ͻ�" IS NULL AND "�������"='82' AND "���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))
       filter(("�������"='82' AND "��ǰ��ۿϷ��Ͻ�" IS NULL AND "���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101') AND 
              "���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
   4 - filter((LNNVL("��ۿϷ��Ͻ�" IS NULL) OR LNNVL("��ǰ��ۿϷ��Ͻ�" IS NULL) OR 
              LNNVL("���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101')) OR LNNVL("���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))))
   5 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�" IS NULL AND "���ȸ���Ϸ��Ͻ�" IS NULL AND 
              "��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "�������"='82' AND "��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 
              23:59:59', 'syyyy-mm-dd hh24:mi:ss'))
       filter(("�������"='82' AND "���ȸ���Ϸ��Ͻ�" IS NULL AND "��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101') AND 
              "��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd hh24:mi:ss')))
   6 - filter(((LNNVL("���ȸ���Ϸ��Ͻ�" IS NULL) OR LNNVL("��ۿϷ��Ͻ�" IS NULL) OR 
              LNNVL("��ǰ��ۿϷ��Ͻ�">=TO_DATE('20190101')) OR LNNVL("��ǰ��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss'))) AND (LNNVL("��ۿϷ��Ͻ�" IS NULL) OR LNNVL("��ǰ��ۿϷ��Ͻ�" IS NULL) OR 
              LNNVL("���ȸ���Ϸ��Ͻ�">=TO_DATE('20190101')) OR LNNVL("���ȸ���Ϸ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 
              'syyyy-mm-dd hh24:mi:ss')))))
   7 - access("��۾�ü��ȣ"='C033' AND "��ۿϷ��Ͻ�">=TO_DATE('20190101') AND "���ȸ���Ϸ��Ͻ�" IS NULL AND 
              "��ǰ��ۿϷ��Ͻ�" IS NULL AND "�������"='82' AND "��ۿϷ��Ͻ�"<=TO_DATE(' 2019-01-31 23:59:59', 'syyyy-mm-dd 
              hh24:mi:ss'))
       filter(("�������"='82' AND "���ȸ���Ϸ��Ͻ�" IS NULL AND "��ǰ��ۿϷ��Ͻ�" IS NULL))
 
 
*/