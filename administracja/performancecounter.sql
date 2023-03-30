select * from sys.dm_os_performance_counters 
SELECT  dopc.cntr_value,
        dopc.cntr_type
FROM    sys.dm_os_performance_counters AS dopc
-- konkretny performance counter
select * from sys.dm_os_performance_counters 
SELECT  dopc.cntr_value,
        dopc.cntr_type
FROM    sys.dm_os_performance_counters AS dopc
WHERE   dopc.object_name =  'SQLServer:General Statistics' 
        AND dopc.counter_name =  'Logins/sec';