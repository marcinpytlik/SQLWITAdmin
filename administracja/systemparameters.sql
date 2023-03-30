--lista wszystkich parametrow
SELECT * from sys.configurations
USE master;
go
EXEC sp_configure  'show advanced option',   1;
RECONFIGURE;
exec sp_configure  'min server memory (MB)',  5120;
exec sp_configure  'max server memory (MB)',  10240;
RECONFIGURE;
go
EXEC sp_configure  'show advanced option',   0;