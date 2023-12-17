/*
T_CUST33 테이블 구조
   CUST_NO       VARCHAR2(7),
   CUST_NM       VARCHAR2(50),
   CUST_CD       VARCHAR2(3),
   DIV           VARCHAR2(3),
   FLAG          VARCHAR2(2),
   C1            VARCHAR2(30),
   C2            VARCHAR2(30),
   C3            VARCHAR2(30),
   C4            VARCHAR2(30),
   C5            VARCHAR2(30)
   
PRIMARY KEY : CUST_NO
인덱스      : CUST_CD + FLAG + DIV


T_CUST33  200만건
  - CUST_CD   200개 종류(001 ~ 200),  코드당 건수는 약  1만건 
  - DIV       100개 종류(001 ~ 100),  코드당 건수는 약  2만건
  - FLAG      10개  종류(01 ~ 10),    코드당 건수는 약 20만건

문제) 화면에 CUST_CD, FLAG,  DIV 3가지 조회 조건이 존재한다.  
      CUST_CD,  DIV는 필수이지만,  FLAG는 선택 조건이다.
      3조건이 모두 입력되었을 경우 평균 출력 건수는 11건이며,
      FLAG가 입력되지 않았을 경우 평균 출력 건수는 100여 건이다.
      아래의 SQL을 튜닝 하세요.   
      FLAG 조건이 들어왔을 경우는 연산자를 LIKE 대신 "="로
      변경해도 결과값은 동일하다.
      
      FLAG가 NULLABLE 일 경우와 NOT NULL 속성일 경우 2가지로 
      풀어 보세요.
*/
SELECT * FROM T_CUST33 
WHERE CUST_CD =    :CUST_CD
  AND FLAG    LIKE :FLAG || '%'
  AND DIV     =    :DIV 
;
/*

실행계획)
Execution Plan
--------------------------------------------------------------------
   0      SELECT STATEMENT Optimizer=ALL_ROWS 
   1    0   TABLE ACCESS (BY INDEX ROWID) OF 'YOON.T_CUST33' (TABLE)
   2    1     INDEX (RANGE SCAN) OF 'YOON.IX_T_CUST33' (INDEX) 

*/