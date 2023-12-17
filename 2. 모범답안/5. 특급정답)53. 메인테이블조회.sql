/*
CREATE INDEX YOON.IX_PRODUCT53_01 ON YOON.T_PRODUCT53(M_CODE, PROD_ID);
CREATE INDEX YOON.IX_ORDER53_01 ON YOON.T_ORDER53 (PROD_ID, ORDER_DT);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_PRODUCT53');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_ORDER53');
*/

--´ä¾È)
SELECT /*+ FULL(A) LEADING(A) */ M_CODE,   M_NM
FROM T_MANUF53 A
WHERE EXISTS (SELECT /*+ UNNEST  */ 1
              FROM T_PRODUCT53 P
              WHERE P.M_CODE  = A.M_CODE
               AND EXISTS (SELECT /*+ UNNEST */ 1 
                        FROM T_ORDER53 O
                        WHERE O.PROD_ID = P.PROD_ID
                        AND  O.ORDER_DT >= '20090101'
                       )
              );
/*------------------------------------------------------------------------------------------
| Id  | Operation               | Name            | Starts | A-Rows |   A-Time   | Buffers |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT        |                 |      1 |     50 |00:00:00.01 |     158 |
|   1 |  NESTED LOOPS SEMI      |                 |      1 |     50 |00:00:00.01 |     158 |
|   2 |   TABLE ACCESS FULL     | T_MANUF53       |      1 |     50 |00:00:00.01 |       4 |
|   3 |   VIEW PUSHED PREDICATE | VW_SQ_1         |     50 |     50 |00:00:00.01 |     154 |
|   4 |    NESTED LOOPS SEMI    |                 |     50 |     50 |00:00:00.01 |     154 |
|*  5 |     INDEX RANGE SCAN    | IX_PRODUCT53_01 |     50 |     50 |00:00:00.01 |      52 |
|*  6 |     INDEX RANGE SCAN    | IX_ORDER53_01   |     50 |     50 |00:00:00.01 |     102 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("P"."M_CODE"="A"."M_CODE")
   6 - access("O"."PROD_ID"="P"."PROD_ID" AND "O"."ORDER_DT">='20090101' AND 
              "O"."ORDER_DT" IS NOT NULL)
*/
ALTER SESSION SET STATISTICS_LEVEL = ALL;
select * from table(dbms_xplan.display_cursor(null, null, 'iostats last'));


