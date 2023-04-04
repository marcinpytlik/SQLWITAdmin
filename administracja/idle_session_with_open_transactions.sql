use master
GO
select session_id,blocking_session_id,open_transaction_count,wait_time,wait_type,
last_wait_type,wait_resource,transaction_isolation_level,lock_timeout
from sys.dm_exec_requests
where blocking_session_id<>0
GO
-- another option
select session_id,blocking_session_id,wait_duration_ms,wait_type,
resource_description
from sys.dm_os_waiting_tasks
where blocking_session_id is not NULL
GO
