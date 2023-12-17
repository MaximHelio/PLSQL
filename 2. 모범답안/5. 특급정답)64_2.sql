/*========================================================================
    30회(2018.09.01)  서술식 2번 문제

2. SQL을 수정하거나 인덱스를 수정하여 SORT 현산이 일어나지 않게 변경하라.
   1) 조건
      - PK 수정 불가(테이블명_PK)
      - Optizer Hint는 사용가능하나 index index_desc 힌트는 사용 불가
      - 불필요한 인덱스 추가 시 감점
   2) 변경 방법
      - SQL만 수정해서 개선 가능한 경우 SQL 만 수정하여 변경안 제시
      - SQL, 인덱스 둘다 변경이 필요한 경우 변경안 제시
      - 변경이 불필요한 경우 '변경 불필요' 기재'
========================================================================*/




--===========================================================================
-- 2.1
--===========================================================================
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


[답안]
  - SQL 및 INDEX 추가
  - INDEX) TAB2_X1 : C1+C3
     => WHERE 조건이 LIKE 대신 = 조건일 경우 C3+C1을 주면 드라이빙 조건으로 검색 후
        SORT도 하지 않겠지만,  
        LIKE 이기 때문에 소트를 하지 않으려면 드라이빙 조건을 타는 것은 포기해야 함.
*/

DROP INDEX YOON.TAB2_X2;
DROP INDEX YOON.TAB2_X3;
DROP INDEX YOON.TAB2_X4;
DROP INDEX YOON.TAB2_X5;
DROP INDEX YOON.TAB2_X6;
DROP INDEX YOON.TAB2_X7;

CREATE INDEX YOON.TAB2_X1 ON YOON.TAB2(C1, C3);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'TAB2');


SELECT /*+ LEADING(B A) USE_NL(A) INDEX(B TAB2_X2) */
       B.C1, SUM(B.C4)
FROM YOON.TAB1 A, YOON.TAB2 B
WHERE A.C1=B.C1
 AND  A.C2 LIKE '20000%'
 AND  B.C3 LIKE '40000%'
GROUP BY B.C1
;


--===========================================================================
-- 2.2
--===========================================================================
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
   SORT(ORDER BY)
     HASH  JOIN
        TABLE  ACCESS BY INDEX ROWID   TAB1
           INDEX  UNIQUE (TAB1_PK)
        TABLE  ACCESS BY INDEX ROWID   TAB2
           INDEX  UNIQUE (TAB2_PK)

[INDEX]
TAB1_PK : C1
TAB2_PK : C1 + C2
TAB2_X1 : C1 + C4

[답안]
  - TAB2 인덱스 추가 : C1+C4
  - C1은 PK 칼럼으로 NULL이 들어올 수 없음.
  ※ 1번과 동일한 문제
*/

DROP INDEX YOON.TAB2_X1;
DROP INDEX YOON.TAB2_X3;
DROP INDEX YOON.TAB2_X4;
DROP INDEX YOON.TAB2_X5;
DROP INDEX YOON.TAB2_X6;
DROP INDEX YOON.TAB2_X7;

CREATE INDEX YOON.TAB2_X2 ON YOON.TAB2(C4, C1);


SELECT /*+ LEADING(B A) USE_NL(A) INDEX_FS(B TAB2_X2) */
       *
FROM TAB1  A, TAB2 B
WHERE  A.C1 = B.C1
 AND   B.C1 = :V1
 AND   A.C2 LIKE :V2 || '%'
 ORDER BY B.C4
;


--===========================================================================
--2.3
--===========================================================================
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

[답안]
  - INDEX 추가
    : C1+C2+C3+C4
------------------------------------------------------------*/

DROP INDEX YOON.TAB1_X1;
DROP INDEX YOON.TAB1_X2;
DROP INDEX YOON.TAB1_X3;
DROP INDEX YOON.TAB1_X4;
DROP INDEX YOON.TAB1_X5;
DROP INDEX YOON.TAB1_X6;
DROP INDEX YOON.TAB1_X7;

CREATE INDEX YOON.TAB1_X3 ON YOON.TAB1(C1, C2, C3, C4);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'TAB1');

--===========================================================================
--2.4
--===========================================================================
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

[답안]
  - SQL 수정 : union을 union all로 변경
    union 에서도 동일 row 발생하지 않음
    왜냐면 위의 ROW에서는 C2가 'M' 인 것만
           아래 ROW에서는 C2가 'C' 인 것만 출력 되기 때문
*/

SELECT C1, C2, C3, C4
FROM TAB1
WHERE C2 IN ('M', 'C')
AND   C3='ABC'
;

--===========================================================================
--2.5
--===========================================================================
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C2=:V1
UNION
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C3=:V1;

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

[답안]
SQL 변경
UNION을  UNION ALL로 변경 
이때 V2=:V1 AND V3=:V1 일 경우 위 아래가 중복되어 출력
  ==> 아래 SQL에 LNNVL 함수 활용

※ Query 변환의 or조건을 Union으로 변경 참조
*/
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C2=:V1
UNION ALL ----------------- UNION ALL로 변경
SELECT C1, C2, C3, C4
FROM TAB1
WHERE C3=:V1
 AND  LNNVL(C2=:V1)  --<-<-<-<-<-<-<-<-<-<-
 
--===========================================================================
--2.6
--===========================================================================
SELECT *
FROM TAB1
WHERE C1=:V1
ORDER BY C2, C3 DESC
;
/*
[PLAN]
SELECT
   SORT (ORDER BY)
      TABLE  ACEESS BY INDEX ROWID TAB1
         INDEX RANGE SCAN (TAB1_X1)

[INDEX]
TAB1_X1 : C1+C2+C3

[답안]
   - 인덱스 수정
     C1 + C2 + C3 DESC  
     <== 참고로 이런 Function Based Index는 내가 잘 안쓰기는 하지만,
         답안을 제출 하려하다보니...
         혹여 더 좋은 방안이 있으면 알려 주시기를~~~
*/

--===========================================================================
--2.7
--===========================================================================
SELECT *
FROM TAB1
WHERE C1=:V1
AND C2 IN ('A', 'D')
ORDER BY C3
;

/*
SELECT
    SORT  (ORDER BY)
       TABLE  ACCESS  BY  INDEX  ROWID  TAB1
          INDEX RANGE(TAB1_X1)

[INDEX]
TAB1_X1 : C1+C2+C3

[답안]
  인덱스 수정 : C1+C3+C2
  C2는 체크조건으로 풀리겠지만,  소트는 발생하지 않음
*/

DROP INDEX YOON.TAB1_X1;
DROP INDEX YOON.TAB1_X2;
DROP INDEX YOON.TAB1_X3;
DROP INDEX YOON.TAB1_X4;
DROP INDEX YOON.TAB1_X5;
DROP INDEX YOON.TAB1_X6;
DROP INDEX YOON.TAB1_X7;

CREATE INDEX YOON.TAB1_X7  ON YOON.TAB1(C1, C3, C2);
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'TAB1');