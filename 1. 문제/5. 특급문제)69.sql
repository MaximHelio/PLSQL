/*
고객_69    100만건
  고객번호      VARCHAR2(10)
  고객명        VARCHAR2(50)
  최종거래일시  DATE
  기타 등등
인덱스
   - PK      : 최종거래일시

주문
  주문번호      VARCHAR2(10)
  고객번호      VARCHAR2(10)
  거래일시      DATE
  기타등등
※ 거래일시 칼럼에 월별 파티션 구성
인덱스 
  - 고객번호 + 거래일시
  - 거래일시

문제1) 아래의 Query를 이용하여 OLTP의 부분범위 처리에 최적화하여 튜닝하세요.
문제2) 아래의 Query를 이용하여 Batch 프로그램에 최적화하여 튜닝하세요.
두 문제 모두 옵티마이저 힌트를 활용하여 실행계획을 고정 하세요.
*/

SELECT C.고객번호, C.고객명, C.최종거래일시
     , (SELECT AVG(주문금액) 
        FROM   주문_69
        WHERE  거래일시 BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                            AND TO_DATE('20190615', 'YYYYMMDD')
         AND   고객번호 = C.고객번호)  평균주문금액
     , (SELECT MAX(주문금액) 
        FROM   주문_69
        WHERE  거래일시 BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                            AND TO_DATE('20190615', 'YYYYMMDD')
         AND   고객번호 = C.고객번호)  최고주문금액
     , (SELECT MIN(주문금액) 
        FROM   주문_69
        WHERE  거래일시 BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                            AND TO_DATE('20190615', 'YYYYMMDD')
         AND   고객번호 = C.고객번호)  최소주문금액            
FROM    고객_69 C
WHERE     C.최종거래일시 BETWEEN TO_DATE('20190515', 'YYYYMMDD')  
                             AND TO_DATE('20190615', 'YYYYMMDD')
;
