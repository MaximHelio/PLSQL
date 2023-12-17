/*========================================================================

2. SQL�� �����ϰų� �ε����� �����Ͽ� SORT ������ �Ͼ�� �ʰ� �����϶�
   1) ����
      - PK ���� �Ұ�(���̺��_PK)
      - Optizer Hint�� ��밡���ϳ� index index_desc ��Ʈ�� ��� �Ұ�
      - ���ʿ��� �ε��� �߰� �� ����
   2) ���� ���
      - SQL�� �����ؼ� ���� ������ ��� SQL �� �����Ͽ� ����� ����
      - SQL, �ε��� �Ѵ� ������ �ʿ��� ��� ����� ����
      - ������ ���ʿ��� ��� '���� ���ʿ�' ����'
========================================================================*/

-- 2.1
SELECT B.C1, FUNC(B.CL)
FROM TAB1 A, TAB2 B
WHERE A.C1=B.C1
 AND  A.C2 LIKE :V1 || '%'
 AND  B.C3 LIKE :V3 || '%'
GROUP BY B.C1
;

/*
[PLAN]
SELECT
    SORT(GROUP BY)
        NESTED LOOP
             NESTED LOOP
                 TABLE FULL  TAB1
                 INDEX  RANGE  TAB2_PK
             TABLE ACCESS BY INDEX ROWID TAB2

[INDEX]
TAB1_PK : C1
TABL1_X1 : C2
TAB2_PK : C1 + C2
*/

-- 2.2
SELECT *
FROM TAB1  A, TAB2  B
WHERE  A.C1 = B.C1
 AND   B.C1 = :V1
 AND   A.C2 LIKE :V2 || '%'
 ORDER BY B.C4
;

/*
[PLAN]
SELECT
    HASH  JOIN
        TABLE  ACCESS BY INDEX ROWID   TAB1
           INDEX  UNIQUE (TAB1_PK)
        TABLE  ACCESS BY INDEX ROWID   TAB2
           INDEX  UNIQUE (TAB2_PK)

[INDEX]
TAB1_PK : C1
TAB2_PK : C1 + C2
TAB2_X1 : C1 + C4
*/

--2.3
SELECT *
FROM TAB1
WHERE C1=:V1
 AND  C2=:V2
ORDER BY C3, C4;

/*
[PLAN]
SELECT
   SORT (ORDER BY)
      TABLE ACCESS BY INDEX ROWID TAB1
         INDEX RANGE (TAB1_PK)
         
[INDEX]
TAB1_PK : C1+C2+C3
*/

--2.4
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C2='M'
AND   C3='ABC'
UNION
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C2='C'
AND   C3='ABC'

/*
[PLAN]
SELECT
   SORT(UNIQUE)
     UNION ALL
        TABLE ACCESS  BY INDEX  ROWID  TAB1
            INDEX RANGE(TAB1_X1)
        TABLE ACCESS  BY INDEX  ROWID  TAB2
            INDEX RANGE(TAB1_X1)
            
[INDEX]
TAB1_PK : C1
TAB1_X1 : C2+C3
*/

--2.5
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C2=:V1
UNION
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C3=:V1

/*
[PLAN]
SELECT
   SORT(UNIQUE)
     UNION ALL
        TABLE ACCESS  BY INDEX  ROWID  TAB1
            INDEX RANGE(TAB1_X1)
        TABLE ACCESS  BY INDEX  ROWID  TAB2
            INDEX RANGE(TAB1_X1)
            
[INDEX]
TAB1_PK : C1
TAB1_X1 : C2
TAB1_X2 : C3
*/

--2.6
SELECT *
FROM TAB1
WHERE C1=:V1
ORDER BY C2, C3 DESC

/*
[PLAN]
SELECT
   SORT (ORDER BY)
      TABLE  ACEESS BY INDEX ROWID TAB1
         INDEX RANGE SCAN (TAB1_X1)

[INDEX]
TAB1_X1 : C1+C2+C3 DESC
*/

--2.7
SELECT *
FROM TAB1
WHERE C1=:V1
AND C2 IN ('A', 'D')
ORDER BY C3

/*
SELECT
    SORT  (ORDER BY)
       TABLE  ACCESS  BY  INDEX  ROWID  TAB1
          INDEX RANGE(TAB1_X1)

[INDEX]
TAB1_X1 : C1+C2+C3
*/