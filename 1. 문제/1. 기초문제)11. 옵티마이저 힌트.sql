--아래 SQL을 다음과 같이 실행계획이 만들어 지도록 옵티마이저 힌트를 작성하세요.

--(SQL)


SELECT   *
FROM   CUST   A,  
       SAL    B,
       GOODS  C
WHERE  A.CUST_NO     = '1234'
 AND   B.CUST_NO     = A.CUST_NO
 AND   C.GOOD_NO     = B.GOOD_NO
 AND   C.BRANCH_CODE = '강남점'
 ;

/*
(조건 1)
JOIN  순서  :  CUST → SAL → GOODS
NL 조인     :  CUST → SAL,  SAL → GOODS
인덱스 활용 :  PK_CUST,  IX_GOODS_01

(조건 2)
JOIN 순서 : 위와 동일
조인      :  NL(CUST→SAL) → HASH(앞의 결과와 GOODS)

  
인덱스 
- PK_CUST 		: CUST  ( CUST_NO)
- PK_SAL    	: SAL    ( CUST_NO, GOOD_NO, SAL_DATE)
- IX_GOODS_01	: GOODS( GOOD_NO, BRANCH_CODE)

*/
