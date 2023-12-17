select   a.고객번호, a.고객명 
       , count(distinct b.주문번호) 당월주문건수
       , count(distinct c.주문번호) 전월주문건수
       , count(distinct d.주문번호) 전전월주문건수
from     고객 a, 주문 b, 주문 c, 주문 d 
where    b.고객번호(+) = a.고객번호
 and     b.주문일시(+) LIKE '202107%'
 and     b.주문타입(+) ='03'
 
 and     c.고객번호(+) = c.고객번호
 and     c.주문일시(+) LIKE '202106%'
 and     c.주문타입(+) ='03'
 
 and     d.고객번호(+) = a.고객번호
 and     d.주문일시(+) LIKE '202105%'
 and     d.주문타입(+) ='03'
group by A.고객번호, A.고객명
having count(distinct b.주문번호) + count(distinct c.주문번호) + count(distinct d.주문번호) > 0  ;

/*
인덱스 
   - 고객 테이블 : 고객_idx01 : 고객번호
   - 주문 테이블 : 주문_idx01 : 고객번호, 주문일시
*/

select 
from   고객 A 