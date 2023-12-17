ALTER SESSION SET STATISTICS_LEVEL = ALL;

SELECT /*+ LEADING(B) USE_NL(A)  */
       A.CUST_NO, A.CNT, A.PRICE, QTY, DT
    ,  B.CUST_NM, B.C1, B.C2
FROM (SELECT /*+ MERGE */
             CUST_NO, COUNT(*) CNT, SUM(ORDER_PRICE) PRICE, SUM(ORDER_QTY) QTY, MAX(ORDER_DT) DT
      FROM T_ORDER41
      WHERE ORDER_DT BETWEEN '20160302'   AND  '20160302'
      GROUP BY CUST_NO
      ) A, T_CUST41 B
WHERE B.CUST_CD = '76A00'
 AND  A.CUST_NO = B.CUST_NO;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST -ROWS'));
/*
------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name            | Starts | A-Rows |   A-Time   | Buffers | Reads  |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                 |      1 |     53 |00:00:00.16 |    1101 |   1055 |
|   1 |  HASH GROUP BY                 |                 |      1 |     53 |00:00:00.16 |    1101 |   1055 |
|   2 |   NESTED LOOPS                 |                 |      1 |     53 |00:00:00.16 |    1101 |   1055 |
|   3 |    NESTED LOOPS                |                 |      1 |     53 |00:00:00.14 |    1047 |   1002 |
|   4 |     TABLE ACCESS BY INDEX ROWID| T_CUST41        |      1 |    361 |00:00:00.04 |     323 |    410 |
|*  5 |      INDEX RANGE SCAN          | IX_T_CUST41_01  |      1 |    361 |00:00:00.01 |       3 |      5 |
|*  6 |     INDEX RANGE SCAN           | IX_T_ORDER41_01 |    361 |     53 |00:00:00.10 |     724 |    592 |
|   7 |    TABLE ACCESS BY INDEX ROWID | T_ORDER41       |     53 |     53 |00:00:00.01 |      54 |     53 |
------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("B"."CUST_CD"='76A00')
   6 - access("CUST_NO"="B"."CUST_NO" AND "ORDER_DT"='20160302')
 
*/
