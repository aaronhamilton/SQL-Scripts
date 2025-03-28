
/*
 Working on a script to look up the URL of documents which have shown up in StoragePoint ULS logs
 METHOD 2
	Expects a raw ULS log file, imports it as-is into a table and then bits we need will be extracted via SQL commands

	WORK IN PROGRESS
*/

IF OBJECT_ID('tempdb..#ULSLogs') IS NOT NULL
DROP TABLE #ULSLogs; --select * from #ULSLogs
GO

-- STEP 1: Create an destination table. Make sure total columns matches exactly with number of columns in your CSV data (don't add extra columns or it gets REALLY confused)
CREATE TABLE #ULSLogs
    (StoragePointProfileID varchar(50), ServerName varchar(50), ProfileName varchar(50), Severity varchar(50), [Occurrances] varchar(50), ErrorMessage varchar(4000), FirstOccurrance datetime, LastOccurrance datetime
)

-- STEP 2: Import data from CSV - in this case tab-delimited
BULK INSERT #ULSLogs
FROM 'Z:\Quest Support\ULS logs 3.txt'
WITH (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
	--, LASTROW = 201
	, BATCHSIZE = 1000
	, ERRORFILE = 'Z:\Quest Support\ULS logs - Bulk Import.log'
);
GO

-- STEP 3: Add columns to hold extracted data elements
ALTER TABLE #ULSLogs
ADD		
		DocumentID VARCHAR(50),
		FolderPath VARCHAR(1000) NULL,
		[FileName] VARCHAR(500)
GO -- select * from #ULSLogs

-- STEP 4: Extract DocumentID from ErrorMessage field (where applicable)
DECLARE @GUIDLen int; SET @GUIDLen = 36
DECLARE @delimADSID varchar(10); SET @delimADSID = 'ADS Id: '
UPDATE #ULSLogs SET DocumentID = 
CASE 
	WHEN  CHARINDEX(@delimADSID, ErrorMessage) > 0 THEN 
		SUBSTRING(
				ErrorMessage,
				CHARINDEX(@delimADSID, ErrorMessage) + Len(@delimADSID)+1, @GUIDLen
			)
	ELSE
		NULL
END; -- select * from #ULSLogs

-- STEP 5 - Loop through the rows too look up URL and File information from the SharePoint content DBs. This information will get populated in the ULS Log table
DECLARE @SiteIndex varchar(5); DECLARE @DirName varchar(1000); DECLARE @FileName varchar(500); DECLARE @PROFILEID varchar(50); DECLARE @DocumentID varchar(50)
DECLARE @sql nvarchar(4000)

DECLARE Doc_cursor CURSOR
FOR SELECT StoragePointProfileID, DocumentID FROM #ULSLogs WHERE DocumentID is not null and LastOccurrance > 01-01-2025
FOR UPDATE OF FolderPath, [FileName]

OPEN Doc_cursor

FETCH NEXT FROM Doc_Cursor INTO @PROFILEID, @DocumentID

WHILE @@FETCH_STATUS = 0
BEGIN
	--DECLARE @SiteIndex varchar(5)
		select top 1 @SiteIndex = RIGHT(Name,(CHARINDEX('-',REVERSE(Name)))-1)  
		 from [StoragePoint].[dbo].[Profiles] where ProfileId = @PROFILEID --'00F146F4-9F88-45C3-8B12-24F35DF08028' 
	--select @SiteIndex
	
	print @DocumentID
	--DECLARE @DirName varchar(1000); DECLARE @FileName varchar(500); DECLARE @PROFILEID varchar(50); DECLARE @DocumentID varchar(50)
	set @sql = 'select @DirName = ''https://krypton.oct.ca/'' + Dirname, @FileName = LeafName FROM [sa_SP2019PROD_Content_Phoenix_Docs_' + @SiteIndex + '].[dbo].[AllDocs]
	where id = ''' + @DocumentID + ''''
	print @sql

	--PRINT @SiteIndex, @DirName, @FileName
	EXEC sp_executesql @sql, N'@DirName varchar(1000) OUTPUT, @FileName varchar(500) OUTPUT', @DirName = @DirName OUTPUT, @FileName = @FileName OUTPUT

	UPDATE #ULSLogs set FolderPath = @DirName, [FileName] = @FileName WHERE CURRENT OF Doc_cursor 

	FETCH NEXT FROM Doc_cursor INTO @PROFILEID, @DocumentID ;

END
CLOSE Doc_cursor
DEALLOCATE Doc_Cursor

SELECT * FROM #ULSLogs

