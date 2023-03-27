SELECT ISNULL(d.[name], bs.[database_name]) AS [Database], d.recovery_model_desc AS [Recovery Model], 
    d.log_reuse_wait_desc AS [Log Reuse Wait Desc],
	CONVERT(DECIMAL(18,2), ds.cntr_value/1024.0) AS [Total Data File Size on Disk (MB)],
	CONVERT(DECIMAL(18,2), ls.cntr_value/1024.0) AS [Total Log File Size on Disk (MB)], 
	CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT) AS DECIMAL(18,2)) * 100 AS [Log Used %],
    MAX(CASE WHEN bs.[type] = 'D' THEN bs.backup_finish_date ELSE NULL END) AS [Last Full Backup],
	MAX(CASE WHEN bs.[type] = 'D' THEN CONVERT (BIGINT, bs.compressed_backup_size / 1048576 ) ELSE NULL END) AS [Last Full Compressed Backup Size (MB)],
    MAX(CASE WHEN bs.[type] = 'I' THEN bs.backup_finish_date ELSE NULL END) AS [Last Differential Backup],
    MAX(CASE WHEN bs.[type] = 'L' THEN bs.backup_finish_date ELSE NULL END) AS [Last Log Backup],
	DATABASEPROPERTYEX ((d.[name]), 'LastGoodCheckDbTime') AS [Last Good CheckDB]
FROM sys.databases AS d WITH (NOLOCK)
INNER JOIN sys.master_files as mf WITH (NOLOCK)
ON d.database_id = mf.database_id
LEFT OUTER JOIN msdb.dbo.backupset AS bs WITH (NOLOCK)
ON bs.[database_name] = d.[name]
AND bs.backup_finish_date > GETDATE()- 30
LEFT OUTER JOIN sys.dm_os_performance_counters AS lu WITH (NOLOCK)
ON d.name = lu.instance_name
LEFT OUTER JOIN sys.dm_os_performance_counters AS ls WITH (NOLOCK)
ON d.name = ls.instance_name
INNER JOIN sys.dm_os_performance_counters AS ds WITH (NOLOCK)
ON d.name = ds.instance_name
WHERE d.name <> N'tempdb'
AND lu.counter_name LIKE N'Log File(s) Used Size (KB)%' 
AND ls.counter_name LIKE N'Log File(s) Size (KB)%'
AND ds.counter_name LIKE N'Data File(s) Size (KB)%'
AND ls.cntr_value > 0 
GROUP BY ISNULL(d.[name], bs.[database_name]), d.recovery_model_desc, d.log_reuse_wait_desc, d.[name],
         CONVERT(DECIMAL(18,2), ds.cntr_value/1024.0),
	     CONVERT(DECIMAL(18,2), ls.cntr_value/1024.0), 
         CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT) AS DECIMAL(18,2)) * 100
ORDER BY d.recovery_model_desc, d.[name] OPTION (RECOMPILE);
