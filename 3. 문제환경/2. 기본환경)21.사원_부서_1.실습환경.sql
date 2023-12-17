drop table yoon.t_emp;
create table yoon.t_emp 
  (emp_no      varchar2(5),
   emp_name    varchar2(50),
   dept_code   varchar2(2),
   div_code    varchar2(2)       
   );

create public synonym t_emp for yoon.t_emp;

alter table yoon.t_emp
add constraint pk_t_emp primary key(emp_no)
using index;

insert /*+ append */ into t_emp
select  lpad(trim(to_char(rownum)), 5, '0') emp_no
      , '12345678901234567890123456789012345678901234567890' emp_name
      , lpad(to_char(round(dbms_random.value(1, 99))), 2, '0') dept_code
      , lpad(to_char(round(dbms_random.value(2, 99))), 2, '0') div_code
from dual connect by level <= 99999
ORDER BY DBMS_RANDOM.RANDOM();

COMMIT;

UPDATE T_EMP
SET DIV_CODE = '01'
WHERE EMP_NO <= '00010';

SELECT * FROM T_EMP WHERE EMP_NO <= '00010';  
SELECT * FROM T_EMP WHERE DIV_CODE = '01';

commit;

drop table yoon.t_dept;

create table yoon.t_dept
 (
  dept_code   varchar2(2),
  dept_name   varchar2(50),
  loc         varchar2(2)
);

create public synonym t_dept for yoon.t_dept;

alter table yoon.t_dept
add constraint pk_t_dept primary key(dept_code)
using index;

insert /*+ append */ into t_dept
select lpad(trim(to_char(rownum)), 2, '0') 부서코드
     , lpad(trim(to_char(rownum)), 2, '0') 부서명
     , lpad(to_char(round(dbms_random.value(1, 10))), 2, '0') 지역
from dual connect by level <= 99
ORDER BY DBMS_RANDOM.RANDOM();;

commit;

EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_EMP');
EXECUTE DBMS_STATS.GATHER_TABLE_STATS('YOON', 'T_DEPT');