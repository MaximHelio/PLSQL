/*  
1번)
T_주문
   배송번호
   배송업체번호
   배송유형
   ...
   
   배송완료일시
   배송회수완료일시
   반품배송완료일시
   
   인덱스 PK            : 주문번호
          IX10_배송이력 : 주문유형, 배송완료일시, 반품회수완료일시, 반품배송완료일시)
   
   - 칼럼 추가 가능(프로그램 수정 및 Migration은 고려하지 않음)
   - 현재 인덱스가 11개 있어 인덱스 추가 변경 최소화
   - 배송일시, 반품회수완료일시, 반품배송완료일시는 배타적
     즉 레코드별 3개의 칼럼 중 하나의 칼럼에만 데이터가 있으며, 나머지 2개는 NULL
   - 1개월 10만건 데이터 발생, 10년 이력저장으로 1,000만건 데이터 존재
*/
    
ALTER SESSION SET STATISTICS_LEVEL=ALL;

SELECT    배송번호, 배송업체번호, 배송유형, 배송완료일시, 배송회수완료일시, 반품배송완료일시
       ,  C1, C2
FROM      배송이력_71
WHERE     배송업체번호 = 'C033'  
 AND      배송유형     = '82' 
 AND  (    배송완료일시     BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
      OR  배송회수완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
      OR  반품배송완료일시 BETWEEN TO_DATE('20190101') AND TO_DATE('20190131235959', 'YYYYMMDDHH24MISS')
     ) 
;
     

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));


