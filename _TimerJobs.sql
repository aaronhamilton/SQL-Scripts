/****** Script for SelectTopNRows command from SSMS  ******/
SELECT count(*)
  FROM [sa_SP2019PROD_Config].[dbo].[TimerJobHistory] (nolock)

-- 85,836,436
-- After manually running Delete Job History job: 83,887,022
-- several days later... 2,296,734

select top 10 ID, StartTime, EndTime 
  FROM [sa_SP2019PROD_Config].[dbo].[TimerJobHistory] (nolock) order by StartTime

/*
ID	StartTime	EndTime
717750222	2021-08-12 09:21:53.490	2021-08-12 10:03:54.627
717750988	2021-08-12 09:38:34.747	2021-08-12 10:12:18.787
717999702	2021-08-12 09:42:39.920	2021-08-12 12:13:09.097
*/
/*
ID	StartTime	EndTime
803135621	2021-10-10 04:13:11.370	2021-10-10 17:18:05.903
803128217	2021-10-10 17:00:00.697	2021-10-10 17:15:20.197
803125089	2021-10-10 17:00:01.053	2021-10-10 17:08:34.633
*/