select   a.����ȣ, a.���� 
       , count(distinct b.�ֹ���ȣ) ����ֹ��Ǽ�
       , count(distinct c.�ֹ���ȣ) �����ֹ��Ǽ�
       , count(distinct d.�ֹ���ȣ) �������ֹ��Ǽ�
from     �� a, �ֹ� b, �ֹ� c, �ֹ� d 
where    b.����ȣ(+) = a.����ȣ
 and     b.�ֹ��Ͻ�(+) LIKE '202107%'
 and     b.�ֹ�Ÿ��(+) ='03'
 
 and     c.����ȣ(+) = c.����ȣ
 and     c.�ֹ��Ͻ�(+) LIKE '202106%'
 and     c.�ֹ�Ÿ��(+) ='03'
 
 and     d.����ȣ(+) = a.����ȣ
 and     d.�ֹ��Ͻ�(+) LIKE '202105%'
 and     d.�ֹ�Ÿ��(+) ='03'
group by A.����ȣ, A.����
having count(distinct b.�ֹ���ȣ) + count(distinct c.�ֹ���ȣ) + count(distinct d.�ֹ���ȣ) > 0  ;

/*
�ε��� 
   - �� ���̺� : ��_idx01 : ����ȣ
   - �ֹ� ���̺� : �ֹ�_idx01 : ����ȣ, �ֹ��Ͻ�
*/

select 
from   �� A 