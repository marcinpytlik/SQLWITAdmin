EXEC sys.xp_readerrorlog 0, 1, N'Manufacturer';
-- This can help you determine the capabilities and capacities of your database server
-- Can also be used to confirm if you are running in a VM
-- This query might take a few seconds if you have not recycled your error log recently
-- This query will return no results if your error log has been recycled since the instance was started
-- Get BIOS date from Windows Registry (Query 19) (BIOS Date)
EXEC sys.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'HARDWARE\DESCRIPTION\System\BIOS', N'BiosReleaseDate';
-- Helps you understand whether the main system BIOS is up to date, and the possible age of the hardware
-- Not as useful for virtualization
-- Does not work on Linux
-- Get processor description from Windows Registry  (Query 20) (Processor Description)
EXEC sys.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'HARDWARE\DESCRIPTION\System\CentralProcessor\0', N'ProcessorNameString';
-- Gives you the model number and rated clock speed of your processor(s)
-- Your processors may be running at less than the rated clock speed due
-- to the Windows Power Plan or hardware power management
-- Does not work on Linux
-- Get information on location, time and size of any memory dumps from SQL Server  (Query 21) (Memory Dump Info)
SELECT [filename], creation_time, size_in_bytes/1048576.0 AS [Size (MB)]
FROM sys.dm_server_memory_dumps WITH (NOLOCK) 
ORDER BY creation_time DESC OPTION (RECOMPILE);
-- This will not return any rows if you have 
-- not had any memory dumps (which is a good thing)
