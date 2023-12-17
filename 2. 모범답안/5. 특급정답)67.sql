/*
문제1-1)
1. 테이블 접근경로
   후보1) CUST_CG_67 => CUST_67 => ORDER_67 => ORDER_CG_67 
                                            => PROD_67 => PROD_CG_67
   후보2) PROD_CG_67 => PROD_67 => ORDER_67 => ORDER_CG_67
                                            => CUST_67 => CUST_CG_67 
   결론) 일반적으로 상품이 고객보다 더 적다.  따라서 후보2를 활용
   
2. GROUP BY 식에서 ORDER_MD_NM, PROD_NM은 제거
   SELECT 절에서 MAX(ORDER_MD_NM), MAX(PROD_NM) 으로 표시
3. Scolar Sub-Query는 outer 조인으로
*/

SELECT SUBSTR(O.ORDER_DT, 1, 6) ORDER_YM
     , C.CUST_MD_CD
     , MAX(CCG.CUST_MD_NM)      CUST_MD_NM
     , O.ORDER_MD_CD
     , MAX(OCG.ORDER_MD_NM)     ORDER_MD_NM
     , P.PROD_NO
     , MAX(P.PROD_NM)           PROD_NM
     , COUNT(O.QTY)             QTY 
     , SUM(O.AMT)               AMT
FROM PROD_CG_67   PCG
  ,  PROD_67      P
  ,  ORDER_67     O
  ,  ORDER_CG_67  OCG
  ,  CUST_67      C
  ,  CUST_CG_67   CCG
WHERE pcg.prod_md_nm    = '은하수'
 AND  P.PROD_MD_CD      = PCG.PROD_MD_CD
 AND  O.PROD_NO         = P.PROD_NO
 AND  O.ORDER_MD_CD     = '050'
 AND  O.ORDER_DT        BETWEEN '20180101' AND '20180630'
 AND  OCG.ORDER_MD_CD   = O.ORDER_MD_CD
 AND  C.CUST_NO         = O.CUST_NO 
 AND  CCG.CUST_MD_CD(+) = C.CUST_MD_CD
 AND  CCG.CUST_CD_DIV(+)= 'ABC'
GROUP BY SUBSTR(O.ORDER_DT, 1, 6), C.CUST_MD_CD, O.ORDER_MD_CD, P.PROD_NO
;

/*
문제1-2)  ORDER_67 테이블의 적당한 인덱스를 구성하세요.
          PROD_NO + ORDER_MD_CD + ORDER_DT
*/
