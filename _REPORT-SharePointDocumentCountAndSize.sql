5fg/**********************************************************/
/* SharePoint Document Count and Size by Content Database */
/**********************************************************/

/*  NOTES

What qualifies as a 'document' in SharePoint?
 - Records from AllDocs where Type = 0 and DocLibRowId NOT NULL  
 - If DocLibRowId IS NULL, the document is a checked-out copy

What are the document types in AppDocs?
 - Type = 2 .... web
 - Type = 1 .... folder
 - Type = 0 .... file in a doclib
*/

USE [sa_SP2019PROD_Content_Phoenix_Docs_165]
GO

-- Document Size Report - KB
select DB_Name() as [Database], count(*) as TotalDocs, max(size)/1000 as [Largest Doc Size (KB)], avg(cast(size as bigint)) / 1000 as [Avg Doc Size (KB)], sum(cast(size as bigint))/1000 as [Total Size All Docs (KB)]   from dbo.alldocs where type = 0
-- Document Size Report - MB/GB
select DB_Name() as [Database], count(*) as TotalDocs, max(size)/1024/1024 as [Largest Doc Size (MB)], avg(cast(size as bigint)) as [Avg Doc Size (KB)], sum(cast(size as bigint))/1024/1024 as [Total Size All Docs (MB)],sum(cast(size as bigint))/1024/1024/102 as [Total Size All Docs (GB)],cast(sum(cast(size as bigint)) as float)/1024/1024/1024/1024 as [Total Size All Docs (TB)]   from dbo.alldocs where type = 0

-- Document Size Report for Docs over 10MB that are Collated
select DB_Name() as [Database], count(*) as TotalDocs, max(size)/1000 as [Largest Doc Size (KB)], avg(cast(size as bigint)) / 1000 as [Avg Doc Size (KB)], sum(cast(size as bigint))/1000 as [Total Size All Docs (KB)]   from dbo.alldocs where type = 0
and size > 10000000
and leafname like '%collat%'

-- Document Size Report for Docs over 10MB that are NOT Collated
select DB_Name() as [Database], count(*) as TotalDocs, max(size)/1000 as [Largest Doc Size (KB)], avg(cast(size as bigint)) / 1000 as [Avg Doc Size (KB)], sum(cast(size as bigint))/1000 as [Total Size All Docs (KB)]   from dbo.alldocs where type = 0
and size > 10000000
and leafname not like '%collat%'

-- Document Size Report for Docs over 10MB that are NOT Collated and created since Aug 15 2021
select DB_Name() as [Database], count(*) as TotalDocs, max(size)/1000 as [Largest Doc Size (KB)], avg(cast(size as bigint)) / 1000 as [Avg Doc Size (KB)], sum(cast(size as bigint))/1000 as [Total Size All Docs (KB)]   from dbo.alldocs where type = 0
and size > 10000000
and leafname not like '%collat%'
and timecreated > '20210815 00:00:00.000'

-- Document URLs
select DB_Name() as [Database], size/1000 as [Size KB], timecreated, 'https://krypton.oct.ca/' + dirname +'/'+ leafname as [Full URL] from dbo.alldocs where type = 0
and size > 10000000
and leafname not like '%collat%'
and timecreated > '20210815 00:00:00.000'

-- Documents per Year
select * from (
	select DB_Name() as [Database], datepart(yyyy,Timecreated) as Year, count(*) [Documents], sum(cast(size as bigint))/1000 as [Total Size (KB)]  from dbo.alldocs where type = 0 group by datepart(yyyy,Timecreated) 
) A order by year DESC

