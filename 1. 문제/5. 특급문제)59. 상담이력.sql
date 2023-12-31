/* 상담이력
  - 하루 10만건 데이터 발생
  - 상담조직            : 100개
  - 고객명   카다널리티 : 월평균 5건
  - 전화번호 카디널리티 : 월평균 3건
  - INDEX               : 조직ID + 상담일시(LOCAL PARTITION INDEX)
  - 파티션 키           : 상담일시(연월별 파티션)
  - 상담일시  VARCHAR2(14)
  - 상담원들은 지역별로 고객을 담당하고 있다   
*/

ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;

DROP INDEX YOON.IX_상담이력_59;
CREATE INDEX YOON.IX_상담이력_59 ON YOON.상담이력_59(조직ID, 상담일시) LOCAL;

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '상담이력_59');
ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;

-- 아래의 SQL과  실행계획을 보고 튜닝 하시오.
-- 필요 시 인덱스 재 구축 방안도 제시하시오.

SELECT 상담이력ID, 조직ID, 상담일시, 고객명, 휴대폰번호
FROM  상담이력_59
WHERE 조직ID = :ORG_ID
 AND  상담일시 BETWEEN 20170201000000 AND 20170228235959
 AND  (CASE WHEN :SRC_FLAG = '1' THEN 고객명
            WHEN :SRC_FLAG = '2' THEN 휴대폰번호) = :SRC_TXT
;

/*
Execution Plan
--------------------------------------------------------------------------------
   0      SELECT STATEMENT Optimizer=ALL_ROWS (Cost=15K Card=778 Bytes=36K)
   1    0   PARTITION RANGE (SINGLE) (Cost=15K Card=778 Bytes=36K)
   2    1     TABLE ACCESS (FULL) OF 'YOON.상담이력_59' (TABLE) (Cost=15K Card=778 Bytes=36K)
*/