;WITH DBCPU
AS
(
SELECT
pa.DBID, DB_NAME(pa.DBID) AS [DB]
,SUM(qs.total_worker_time/1000) AS [CPUTime]
FROM
sys.dm_exec_query_stats qs WITH (NOLOCK)
CROSS APPLY
(
SELECT CONVERT(INT, value) AS [DBID]
FROM sys.dm_exec_plan_attributes(qs.plan_handle)
WHERE attribute = N'dbid'
) AS pa
GROUP BY pa.DBID
)
SELECT
[DB]
,[CPUTime] AS [CPU Time (ms)]
,CONVERT(decimal(5,2), 1. * [CPUTime] /
SUM([CPUTime]) OVER() * 100.0) AS [CPU Percent]
FROM DBCPU
WHERE DBID <> 32767 -- ResourceDB
ORDER BY [CPUTime] DESC;