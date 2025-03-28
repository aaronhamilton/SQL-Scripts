------------------------------------------------------------------------------------------
-- Count of documents created in Sharepoint databases Pre-GoLive
------------------------------------------------------------------------------------------
DECLARE @cnt INT = 1; DECLARE @current varchar(3); DECLARE @SQLCommand nvarchar(max) = ''
DECLARE @Filter nvarchar(200); DECLARE @UpperRange int
--SET @Filter = 'and CheckInComment =  ''Imported by ShareGate'' '
SET @Filter = 'and CheckInComment is NULL and ListId = (select top 1 tp_id from [sa_SP2019PROD_Content_Phoenix_Docs_@current].[dbo].AllLists where tp_title = ''Client'')'
--SET @Filter = '' -- All Documents 
select @filter
select 'Filter for this query: ' + @Filter
SET @UpperRange = 167
WHILE @cnt <= @UpperRange 
BEGIN
	SET @current = CAST(@cnt AS VARCHAR(3))
	SET @SQLCommand = @SQLCommand + 'SELECT ''sa_SP2019PROD_Content_Phoenix_Docs_' + @current + ''' as [Content DB], ' + @current + ' as [Index], count(*) as [Document Count], GetDate() as [Run Date] FROM [sa_SP2019PROD_Content_Phoenix_Docs_' +  @current + '].[dbo].[AllDocs] where Type = 0 ' + Replace(@Filter,'@current',@current)
	if @cnt < @UpperRange SET @SQLCommand = @SQLCommand + ' UNION ' + CHAR(13)+CHAR(10)
   SET @cnt = @cnt + 1;
END;
PRINT @sqlcommand
SELECT @SQLCommand
EXEC sp_executesql @SQLCommand
GO
/*

SELECT CheckInComment, count(*) from [sa_SP2019PROD_Content_Phoenix_Docs_1].[dbo].[AllDocs] where Type = 0 group by CheckInComment
SELECT CheckInComment, count(*) from [sa_SP2019PROD_Content_Phoenix_Docs_165].[dbo].[AllDocs] where Type = 0 group by CheckInComment

SELECT count(*)
  FROM [sa_SP2019PROD_Content_Phoenix_Docs_1].[dbo].[AllDocs]
-- 123,050

SELECT count(*)
  FROM [sa_SP2019PROD_Content_Phoenix_Docs_50].[dbo].[AllDocs]
-- 116,780 (12% of total legacy docs) 
-- Contacts
	-- Client (approx 7000)
		-- phoenix_document
			-- doc A
			-- doc B 
			-...

SELECT count(*)
  FROM [sa_SP2019PROD_Content_Phoenix_Docs_50].[dbo].[AllDocs]
-- 116,780
 -- Current: 23 Cleanup jobs per night.. with 165 spread over 1 week
 -- Future: 23 with more threads/connections?
 -- Future: 10 .. with 165 jobs spread over 2 weeks




SELECT count(*)
  FROM [sa_SP2019PROD_Content_Phoenix_Docs_167].[dbo].[AllDocs]
-- 568 documents !!

SELECT *   FROM [sa_SP2019PROD_Content_Phoenix_Docs_167].[dbo].[AllDocs]  where DirName like 'docs/'

SELECT top 50 *, case when timeCreated > '2021-05-26' then 'Pre_live   FROM [sa_SP2019PROD_Content_Phoenix_Docs_1].[dbo].[AllDocs] where DirName like '%phoenix_document' and timeCreated > '2021-05-26'


 */

