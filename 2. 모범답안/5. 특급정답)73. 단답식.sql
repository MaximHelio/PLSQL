/*
�ܴ��
sys_connect_by_path(Į��, '/')
C1  is null

INDEX FAST FULL SCAN
���������� �Է�Į��, ��Į������������ ���Į��
  ��) A.DEPARTMENT_NO, DEPT_NAME
      SELECT EMPNO,  (SELECT DEPT_NAME FROM DEPTNO = A.DEPARTMENT_NO)
      FROM   EMP A ;
Granule <= ���ļ����� ó�� ����
clustering factor
LOCAL
Extent
arraysize
nologging
*/