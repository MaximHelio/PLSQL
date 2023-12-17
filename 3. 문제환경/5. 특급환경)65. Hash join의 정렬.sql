drop table scott.t111;
create table scott.t111 as
select owner, object_name, object_id, data_object_id, to_char(created, 'yyyymmdd') created, 
       to_char(last_ddl_time, 'yyyymmdd') last_ddl  
from dba_objects
;

drop table scott.t222;
create table scott.t222 as 
select owner, object_name, object_id, 1000000-data_object_id data_object_id, created, last_ddl
from scott.t111;


select *
from scott.t111 
where object_id >= 85000;

--1,000,000
select *
from scott.t222 
where data_object_id >= 999990;


SELECT * FROM SCOTT.T111;
SELECT * FROM SCOTT.T222;


create index scott.ix_t111 on scott.t111(object_id);
create index scott.ix_t222 on scott.t222(data_object_id);

execute dbms_stats.gather_table_stats('SCOTT', 'T111');
execute dbms_stats.gather_table_stats('SCOTT', 'T222');