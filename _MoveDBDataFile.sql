
declare @dbName nvarchar(200); declare @NewPhysicalPath_DB nvarchar(200); declare @NewPhysicalPath_LOG nvarchar(200); 
set @dbName = 'Phoenix_DocumentMigration_Mappings'
set @NewPhysicalPath_DB = 'F:\MSSQL\Data' -- comment row to skip this file type
--set @NewPhysicalPath_LOG = 'G:\MSSQL\Log' -- comment row to skip this file type

declare @SQL_master nvarchar(100)
set @SQL_master = 'USE master; --do this all from the master '

-- SET DB OFFLINE
--ALTER DATABASE Phoenix_DocumentLocation_Cleanup SET OFFLINE WITH ROLLBACK IMMEDIATE; -- (I use WITH ROLLBACK IMMEDIATE to kick everyone out and rollback all currently open transactions)

declare @FILETYPE_DB int; set @FILETYPE_DB = 0
declare @FILETYPE_LOG int; set @FILETYPE_LOG = 1
declare @CR nvarchar(20); set @CR = CHAR(10) --+ CHAR(13)
declare @LogicalName_DB nvarchar(200)
declare @LogicalName_Log nvarchar(200)
declare @PhysicalName_DB nvarchar(500)
declare @PhysicalName_LOG nvarchar(500)
declare @FileName_DB nvarchar(500)
declare @FileName_LOG nvarchar(500)

-- GET PROPERTIES OF EXISTING DATABASE
SELECT @LogicalName_DB = mf.name, @PhysicalName_DB = mf.physical_name, @FileName_DB = RIGHT(mf.physical_name, CHARINDEX('\', REVERSE(mf.physical_name)) -1) FROM sys.databases db 
INNER JOIN sys.master_files mf on db.database_id = mf.database_id
where db.name = @dbName and mf.type = @FILETYPE_DB --'Phoenix_DocumentMigration_Clients' 

USE master;

-- GET PROPERTIES OF EXISTING LOG FILE
SELECT @LogicalName_Log = mf.name, @PhysicalName_LOG = mf.physical_name, @FileName_LOG = RIGHT(mf.physical_name, CHARINDEX('\', REVERSE(mf.physical_name)) -1)  FROM sys.databases db 
INNER JOIN sys.master_files mf on db.database_id = mf.database_id
where db.name = @dbName and mf.type = @FILETYPE_LOG --'Phoenix_DocumentMigration_Clients' 

-- SHOW OLD SETTINGS
declare @SQL_OldSettings nvarchar(max); 
set @SQL_OldSettings = @CR
set @SQL_OldSettings = '/*' + @CR
set @SQL_OldSettings = @SQL_OldSettings + '--ORIGINAL SETTINGS -----------------------------------------------------------------' + @CR
Set @SQL_OldSettings = @SQL_OldSettings + 'DATABASE NAME: ' + @dbName + @CR
Set @SQL_OldSettings = @SQL_OldSettings + 'LOGICAL NAME: ' + @LogicalName_DB + @CR
Set @SQL_OldSettings = @SQL_OldSettings + 'PHYSICAL PATH: ' + @PhysicalName_DB + @CR
Set @SQL_OldSettings = @SQL_OldSettings + 'LOG LOGICAL NAME: ' + @LogicalName_LOG + @CR
Set @SQL_OldSettings = @SQL_OldSettings + 'LOG LOGICAL PATH: ' + @PhysicalName_LOG + @CR
set @SQL_OldSettings = @SQL_OldSettings + '*/' + @CR

-- NEW DB FILE LOCATION
declare @SQL_AlterDBData nvarchar(max); 
Set @SQL_AlterDBData = @CR + '-- DB FILE' + @CR 
if LEN(@NewPhysicalPath_DB) > 0
BEGIN
	declare @Newfilename_DB nvarchar(200); set @Newfilename_DB = @LogicalName_DB + '.mdf' 
	declare @NewpathAndFilename_DB nvarchar(500); set @NewpathAndFilename_DB = @NewPhysicalPath_DB + '\' + @FileName_DB 

	Set @SQL_AlterDBData = @SQL_AlterDBData + '-- ORIGINAL:' + @PhysicalName_DB + @CR
	Set @SQL_AlterDBData = @SQL_AlterDBData + '-- NEW PATH: ' + @NewpathAndFilename_DB + @CR
	Set @SQL_AlterDBData = @SQL_AlterDBData + 'ALTER DATABASE ' + @dbName + ' MODIFY FILE (name=''' + @LogicalName_DB + ''',filename=''' + @NewpathAndFilename_DB + '''); -- NOTE: Filename is new DB file location'
END
ELSE
	set @SQL_AlterDBData = @SQL_AlterDBData + '-- new DB file location not specified '

declare @SQL_RollbackDB nvarchar(max); 
set @SQL_RollbackDB = @CR + 'ALTER DATABASE ' + @dbName + ' SET OFFLINE WITH ROLLBACK IMMEDIATE;'


-- NEW LOG FILE LOCATION
declare @SQL_AlterLOGData nvarchar(max); 
Set @SQL_AlterLOGData = @CR + '-- LOG FILE' + @CR
if LEN(@NewPhysicalPath_LOG) > 0
BEGIN
	declare @Newfilename_LOG nvarchar(200); set @Newfilename_LOG = @LogicalName_LOG + '.ldf' 
	declare @NewpathAndFilename_LOG nvarchar(500); set @NewpathAndFilename_LOG = @NewPhysicalPath_LOG + '\' + @FileName_LOG 

	Set @SQL_AlterLOGData = @SQL_AlterLOGData + '-- ORIGINAL:' + @PhysicalName_LOG + @CR
	Set @SQL_AlterLOGData = @SQL_AlterLOGData + '-- NEW PATH: ' + @NewpathAndFilename_LOG + @CR
	set @SQL_AlterLOGData = @SQL_AlterLOGData + 'ALTER DATABASE ' + @dbName + ' MODIFY FILE (name=''' + @LogicalName_LOG + ''',filename=''' + @NewpathAndFilename_LOG + '''); -- NOTE: Filename is new LOG file location'
END
ELSE
	set @SQL_AlterLOGData = @SQL_AlterLOGData + '-- new Log file location not specified '



-- MOVE/COPY FILES
declare @SQL_Instructions nvarchar(max); 
set @SQL_Instructions = @CR + '-- NEXT: copy the files over using your favorite method (Click n Drag, XCopy, Copy-Item, Robocopy)' + @CR
-- BRING DB ONLINE

declare @SQL_DBOnline nvarchar(max); 
set @SQL_DBOnline = '-- NEXT: run the following statement to bring DB back online' + @CR + '-- ALTER DATABASE ' + @dbName + ' SET ONLINE;'

print @SQL_master
print @SQL_OldSettings
print @SQL_RollbackDB
print @SQL_AlterDBData
print @SQL_AlterLOGData
print @SQL_Instructions
print @SQL_DBOnline


