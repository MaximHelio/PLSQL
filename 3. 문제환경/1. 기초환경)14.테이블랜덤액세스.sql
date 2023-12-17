ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;

drop table yoon.t_주문14;

create table yoon.t_주문14 AS
SELECT A.고객번호, 주문금액, 주문지역코드, B.주문일자
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C1
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C2
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C3
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C4
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C5
     , 'ASDFFDSAASDFFDSAASDFFDSAASDFFDSAASDFFDSA' C6
FROM   (select  'C' || lpad(trim(to_char(rownum)), 4, '0')             고객번호
              , round(dbms_random.value(10000, 100000))                주문금액
              , lpad(to_char(round(dbms_random.value(1, 5))), 2, '0') 주문지역코드
        from dual connect by level <= 1000
        ) A,
       (SELECT  TO_CHAR(TO_DATE('20190901', 'YYYYMMDD') - ROWNUM, 'YYYYMMDD') 주문일자
        FROM DUAL CONNECT BY LEVEL <= 100
       ) B,
       (SELECT ROWNUM R_NUM 
        FROM   DUAL
        CONNECT BY LEVEL <= 100
       )
ORDER BY DBMS_RANDOM.RANDOM();

create public synonym t_주문14 for yoon.t_주문14;

CREATE INDEX YOON.IX_t_주문14_01 ON YOON.t_주문14(주문지역코드, 주문일자, 주문금액);

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 't_주문14');

ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;