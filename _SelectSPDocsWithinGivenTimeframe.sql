
-- SELECT MOST RECENT DOCUMENTS CREATED IN SHAREPOINT
select dirname, leafname, TimeCreated as TimeCreatedGMT, 
--TimeCreated as TimeCreatedUTC, 
DATEADD(HOUR, -5, TimeCreated) as TimeCreatedEST
 from [sa_SP2019PROD_Content_Phoenix_Docs_165].dbo.AllDocs AD where type=0  
	and TimeCreated between DATEADD(HOUR, 5, '2022-03-04 08:30:00.000') and DATEADD(HOUR, 5, '2022-03-04 14:45:00.000')
order by TimeCreated asc



