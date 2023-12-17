/*
단답식
sys_connect_by_path(칼럼, '/')
C1  is null

INDEX FAST FULL SCAN
메인쿼리의 입력칼럼, 스칼러서브쿼리의 출력칼럼
  예) A.DEPARTMENT_NO, DEPT_NAME
      SELECT EMPNO,  (SELECT DEPT_NAME FROM DEPTNO = A.DEPARTMENT_NO)
      FROM   EMP A ;
Granule <= 병렬서버의 처리 단위
clustering factor
LOCAL
Extent
arraysize
nologging
*/