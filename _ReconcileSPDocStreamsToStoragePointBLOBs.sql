/* RECONCILE SP DOCUMENT STREAMS to STORAGEPOINT BLOBS */

declare @searchTerm nvarchar(10); declare @operator nvarchar (5); declare @endpointPrefix nvarchar(5); declare @searchTermWithEndpointPrefix nvarchar(10);
set @searchTerm = '165'; set @endpointPrefix = '-A'; set @searchTermWithEndpointPrefix = @searchTerm + @endpointPrefix
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

--select * from StoragePoint.dbo.Profiles where name = 'Phoenix-Documents-161'
/*
ProfileId								Name					Type		ScopeId									Id		RoutingRuleName	Xml																																																																																																																																																																																						IsCurrent	IsActive	State
7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D	Phoenix-Documents-161	ContentDb	308FB113-D83C-4591-BE35-031A0BC56CFD	NULL	NULL			<Profile blobretention="1" rbs="yes" archivingenabled="False" allowruledefintionfromimp="False" impendpoints="(all)" selectendpointasync="no" globaldedup="no" lastAccessDateRetention="no" lastAccessDateUpdate="no" backupendpoint="" backupretention="180" rmEnabled="no" rmScope="" rmDeclaredRecord="no" rmDeclaredRecordEndpoint="" rmUndeclaredRecord="no" rmUndeclaredRecordEndpoint="" hmEnabled="no" hmScope="" hmOnHold="no" hmOnHoldEndpoint="" hmRemovedFromHold="no" hmRemovedFromHoldEndpoint="" cdbBackupRetentionDays="0" maxCdbBackupFiles="0" restrCdbBackupEnabled="no" ></Profile>																																					1			0			0
35BD71C5-DDA2-4656-9BA6-61E376CA5189	Phoenix-Documents-161	ContentDb	308FB113-D83C-4591-BE35-031A0BC56CFD	NULL	NULL			<Profile blobretention="1" rbs="yes" archivingenabled="False" allowruledefintionfromimp="False" impendpoints="(all)" selectendpointasync="no" globaldedup="no" lastAccessDateRetention="no" lastAccessDateUpdate="no" backupendpoint="" backupretention="180" rmEnabled="no" rmScope="" rmDeclaredRecord="no" rmDeclaredRecordEndpoint="00000000-0000-0000-0000-000000000000" rmUndeclaredRecord="no" rmUndeclaredRecordEndpoint="00000000-0000-0000-0000-000000000000" hmEnabled="no" hmScope="" hmOnHold="no" hmOnHoldEndpoint="00000000-0000-0000-0000-000000000000" hmRemovedFromHold="no" hmRemovedFromHoldEndpoint="00000000-0000-0000-0000-000000000000" cdbBackupRetentionDays="0" maxCdbBackupFiles="0" restrCdbBackupEnabled="no" ></Profile>	1			1			1
*/

--select * from StoragePoint.dbo.Profiles where name = 'Phoenix-Documents-161' order by Name

--select * from StoragePoint.dbo.[ProfileBlobs_35BD71C5-DDA2-4656-9BA6-61E376CA5189]
 -- many items
--select * from StoragePoint.dbo.ProfileEndPoints where ProfileID = '35BD71C5-DDA2-4656-9BA6-61E376CA5189'
 -- one endpoint - see below 
--select * from StoragePoint.dbo.EndPoints E where E.EndPointId = '8231793D-F95C-4B42-AFF5-B48C93DCF542'
 -- Phoenix-Documents-161-A

--select * from StoragePoint.dbo.[ProfileBlobs_7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D] 
 -- no items (this is the orphan profile)
--select * from StoragePoint.dbo.ProfileEndPoints where ProfileID = '7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D'
/*
ProfileId	EndPointId	Sequence	EndPointType	IsActive
7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D	2E12D3FB-BC40-44DE-B706-3037E7C7AAB7	1	0	1
*/

--select * from StoragePoint.dbo.EndPoints E where E.EndPointId = '2E12D3FB-BC40-44DE-B706-3037E7C7AAB7'
/*
EndPointId								Name					Type	IsCurrent	State	Status
2E12D3FB-BC40-44DE-B706-3037E7C7AAB7	Phoenix-Documents-161	0		1			0		0
*/
--
--select count(*) from [sa_SP2019PROD_Content_Phoenix_Docs_161].dbo.AllDocs
-- 158173

--select count(*) from [sa_SP2019PROD_Content_Phoenix_Docs_162].dbo.AllDocs
-- 160297
