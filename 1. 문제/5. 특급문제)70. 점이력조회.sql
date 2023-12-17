ALTER SESSION SET CURRENT_SCHEMA=YOON;
/* ���̺�
   �ֹ�
      (��ǰID    VARCHAR2(7)   PK
       ����ȣ  VARCHAR2(6)   PK
       �ֹ�����  VARCHAR2(8)   PK
       �ֹ�����  NUMBER
       ...
       )
�ε��� ��������,  SQL Ʃ��
*/       
     

-- 1-1��
SELECT   X.��ǰID, X.����ȣ, X.�ֹ�����,  X.�ֹ�����
FROM     �ֹ�_70 X,
         (SELECT   ����ȣ, MAX(�ֹ�����) �����ֹ�����
          FROM     �ֹ�_70
          WHERE    ��ǰID = '0000100'
          GROUP BY ����ȣ
         ) Y
WHERE    X.����ȣ = Y.����ȣ
  AND    X.�ֹ����� = Y.�����ֹ�����
  AND    X.��ǰID   = '0000100'
ORDER BY X.��ǰID, X.����ȣ
;

-- 1-2��
SELECT   X.��ǰID, X.����ȣ, X.�ֹ�����, Y.�ֹ��Ǽ�, Y.����ֹ��ݾ�, Y.�ִ��ֹ��ݾ�
FROM     �ֹ�_70 X,
         (SELECT   ����ȣ, COUNT(*) �ֹ��Ǽ�, AVG(�ֹ�����) ����ֹ��ݾ�,  MAX(�ֹ�����) �ִ��ֹ��ݾ�
          FROM     �ֹ�_70
          WHERE    ��ǰID = '0000100'
          GROUP BY ����ȣ
         )Y
WHERE    X.����ȣ   = Y.����ȣ
 AND    ��ǰID = '0000100'
;
