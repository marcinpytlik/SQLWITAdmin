SELECT servicename, process_id, startup_type_desc, status_desc, 
last_startup_time, service_account, is_clustered, cluster_nodename, [filename], 
instant_file_initialization_enabled
FROM sys.dm_server_services WITH (NOLOCK) OPTION (RECOMPILE);
-- Tells you the account being used for the SQL Server Service and the SQL Agent Service
-- Shows the process_id, when they were last started, and their current status
-- Also shows whether you are running on a failover cluster instance, and what node you are running on
-- Also shows whether IFI is enabled
