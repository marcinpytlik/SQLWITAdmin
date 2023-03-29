DECLARE
@now BIGINT;
SELECT @now = cpu_ticks / (cpu_ticks / ms_ticks)
FROM sys.dm_os_sys_info WITH (NOLOCK);
;WITH RingBufferData([timestamp], rec)
AS
(
SELECT [timestamp], CONVERT(XML, record) AS rec
FROM sys.dm_os_ring_buffers WITH (NOLOCK)
WHERE
ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR' AND
record LIKE N'%<SystemHealth>%'
)
,Data(id, SystemIdle, SQLCPU, [timestamp])
AS
(
SELECT
rec.value('(./Record/@id)[1]', 'int')
,rec.value
('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]','int')
,rec.value
('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]'
,'int')
,[timestamp]
FROM RingBufferData
)
SELECT TOP 256
dateadd(MS, -1 * (@now - [timestamp]), getdate()) AS [Event Time]
,SQLCPU AS [SQL Server CPU Utilization]
,SystemIdle AS [System Idle]
,100 - SystemIdle - SQLCPU AS [Other Processes CPU Utilization]
FROM Data
ORDER BY id desc
OPTION (RECOMPILE, MAXDOP 1);