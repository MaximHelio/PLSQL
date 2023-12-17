/*
ERD가 제공되기에 WORD 파일로 문제를 볼것
문제1-1)
   1. NL 조인으로 풀린다.
   2. scolar sub query, 인라인뷰, 조건서브쿼리 등 모든 서브쿼리를 배제하고 하나의 메인쿼리로 
      최적의 SQL을 작성하세요.
   3. group by는 꼭 필요한 최소칼럼으로 작성하세요.
      동 쿼리의 결과로 집계테이블을 만들경우 PK 수준으로 작성 하세요.
   
문제1-2)  order 테이블의 최적의 인덱스를 작성하세요.
*/

SELECT order_ym, cust_md_cd,
       (SELECT cust_md_nm FROM cust_cg_67 WHERE cust_md_cd = c.cust_md_cd AND cust_cd_div = 'ABC') cust_md_nm, 
       X.order_md_cd, X.ORDER_MD_NM
       prod_no, prod_nm,
       COUNT(qty) QTY, SUM(amt) AMT
FROM (
      SELECT substr(order_dt, 1, 6) order_ym, cust_no, O.order_md_cd, CG.order_md_nm, O.prod_no, P.prod_nm
           , COUNT(qty) qty, SUM(amt) amt
      FROM order_67 o, order_cg_67 cg, prod_67 p
      WHERE order_dt BETWEEN '20180101' AND '20180630'
        AND p.prod_md_cd in (SELECT prod_md_cd FROM prod_cg_67 WHERE prod_md_nm = '은하수')
        AND cg.order_md_cd = '050'
        AND o.prod_no      = p.prod_no
        AND o.order_md_cd  = cg.order_md_cd
      group by substr(O.order_dt, 1, 6), 
               o.cust_no, o.order_md_cd, cg.order_md_nm, o.prod_no, p.prod_nm
     ) x, cust_67 c
WHERE x.cust_no = c.cust_no
GROUP BY x.order_ym, c.cust_md_cd, order_md_cd, order_md_nm, x.prod_no, X.prod_nm
;
