use master
go
select t.text,r.status,r.command,databaseName´db_name(r.database_id),
r.cpu_time,r.total_elapsed_time,r.percent_complete
from sys.dm_exec.requests r
cross apply sys.dm_exec.sql_text(r.sql_handle) t

