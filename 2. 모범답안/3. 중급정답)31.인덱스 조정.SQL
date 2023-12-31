ALTER SESSION SET STATISTICS_LEVEL = ALL;
   
SELECT /*+ LEADING(M P) USE_NL(P) USE_NL(O) 
           INDEX(P IX_T_PRODUCT_02) INDEX(O IX_T_ORDER_02) */
       P.PROD_NM, P.PROD_ID, O.ORDER_QTY
FROM   T_MANUF M, T_PRODUCT P,  T_ORDER O
WHERE  M.M_CODE BETWEEN 'M00001' AND 'M00100'
 AND   P.M_CODE  = M.M_CODE
 AND   O.PROD_ID = P.PROD_ID
 AND   O.ORDER_DT = '20160412'
 AND   O.ORDER_QTY > 9000;

--모범답안)
CREATE INDEX YOON.IX_T_PRODUCT_02 ON YOON.T_PRODUCT(M_CODE, PROD_ID, PROD_NM);
CREATE INDEX YOON.IX_T_ORDER_02 ON YOON.T_ORDER(PROD_ID, ORDER_DT, ORDER_QTY);


/*  
------------------------------------------------------------------------------------------------
| Id  | Operation          | Name            | Starts | A-Rows |   A-Time   | Buffers | Reads  |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                 |      1 |     32 |00:00:00.09 |   20318 |      4 |
|   1 |  NESTED LOOPS      |                 |      1 |     32 |00:00:00.09 |   20318 |      4 |
|   2 |   NESTED LOOPS     |                 |      1 |  10000 |00:00:00.01 |     314 |      0 |
|*  3 |    INDEX RANGE SCAN| PK_T_MANUF      |      1 |    100 |00:00:00.01 |       3 |      0 |
|*  4 |    INDEX RANGE SCAN| IX_T_PRODUCT_02 |    100 |  10000 |00:00:00.01 |     311 |      0 |
|*  5 |   INDEX RANGE SCAN | IX_T_ORDER_02   |  10000 |     32 |00:00:00.08 |   20004 |      4 |
------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
   3 - access("M"."M_CODE">='M00001' AND "M"."M_CODE"<='M00100')
   4 - access("P"."M_CODE"="M"."M_CODE")
       filter(("P"."M_CODE"<='M00100' AND "P"."M_CODE">='M00001'))
   5 - access("O"."PROD_ID"="P"."PROD_ID" AND "O"."ORDER_DT"='20160412' AND 
              "O"."ORDER_QTY">9000 AND "O"."ORDER_QTY" IS NOT NULL) 
 */
ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;

DROP INDEX YOON.IX_T_PROD_01;
DROP INDEX YOON.IX_T_ORDER_01;

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_PRODUCT');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_ORDER');

 
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST -ROWS'));


