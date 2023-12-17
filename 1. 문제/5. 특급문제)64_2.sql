/*========================================================================

2. SQL을 수정하거나 인덱스를 수정하여 SORT 현산이 일어나지 않게 변경하라
   1) 조건
      - PK 수정 불가(테이블명_PK)
      - Optizer Hint는 사용가능하나 index index_desc 힌트는 사용 불가
      - 불필요한 인덱스 추가 시 감점
   2) 변경 방법
      - SQL만 수정해서 개선 가능한 경우 SQL 만 수정하여 변경안 제시
      - SQL, 인덱스 둘다 변경이 필요한 경우 변경안 제시
      - 변경이 불필요한 경우 '변경 불필요' 기재'
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