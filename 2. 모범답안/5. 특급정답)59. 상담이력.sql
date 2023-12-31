ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2147483647;


-- LOCAL 파티션 인덱스를 2개 만든다. 
CREATE INDEX YOON.IX_상담이력_59_01 ON YOON.상담이력_59(고객명) LOCAL;
CREATE INDEX YOON.IX_상담이력_59_02 ON YOON.상담이력_59(휴대폰번호) LOCAL;
-- 상담원들은 지역별로 고객을 담당하고 있다. 라는 요건으로 고객명과 조직ID는 묶여 있다.
-- 따라서 조직ID는 빠져도 상관 괜찮음.
-- 파티션 프러닝이 발생하여 상담일시는 인덱스 불필요

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', '상담이력_59');

ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;


SELECT 상담이력ID, 조직ID, 상담일시, 고객명, 휴대폰번호
FROM  상담이력_59
WHERE :SRC_FLAG = '1'
 AND  고객명    = :SRC_TXT
 AND  조직ID    = :ORG_ID
 AND  상담일시 BETWEEN '20170201000000' AND '20170228235959'
UNION ALL
SELECT 상담이력ID, 조직ID, 상담일시, 고객명, 휴대폰번호
FROM  상담이력_59
WHERE :SRC_FLAG  = '2'
 AND  휴대폰번호 = :SRC_TXT
 AND  조직ID     = :ORG_ID
 AND  상담일시 BETWEEN '20170201000000' AND '20170228235959'
;


