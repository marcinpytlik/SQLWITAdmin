use master
go
select t.text,r.status,r.command, db_name(r.database_id) as DatabaseName,
r.cpu_time,r.total_elapsed_time,r.percent_complete
from sys.dm_exec_requests r
cross apply sys.dm_exec_sql_text(r.sql_handle) t
