ALTER SESSION SET CURRENT_SCHEMA=YOON;
/* 테이블
   주문
      (상품ID    VARCHAR2(7)   PK
       고객번호  VARCHAR2(6)   PK
       주문일자  VARCHAR2(8)   PK
       주문가격  NUMBER
       ...
       )
인덱스 하지말고,  SQL 튜닝
*/       
     

-- 1-1번
SELECT   X.상품ID, X.고객번호, X.주문가격,  X.주문일자
FROM     주문_70 X,
         (SELECT   고객번호, MAX(주문일자) 최종주문일자
          FROM     주문_70
          WHERE    상품ID = '0000100'
          GROUP BY 고객번호
         ) Y
WHERE    X.고객번호 = Y.고객번호
  AND    X.주문일자 = Y.최종주문일자
  AND    X.상품ID   = '0000100'
ORDER BY X.상품ID, X.고객번호
;

-- 1-2번
SELECT   X.상품ID, X.고객번호, X.주문일자, Y.주문건수, Y.평균주문금액, Y.최대주문금액
FROM     주문_70 X,
         (SELECT   고객번호, COUNT(*) 주문건수, AVG(주문가격) 평균주문금액,  MAX(주문가격) 최대주문금액
          FROM     주문_70
          WHERE    상품ID = '0000100'
          GROUP BY 고객번호
         )Y
WHERE    X.고객번호   = Y.고객번호
 AND    상품ID = '0000100'
;
