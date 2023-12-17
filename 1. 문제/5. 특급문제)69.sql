/*
��_69    100����
  ����ȣ      VARCHAR2(10)
  ����        VARCHAR2(50)
  �����ŷ��Ͻ�  DATE
  ��Ÿ ���
�ε���
   - PK      : �����ŷ��Ͻ�

�ֹ�
  �ֹ���ȣ      VARCHAR2(10)
  ����ȣ      VARCHAR2(10)
  �ŷ��Ͻ�      DATE
  ��Ÿ���
�� �ŷ��Ͻ� Į���� ���� ��Ƽ�� ����
�ε��� 
  - ����ȣ + �ŷ��Ͻ�
  - �ŷ��Ͻ�

����1) �Ʒ��� Query�� �̿��Ͽ� OLTP�� �κй��� ó���� ����ȭ�Ͽ� Ʃ���ϼ���.
����2) �Ʒ��� Query�� �̿��Ͽ� Batch ���α׷��� ����ȭ�Ͽ� Ʃ���ϼ���.
�� ���� ��� ��Ƽ������ ��Ʈ�� Ȱ���Ͽ� �����ȹ�� ���� �ϼ���.
*/

SELECT C.����ȣ, C.����, C.�����ŷ��Ͻ�
     , (SELECT AVG(�ֹ��ݾ�) 
        FROM   �ֹ�_69
        WHERE  �ŷ��Ͻ� BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                            AND TO_DATE('20190615', 'YYYYMMDD')
         AND   ����ȣ = C.����ȣ)  ����ֹ��ݾ�
     , (SELECT MAX(�ֹ��ݾ�) 
        FROM   �ֹ�_69
        WHERE  �ŷ��Ͻ� BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                            AND TO_DATE('20190615', 'YYYYMMDD')
         AND   ����ȣ = C.����ȣ)  �ְ��ֹ��ݾ�
     , (SELECT MIN(�ֹ��ݾ�) 
        FROM   �ֹ�_69
        WHERE  �ŷ��Ͻ� BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                            AND TO_DATE('20190615', 'YYYYMMDD')
         AND   ����ȣ = C.����ȣ)  �ּ��ֹ��ݾ�            
FROM    ��_69 C
WHERE     C.�����ŷ��Ͻ� BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                             AND TO_DATE('20190615', 'YYYYMMDD')
;
