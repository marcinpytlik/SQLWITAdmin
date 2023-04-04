use master
GO
select r.session_id , r.request_id,t.text as query,
u.allocated as task_internal_object_page_allocation_count,
u.deallocated as task_internal_object_page_deallocation_count
from (select session_id,request_id,
sum(internal_objects_alloc_page_count) as allocated,
sum(internal_objects_dealloc_page_count) as deallocated
from sys.dm_db_task_space_usage
group by session_id,request_id) as u
join sys.dm_exec_requests as r
on u.session_id=r.session_id and u.request_id=r.request_id
cross apply sys.dm_exec_sql_text(r.sql_handle) as t
order by u.allocated desc;
GO