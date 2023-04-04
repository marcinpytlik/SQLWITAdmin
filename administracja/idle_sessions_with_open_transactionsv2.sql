use master
GO
select s.* from sys.dm_exec_sessions as s 
where exists(select * from sys.dm_tran_session_transactions as t
where t.session_id=s.session_id)
and not exists(select * from sys.dm_exec_requests as r 
where r.session_id=s.session_id)
go
