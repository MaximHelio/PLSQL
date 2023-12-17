/* �ε��� �߰�
   �ֹ���ǰ_57 (�ֹ���ȣ+��ǰ��ȣ)
*/

CREATE INDEX YOON.IX_�ֹ���ǰ_57 ON YOON.�ֹ���ǰ_57(�ֹ���ȣ, ��ǰ��ȣ);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '�ֹ���ǰ_57');

/* SQL Ʃ��
   �ֹ��� ����̺� ���̺���ϰ� �ֹ���ǰ���� ����
   
   M ������ �����Ͱ� ��µǸ�, ���� ��ǰ�� �ߺ� Access�� ����.
   ���� ĳ�̱���� �ִ� Scholar Sub Query�� ���� ��.
   
�� ��Į�� ��������
8i, 9i�� cache entry 256��
10g �̻� _query_execution_cache_max_size ��ŭ (65,536��)
�� 10g �̻��� ��� ������������ ��ȯ�ϴ� ���� 65,536�� �̸��̰�, �ߺ����� ���� ��쿡 �ַ� ȿ��

*/


ALTER SESSION SET STATISTICS_LEVEL = ALL;

-- ��Į�� ���������� �ۼ����� ���
SELECT /*+ LEADING(A) USE_NL(B) */
       A.����ȣ
     , (SELECT ���� FROM ��_57 WHERE ����ȣ = A.����ȣ) ����
     , A.�ֹ���ȣ, A.�ֹ�����
     , B.�Ϸù�ȣ, B.��ǰ��ȣ
     , (SELECT ��ǰ�� FROM ��ǰ_57 WHERE ��ǰ��ȣ = B.��ǰ��ȣ) ��ǰ��
FROM �ֹ�_57 A, �ֹ���ǰ_57 B
WHERE A.�ֹ����� BETWEEN '20170719' AND '20170729'
 AND  B.�ֹ���ȣ = A.�ֹ���ȣ 
 AND  B.��ǰ��ȣ LIKE 'A%'   
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));
/*
PLAN_TABLE_OUTPUT
---------------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name       | Starts | E-Rows | A-Rows |   A-Time   | Buffers | Reads  |
---------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |            |      1 |        |    187 |00:00:00.01 |     108 |     10 |
|   1 |  TABLE ACCESS BY INDEX ROWID  | ��_57    |     58 |      1 |     58 |00:00:00.01 |      63 |      0 |
|*  2 |   INDEX UNIQUE SCAN           | ��_57_PK |     58 |      1 |     58 |00:00:00.01 |       5 |      0 |
|   3 |  TABLE ACCESS BY INDEX ROWID  | ��ǰ_57    |     15 |      1 |     15 |00:00:00.01 |      19 |      0 |
|*  4 |   INDEX UNIQUE SCAN           | ��ǰ_57_PK |     15 |      1 |     15 |00:00:00.01 |       4 |      0 |
|   5 |  NESTED LOOPS                 |            |      1 |        |    187 |00:00:00.01 |     108 |     10 |
|   6 |   NESTED LOOPS                |            |      1 |    243 |    187 |00:00:00.01 |      88 |      6 |
|   7 |    TABLE ACCESS BY INDEX ROWID| �ֹ�_57    |      1 |    239 |   1100 |00:00:00.01 |      16 |      0 |
|*  8 |     INDEX RANGE SCAN          | �ֹ�_57_X01|      1 |    239 |   1100 |00:00:00.01 |       8 |      0 |
|*  9 |    INDEX RANGE SCAN           | IX_�ֹ���ǰ|   1100 |      1 |    187 |00:00:00.01 |      72 |      6 |
|  10 |   TABLE ACCESS BY INDEX ROWID | �ֹ���ǰ_57|    187 |      1 |    187 |00:00:00.01 |      20 |      4 |
---------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("����ȣ"=:B1)
   4 - access("��ǰ��ȣ"=:B1)
   8 - access("A"."�ֹ�����">='20170719' AND "A"."�ֹ�����"<='20170729')
   9 - access("B"."�ֹ���ȣ"="A"."�ֹ���ȣ" AND "B"."��ǰ��ȣ" LIKE 'A%')
       filter("B"."��ǰ��ȣ" LIKE 'A%')
 
*/