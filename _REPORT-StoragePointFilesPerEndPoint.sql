use Storagepoint
GO

DROP TABLE #EndPoints
select EndPointID, [Name], IsCurrent,[State],[Status] INTO #EndPoints from EndPoints

drop table #StoragePointProfiles
GO

Create table #StoragePointProfiles (
	[ProfileID] nvarchar(50),[EndPointID] nvarchar(50),EndPointName nvarchar(50),[FileCount] int
);
GO

DECLARE @sql nvarchar(500)
DECLARE @table_name NVARCHAR(50) 
DECLARE @profileid CHAR(36) 
DECLARE @endpointid CHAR(36)

DECLARE db_cursor CURSOR FOR 
--SELECT profileid, table_name FROM  StoragePoint.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE 'ProfileBlobs%' 
SELECT profileid, endpointid from dbo.ProfileEndPoints

select * from #StoragePointProfiles order by FileCount DESC
select * from #storagepointprofiles order by EndPointName
select sum(FileCount) from #storagepointprofiles -- group by filecount



OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @profileid, @endpointid

WHILE @@FETCH_STATUS = 0  
BEGIN 
	---set @sql = 'INSERT INTO #StoragePointProfiles select ''' + @profileid + ''', ''' + @endpointid + ''',  count(*) from [dbo].[ProfileBlobs_' + @profileid + '] where EndPointid = ''' + @endpointid + ''''
	set @sql = 'INSERT INTO #StoragePointProfiles select ''' + @profileid + ''', ''' + @endpointid + ''',  (select name from EndPoints where EndpointID = ''' + @endpointid + '''), count(*) from [dbo].[ProfileBlobs_' + @profileid + '] where EndPointid = ''' + @endpointid + ''''
print @sql
	EXECUTE sp_executesql @sql

	FETCH NEXT FROM db_cursor INTO @profileid, @endpointid
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

select * from #StoragePointProfiles order by FileCount desc




