--1, 2��  ��� �Ʒ��� Query�� ����ϵ�  ��Ƽ������ ��Ʈ�� ����

ALTER SESSION SET STATISTICS_LEVEL = ALL;

SELECT    /*+  FIRST_ROWS LEADING(C) USE_NL(O)    INDEX(C) INDEX(O) */
          C.����ȣ, MAX(C.����) ����, MAX(C.�����ŷ��Ͻ�) �����ŷ��Ͻ�
        , AVG(O.�ֹ��ݾ�)  ����ֹ��ݾ�
        , MAX(O.�ֹ��ݾ�)  �ְ��ֹ��ݾ�
        , MIN(�ֹ��ݾ�)    �ּ��ֹ��ݾ�            
  FROM    ��_69 C
        , �ֹ�_69 O 
WHERE     C.�����ŷ��Ͻ� BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
 AND      O.����ȣ(+)  = C.����ȣ
 AND      O.�ŷ��Ͻ�(+)  BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
GROUP BY  C.����ȣ
;

/*
------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |             |      1 |        |       |       |   1000 |00:00:00.02 |    5979 |
|   1 |  HASH GROUP BY                       |             |      1 |  75859 |       |       |   1000 |00:00:00.02 |    5979 |
|   2 |   NESTED LOOPS OUTER                 |             |      1 |  94658 |       |       |   1000 |00:00:00.01 |    5979 |
|   3 |    TABLE ACCESS BY INDEX ROWID       | ��_69     |      1 |  75859 |       |       |   1000 |00:00:00.01 |    1006 |
|*  4 |     INDEX RANGE SCAN                 | IX_��_69_0|      1 |  75859 |       |       |   1000 |00:00:00.01 |       6 |
|   5 |    PARTITION RANGE ITERATOR          |             |   1000 |      1 |    14 |    15 |   1000 |00:00:00.01 |    4973 |
|   6 |     TABLE ACCESS BY LOCAL INDEX ROWID| �ֹ�_69     |   2000 |      1 |    14 |    15 |   1000 |00:00:00.01 |    4973 |
|*  7 |      INDEX RANGE SCAN                | PK_�ֹ�_69  |   2000 |      1 |    14 |    15 |   1000 |00:00:00.01 |    4024 |
------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("C"."�����ŷ��Ͻ�">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND "C"."�����ŷ��Ͻ�"<=TO_DATE(' 
              2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
   7 - access("O"."����ȣ"="C"."����ȣ" AND "O"."�ŷ��Ͻ�">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND 
              "O"."�ŷ��Ͻ�"<=TO_DATE(' 2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
 
*/

--2. ��ü���� ó��
SELECT    /*+  ALL_ROWS LEADING(C) USE_HASH(O)    INDEX(C) FULL(O) */
          C.����ȣ, MAX(C.����) ����, MAX(C.�����ŷ��Ͻ�) �����ŷ��Ͻ�
        , AVG(O.�ֹ��ݾ�)  ����ֹ��ݾ�
        , MAX(O.�ֹ��ݾ�)  �ְ��ֹ��ݾ�
        , MIN(�ֹ��ݾ�)    �ּ��ֹ��ݾ�            
  FROM    ��_69 C
        , �ֹ�_69 O 
WHERE     C.�����ŷ��Ͻ� BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
 AND      O.����ȣ(+)  = C.����ȣ
 AND      O.�ŷ��Ͻ�(+)  BETWEEN TO_DATE('20190515', 'YYYYMMDD')  AND TO_DATE('20190615', 'YYYYMMDD')
GROUP BY  C.����ȣ
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS PARTITION LAST'));

/*
 
 --2��
-----------------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Starts | E-Rows | Pstart| Pstop | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |      1 |        |       |       |   1000 |00:00:00.04 |    1592 |
|   1 |  HASH GROUP BY                |             |      1 |  75936 |       |       |   1000 |00:00:00.04 |    1592 |
|*  2 |   HASH JOIN OUTER             |             |      1 |  94776 |       |       |   1000 |00:00:00.03 |    1592 |
|   3 |    TABLE ACCESS BY INDEX ROWID| ��_69     |      1 |  75936 |       |       |   1000 |00:00:00.01 |     943 |
|*  4 |     INDEX RANGE SCAN          | IX_��_69_0|      1 |  75936 |       |       |   1000 |00:00:00.01 |       6 |
|   5 |    PARTITION RANGE ITERATOR   |             |      1 |    493K|    14 |    15 |   1000 |00:00:00.01 |     649 |
|*  6 |     TABLE ACCESS FULL         | �ֹ�_69     |      2 |    493K|    14 |    15 |   1000 |00:00:00.01 |     649 |
-----------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("O"."����ȣ"="C"."����ȣ")
   4 - access("C"."�����ŷ��Ͻ�">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND 
              "C"."�����ŷ��Ͻ�"<=TO_DATE(' 2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))
   6 - filter(("O"."�ŷ��Ͻ�">=TO_DATE(' 2019-05-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss') AND "O"."�ŷ��Ͻ�"<=TO_DATE(' 
              2019-06-15 00:00:00', 'syyyy-mm-dd hh24:mi:ss')))
 
 */