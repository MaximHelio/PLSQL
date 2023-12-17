ALTER SESSION SET CURRENT_SCHEMA=YOON;

-- 1-1번
-- 변경 전
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

-- 변경 후
SELECT  상품ID, 고객번호, 주문가격, 주문일자
FROM    (SELECT   상품ID, 고객번호, 주문가격, 주문일자
                , ROW_NUMBER()  OVER (PARTITION BY 고객번호 ORDER BY 주문일자 DESC) R_NUM
         FROM     주문_70
         WHERE    상품ID = '0000100'
        )
WHERE   R_NUM = 1
ORDER BY 상품ID, 고객번호;


-- 1-2번
-- 변경 전
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

-- 변경 후
SELECT     상품ID, 고객번호, 주문일자
         , COUNT(주문가격) OVER (PARTITION BY 고객번호)       주문건수
         , AVG(주문가격)   OVER (PARTITION BY 고객번호)       평균주문금액
         , MAX(주문가격)   OVER (PARTITION BY 고객번호)       최대주문금액 
FROM       주문_70
WHERE      상품ID = '0000100'
;
