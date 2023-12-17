DROP   INDEX YOON.IX_T_CUST54_01;
CREATE INDEX YOON.IX_T_CUST54_01 ON YOON.T_CUST54(CUST_TYPE, CUST_NO);

DROP   INDEX YOON.IX_T_ORDER54_01;
CREATE INDEX YOON.IX_T_ORDER54_01 ON YOON.T_ORDER54(CUST_NO, ORDER_TYPE, ORDER_DT);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_CUST54');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_ORDER54');

ALTER SESSION SET STATISTICS_LEVEL=ALL;

/*==========================================================================================

      - ������  T_CUST54 �� ���� ���� �׼����� �ε����� �о� �ٷ� �õ�
        PUSH_SUBQ ����� T_CUST54 �ε����� T_ORDER54 �ε����� ���͸� ��
        ���̺� ���� �׼����� �ϱ� ������ ���� �׼��� ���� ���� �� ����
        ������ push_subq ����� filtering ��� �ε����� root block�� buffer pining�� ���� ����
        
      - ������ T_ORDER54 ���̺��� ���͸� �ϱ� �� 
        T_CUST54 ���̺� �����׼����� ���� �ϱ� ������ ���̺� �����׼��� ���� ���� �߻�
        ��� T_ORDER54�� �ε��� ROOT ����� BUFFER PINING �ϱ⿡ ����
      
      - ��� : �� ����� ���̴� ũ�� ������, ���� �������� PUSH_SUBQ
               ���������� �ε����� BUFFER PINING �� ��� PUSH_SUBQ�� �ξ� ����
               ��, ���� ���� �� PUSH_SUBQ�� �ۼ��� ���� ����
==========================================================================================*/

SELECT /*+ LEADING (C) USE_NL(H)*/ C.CUST_NO, C.CUST_NM, H.HOBBY_TYPE, H.C11
FROM T_CUST54 C,  T_HOBBY54 H
WHERE C.CUST_TYPE    = 'C050'
  AND H.CUST_NO = C.CUST_NO
  AND EXISTS (SELECT /*+ NO_UNNEST PUSH_SUBQ*/ 1
              FROM T_ORDER54 O
              WHERE CUST_NO    = C.CUST_NO
               AND  ORDER_TYPE = '001'
               AND  ORDER_DT IS NULL);
/*
-----------------------------------------------------------------------------------------------------------
| Id  | Operation                     | Name            | Starts | A-Rows |   A-Time   | Buffers | Reads  |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                 |      1 |     15 |00:00:00.07 |    1540 |    330 |
|   1 |  NESTED LOOPS                 |                 |      1 |     15 |00:00:00.07 |    1540 |    330 |
|   2 |   NESTED LOOPS                |                 |      1 |     15 |00:00:00.06 |    1525 |    315 |
|   3 |    TABLE ACCESS BY INDEX ROWID| T_CUST54        |      1 |      5 |00:00:00.06 |    1512 |    315 |
|*  4 |     INDEX RANGE SCAN          | IX_T_CUST54_01  |      1 |      5 |00:00:00.06 |    1507 |    315 |
|*  5 |      INDEX RANGE SCAN         | IX_T_ORDER54_01 |    500 |      5 |00:00:00.06 |    1503 |    315 |
|*  6 |    INDEX RANGE SCAN           | PK_HOBBY54      |      5 |     15 |00:00:00.01 |      13 |      0 |
|   7 |   TABLE ACCESS BY INDEX ROWID | T_HOBBY54       |     15 |     15 |00:00:00.01 |      15 |     15 |
-----------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("C"."CUST_TYPE"='C050')
       filter( IS NOT NULL)
   5 - access("CUST_NO"=:B1 AND "ORDER_TYPE"='001' AND "ORDER_DT" IS NULL)
   6 - access("H"."CUST_NO"="C"."CUST_NO")
  */

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST -ROWS'));
/*==========================================================================================
                ���� ���� ����
==========================================================================================*/
SELECT /*+ LEADING (C O@T_ORDER54 H) NL_SJ(O@T_ORDER54) USE_NL(H)*/ C.CUST_NO, C.CUST_NM, H.HOBBY_TYPE, H.C11
FROM T_CUST54 C,  T_HOBBY54 H
WHERE C.CUST_TYPE    = 'C050'
  AND H.CUST_NO = C.CUST_NO
  AND EXISTS (SELECT /*+ QB_NAME(T_ORDER54) UNNEST */ 1
              FROM T_ORDER54 O
              WHERE CUST_NO    = C.CUST_NO
               AND  ORDER_TYPE = '001'
               AND  ORDER_DT IS NULL
              );

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'ALLSTATS LAST -ROWS'));

/*
---------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name            | Starts | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                 |      1 |     15 |00:00:00.01 |    1538 |
|   1 |  NESTED LOOPS                  |                 |      1 |     15 |00:00:00.01 |    1538 |
|   2 |   NESTED LOOPS                 |                 |      1 |     15 |00:00:00.01 |    1523 |
|   3 |    NESTED LOOPS SEMI           |                 |      1 |      5 |00:00:00.01 |    1510 |
|   4 |     TABLE ACCESS BY INDEX ROWID| T_CUST54        |      1 |    500 |00:00:00.01 |     504 |
|*  5 |      INDEX RANGE SCAN          | IX_T_CUST54_01  |      1 |    500 |00:00:00.01 |       4 |
|*  6 |     INDEX RANGE SCAN           | IX_T_ORDER54_01 |    500 |      5 |00:00:00.01 |    1006 |
|*  7 |    INDEX RANGE SCAN            | PK_HOBBY54      |      5 |     15 |00:00:00.01 |      13 |
|   8 |   TABLE ACCESS BY INDEX ROWID  | T_HOBBY54       |     15 |     15 |00:00:00.01 |      15 |
---------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access("C"."CUST_TYPE"='C050')
   6 - access("CUST_NO"="C"."CUST_NO" AND "ORDER_TYPE"='001' AND "ORDER_DT" IS NULL)
   7 - access("H"."CUST_NO"="C"."CUST_NO")
  */
