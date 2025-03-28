
select * from (
	select DB_Name (dbid) as DBName, Count(dbid) as NumberOfConnections
	from sys.sysprocesses
	where dbid > 0 
	Group by DBid
) A order by NumberOfConnections desc

select * from (
	select DB_Name (dbid) as DBName, Count(dbid) as NumberOfConnections
	from sys.sysprocesses
	where dbid > 0 
	Group by DBid
) A where DBName like '%StoragePoint%'
order by NumberOfConnections desc

/*	DBName									NumberOfConnections
	StoragePoint							109
	sa_SP2019PROD_Config					39
	master									35
	sa_SP2019PROD_Content_Phoenix_Docs_162	24
*/

/*
DBName	NumberOfConnections
master	34
sa_SP2019PROD_Config	28
StoragePoint	26
sa_SP2019PROD_Search	21
sa_SP2019PROD_Content_Phoenix_Docs_165	15
*/

select * from sys.configurations where name = 'user connections'

/*	configuration_id		name	value	minimum		maximum	value_in_use	description							is_dynamic	is_advanced
	103	user connections	0		0		32767		0						Number of user connections allowed	0			1	
*/

select * from sys.dm_os_performance_counters where counter_name = 'User Connections'
/*	object_name						counter_name		instance_name	cntr_value	cntr_type
	SQLServer:General Statistics    User Connections					1133		65792
*/

-- This script returns the Database, Number of open connections and logged-in user credentials
SELECT DB_NAME(dbid) as DBName, COUNT(dbid) as NumberOfConnections,loginame as LoginName
FROM sys.sysprocesses
WHERE dbid > 0
GROUP BY dbid, loginame

-- This script returns the status, login name and host name for the database you specify.
SELECT spid, status, loginame, hostname, blocked, db_name(dbid), cmd
FROM sys.sysprocesses
WHERE db_name(dbid) = 'StoragePoint' order by spid

-- This script returns the status, login name and host name for the database you specify.
SELECT  *
FROM sys.sysprocesses
WHERE db_name(dbid) = 'StoragePoint' order by spid

sp_who

sp_who2
