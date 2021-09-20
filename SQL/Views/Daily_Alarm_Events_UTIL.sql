USE [DCS]
GO

/****** Object:  View [dbo].[Daily_Alarm_Events_UTIL]    Script Date: 20/09/2021 9:54:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/****** Object:  View [dbo].[Daily_Alarm_Events]    Script Date: 19/04/2021 1:26:14 PM ******/
CREATE VIEW [dbo].[Daily_Alarm_Events_UTIL]
AS
SELECT top 10 [Priority] = ROW_NUMBER() OVER (ORDER BY (SELECT 1)), max (Timestamp) as Timestamp, t1.Source, max(Condition) as Condition, max(Message) as [Message], COUNT(Source) as Occurence  FROM (select DISTINCT * from [DCS].[dbo].[tbl_DCS_Alarm_Events]) as t1 where Source like 'UTIL%' AND [Condition] NOT LIKE '%Failure%' AND [Condition] NOT LIKE '%error%' AND Message NOT LIKE '%operator%' AND Message NOT LIKE '%administrator%' AND Message NOT LIKE '%error%' AND Active = 'ACTIVE' And Ackd = 'NOT ACKED' And AckReqd ='ACKREQD'
GROUP BY  T1.Source order by (Occurence) DESC

GO

