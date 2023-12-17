ALTER SESSION SET CURRENT_SCHEMA=YOON;

-- 1-1��
-- ���� ��
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

-- ���� ��
SELECT  ��ǰID, ����ȣ, �ֹ�����, �ֹ�����
FROM    (SELECT   ��ǰID, ����ȣ, �ֹ�����, �ֹ�����
                , ROW_NUMBER()  OVER (PARTITION BY ����ȣ ORDER BY �ֹ����� DESC) R_NUM
         FROM     �ֹ�_70
         WHERE    ��ǰID = '0000100'
        )
WHERE   R_NUM = 1
ORDER BY ��ǰID, ����ȣ;


-- 1-2��
-- ���� ��
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

-- ���� ��
SELECT     ��ǰID, ����ȣ, �ֹ�����
         , COUNT(�ֹ�����) OVER (PARTITION BY ����ȣ)       �ֹ��Ǽ�
         , AVG(�ֹ�����)   OVER (PARTITION BY ����ȣ)       ����ֹ��ݾ�
         , MAX(�ֹ�����)   OVER (PARTITION BY ����ȣ)       �ִ��ֹ��ݾ� 
FROM       �ֹ�_70
WHERE      ��ǰID = '0000100'
;
