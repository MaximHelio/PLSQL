/*문제) 아래 쿼리를 튜닝 하시오.  (인덱스 추가 및 변경 불가능)
  인덱스 
   T_CUS41 : PK_T_CUST41(CUST_NO)
     CREATE INDEX YOON.IX_T_CUST41_01 ON YOON.T_CUST41(CUST_CD);

   T_ORDER41 
     PK_T_ORDER41(ORDER_SN),  YOON.IX_T_ORDER41_01(CUST_NO, ORDER_DT);
   
  테이블정보-> T_CUST41  :    70,000건, CUST_CD 76A00은 355건 
               T_ORDER41 : 1,504,500건

쿼리) */
SELECT /*+ LEADING(A) USE_NL(B) NO_PUSH_PRED(A) */ A.CUST_NO, A.CNT, A.PRICE, QTY, DT
    ,  B.CUST_NM, B.C1, B.C2
FROM (SELECT  /*+ NO_MERGE */ 
          CUST_NO, COUNT(*) CNT, SUM(ORDER_PRICE) PRICE, SUM(ORDER_QTY) QTY, MAX(ORDER_DT) DT
      FROM T_ORDER41
      WHERE ORDER_DT BETWEEN '20160302'   AND  '20160302'
      GROUP BY CUST_NO
      ) A,  T_CUST41 B
WHERE B.CUST_NO = A.CUST_NO
 AND  B.CUST_CD = '76A00'
 ;
/*
PLAN_TABLE_OUTPUT
----------------------------------------------------------------------
| Id  | Operation                    | Name        | A-Rows |Buffers |
----------------------------------------------------------------------
|   0 | SELECT STATEMENT             |             |     38 |  26174 |
|   1 |  NESTED LOOPS                |             |     38 |  26174 |
|   2 |   NESTED LOOPS               |             |   8500 |  17674 |
|   3 |    VIEW                      |             |   8500 |   9171 |
|   4 |     HASH GROUP BY            |             |   8500 |   9171 |
|*  5 |      TABLE ACCESS FULL       | T_ORDER41   |   8500 |   9171 |
|*  6 |    INDEX UNIQUE SCAN         | PK_T_CUST41 |   8500 |   8503 |
|*  7 |   TABLE ACCESS BY INDEX ROWID| T_CUST41    |     38 |   8500 |
----------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - filter("ORDER_DT"='20160302')
   6 - access("B"."CUST_NO"="A"."CUST_NO")
   7 - filter("B"."CUST_CD"='76A00')
*/