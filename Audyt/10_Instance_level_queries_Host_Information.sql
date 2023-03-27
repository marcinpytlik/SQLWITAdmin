SELECT host_platform, host_distribution, host_release, 
       host_service_pack_level, host_sku, os_language_version,
	   host_architecture
FROM sys.dm_os_host_info WITH (NOLOCK) OPTION (RECOMPILE); 
-- host_release codes (only valid for Windows)
-- 10.0 is either Windows 10, Windows Server 2016 or Windows Server 2019
-- 6.3 is either Windows 8.1 or Windows Server 2012 R2 
-- 6.2 is either Windows 8 or Windows Server 2012


-- host_sku codes (only valid for Windows)
-- 4 is Enterprise Edition
-- 7 is Standard Server Edition
-- 8 is Datacenter Server Edition
-- 10 is Enterprise Server Edition
-- 48 is Professional Edition
-- 161 is Pro for Workstations

-- 1033 for os_language_version is US-English

-- SQL Server 2019 requires Windows Server 2016 or newer 
