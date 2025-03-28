
declare @searchTerm nvarchar(10); declare @operator nvarchar (5); declare @endpointPrefix nvarchar(5); declare @searchTermWithEndpointPrefix nvarchar(10);
set @searchTerm = '1'; set @endpointPrefix = '-A'; set @searchTermWithEndpointPrefix = @searchTerm + @endpointPrefix
declare @SiteIndex nvarchar(10); declare @ProfileID char(36); declare @ProfileName char(100); declare @sql nvarchar(max); declare @linebreak nvarchar(10); set @linebreak = CHAR(13)+CHAR(10); set @SiteIndex = @searchTerm
declare @ActiveEndPointID char(36); select @ActiveEndPointID = EndPointID from StoragePoint.dbo.[EndPoints] where [Name] like '%-' + @searchTerm + @endpointPrefix ; print 'Active EndPoint = ' + @ActiveEndPointID
select @ProfileID = ProfileID, @ProfileName = P.[Name] from [StoragePoint].[dbo].Profiles P where name like '%-' + @searchTerm; print 'ProfileName = ' + @ProfileName + @linebreak + 'Profile = ' + @ProfileID + @linebreak + @linebreak; 
set @sql = 'if object_id(''tempdb..#BLOBReport'') is not null BEGIN drop table #BLOBReport END' + @linebreak + @linebreak 
set @sql = @sql + 'select AD.Dirname, AD.LeafName, AD.TimeCreated, AD.DeleteTransactionId, format(cast(AD.Size as float)/1024/1000, ''N2'') as SizeMB, AD.Id as ItemId, DS.StreamCount, DS2.StreamCount as StreamCount_inclExpiration, B.BLOBCount, EP.Name as EPName, B.EndPointID, ''' + @ProfileID + ''' as [StoragePoint ProfileID] into #BLOBReport from ' + @linebreak
set @sql = @sql + '[sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].dbo.AllDocs AD' + @linebreak 
set @sql = @sql + 'left join (select ItemId, EndPointId, Count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_' + @ProfileID + '] PB where EndPointId = ''' + @ActiveEndPointID + ''' group by itemid, endpointid) B on B.ItemId = AD.Id ' + @linebreak 
set @sql = @sql + 'left join (select DocId, count(*) as StreamCount from [sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].dbo.DocStreams where ExpirationUTC is NULL group by DocId) DS on DS.DocId = B.ItemID ' + @linebreak
set @sql = @sql + 'left join (select DocId, count(*) as StreamCount from [sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].dbo.DocStreams group by DocId) DS2 on DS2.DocId = B.ItemID ' + @linebreak
set @sql = @sql + 'left join StoragePoint.dbo.EndPoints EP on EP.EndPointId = B.EndPointID ' + @linebreak 
set @sql = @sql + 'where AD.HasStream = 1 ' + @linebreak + @linebreak
set @sql = @sql + 'select ' + @linebreak + @linebreak
set @sql = @sql + '     (select Count(*) as DocsWithNoStream from [sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].dbo.AllDocs AD where AD.HasStream = 0 and ISNULL(ContentVersion,0) > 0 ) AS [Docs - NoStream], ' + @linebreak + @linebreak
set @sql = @sql + '     (select Count(*) as DocsWithStream from [sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].dbo.AllDocs AD where AD.HasStream = 1 ) AS [Docs - WithStream],  ' + @linebreak + @linebreak
set @sql = @sql + '     (select sum(StreamCount) from #BLOBReport) As TotalStreams ' + @linebreak + @linebreak
set @sql = @sql + 'select ''Document BLOBs not Referenced in StoragePoint Profile Table'', * from #BLOBReport where BLOBCount is NULL' + @linebreak + @linebreak
set @sql = @sql + 'select ''Mismatched BLOBs Counts'', * from #BLOBReport where StreamCount <> BLOBCount ' + @linebreak + @linebreak
set @sql = @sql + 'select ''Mismatched BLOBs Counts (counting upcoming expirations)'', * from #BLOBReport where StreamCount_inclExpiration <> BLOBCount ' + @linebreak + @linebreak
print 'SQL = ' + @sql ; execute sp_executesql @sql 

/* GET LIST OF DOCS WITH STREAMS, DOCS WITHOUT STREAMS
select * from [sa_SP2019PROD_Content_Phoenix_Docs_100].dbo.AllDocs AD where AD.HasStream = 1   
select * from [sa_SP2019PROD_Content_Phoenix_Docs_100].dbo.AllDocs AD where AD.HasStream = 0 and Size is not NULL
*/


/*
select AD.Dirname, AD.LeafName, AD.TimeCreated, AD.DeleteTransactionId, format(cast(AD.Size as float)/1024/1000, 'N2') as SizeMB, AD.Id as ItemId, DS.StreamCount, DS2.StreamCount as StreamCount_inclExpiration, B.BLOBCount, 
EP.Name as EPName, B.EndPointID, 'B43CB487-7542-47DD-8447-D73C2757DD91' as [StoragePoint ProfileID] into #BLOBReport from 

select count(*) from [sa_SP2019PROD_Content_Phoenix_Docs_100].dbo.AllDocs AD

left join (select ItemId, EndPointId, Count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_B43CB487-7542-47DD-8447-D73C2757DD91] PB where EndPointId = '6074BB0A-EAA3-470D-A2BA-DF47E8D9473A' group by itemid, endpointid) B on B.ItemId = AD.Id 
left join (select DocId, count(*) as StreamCount from [sa_SP2019PROD_Content_Phoenix_Docs_100].dbo.DocStreams where ExpirationUTC is NULL group by DocId) DS on DS.DocId = B.ItemID 
left join (select DocId, count(*) as StreamCount from [sa_SP2019PROD_Content_Phoenix_Docs_100].dbo.DocStreams group by DocId) DS2 on DS2.DocId = B.ItemID 
left join StoragePoint.dbo.EndPoints EP on EP.EndPointId = B.EndPointID 
where AD.HasStream = 1 

select count(*) StoragePoint.dbo.[ProfileBlobs_B43CB487-7542-47DD-8447-D73C2757DD91]
*/



