USE [DCS]
GO

/****** Object:  View [dbo].[Daily_Alarm_Events_AIRSEP_INSTRUMENTATION]    Script Date: 20/09/2021 9:50:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Daily_Alarm_Events_AIRSEP_INSTRUMENTATION]
AS
SELECT top 10 [Priority] = ROW_NUMBER() OVER (ORDER BY (SELECT 1)), max (Timestamp) as Timestamp, t1.Source, max(Condition) as Condition, max(Message) as [Message], COUNT(Source) as Occurence  FROM (select DISTINCT * from [DCS].[dbo].[tbl_DCS_Alarm_Events]) as t1 where Source like 'AIR_SEP%' AND Message NOT LIKE '%operator%' AND [Condition] LIKE '%Failure%'AND Message NOT LIKE '%administrator%' AND Active = 'ACTIVE' And Ackd = 'NOT ACKED' And AckReqd ='ACKREQD'
GROUP BY  T1.Source order by (Occurence) DESC

GO

