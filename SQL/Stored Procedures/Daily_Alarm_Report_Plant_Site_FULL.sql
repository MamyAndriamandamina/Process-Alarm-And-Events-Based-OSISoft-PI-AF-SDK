USE [master]
GO

/****** Object:  StoredProcedure [dbo].[Daily_Alarm_Report_Plant_Site_FULL]    Script Date: 20/09/2021 9:36:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Mamy ANDRIAMANDAMINA>
-- Create date: <APRIL 2019>
-- Modified: <APRIL 2021> 
-- Description:	<Used to send HTML Format email reporting the daily Advanced Interlock Management Reporting at Plant Site.>
-- =============================================
CREATE PROCEDURE [dbo].[Daily_Alarm_Report_Plant_Site_FULL]
AS
BEGIN
	EXEC('
DECLARE @XBody1 NVARCHAR(MAX) ; 
DECLARE @XBody2 NVARCHAR(MAX) ; 
DECLARE @XBody3 NVARCHAR(MAX) ; 
DECLARE @XBody4 NVARCHAR(MAX) ; 
DECLARE @XBody5 NVARCHAR(MAX) ; 
DECLARE @XBody6 NVARCHAR(MAX) ; 
DECLARE @XBody7 NVARCHAR(MAX) ;
DECLARE @XBody8 NVARCHAR(MAX) ;

DECLARE @XBodyfinal NVARCHAR(MAX) ; 

DECLARE @emailIntro NVARCHAR(MAX) ; 
DECLARE @emailIntro1 NVARCHAR(MAX) ; 
DECLARE @emailIntro2 NVARCHAR(MAX) ; 
DECLARE @emailIntro3 NVARCHAR(MAX) ; 
DECLARE @emailIntro4 NVARCHAR(MAX) ; 
DECLARE @emailIntro5 NVARCHAR(MAX) ; 
DECLARE @emailIntro6 NVARCHAR(MAX) ; 
DECLARE @emailIntro7 NVARCHAR(MAX) ; 

DECLARE @tableHeader NVARCHAR(MAX);

DECLARE @xml1  NVARCHAR(MAX);
DECLARE @xml2  NVARCHAR(MAX);
DECLARE @xml3  NVARCHAR(MAX);
DECLARE @xml4  NVARCHAR(MAX);
DECLARE @xml5  NVARCHAR(MAX);
DECLARE @xml6  NVARCHAR(MAX);
DECLARE @xml7  NVARCHAR(MAX);
DECLARE @xml8  NVARCHAR(MAX);
DECLARE @KPI  NVARCHAR(MAX);

Declare @body1 NVARCHAR(max);
Declare @body2 NVARCHAR(max);
Declare @body3 NVARCHAR(max);
Declare @body4 NVARCHAR(max);
Declare @body5 NVARCHAR(max);
Declare @body6 NVARCHAR(max);
Declare @body7 NVARCHAR(max);
Declare @body8 NVARCHAR(max);

SET @xml1 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_AIRSEP FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))
SET @xml2 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_HYDROGEN FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))
SET @xml3 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_PAL FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))
SET @xml4 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_POWER FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))
SET @xml5 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_REFINERY FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))
SET @xml6 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_UTIL FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))
SET @xml7 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_AMMONIA FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))
SET @xml8 = CAST((SELECT [Priority] AS ''td'','''', [Timestamp] AS ''td'','''',[Source] AS ''td'','''',[Condition] AS ''td'','''',[Message] AS ''td'','''', [Occurence] AS ''td'','''' FROM  [DCS].dbo.Daily_Alarm_Events_PORT FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))

set @tableHeader =	N''<html><table border="1">'' +  
					N''<tr><th bgcolor=#FBEC2E>Priority</th><th bgcolor=#FBEC2E>Timestamp</th><th  bgcolor=#FBEC2E>Source</th><th  bgcolor=#FBEC2E>Condition</th>'' +  
					N''<th  bgcolor=#FBEC2E>Message</th><th  bgcolor=#FBEC2E>Occurrence</th></tr>''
SET @KPI = CAST((SELECT TOP 1 [Timestamp] AS ''td'','''',[Total Events Counted from last 24H] AS ''td'','''',[Approximative Days for PI to consume 1Gb data] AS ''td'','''',[Performance Status] AS ''td'','''' FROM  [DCS].dbo.tbl_KPI_PIArchss ORDER BY [Timestamp] DESC FOR XML PATH(''tr''), ELEMENTS) AS NVARCHAR(MAX))

SET @emailIntro = N''<html><body><H1>Alarm Hit List</H1>'' +  
    N''<p><u> Start Time:</u> '' + cast(CONVERT(datetime, dateadd(mi,300,datediff (d,1,getdate())), 103) as nvarchar(max)) + '' </p>'' +
    N''<p><u> End Time: </u>'' + cast(CONVERT(datetime, dateadd(mi,300,datediff (d,0,getdate())), 103) as nvarchar(max)) + '' </p> 
	<p>Dear All,</p> 
	<p>Please find below the TOP 10 Alarm Hit List.</p>
	<p>Thank you. PIHelp.</p>
	<br/><p><H3>Air Separation Plant - Alarm Hit List.</H3></p></body></html>''

SET @emailIntro1 = N''<html><body><H3>Hydrogen Plant - Alarm Hit List.</H3></html>''
SET @emailIntro2 = N''<html><body><H3>Pressure Acid Leach - Alarm Hit List.</H3></html>''
SET @emailIntro3 = N''<html><body><H3>Power Plant - Alarm Hit List.</H3></html>''
SET @emailIntro4 = N''<html><body><H3>Refinery - Alarm Hit List.</H3></html>''
SET @emailIntro5 = N''<html><body><H3>Utilities - Alarm Hit List.</H3></html>''
SET @emailIntro6 = N''<html><body><H3>Ammonia - Alarm Hit List.</H3></html>''
SET @emailIntro7 = N''<html><body><H3>Port - Alarm Hit List.</H3></html>''
    
SET @body1 = N''<html>'' + @tableHeader + @xml1 + ''</table></html>''
SET @body2 = N''<html>'' + @tableHeader + @xml2 + ''</table></html>''
SET @body3 = N''<html>'' + @tableHeader + @xml3 + ''</table></html>''
SET @body4 = N''<html>'' + @tableHeader + @xml4 + ''</table></html>''
SET @body5 = N''<html>'' + @tableHeader + @xml5 + ''</table></html>''
SET @body6 = N''<html>'' + @tableHeader + @xml6 + ''</table></html>''
SET @body7 = N''<html>'' + @tableHeader + @xml7 + ''</table></html>''
SET @body8 = N''<html>'' + @tableHeader + @xml8 + ''</table></html>''

select @XBody1 = Case When @body1 IS NULL THEN @emailIntro ELSE @emailIntro + @body1 END
select @XBody2 = Case When @body2 IS NULL THEN @emailIntro1 ELSE @emailIntro1 + @body2 END
select @XBody3 = Case When @body3 IS NULL THEN @emailIntro2 ELSE @emailIntro2 + @body3 END
select @XBody4 = Case When @body4 IS NULL THEN @emailIntro3 ELSE @emailIntro3 + @body4 END
select @XBody5 = Case When @body5 IS NULL THEN @emailIntro4 ELSE @emailIntro4 + @body5 END
select @XBody6 = Case When @body6 IS NULL THEN @emailIntro5 ELSE @emailIntro5 + @body6 END
select @XBody7 = Case When @body7 IS NULL THEN @emailIntro6 ELSE @emailIntro6 + @body7 END
select @XBody8 = Case When @body8 IS NULL THEN @emailIntro7 ELSE @emailIntro7 + @body8 END

select @Xbodyfinal = @XBody1 + @XBody2 + @XBody3 + @XBody4 + @XBody5 + @XBody6 + @XBody7 + @XBody8 

EXEC msdb.dbo.sp_send_dbmail @recipients=''youremail_1_@yourdomain.com;youremail_2_@yourdomain.com;youremail_X_@yourdomain.com'',  
	@profile_name = ''PI'',
    @subject = ''Alarm Hit List'',  
    @body = @XBodyfinal,  
    @body_format = ''HTML'' ;
    ')
END


GO

