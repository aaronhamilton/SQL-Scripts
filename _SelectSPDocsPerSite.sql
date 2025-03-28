
/* SHAREPOINT DOCS PER SITE  */
DECLARE @sql nvarchar(max)
DECLARE @SiteIndex INT = 1;

WHILE @SiteIndex < 2 -- 167
	BEGIN
		set @sql = 'select ''' + convert(varchar,@SiteIndex) + ''' as SiteIndex, * from [sa_SP2019PROD_Content_Phoenix_Docs_' + convert(varchar,@SiteIndex) + '].dbo.AllDocs where Type = 0 ' --UNION ' + char(13) + char(10)  
		print @sql	
		execute sp_executesql @sql
 		SET @SiteIndex = @SiteIndex + 1;
	END;


--select '1' as SiteIndex, * from [sa_SP2019PROD_Content_Phoenix_Docs_1].dbo.AllDocs where Type = 0 