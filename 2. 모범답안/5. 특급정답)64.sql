ALTER SESSION SET WORKAREA_SIZE_POLICY='MANUAL';
ALTER SESSION SET SORT_AREA_SIZE=2000000000;

-- :CNO 가 NULL일 경우 활용
-- NOT NULL 일 경우 PK 활용 >> CNO + DT 가 3건으로 변별력이 너무 좋아 수평적 스캔의 비효율이 오히려 효율적
CREATE INDEX YOON.IX_T_TAB64_01 ON YOON.T_TAB64(PRCD, DT);  
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_TAB64');

ALTER SESSION SET WORKAREA_SIZE_POLICY='AUTO';

ALTER SESSION SET STATISTICS_LEVEL = ALL;

-- OR-Expasion이 발생하여 CONTENATION으로 분기하는 방식
-- Scholar Sub Query 제거
-- PK : CNO, DT, SEQ, PRCD
SELECT CNO, DT, SEQ, PRCD, ORDQ, ORDP, DCSSCD
      , MAX(CASE WHEN DCSSCD IN ('D49997', 'D49930') THEN DT END) OVER (PARTITION BY CNO, PRCD ORDER BY DT ROWS UNBOUNDED PRECEDING) PRVLAST
FROM T_TAB64 O
WHERE CNO = NVL(:CNO, CNO) 
 AND  O.DT BETWEEN  '20180203' AND '20180205'
 AND  O.PRCD IN ('P000003', 'P000045', 'P000070')
;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(NULL, NULL, 'IOSTATS LAST'));
/*
-- :CNO = 70
-----------------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name          | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |               |      1 |        |      3 |00:00:00.01 |       5 |
|   1 |  WINDOW SORT                    |               |      1 |      2 |      3 |00:00:00.01 |       5 |
|   2 |   CONCATENATION                 |               |      1 |        |      3 |00:00:00.01 |       5 |
|*  3 |    FILTER                       |               |      1 |        |      0 |00:00:00.01 |       0 |
|   4 |     INLIST ITERATOR             |               |      0 |        |      0 |00:00:00.01 |       0 |
|*  5 |      TABLE ACCESS BY INDEX ROWID| T_TAB64       |      0 |      1 |      0 |00:00:00.01 |       0 |
|*  6 |       INDEX RANGE SCAN          | IX_T_TAB64_01 |      0 |     87 |      0 |00:00:00.01 |       0 |
|*  7 |    FILTER                       |               |      1 |        |      3 |00:00:00.01 |       5 |
|   8 |     TABLE ACCESS BY INDEX ROWID | T_TAB64       |      1 |      1 |      3 |00:00:00.01 |       5 |
|*  9 |      INDEX RANGE SCAN           | PKT_T_64      |      1 |      1 |      3 |00:00:00.01 |       4 |
-----------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
3 - filter(:CNO IS NULL)
5 - filter("CNO"=TO_NUMBER(TO_CHAR("CNO")))
6 - access((("O"."PRCD"='P000003' OR "O"."PRCD"='P000045' OR "O"."PRCD"='P000070')) AND
"O"."DT">='20180203' AND "O"."DT"<='20180205')
7 - filter(:CNO IS NOT NULL)
9 - access("CNO"=TO_NUMBER(:CNO) AND "O"."DT">='20180203' AND "O"."DT"<='20180205')
filter(("O"."PRCD"='P000003' OR "O"."PRCD"='P000045' OR "O"."PRCD"='P000070'))

---- :CNO NULL
-----------------------------------------------------------------------------------------------------------
| Id  | Operation                       | Name          | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                |               |      1 |        |     90 |00:00:00.01 |     101 |
|   1 |  WINDOW SORT                    |               |      1 |      2 |     90 |00:00:00.01 |     101 |
|   2 |   CONCATENATION                 |               |      1 |        |     90 |00:00:00.01 |     101 |
|*  3 |    FILTER                       |               |      1 |        |     90 |00:00:00.01 |     101 |
|   4 |     INLIST ITERATOR             |               |      1 |        |     90 |00:00:00.01 |     101 |
|*  5 |      TABLE ACCESS BY INDEX ROWID| T_TAB64       |      3 |      1 |     90 |00:00:00.01 |     101 |
|*  6 |       INDEX RANGE SCAN          | IX_T_TAB64_01 |      3 |     87 |     90 |00:00:00.01 |      11 |
|*  7 |    FILTER                       |               |      1 |        |      0 |00:00:00.01 |       0 |
|   8 |     TABLE ACCESS BY INDEX ROWID | T_TAB64       |      0 |      1 |      0 |00:00:00.01 |       0 |
|*  9 |      INDEX RANGE SCAN           | PKT_T_64      |      0 |      1 |      0 |00:00:00.01 |       0 |
-----------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
3 - filter(:CNO IS NULL)
5 - filter("CNO"=TO_NUMBER(TO_CHAR("CNO")))
6 - access((("O"."PRCD"='P000003' OR "O"."PRCD"='P000045' OR "O"."PRCD"='P000070')) AND
"O"."DT">='20180203' AND "O"."DT"<='20180205')
7 - filter(:CNO IS NOT NULL)
9 - access("CNO"=TO_NUMBER(:CNO) AND "O"."DT">='20180203' AND "O"."DT"<='20180205')
filter(("O"."PRCD"='P000003' OR "O"."PRCD"='P000045' OR "O"."PRCD"='P000070'))
*/