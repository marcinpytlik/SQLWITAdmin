SELECT
    parent_node_id AS [NUMA Node]
    ,COUNT(*) AS [Schedulers]
    ,SUM(IIF(status = N'VISIBLE ONLINE',1,0)) AS [Online Schedulers]
     ,SUM(IIF(status = N'VISIBLE OFFLINE',1,0)) AS [Offline Schedulers]
    ,SUM(current_tasks_count) AS [Current Tasks]
     ,SUM(runnable_tasks_count) AS [Runnable Tasks]
 FROM
    sys.dm_os_schedulers WITH (NOLOCK)
 WHERE
    status IN (N'VISIBLE ONLINE',N'VISIBLE OFFLINE')
 GROUP BY
    parent_node_id OPTION (RECOMPILE, MAXDOP 1);