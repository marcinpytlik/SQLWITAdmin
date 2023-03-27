
/*-------------------------------------------------------------*\
Name:             dbinfo.sql
Author:           Marcin Pytlik , PracowniaIT Joanny i Marcina Pytlik Sp. z o.o. 
Created Date:     April 20, 2020
Description: Get information about DB

Sample Usage:
      Set @DBName='YourDBName'

\*-------------------------------------------------------------*/
DECLARE @DBName varchar(50);
SET @DBName='Demo';
SELECT 
CONVERT(VARCHAR(25), DB.name) AS dbName,
CONVERT(VARCHAR(10), DATABASEPROPERTYEX(name, 'status')) AS [Status],
state_desc,
(SELECT COUNT(1) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows') AS DataFiles,
(SELECT SUM((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows') AS [Data MB],
(SELECT COUNT(1) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'log') AS LogFiles,
(SELECT SUM((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'log') AS [Log MB],
user_access_desc AS [User access],
recovery_model_desc AS [Recovery model],
CASE compatibility_level
WHEN 60 THEN '60 (SQL Server 6.0)'
WHEN 65 THEN '65 (SQL Server 6.5)'
WHEN 70 THEN '70 (SQL Server 7.0)'
WHEN 80 THEN '80 (SQL Server 2000)'
WHEN 90 THEN '90 (SQL Server 2005)'
WHEN 100 THEN '100 (SQL Server 2008)'
WHEN 110 THEN '110'
WHEN 120 THEN '120'
WHEN 130 THEN '130'
WHEN 140 THEN '140'
WHEN 150 THEN '150'
WHEN 160 THEN '160'
END AS [compatibility level],
CONVERT(VARCHAR(20), create_date, 103) + ' ' + CONVERT(VARCHAR(20), create_date, 108) AS [Creation date],
-- last backup
ISNULL((SELECT TOP 1
CASE TYPE WHEN 'D' THEN 'Full' WHEN 'I' THEN 'Differential' WHEN 'L' THEN 'Transaction log' END + ' – ' +
LTRIM(ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(),Backup_finish_date))) + ' days ago', 'NEVER')) + ' – ' +
CONVERT(VARCHAR(20), backup_start_date, 103) + ' ' + CONVERT(VARCHAR(20), backup_start_date, 108) + ' – ' +
CONVERT(VARCHAR(20), backup_finish_date, 103) + ' ' + CONVERT(VARCHAR(20), backup_finish_date, 108) +
' (' + CAST(DATEDIFF(second, BK.backup_start_date,
BK.backup_finish_date) AS VARCHAR(4)) + ' '
+ 'seconds)'
FROM msdb..backupset BK WHERE BK.database_name = DB.name ORDER BY backup_set_id DESC),'-') AS [Last backup],
CASE WHEN is_fulltext_enabled = 1 THEN 'Fulltext enabled' ELSE '' END AS [fulltext],
CASE WHEN is_auto_close_on = 1 THEN 'autoclose' ELSE '' END AS [autoclose],
page_verify_option_desc AS [page verify option],
CASE WHEN is_read_only = 1 THEN 'read only' ELSE '' END AS [read only],
CASE WHEN is_auto_shrink_on = 1 THEN 'autoshrink' ELSE '' END AS [autoshrink],
CASE WHEN is_auto_create_stats_on = 1 THEN 'auto create statistics' ELSE '' END AS [auto create statistics],
CASE WHEN is_auto_update_stats_on = 1 THEN 'auto update statistics' ELSE '' END AS [auto update statistics],
CASE WHEN is_in_standby = 1 THEN 'standby' ELSE '' END AS [standby],
CASE WHEN is_cleanly_shutdown = 1 THEN 'cleanly shutdown' ELSE '' END AS [cleanly shutdown],
CASE WHEN is_read_committed_snapshot_on = 1		THEN '1' ELSE '0' END AS  [is_read_committed_snapshot_on],
CASE WHEN is_supplemental_logging_enabled = 1	THEN '1' ELSE '0' END AS [is_supplemental_logging_enabled],
CASE WHEN is_auto_create_stats_incremental_on = 1		THEN '1' ELSE '0' END AS [is_auto_create_stats_incremental_on],	 
CASE WHEN is_auto_update_stats_async_on = 1				THEN '1' ELSE '0' END AS [is_auto_update_stats_async_on],			 
CASE WHEN is_ansi_null_default_on = 1					THEN '1' ELSE '0' END AS [is_ansi_null_default_on],				 
CASE WHEN is_ansi_nulls_on =1							THEN '1' ELSE '0' END AS [is_ansi_nulls_on],			
CASE WHEN is_ansi_padding_on = 1						THEN '1' ELSE '0' END AS [is_ansi_padding_on],					 
CASE WHEN is_ansi_warnings_on = 1						THEN '1' ELSE '0' END AS [is_ansi_warnings_on],					 
CASE WHEN is_arithabort_on=1							THEN '1' ELSE '0' END AS [is_arithabort_on],					
CASE WHEN is_concat_null_yields_null_on = 1				THEN '1' ELSE '0' END AS [is_concat_null_yields_null_on],			 
CASE WHEN is_numeric_roundabort_on = 1					THEN '1' ELSE '0' END AS [is_numeric_roundabort_on],				 
CASE WHEN is_quoted_identifier_on = 1					THEN '1' ELSE '0' END AS [is_quoted_identifier_on],		 
CASE WHEN is_recursive_triggers_on = 1					THEN '1' ELSE '0' END AS [is_recursive_triggers_on],				 
CASE WHEN is_cursor_close_on_commit_on = 1				THEN '1' ELSE '0' END AS [is_cursor_close_on_commit_on],			 
CASE WHEN is_local_cursor_default = 1					THEN '1' ELSE '0' END AS [is_local_cursor_default],				 
CASE WHEN is_trustworthy_on = 1							THEN '1' ELSE '0' END AS [is_trustworthy_on],					 
CASE WHEN is_db_chaining_on = 1							THEN '1' ELSE '0' END AS [is_db_chaining_on],						 
CASE WHEN is_parameterization_forced = 1				THEN '1' ELSE '0' END AS [is_parameterization_forced],			 
CASE WHEN is_master_key_encrypted_by_server = 1			THEN '1' ELSE '0' END AS [is_master_key_encrypted_by_server],		 
CASE WHEN is_query_store_on = 1							THEN '1' ELSE '0' END AS [is_query_store_on],				 
CASE WHEN is_published = 1								THEN '1' ELSE '0' END AS [is_published],							 
CASE WHEN is_subscribed = 1								THEN '1' ELSE '0' END AS [is_subscribed],						 
CASE WHEN is_merge_published = 1						THEN '1' ELSE '0' END AS [is_merge_published],					 
CASE WHEN is_distributor = 1							THEN '1' ELSE '0' END AS [is_distributor],				 
CASE WHEN is_sync_with_backup = 1						THEN '1' ELSE '0' END AS [is_sync_with_backup],				 		 				 
CASE WHEN is_cdc_enabled = 1							THEN '1' ELSE '0' END AS [is_cdc_enabled], 
CASE WHEN is_encrypted = 1								THEN '1' ELSE '0' END AS [is_encrypted],							 
CASE WHEN is_honor_broker_priority_on= 1				THEN '1' ELSE '0' END AS [is_honor_broker_priority_on],
CASE WHEN is_nested_triggers_on = 1						THEN '1' ELSE '0' END AS [is_nested_triggers_on],					 
CASE WHEN is_transform_noise_words_on = 1				THEN '1' ELSE '0' END AS [is_transform_noise_words_on],			 
CASE WHEN is_memory_optimized_elevate_to_snapshot_on =1 THEN '1' ELSE '0' END AS [is_memory_optimized_elevate_to_snapshot_on],
CASE WHEN is_federation_member = 1						THEN '1' ELSE '0' END AS [is_federation_member],					 
CASE WHEN is_remote_data_archive_enabled = 1			THEN '1' ELSE '0' END AS [is_remote_data_archive_enabled],		 
CASE WHEN is_mixed_page_allocation_on = 1				THEN '1' ELSE '0' END AS [is_mixed_page_allocation_on],			 
CASE WHEN is_temporal_history_retention_enabled = 1		THEN '1' ELSE '0' END AS [is_temporal_history_retention_enabled],	 
CASE WHEN is_result_set_caching_on = 1					THEN '1' ELSE '0' END AS [is_result_set_caching_on],			 
CASE WHEN is_accelerated_database_recovery_on = 1		THEN '1' ELSE '0' END AS [is_accelerated_database_recovery_on],	 
CASE WHEN is_tempdb_spill_to_remote_store = 1			THEN '1' ELSE '0' END AS [is_tempdb_spill_to_remote_store],		 
CASE WHEN is_stale_page_detection_on = 1				THEN '1' ELSE '0' END AS [is_stale_page_detection_on],			 
CASE WHEN is_memory_optimized_enabled = 1				THEN '1' ELSE '0' END AS [is_memory_optimized_enabled]
FROM sys.databases DB
WHERE DB.name=@DBName
ORDER BY dbName, [Last backup] DESC, NAME
