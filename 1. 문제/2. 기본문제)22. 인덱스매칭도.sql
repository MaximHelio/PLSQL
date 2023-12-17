/*
PRIMARY KEY : CUST_NO
인덱스      : CUST_CD + FLAG + DIV

T_CUST22  200만건
  - CUST_CD   2000개 종류(001 ~ 200),  코드당 건수는 약  1만건 
  - DIV       100개 종류(001 ~ 100),  코드당 건수는 약  2만건
  - FLAG      100개  종류,    코드당 건수는 약 20만건

-----------------------------------------------------------------------------------------------
| Id  | Operation                   | Name           | Starts | A-Rows |   A-Time   | Buffers |
-----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                |      1 |    125 |00:00:00.01 |     470 |
|   1 |  TABLE ACCESS BY INDEX ROWID| T_CUST22       |      1 |    125 |00:00:00.01 |     470 |
|*  2 |   INDEX RANGE SCAN          | IX_T_CUST22_01 |      1 |    125 |00:00:00.01 |     345 |
-----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("CUST_CD">='190' AND "FLAG"='160' AND "CUST_CD"<='200')
       filter(("FLAG"='160' AND INTERNAL_FUNCTION("DIV")))
 
  
아래 SQL을 보고 튜닝 하시오(인덱스 및 SQL변경 가능)
*/

SELECT *
FROM T_CUST22 
WHERE  CUST_CD BETWEEN '190' AND '200' 
AND   DIV IN ('30', '40', '50', '60', '20')
AND   FLAG = '160'
;
