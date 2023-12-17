select *
from t_emp e, 
     t_dept d 
where  d.dept_code in ('98', '99')
and    e.dept_code(+) = d.dept_code
and    e.div_code(+) = '75'
;

-----------------and    e.div_code = '75' 에 (+) 표시가 없어 outer 조인 효과가 사라진다.
select *
from t_emp e, 
     t_dept d 
where  d.dept_code in ('98', '99')
and    e.dept_code(+) = d.dept_code
--and    e.div_code (+) between '75' and '76'
and    e.div_code is null;
