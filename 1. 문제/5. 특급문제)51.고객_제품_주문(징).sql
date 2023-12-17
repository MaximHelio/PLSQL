--SQL

ALTER SESSION SET STATISTICS_LEVEL = ALL;

SELECT /*+ ORDERED USE_NL(P O) */
       *
FROM   T_MANUF M, T_PRODUCT P,  T_ORDER O
WHERE  M.M_CODE BETWEEN 'M00001' AND 'M00100'
 AND   P.M_CODE  = M.M_CODE
 AND   O.PROD_ID = P.PROD_ID
 AND   O.ORDER_DT = '20160412'
 AND   O.ORDER_QTY > 9000;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST -ROWS'));

-- Index 정보
/*

CREATE UNIQUE INDEX YOON.PK_T_MANUF    ON YOON.T_MANUF  (M_CODE);
CREATE UNIQUE INDEX YOON.PK_T_PRODUCT  ON YOON.T_PRODUCT(M_CODE, PROD_ID);
CREATE        INDEX YOON.IX_T_ORDER_01 ON YOON.T_ORDER  (PROD_ID);
CREATE        INDEX YOON.IX_T_ORDER_02 ON YOON.T_ORDER  (ORDER_DT, ORDER_QTY, PROD_ID);


-------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name          | Starts | A-Rows |   A-Time   | Buffers |
-------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |               |      1 |     32 |00:00:00.04 |   30222 |
|   1 |  NESTED LOOPS                  |               |      1 |     32 |00:00:00.04 |   30222 |
|   2 |   NESTED LOOPS                 |               |      1 |  10000 |00:00:00.03 |   20242 |
|   3 |    NESTED LOOPS                |               |      1 |  10000 |00:00:00.01 |   10212 |
|   4 |     TABLE ACCESS BY INDEX ROWID| T_MANUF       |      1 |    100 |00:00:00.01 |      99 |
|*  5 |      INDEX RANGE SCAN          | PK_T_MANUF    |      1 |    100 |00:00:00.01 |       3 |
|   6 |     TABLE ACCESS BY INDEX ROWID| T_PRODUCT     |    100 |  10000 |00:00:00.01 |   10113 |
|*  7 |      INDEX RANGE SCAN          | PK_T_PRODUCT  |    100 |  10000 |00:00:00.01 |     138 |
|*  8 |    INDEX RANGE SCAN            | IX_T_ORDER_01 |  10000 |  10000 |00:00:00.01 |   10030 |
|*  9 |   TABLE ACCESS BY INDEX ROWID  | T_ORDER       |  10000 |     32 |00:00:00.01 |    9980 |
-------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("M"."M_CODE">='M00001' AND "M"."M_CODE"<='M00100')
   7 - access("P"."M_CODE"="M"."M_CODE")
       filter(("P"."M_CODE">='M00001' AND "P"."M_CODE"<='M00100'))
   8 - access("O"."PROD_ID"="P"."PROD_ID")
   9 - filter(("O"."ORDER_DT"='20160412' AND "O"."ORDER_QTY">9000))
 
문제)

  SQL을 튜닝 하시오. (인덱스 변경 불가)
  
*/