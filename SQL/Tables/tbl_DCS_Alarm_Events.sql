USE [DCS]
GO

/****** Object:  Table [dbo].[tbl_DCS_Alarm_Events]    Script Date: 20/09/2021 9:38:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_DCS_Alarm_Events](
	[Timestamp] [nvarchar](max) NULL,
	[Source] [nvarchar](max) NULL,
	[EventCategory] [nvarchar](max) NULL,
	[Condition] [nvarchar](max) NULL,
	[SubCondition] [nvarchar](max) NULL,
	[Severity] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
	[ActorID] [nvarchar](max) NULL,
	[Enabled] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Ackd] [nvarchar](max) NULL,
	[AckReqd] [nvarchar](max) NULL,
	[Quality] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

