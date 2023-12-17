-- DBMS Sort 영역 메모리 확보를 위한 스크립트
ALTER SESSION SET WORKAREA_SIZE_POLICY = MANUAL;
ALTER SESSION SET SORT_AREA_SIZE = 2000000000;

-- 최초 수행 시 해당 테이블이 없기에 에러나는 것이 정상
drop table yoon.t_emp23;

-- DB 계정 yoon에 테이블을 만들며, 다른 계정에 만들경우 yoon 대신 다른 계정 사용 가능
create table yoon.t_emp23 AS
select  lpad(trim(to_char(rownum)), 8, '0') emp_no
      , '12345678901234567890123456789012345678901234567890' emp_name
      , lpad(to_char(round(dbms_random.value(1, 99))), 2, '0') dept_code
      , lpad(to_char(round(dbms_random.value(2, 999))), 3, '0') div_code
from dual connect by level <= 9999999;

COMMIT;

-- from 절에 스키마명(계정명)을 넣지 않고 테이블 명칭만으로 조회 가능하도록 만드는 기능
-- 다른 계정에 만들었을 경우 for 다음에 "yoon" 대신 다른 계정을 입력하면 가능
create public synonym t_emp23 for yoon.t_emp23;

UPDATE T_EMP23
SET DIV_CODE = '001'
WHERE EMP_NO <= '00000010';

COMMIT;

-- 다른 계정에 테이블을 만들었을 때는 on 다음에 yoon 대신 다른 계정 입력
CREATE INDEX YOON.IX_T_EMP23 ON YOON.T_EMP23(DEPT_CODE);

-- 다른 계정에 테이블을 만들었을 때는 첫 번째 파라미터에 YOON 대신 다른 계정 입력
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_EMP23');

-- DBMS Sort 영역 메모리 확보를 했던 것 원상복구
ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;