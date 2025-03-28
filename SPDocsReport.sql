USE [sa_SP2019PROD_Content_Phoenix_Docs_165]
GO

select top 1 * from dbo.AllDocs
select top 10 * from dbo.AllWebs
select top 10 * from dbo.AllSites

select id as [Document GUID], DirName + '/' + Leafname as [FilePath], extension as [File Type], Size as [Size in Bytes], cast(size as float)/1000000 as [Size in MB], TimeCreated, TimeLastModified from dbo.AllDocs D where type = 0 and [DeleteTransactionId] = 0x and Size > 50000000

select FullUrl, D.id as [Document GUID], DirName + '/' + Leafname as [FilePath], extension as [File Type], Size as [Size in Bytes], cast(size as float)/1000000 as [Size in MB], D.TimeCreated, TimeLastModified
from dbo.AllDocs D inner join AllSites [S] on S.Id = D.SiteID 
where type = 0 and [DeleteTransactionId] = 0x and Size > 50000000

select id as [Document GUID], DirName + '/' + Leafname as [FilePath], extension as [File Type], Size as [Size in Bytes], cast(size as float)/1000000 as [Size in MB], TimeCreated, TimeLastModified
from dbo.AllDocs where type = 0 and [DeleteTransactionId] = 0x and Size > 50000000


select extension as [File Type], count(*) [Documents], sum(cast(size as bigint))/1000 as [Total Size (KB)]   from dbo.alldocs where type = 0 group by extension


