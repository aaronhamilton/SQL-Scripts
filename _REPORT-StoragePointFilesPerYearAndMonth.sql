/* REPORT - Count of StoragePoint files per year and month */

/* Profile 165 Per Year */
select Year, Count(*) from (
	select datepart(YYYY,TimeCreated) as [Year], 
		cast(datepart(YYYY,TimeCreated) as nvarchar)+'-'+cast(datepart(MM,TimeCreated) as nvarchar) as [Month]
	from  [dbo].[ProfileBlobs_20CE1A08-5F58-4550-A6ED-31106AD9470F] 
) A Group by [Year]
/*
SITE 165
Year	(No column name)
2021	830772
2022	491181
*/

/* Profile 165 Per Month */
select [Month], Count(*) from (
	select datepart(YYYY,TimeCreated) as [Year], 
		cast(datepart(YYYY,TimeCreated) as nvarchar)+'-'+cast(datepart(MM,TimeCreated) as nvarchar) as [Month]
	from  [dbo].[ProfileBlobs_20CE1A08-5F58-4550-A6ED-31106AD9470F] 
) A Group by [Month] order by [Month] ASC
/*
SITE 165
Month	(No column name)
2021-11	816587
2021-12	14185
2022-1	45814
2022-10	19506
2022-11	13941
2022-2	39921
2022-3	37982
2022-4	45914
2022-5	46477
2022-6	57486
2022-7	35184
2022-8	80197
2022-9	68782
*/

/* Profile 159 Per Year */
select Year, Count(*) from (
	select datepart(YYYY,TimeCreated) as [Year], 
		cast(datepart(YYYY,TimeCreated) as nvarchar)+'-'+cast(datepart(MM,TimeCreated) as nvarchar) as [Month]
	from  [dbo].[ProfileBlobs_466D7BE2-4D05-4FBE-865D-BCD81400FD76] 
) A Group by [Year]

/* Profile 159 Per MOnth */
select [Month], Count(*) from (
	select datepart(YYYY,TimeCreated) as [Year], 
		cast(datepart(YYYY,TimeCreated) as nvarchar)+'-'+cast(datepart(MM,TimeCreated) as nvarchar) as [Month]
	from  [dbo].[ProfileBlobs_466D7BE2-4D05-4FBE-865D-BCD81400FD76] 
) A Group by [Month] order by [Month] ASC
