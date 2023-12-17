
/*  2번

주문 
   주문번호(PK)
   회원번호
   주문상태
   ~~~
   (인덱스 : PK_주문(주문번호), IX01_주문(회원번호))
   
주문이력
   주문이력번호(PK)
   주문번호(FK)
   (인덱스 : PK_주문이력(주문이력번호), IX01_주문이력(주문번호))
   
결제이력
   결제이력번호(PK)
   주문이력번호(FK)
   카드번호
   결제일자
   ~~~
   (인덱스 : PK_결제이력(결제이력번호), IX01_결제이력(주문이력번호), IX02_결제이력(결제일자)
주문데이터 입력 시 최종 결제 카드번호 찾아야 함 
 - 모델 변경 불가
 - 인덱스 변경 가능
 - SQL 변경 가능
 - 힌트는 조인순서, 조인방법, 인덱스 관련만 지정 가능
*/

SELECT X.카드번호
FROM   (SELECT   C.카드번호, ROWNUM RNUM
        FROM     주문_72     A
               , 주문이력_72 B
               , 결제이력_72 C
        WHERE    A.회원번호     = 'C13991'
         AND     A.주문상태코드 = '12'
         AND     B.주문번호     = A.주문번호
         AND     C.주문이력번호 = B.주문이력번호
        ORDER BY C.결제일자 DESC
       ) X 
WHERE  RNUM = 1;
