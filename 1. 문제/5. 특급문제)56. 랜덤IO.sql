/*
���̺� ���� 
��_56(10,000��, ���� �׽�Ʈ �����ʹ� 100�Ǹ� ���������, 1�������� �����ϰ�...)
   ����ȣ     VARCHAR2(6)   <== PK
   ����      VARCHAR2(50)
   ����ó      VARCHAR2(20)
   ��Ÿ Į��...

��ǰ_56(100��)
   ��ǰ��ȣ    VARCHAR2(4)  <== PK
   ��ǰ��      VARCHAR2(20)
   
�ֹ�_56(500����)
   �ֹ���ȣ    VARCHAR2(8)   <== PK
   ����ȣ    VARCHAR2(6)
   �ֹ�����    VARCHAR2(8)                                                                    
   �ֹ��ݾ�    NUMBER
   ��Ÿ Į��...
   �ε��� (�ֹ�����),  (����ȣ+�ֹ�����);

�ֹ���ǰ_56(600����)
   �ֹ���ȣ      VARCHAR2(8) <== PK1
   �Ϸù�ȣ      NUMBER      <== PK2
   ��ǰ��ȣ      VARCHAR2(4)
   ��Ÿ Į��...
   
�� 1���ֹ��Ǽ� : 100��

�Ʒ� SQL�� Ʃ���ϼ���. ^^
�ε��� ���� �Ұ���
*/
SELECT /*+ NO_QUERY_TRANSFORMATION LEADING(B) USE_NL(A) */
       A.����ȣ,
       MIN(A.����)   ����,
       MIN(A.����ó)   ����ó,
       COUNT(*)        �ֹ��Ǽ�,
       SUM(B.�ֹ��ݾ�) �ֹ��ݾ�
FROM ��_56 A,  �ֹ�_56 B
WHERE �ֹ����� BETWEEN TO_CHAR(SYSDATE -8, 'YYYYMMDD') 
                  AND  TO_CHAR(SYSDATE -1, 'YYYYMMDD')
 AND A.����ȣ = B.����ȣ
 AND EXISTS (SELECT 1 FROM �ֹ�_56 X, �ֹ���ǰ_56 Y
             WHERE X.����ȣ = A.����ȣ
              AND  X.�ֹ����� = TO_CHAR(SYSDATE, 'YYYYMMDD')
              AND  Y.�ֹ���ȣ = X.�ֹ���ȣ
              AND  Y.��ǰ��ȣ LIKE 'A%'
             )
GROUP BY A.����ȣ
;

/* 
----------------------------------------------------------------------------------
| Id  | Operation                        | Name       |A-Rows | Buffers | Reads  |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                 |            |    15 |    1711 |     97 |
|   1 |  HASH GROUP BY                   |            |    15 |    1711 |     97 |
|*  2 |   FILTER                         |            |   120 |    1711 |     97 |
|*  3 |    FILTER                        |            |   800 |     814 |      0 |
|   4 |     NESTED LOOPS                 |            |   800 |     814 |      0 |
|   5 |      NESTED LOOPS                |            |   800 |      14 |      0 |
|   6 |       TABLE ACCESS BY INDEX ROWID| �ֹ�_56    |   800 |      10 |      0 |
|*  7 |        INDEX RANGE SCAN          | �ֹ�_56_X01|   800 |       5 |      0 |
|*  8 |       INDEX UNIQUE SCAN          | ��_56_PK |   800 |       4 |      0 |
|   9 |      TABLE ACCESS BY INDEX ROWID | ��_56    |   800 |     800 |      0 |
|  10 |    NESTED LOOPS                  |            |    15 |     897 |     97 |
|  11 |     NESTED LOOPS                 |            |   145 |     752 |     97 |
|  12 |      TABLE ACCESS BY INDEX ROWID | �ֹ�_56    |   128 |     603 |     97 |
|* 13 |       INDEX RANGE SCAN           | �ֹ�_56_X02|   128 |     475 |     97 |
|* 14 |      INDEX RANGE SCAN            | �ֹ���ǰ_56|   145 |     149 |      0 |
|* 15 |     TABLE ACCESS BY INDEX ROWID  | �ֹ���ǰ_56|    15 |     145 |      0 |
----------------------------------------------------------------------------------

 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   6 - access("A"."����ȣ"="B"."����ȣ")
       filter("A"."����ȣ"="B"."����ȣ")
   8 - access("�ֹ�����">=TO_CHAR(SYSDATE@!-8,'YYYYMMDD') AND "�ֹ�����"<=TO_CHAR(SYSDATE@!-1,'YYYYMMDD'))
   9 - access("ITEM_1"="A"."����ȣ")
       filter("ITEM_1"="A"."����ȣ")
  11 - filter(TO_CHAR(SYSDATE@!-8,'YYYYMMDD')<=TO_CHAR(SYSDATE@!-1,'YYYYMMDD'))
  15 - access("X"."�ֹ�����"=TO_CHAR(SYSDATE@!,'YYYYMMDD'))
  16 - access("Y"."�ֹ���ȣ"="X"."�ֹ���ȣ")
  17 - filter("Y"."��ǰ��ȣ" LIKE 'A%')
*/