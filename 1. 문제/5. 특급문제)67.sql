/*
ERD�� �����Ǳ⿡ WORD ���Ϸ� ������ ����
����1-1)
   1. NL �������� Ǯ����.
   2. scolar sub query, �ζ��κ�, ���Ǽ������� �� ��� ���������� �����ϰ� �ϳ��� ���������� 
      ������ SQL�� �ۼ��ϼ���.
   3. group by�� �� �ʿ��� �ּ�Į������ �ۼ��ϼ���.
      �� ������ ����� �������̺��� ������ PK �������� �ۼ� �ϼ���.
   
����1-2)  order ���̺��� ������ �ε����� �ۼ��ϼ���.
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
        AND p.prod_md_cd in (SELECT prod_md_cd FROM prod_cg_67 WHERE prod_md_nm = '���ϼ�')
        AND cg.order_md_cd = '050'
        AND o.prod_no      = p.prod_no
        AND o.order_md_cd  = cg.order_md_cd
      group by substr(O.order_dt, 1, 6), 
               o.cust_no, o.order_md_cd, cg.order_md_nm, o.prod_no, p.prod_nm
     ) x, cust_67 c
WHERE x.cust_no = c.cust_no
GROUP BY x.order_ym, c.cust_md_cd, order_md_cd, order_md_nm, x.prod_no, X.prod_nm
;
