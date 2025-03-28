
----------------------------------------------------
-- Get Count by EndPoint for a Profile 
----------------------------------------------------
declare @Profile char(36); declare @sql nvarchar(1000); declare @searchTerm nvarchar(10); set @searchTerm = '%-100'
select ProfileID, Name from [StoragePoint].[dbo].Profiles where name like @searchTerm
select @Profile = ProfileID from [StoragePoint].[dbo].Profiles where name like @searchTerm
print 'Profile = ' + @Profile
set @sql = 'select ''' + @Profile +''' as ProfileID, EP.Name, PB.EndPointID, count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_' + @Profile +'] PB inner join StoragePoint.dbo.EndPoints EP on EP.EndPointId = PB.EndPointID group by EP.Name, PB.EndPointId '
print 'SQL = ' + @sql 
execute sp_executesql @sql 


select top 


select EP.Name, PB.EndPointID, count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_35BD71C5-DDA2-4656-9BA6-61E376CA5189] PB inner join StoragePoint.dbo.EndPoints EP on EP.EndPointId = PB.EndPointID group by EP.Name, PB.EndPointId 
select top 1 * from StoragePoint.dbo.EndPoints

select * from [StoragePoint].[dbo].Profiles where Name like '%161%' -- ProfileId = '7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D'
select Name, count(*) from [StoragePoint].[dbo].Profiles group by Name having count(*) > 1 --, order by Name

select EP.Name, PB.EndPointID, count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_B43CB487-7542-47DD-8447-D73C2757DD91] PB 
inner join StoragePoint.dbo.EndPoints EP on EP.EndPointId = PB.EndPointID group by EP.Name, PB.EndPointId 

-- Phoenix-Documents-100	6E536FBF-0E15-42A3-B5A5-FB980D9AC196	55784
select count(*) from StoragePoint.dbo.EndPoints EP where EP.EndPointId = '6E536FBF-0E15-42A3-B5A5-FB980D9AC196' 

select top 5 * from StoragePoint.dbo.EndPoints order by EndPointID
/*
ProfileID								Name					EndPointID								BLOBCount
B0D46929-FC81-4423-A92C-DABAEAFB6E77	Phoenix-Documents-65-A	A3136653-0208-4349-8704-89DD437690A7	122
B0D46929-FC81-4423-A92C-DABAEAFB6E77	Phoenix-Documents-100	6E536FBF-0E15-42A3-B5A5-FB980D9AC196	55784
*/


select top 1 * from StoragePoint.dbo.[ProfileBlobs_B0D46929-FC81-4423-A92C-DABAEAFB6E77] 

select * from StoragePoint.dbo.[ProfileBlobs_B0D46929-FC81-4423-A92C-DABAEAFB6E77] where BlobId = 'fffce093-0c62-4312-b119-7f08bef13646'

select * from StoragePoint.dbo.[ProfileBlobs_B0D46929-FC81-4423-A92C-DABAEAFB6E77]  where ProfileId <> 'B0D46929-FC81-4423-A92C-DABAEAFB6E77'

select * from StoragePoint.dbo.[ProfileBlobs_B0D46929-FC81-4423-A92C-DABAEAFB6E77]  where EndPointId <> '6E536FBF-0E15-42A3-B5A5-FB980D9AC196'

select EndPointId, count(*) as BlobCount from StoragePoint.dbo.[ProfileBlobs_B0D46929-FC81-4423-A92C-DABAEAFB6E77]   group by EndPointId


/* LOOK FOR ANY PROFILE BLOBS WITH MORE THAN ONE END POINT */

DECLARE @sql nvarchar(max); DECLARE @SiteIndex INT = 1;  DECLARE @ProfileID char(36); DECLARE @ProfileName nvarchar(100); 

--WHILE @SiteIndex < 168
--	BEGIN
set @SiteIndex = 161
		select @ProfileID = ProfileID, @ProfileName = Name from [StoragePoint].[dbo].Profiles where name like '%-' + convert(varchar,@SiteIndex)
		set @sql = 'select PBlob.ProfileName, ''' + @ProfileID  + ''' as PrimaryProfileID, PBlob.EndPointId, PBlob.ProfileID as BlobProfileID, EP.Name as BlobEPName, IsCurrent, PBlob.BlobCount from StoragePoint.dbo.EndPoints EP ' + char(13) + char(10)
		set @sql = @sql + 'inner join (  ' + char(13) + char(10)
		set @sql = @sql + '   select ' + convert(varchar,@SiteIndex) + ' as SiteIndex, ''' + @ProfileName  + ''' as ProfileName, ProfileID, EndPointId, count(*) as BlobCount from StoragePoint.dbo.[ProfileBlobs_' + @ProfileID  + ']   group by Profileid, EndPointId'
		set @sql = @sql + ')  as [PBlob] ' + char(13) + char(10)
		set @sql = @sql + 'on PBlob.EndPointId = EP.EndPointId '
		print @sql
		execute sp_executesql @sql
 		SET @SiteIndex = @SiteIndex + 1;
	END;

select top 1 *  from StoragePoint.dbo.[ProfileBlobs_F7C104B1-F07B-4E57-AADD-1B5556DA4CA8] 

/*
ProfileName				PrimaryProfileID						EndPointId								BlobProfileID							BlobEPName				IsCurrent	BlobCount
Phoenix-Documents-7		2D73376B-2CA2-4AAC-A527-82133CAD3808	E7FD8C53-1D55-43C5-88A5-1ADEA688B6A7	2D73376B-2CA2-4AAC-A527-82133CAD3808	Phoenix-Documents-7		1			4			confirm these BLOBs are not important
Phoenix-Documents-7		2D73376B-2CA2-4AAC-A527-82133CAD3808	CA625E07-EE6E-47DC-B852-6C2AC4F338E5	2D73376B-2CA2-4AAC-A527-82133CAD3808	Phoenix-Documents-7-A	1			180144

Phoenix-Documents-24	D677E2AF-CAE4-4F89-AD08-60A92B21922A	8FF95011-397D-453B-A03B-7C1641CB5849	D677E2AF-CAE4-4F89-AD08-60A92B21922A	Phoenix-Documents-24	1			12			confirm these BLOBs are not important
Phoenix-Documents-24	D677E2AF-CAE4-4F89-AD08-60A92B21922A	2864F4B8-DED6-42CF-8485-3BFA61D4F0DB	D677E2AF-CAE4-4F89-AD08-60A92B21922A	Phoenix-Documents-24-A	1			181716

Phoenix-Documents-63	712EA6FF-A1B6-4DED-9CAB-916141582E26	6E536FBF-0E15-42A3-B5A5-FB980D9AC196	712EA6FF-A1B6-4DED-9CAB-916141582E26	Phoenix-Documents-100	1			36934		migrate from EP 100 to EP 63-A
Phoenix-Documents-63	712EA6FF-A1B6-4DED-9CAB-916141582E26	9BD274EC-042E-49E7-AE61-08FED7B69016	712EA6FF-A1B6-4DED-9CAB-916141582E26	Phoenix-Documents-63-A	1			30

Phoenix-Documents-65	B0D46929-FC81-4423-A92C-DABAEAFB6E77	A3136653-0208-4349-8704-89DD437690A7	B0D46929-FC81-4423-A92C-DABAEAFB6E77	Phoenix-Documents-65-A	1			122
Phoenix-Documents-65	B0D46929-FC81-4423-A92C-DABAEAFB6E77	6E536FBF-0E15-42A3-B5A5-FB980D9AC196	B0D46929-FC81-4423-A92C-DABAEAFB6E77	Phoenix-Documents-100	1			55784		migrate from EP 100 to EP 65-A

Phoenix-Documents-93	A4F6437A-C638-4116-AC2A-E2CF0A1749D0	D4F4C696-C385-43A0-90F9-74BB9B5CA52C	A4F6437A-C638-4116-AC2A-E2CF0A1749D0	Phoenix-Documents-93	1			1			file has been deleted - clean up BLOB with UBC
Phoenix-Documents-93	A4F6437A-C638-4116-AC2A-E2CF0A1749D0	3B0AE473-E994-4B7F-BF5E-7B80814BEAE0	A4F6437A-C638-4116-AC2A-E2CF0A1749D0	Phoenix-Documents-93-A	1			15032

	select * from StoragePoint.dbo.[ProfileBlobs_A4F6437A-C638-4116-AC2A-E2CF0A1749D0] Z where Z.EndPointId = 'D4F4C696-C385-43A0-90F9-74BB9B5CA52C' --> 144 records in State = 1... because it was deleted but not yet flagged for deletion

Phoenix-Documents-100	B43CB487-7542-47DD-8447-D73C2757DD91	6074BB0A-EAA3-470D-A2BA-DF47E8D9473A	B43CB487-7542-47DD-8447-D73C2757DD91	Phoenix-Documents-100-A	1			1064		check SP docs & shards

	select * from StoragePoint.dbo.[ProfileBlobs_B43CB487-7542-47DD-8447-D73C2757DD91]  --> 1,064 records in State = 1

Phoenix-Documents-161	7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D	2E12D3FB-BC40-44DE-B706-3037E7C7AAB7	7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D	Phoenix-Documents-161	1			8

Phoenix-Documents-161	35BD71C5-DDA2-4656-9BA6-61E376CA5189	8231793D-F95C-4B42-AFF5-B48C93DCF542	35BD71C5-DDA2-4656-9BA6-61E376CA5189	Phoenix-Documents-161-A	1			591059

		select * from StoragePoint.dbo.[ProfileBlobs_7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D] -- Z where Z.EndPointId = '4D797549-208E-450A-9817-E2CC1E5C7439' --> 8 Blobs in State = 2	ready for cleanup

Phoenix-Documents-165	20CE1A08-5F58-4550-A6ED-31106AD9470F	4D797549-208E-450A-9817-E2CC1E5C7439	20CE1A08-5F58-4550-A6ED-31106AD9470F	Phoenix-Documents-165	1			144			file has been migrated - clean up BLOB with UBC
Phoenix-Documents-165	20CE1A08-5F58-4550-A6ED-31106AD9470F	A010A216-C5B0-4364-A745-CF3699A25E3F	20CE1A08-5F58-4550-A6ED-31106AD9470F	Phoenix-Documents-165-A	1			859295

	select * from StoragePoint.dbo.[ProfileBlobs_20CE1A08-5F58-4550-A6ED-31106AD9470F] Z where Z.EndPointId = '4D797549-208E-450A-9817-E2CC1E5C7439' --> 144 records in State = 2... ready for cleanup?

Phoenix-Documents-166	660BF69B-88F6-4717-9196-82371A3C846C	E4EA095B-C1B7-449B-9D9F-1FE349403933	660BF69B-88F6-4717-9196-82371A3C846C	Phoenix-Documents-166	1			4			confirm these BLOBs are not important
Phoenix-Documents-166	660BF69B-88F6-4717-9196-82371A3C846C	9A4187C6-CEE0-4642-82BF-558C324957A4	660BF69B-88F6-4717-9196-82371A3C846C	Phoenix-Documents-166-A	1			236

	select * from StoragePoint.dbo.[ProfileBlobs_660BF69B-88F6-4717-9196-82371A3C846C] Z where Z.EndPointId = 'E4EA095B-C1B7-449B-9D9F-1FE349403933' --> 4 records in State = 2
*/



/*
ProfileID								Name
A4F6437A-C638-4116-AC2A-E2CF0A1749D0	Phoenix-Documents-93

Name					EndPointID								BLOBCount
Phoenix-Documents-93	D4F4C696-C385-43A0-90F9-74BB9B5CA52C	1
Phoenix-Documents-93-A	3B0AE473-E994-4B7F-BF5E-7B80814BEAE0	15031


ProfileID	Name
B43CB487-7542-47DD-8447-D73C2757DD91	Phoenix-Documents-100

Name					EndPointID								BLOBCount
Phoenix-Documents-100-A	6074BB0A-EAA3-470D-A2BA-DF47E8D9473A	1061


ProfileID								Name
83A6D254-E407-4B8E-9E10-A748D19F1126	Phoenix-Documents-160

Name					EndPointID								BLOBCount
Phoenix-Documents-160-A	3596A2B2-48FB-46D2-82E5-B168E1174BC3	579324



ProfileID								Name
20CE1A08-5F58-4550-A6ED-31106AD9470F	Phoenix-Documents-165

Name					EndPointID								BLOBCount
Phoenix-Documents-165-A	A010A216-C5B0-4364-A745-CF3699A25E3F	856208
Phoenix-Documents-165	4D797549-208E-450A-9817-E2CC1E5C7439	144

		select top 1 EP.Name, PB.EndPointID, count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_20CE1A08-5F58-4550-A6ED-31106AD9470F] PB inner join StoragePoint.dbo.EndPoints EP on EP.EndPointId = PB.EndPointID group by EP.Name, PB.EndPointId 
		select * from StoragePoint.dbo.[ProfileBlobs_20CE1A08-5F58-4550-A6ED-31106AD9470F]  where EndPointId = '4D797549-208E-450A-9817-E2CC1E5C7439'

		select * from StoragePoint.dbo.[ProfileBlobs_20CE1A08-5F58-4550-A6ED-31106AD9470F] where ItemId = 'D2A05CC9-F0CA-430B-97C7-B5E266ABD82F'


ProfileID								Name
7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D	Phoenix-Documents-161
	- ENDPOINT Phoenix-Documents-161	2E12D3FB-BC40-44DE-B706-3037E7C7AAB7 --- 8 blobs
35BD71C5-DDA2-4656-9BA6-61E376CA5189	Phoenix-Documents-161
	- ENDPOINT Phoenix-Documents-161-A	8231793D-F95C-4B42-AFF5-B48C93DCF542

Name					EndPointID								BLOBCount
Phoenix-Documents-161-A	8231793D-F95C-4B42-AFF5-B48C93DCF542	591034

	select EP.Name, PB.EndPointID, count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D] PB inner join StoragePoint.dbo.EndPoints EP on EP.EndPointId = PB.EndPointID group by EP.Name, PB.EndPointId 
		Name					EndPointID								BLOBCount
		Phoenix-Documents-161	2E12D3FB-BC40-44DE-B706-3037E7C7AAB7	8

		select * from StoragePoint.dbo.[ProfileBlobs_7CF74E1C-2345-4EE4-80AB-20E9DDD5B77D] 

	select EP.Name, PB.EndPointID, count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_35BD71C5-DDA2-4656-9BA6-61E376CA5189] PB inner join StoragePoint.dbo.EndPoints EP on EP.EndPointId = PB.EndPointID group by EP.Name, PB.EndPointId 
		Name					EndPointID								BLOBCount
		Phoenix-Documents-161-A	8231793D-F95C-4B42-AFF5-B48C93DCF542	591034
*/


select * from [Phoenix_DocumentMigration_Mappings].dbo.[AllShards] A where MemberName = 'Darell Small'

select * from 

--------------------------------------------------------------
-- Get StreamCount and BLOBCount by EndPoint for Any Profile
--------------------------------------------------------------
declare @searchTerm nvarchar(10); set @searchTerm = '93'
declare @SiteIndex nvarchar(10); declare @ProfileID char(36); declare @sql nvarchar(max); declare @linebreak nvarchar(10); set @linebreak = CHAR(13)+CHAR(10); set @SiteIndex = @searchTerm
select ProfileID, Name from [StoragePoint].[dbo].Profiles where name like '%-' + @searchTerm; select @ProfileID = ProfileID from [StoragePoint].[dbo].Profiles where name like '%-' + @searchTerm; print 'Profile = ' + @ProfileID
set @sql = '-- START' + @linebreak + 'select AD.Dirname, AD.LeafName, AD.DeleteTransactionId, format(cast(AD.Size as float)/1024/1000, ''N2'') as SizeMB, AD.Id as ItemId, DS.StreamCount, B.BLOBCount, EP.Name, B.EndPointID ' + @linebreak
set @sql = @sql + 'from (select ItemId, EndPointId, Count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_' + @ProfileID + '] PB group by itemid, endpointid) B ' + @linebreak 
set @sql = @sql + 'left outer join (select DocId, count(*) as StreamCount from [sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].dbo.DocStreams group by DocId) DS on DS.DocId = B.ItemID ' + @linebreak
set @sql = @sql + 'right outer join [sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].dbo.AllDocs AD on AD.Id = B.ItemId ' + @linebreak 
set @sql = @sql + 'left outer join StoragePoint.dbo.EndPoints EP on EP.EndPointId = B.EndPointID ' + @linebreak 
set @sql = @sql + 'where AD.HasStream = 1 order by B.ItemId desc ' + @linebreak + ' -- END'
print 'SQL = ' + @sql ;  execute sp_executesql @sql 

--------------------------------------------------------------------------------------------------------------
-- Identify documents whose StreamCount matches (or don't match) BLOBCount for a Given EndPoint and Profile
--------------------------------------------------------------------------------------------------------------
declare @searchTerm nvarchar(10); declare @operator nvarchar (5); declare @endpointPrefix nvarchar(5); declare @searchTermWithEndpointPrefix nvarchar(10);
set @searchTerm = '109'; set @endpointPrefix = '-A'; set @searchTermWithEndpointPrefix = @searchTerm + @endpointPrefix
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
set @sql = @sql + 'select ''Document BLOBs not Referenced in StoragePoint Profile Table'', * from #BLOBReport where BLOBCount is NULL' + @linebreak + @linebreak
set @sql = @sql + 'select ''Mismatched BLOBs Counts'', * from #BLOBReport where StreamCount <> BLOBCount ' + @linebreak + @linebreak
set @sql = @sql + 'select ''Mismatched BLOBs Counts (counting upcoming expirations)'', * from #BLOBReport where StreamCount_inclExpiration <> BLOBCount ' + @linebreak + @linebreak
print 'SQL = ' + @sql ; execute sp_executesql @sql 

-- Look up Document BLOBs
4F941AE2-2D62-44F1-837C-DC8D8E839C28
CC6D7FE1-C449-4993-8D9D-6851870FF3AE
F8E47BBF-CC19-4EF9-B238-58B7A5D83B0D
declare @ItemID nvarchar(36); set @ItemID = 'F8E47BBF-CC19-4EF9-B238-58B7A5D83B0D'
select * from [sa_SP2019PROD_Content_Phoenix_Docs_1].dbo.DocsToStreams where DocId = @ItemID order by HistVersion, StreamId
select ItemId, EndPointId, Count(*) as BLOBCount from StoragePoint.dbo.[ProfileBlobs_6AF14AF4-C3D1-4D29-AE33-63CF2029821D] PB where ItemId = @ItemID group by itemid, endpointid
select top 10 * from [sa_SP2019PROD_Content_Phoenix_Docs_18].dbo.DocStreams where DocId = @ItemID

select top 1 * from [sa_SP2019PROD_Content_Phoenix_Docs_93].dbo.AllDocs order by id desc
select top 5 * from [sa_SP2019PROD_Content_Phoenix_Docs_93].dbo.AllDocs where leafname like 'Deceased Notification from Pension Board%' -- 'Deceased Notification from Pension Board_138737_20211013_162151721.pdf'
select * from [sa_SP2019PROD_Content_Phoenix_Docs_93].dbo.AllDocs where leafname like 'Deceased Notification from Pension Board_138737_20211013_162151721.pdf'
select * from [sa_SP2019PROD_Content_Phoenix_Docs_93].dbo.AllDocs where dirname like 'docs/93/Deceased%' -- Notification from Pension Board_138737_20211013_162151721.pdf'
 'Deceased Notification from Pension Board_138737_20211013_162151721.pdf'

select * from sa_SP2019PROD_Content_Phoenix_Docs_100.dbo.allLists where tp_title = 'Client' -- ID = C69B2B4A-7345-4805-9883-7BF67F67A7E5 ;  webId = CCEAE443-4ACB-4045-A157-74F7B9C67631

select top 100 * from [sa_SP2019PROD_Content_Phoenix_Docs_93].dbo.AllDocs where dirname like 'docs/93' -- and listid = 'C69B2B4A-7345-4805-9883-7BF67F67A7E5'
77B77447-F34D-4CC8-86BD-5A60BDF1F25F	8AC68AB1-A408-457F-9907-E0927BF25136	docs/93	Deceased Notification from Pension Board_138737_20211013_162151721.pdf	1	26631DB0-347B-4040-999B-3C2D1605CF42	0x	1EA9FA5F-207A-4E3D-AFDB-1D2793E1F002	NULL	NULL	0	0	1825	1	257	257	1	149	100	66	1	0	512	0	0	320	0	-2	NULL	2021-10-13 20:23:59.000	2021-10-13 20:23:59.000	NULL	2021-10-13 20:23:59.000	2021-10-13 20:23:59.000	16	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	0	NULL	NULL	NULL	NULL	0xA8A930310C00000007010000789C8DCEB10E82301006E0DDC4A77086002A06121717E300830C389098D29650140A77A548C2C35B425C8C83CB2DF7FDFF9D56E2CE72A425AF89E680423661729D5CDF766C776FE67AA50DC11624C5DFCC0B761F3680505C93A7604419A2E4831B974EE2763EC558557D14BD62BF6B9366EC02482F65218F4BB225801CBEABCD0FCEF6E02DA4964C1482B37C9CF7227436F63049AA2C2561BE9565146A0B4754BC5E12A457A5847FF41BBA5B5D21	186	1	NULL	NULL	NULL	NULL	NULL	1	NULL	NULL	1.0	9F4B5F6F-F6EB-490D-BD0C-0EB32E64C020	NULL	NULL	NULL	NULL	NULL	NULL	pdf	pdf	0	0	NULL	0	0	NULL	NULL	0x0289718136C8E3B8C33137AAA94A7CAAF6B58885FA	1825	1825	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL

select top 100 * from [sa_SP2019PROD_Content_Phoenix_Docs_100].dbo.AllDocs where leafname like '%'


select * from [sa_SP2019PROD_Content_Phoenix_Docs_93].dbo.AllDocs where ListId is null and Type = 0 --dirname like 'docs/93' 
	-- 77B77447-F34D-4CC8-86BD-5A60BDF1F25F	8AC68AB1-A408-457F-9907-E0927BF25136	docs/93	Deceased Notification from Pension Board_138737_20211013_162151721.pdf	1	26631DB0-347B-4040-999B-3C2D1605CF42	0x	1EA9FA5F-207A-4E3D-AFDB-1D2793E1F002	NULL	NULL	0	0	1825	1	257	257	1	149	100	66	1	0	512	0	0	320	0	-2	NULL	2021-10-13 20:23:59.000	2021-10-13 20:23:59.000	NULL	2021-10-13 20:23:59.000	2021-10-13 20:23:59.000	16	NULL	NULL	NULL	NULL	NULL	NULL	0	NULL	NULL	0	NULL	NULL	NULL	NULL	0xA8A930310C00000007010000789C8DCEB10E82301006E0DDC4A77086002A06121717E300830C389098D29650140A77A548C2C35B425C8C83CB2DF7FDFF9D56E2CE72A425AF89E680423661729D5CDF766C776FE67AA50DC11624C5DFCC0B761F3680505C93A7604419A2E4831B974EE2763EC558557D14BD62BF6B9366EC02482F65218F4BB225801CBEABCD0FCEF6E02DA4964C1482B37C9CF7227436F63049AA2C2561BE9565146A0B4754BC5E12A457A5847FF41BBA5B5D21	186	1	NULL	NULL	NULL	NULL	NULL	1	NULL	NULL	1.0	9F4B5F6F-F6EB-490D-BD0C-0EB32E64C020	NULL	NULL	NULL	NULL	NULL	NULL	pdf	pdf	0	0	NULL	0	0	NULL	NULL	0x0289718136C8E3B8C33137AAA94A7CAAF6B58885FA	1825	1825	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL

select * from [sa_SP2019PROD_Content_Phoenix_Docs_92].dbo.AllDocs where ListId is null and Type = 0 --dirname like 'docs/93' 

/* LOOK FOR ANY SHAREPOINT DOCS WHERE PATH IS NOT A DOC LIBRARY */
DECLARE @sql nvarchar(max)
DECLARE @SiteIndex INT = 1;

WHILE @SiteIndex < 2 -- 167
	BEGIN
		set @sql = 'select ''' + convert(varchar,@SiteIndex) + ''' as SiteIndex, * from [sa_SP2019PROD_Content_Phoenix_Docs_' + convert(varchar,@SiteIndex) + '].dbo.AllDocs where ListId is null and Type = 0 ' --UNION ' + char(13) + char(10)  
		print @sql	
		execute sp_executesql @sql
 		SET @SiteIndex = @SiteIndex + 1;
	END;


select '1' as SiteIndex, * from [sa_SP2019PROD_Content_Phoenix_Docs_1].dbo.AllDocs where ListId is null and Type = 0 
