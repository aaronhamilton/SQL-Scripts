
/* SHAREPOINT COUNT OF SHARDS PER CONTENT SITE  */
DECLARE @sql nvarchar(max)
DECLARE @SiteIndex INT = 1;
set @sql = ''

WHILE @SiteIndex < 167
	BEGIN
		set @sql = @sql +  'select ''' + convert(varchar,@SiteIndex) + ''' as SiteIndex, count(*) as BLOBCount from [sa_SP2019PROD_Content_Phoenix_Docs_' + convert(varchar,@SiteIndex) + '].dbo.DocsToStreams UNION ' + char(13) + char(10)  
		print @sql	
 		SET @SiteIndex = @SiteIndex + 1;
	END;

set @sql = substring(@sql,0,LEN(@sql)-6) + ' order by Count(*) desc'
execute sp_executesql @sql

/*
SHARD COUNT RESULTS - LATEST

165	940952 - Run date Mar 14
159	662082
163	620407
161	595525

SHARD COUNT RESULTS - OLD

165	933321 - Run date Mar 7 ...?
159	662261
163	620388
161	595519
*/

/* SHAREPOINT COUNT OF DOCUMENTS PER CONTENT SITE  */
DECLARE @sql nvarchar(max)
DECLARE @SiteIndex INT = 1;
set @sql = ''

WHILE @SiteIndex < 167
	BEGIN
		set @sql = @sql + 'select ''' + convert(varchar,@SiteIndex) + ''' as SiteIndex, count(*) as DocumentCount from [sa_SP2019PROD_Content_Phoenix_Docs_' + convert(varchar,@SiteIndex) + '].dbo.Docs UNION ' + char(13) + char(10)  
		print @sql	
 		SET @SiteIndex = @SiteIndex + 1;
	END;

set @sql = substring(@sql,0,LEN(@sql)-6) + ' order by Count(*) desc'
execute sp_executesql @sql

