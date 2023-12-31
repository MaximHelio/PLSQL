ALTER SESSION SET STATISTICS_LEVEL = ALL;

-- 튜닝된 SQL
SELECT /*+ NO_QUERY_TRANSFORMATION  
          LEADING(M P_BRG O_BRG P O) USE_NL(P_BRG) USE_HASH(O_BRG) 
          SWAP_JOIN_INPUTS(O_BRG)
          INDEX(O_BRG IX_T_ORDER_02) INDEX(M PK_T_MANUF) */
       M.*, P.*, O.*
FROM   T_MANUF M, T_PRODUCT P,  T_ORDER O 
     , T_PRODUCT P_BRG, T_ORDER O_BRG
WHERE  M.M_CODE BETWEEN 'M00001' AND 'M00100'
 AND   P_BRG.M_CODE  = M.M_CODE
 AND   O_BRG.PROD_ID = P_BRG.PROD_ID
 AND   O_BRG.ORDER_DT = '20160412'
 AND   O_BRG.ORDER_QTY > 9000
 AND   P.ROWID = P_BRG.ROWID
 AND   O.ROWID = O_BRG.ROWID
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST -ROWS'));
/* 
--------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name          | Starts | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |               |      1 |     32 |00:00:00.01 |     265 |
|   1 |  NESTED LOOPS                   |               |      1 |     32 |00:00:00.01 |     265 |
|   2 |   NESTED LOOPS                  |               |      1 |     32 |00:00:00.01 |     251 |
|*  3 |    HASH JOIN                    |               |      1 |     32 |00:00:00.01 |     239 |
|*  4 |     INDEX RANGE SCAN            | IX_T_ORDER_02 |      1 |     32 |00:00:00.01 |       2 |
|   5 |     NESTED LOOPS                |               |      1 |  10000 |00:00:00.01 |     237 |
|   6 |      TABLE ACCESS BY INDEX ROWID| T_MANUF       |      1 |    100 |00:00:00.01 |      99 |
|*  7 |       INDEX RANGE SCAN          | PK_T_MANUF    |      1 |    100 |00:00:00.01 |       3 |
|*  8 |      INDEX RANGE SCAN           | PK_T_PRODUCT  |    100 |  10000 |00:00:00.01 |     138 |
|   9 |    TABLE ACCESS BY USER ROWID   | T_PRODUCT     |     32 |     32 |00:00:00.01 |      12 |
|  10 |   TABLE ACCESS BY USER ROWID    | T_ORDER       |     32 |     32 |00:00:00.01 |      14 |
--------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("O_BRG"."PROD_ID"="P_BRG"."PROD_ID")
   4 - access("O_BRG"."ORDER_DT"='20160412' AND "O_BRG"."ORDER_QTY">9000 AND 
              "O_BRG"."ORDER_QTY" IS NOT NULL)
   7 - access("M"."M_CODE">='M00001' AND "M"."M_CODE"<='M00100')
   8 - access("P_BRG"."M_CODE"="M"."M_CODE")
       filter(("P_BRG"."M_CODE">='M00001' AND "P_BRG"."M_CODE"<='M00100'))
 
   */
 
