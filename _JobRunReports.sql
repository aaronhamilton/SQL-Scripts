/*  Get summary all jobs in order */

SELECT P.Name, CASE J.JobType WHEN 12 THEN '2. UBC' WHEN 14 THEN '1. BHA' END AS [Job Type], J.ElapsedTime as ElapsedSeconds, convert(float, (J.ElapsedTime / 3600)) as [ElapsedHours], J.Started, J.Completion as PercentComplete 
from [StoragePoint].[dbo].[Jobs] J right outer join [StoragePoint].[dbo].Profiles P on P.ProfileId = J.ProfileID
where J.JobType in (12,14) and J.Started > '02/05/2022' order by j.Completion, j.Started desc


/* Get tally of job runs per profile since Feb 5 2022 */

select * from (
	SELECT P.Name, count(*) as UBCandBHAJobCount
	 from [StoragePoint].[dbo].[Jobs] J right outer join [StoragePoint].[dbo].Profiles P on P.ProfileId = J.ProfileID
	where J.JobType in (12,14) and J.Started > '02/05/2022' group by P.Name -- GetDate()
) A order by A.UBCandBHAJobCount

-- GET ALL BHA/UBC JOBS, MOST RECENT FIRST, 
select P.Name, J.JobId, J.ProfileID, J.JobType, CASE WHEN J.JobType = 14 THEN '1 - BHA' WHEN J.JobType = 12 THEN '2 - UBC' ELSE CONVERT(varchar,J.JobType) END as [JobTypeName], J.State, J.Started, J.[ElapsedTime] as [ElapsedSeconds], convert(FLOAT,J.[ElapsedTime])/convert(FLOAT,60) as [ElapsedMinutes], convert(FLOAT,J.[ElapsedTime])/convert(FLOAT,60)/convert(FLOAT,60) as [ElapsedHours], J.[Completion] as [PercentComplete] --, *
 from [StoragePoint].[dbo].[Jobs] J inner join [StoragePoint].[dbo].Profiles P on P.ProfileId = J.ProfileID
where  J.State = 'running' and 
J.JobType in (12,14) 
UNION
select P.Name, J.JobId, J.ProfileID, J.JobType, CASE WHEN J.JobType = 14 THEN '1 - BHA' WHEN J.JobType = 12 THEN '2 - UBC' ELSE CONVERT(varchar,J.JobType) END as [JobTypeName], J.State, J.Started, J.[ElapsedTime] as [ElapsedSeconds], convert(FLOAT,J.[ElapsedTime])/convert(FLOAT,60) as [ElapsedMinutes], convert(FLOAT,J.[ElapsedTime])/convert(FLOAT,60)/convert(FLOAT,60) as [ElapsedHours], J.[Completion] as [PercentComplete] --, *
 from [StoragePoint].[dbo].[Jobs] J inner join [StoragePoint].[dbo].Profiles P on P.ProfileId = J.ProfileID
where  J.State = 'complete' and 
J.JobType in (12,14) order by J.[Started] Desc

