/*-------------------------------------------------------------*\
Name:             listexpensivequeries.sql
Author:           Marcin Pytlik , PracowniaIT Joanny i Marcina Pytlik Sp. z o.o. 
Created Date:     June 06, 2022
Description: find higest query in db QLServer

Sample Usage: use DBNAME
go
and run 
1. with ORDER BY qs.execution_count DESC OPTION (RECOMPILE);-- frequently ran query
2. ORDER BY [Total Logical Reads (MB)] DESC OPTION (RECOMPILE);-- High Disk Reading query
3. ORDER BY [Avg Worker Time (ms)] DESC OPTION (RECOMPILE);-- High CPU query
4. ORDER BY [Avg Elapsed Time (ms)] DESC OPTION (RECOMPILE);-- Long Running query

      
\*-------------------------------------------------------------*/

SELECT TOP(100) qs.execution_count AS [Execution Count],
(qs.total_logical_reads)*8/1024.0 AS [Total Logical Reads (MB)],
(qs.total_logical_reads/qs.execution_count)*8/1024.0 AS [Avg Logical Reads (MB)],
(qs.total_worker_time)/1000.0 AS [Total Worker Time (ms)],
(qs.total_worker_time/qs.execution_count)/1000.0 AS [Avg Worker Time (ms)],
(qs.total_elapsed_time)/1000.0 AS [Total Elapsed Time (ms)],
(qs.total_elapsed_time/qs.execution_count)/1000.0 AS [Avg Elapsed Time (ms)],
qs.creation_time AS [Creation Time]
,t.text AS [Complete Query Text], qp.query_plan AS [Query Plan]
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
WHERE t.dbid = DB_ID()
ORDER BY qs.execution_count DESC OPTION (RECOMPILE);-- frequently ran query
-- ORDER BY [Total Logical Reads (MB)] DESC OPTION (RECOMPILE);-- High Disk Reading query
-- ORDER BY [Avg Worker Time (ms)] DESC OPTION (RECOMPILE);-- High CPU query
-- ORDER BY [Avg Elapsed Time (ms)] DESC OPTION (RECOMPILE);-- Long Running query
