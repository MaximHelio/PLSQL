/* 아래의 SQL에 대한 인덱스를 설계하시오
T1 
  - 전체 1천만건
  - T1.C5 = 'A'   100건
  
T2
  - 전체 1억건
  - T2.C2 = '10'  AND  T2.C3 = '123'  2,000
*/

--1)
SELECT  /*+ ORDERED  USE_NL(T2) */  *
FROM  T1_34 T1,  T2_34 T2
WHERE  T1.C5 = 'A'
 AND   T2.C1 = T1.C1
 AND   T2.C2 = '10'
 AND   T2.C3 = '123';
-- Nested Loop Join으로 최적화 시키세요.

--2)
SELECT  /*+ ORDERED  USE_HASH(T2) */   *
FROM  T1_34 T1,  T2_34 T2
WHERE  T1.C5 = 'A'
 AND   T2.C1 = T1.C1
 AND   T2.C2 = '10'
 AND   T2.C3 = '123';

-- HASH JOIN으로 최적화 시키세요.
     -- 인덱스 변경가능
     -- SQL 변경 가능