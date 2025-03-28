
-- SELECT MOST RECENT DOCUMENTS CREATED IN SHAREPOINT
select top 100 dirname, leafname, 
--TimeCreated as TimeCreatedUTC, 
DATEADD(HOUR, -5, TimeCreated) as TimeCreatedEST
 from [sa_SP2019PROD_Content_Phoenix_Docs_165].dbo.AllDocs AD where type=0  order by TimeCreated desc



