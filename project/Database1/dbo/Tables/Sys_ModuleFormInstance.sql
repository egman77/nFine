CREATE TABLE [dbo].[Sys_ModuleFormInstance](
	[F_Id] [nvarchar](50) NOT NULL,
	[F_FormId] [nvarchar](50) NOT NULL,
	[F_ObjectId] [nvarchar](50) NULL,
	[F_InstanceJson] [nvarchar](max) NULL,
	[F_SortCode] [int] NULL,
	[F_CreatorTime] [datetime] NULL,
	[F_CreatorUserId] [nvarchar](50) NULL,
 CONSTRAINT [PK_SYS_MODULEFORMINSTANCE] PRIMARY KEY NONCLUSTERED 
(
	[F_Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'表单实例主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance', @level2type=N'COLUMN',@level2name=N'F_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'表单主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance', @level2type=N'COLUMN',@level2name=N'F_FormId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'对象主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance', @level2type=N'COLUMN',@level2name=N'F_ObjectId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'表单实例Json' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance', @level2type=N'COLUMN',@level2name=N'F_InstanceJson'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'排序码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance', @level2type=N'COLUMN',@level2name=N'F_SortCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance', @level2type=N'COLUMN',@level2name=N'F_CreatorTime'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建用户' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance', @level2type=N'COLUMN',@level2name=N'F_CreatorUserId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'模块表单实例' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sys_ModuleFormInstance'