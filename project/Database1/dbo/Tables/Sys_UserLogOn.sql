CREATE TABLE [dbo].[Sys_UserLogOn](
	[F_Id] [nvarchar](50) NOT NULL,
	[F_UserId] [nvarchar](50) NULL,
	[F_UserPassword] [nvarchar](50) NULL,
	[F_UserSecretkey] [nvarchar](50) NULL,
	[F_AllowStartTime] [datetime] NULL,
	[F_AllowEndTime] [datetime] NULL,
	[F_LockStartDate] [datetime] NULL,
	[F_LockEndDate] [datetime] NULL,
	[F_FirstVisitTime] [datetime] NULL,
	[F_PreviousVisitTime] [datetime] NULL,
	[F_LastVisitTime] [datetime] NULL,
	[F_ChangePasswordDate] [datetime] NULL,
	[F_MultiUserLogin] [bit] NULL,
	[F_LogOnCount] [int] NULL,
	[F_UserOnLine] [bit] NULL,
	[F_Question] [nvarchar](50) NULL,
	[F_AnswerQuestion] [nvarchar](500) NULL,
	[F_CheckIPAddress] [bit] NULL,
	[F_Language] [nvarchar](50) NULL,
	[F_Theme] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYS_USERLOGON] PRIMARY KEY NONCLUSTERED 
(
	[F_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'用户登录主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'用户主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_UserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'用户密码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_UserPassword'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'用户秘钥' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_UserSecretkey'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'允许登录时间开始' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_AllowStartTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'允许登录时间结束' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_AllowEndTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'暂停用户开始日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_LockStartDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'暂停用户结束日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_LockEndDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'第一次访问时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_FirstVisitTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'上一次访问时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_PreviousVisitTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最后访问时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_LastVisitTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'最后修改密码日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_ChangePasswordDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'允许同时有多用户登录' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_MultiUserLogin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'登录次数' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_LogOnCount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'在线状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_UserOnLine'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'密码提示问题' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_Question'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'密码提示答案' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_AnswerQuestion'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否访问限制' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_CheckIPAddress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'系统语言' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_Language'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'系统样式' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn', @level2type=N'COLUMN',@level2name=N'F_Theme'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'用户登录信息表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_UserLogOn'