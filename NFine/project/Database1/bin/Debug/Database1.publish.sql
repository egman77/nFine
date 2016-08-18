/*
NFineBase 的部署脚本

此代码由工具生成。
如果重新生成此代码，则对此文件的更改可能导致
不正确的行为并将丢失。
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "NFineBase"
:setvar DefaultFilePrefix "NFineBase"
:setvar DefaultDataPath "D:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\DATA\"
:setvar DefaultLogPath "D:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\DATA\"

GO
:on error exit
GO
/*
请检测 SQLCMD 模式，如果不支持 SQLCMD 模式，请禁用脚本执行。
要在启用 SQLCMD 模式后重新启用脚本，请执行:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'要成功执行此脚本，必须启用 SQLCMD 模式。';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'正在创建 $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'无法修改数据库设置。您必须是 SysAdmin 才能应用这些设置。';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'无法修改数据库设置。您必须是 SysAdmin 才能应用这些设置。';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'正在创建 [dbo].[Sys_Area]...';


GO
CREATE TABLE [dbo].[Sys_Area] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_ParentId]         VARCHAR (50)  NULL,
    [F_Layers]           INT           NULL,
    [F_EnCode]           VARCHAR (50)  NULL,
    [F_FullName]         VARCHAR (50)  NULL,
    [F_SimpleSpelling]   VARCHAR (50)  NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_AREA] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup]...';


GO
CREATE TABLE [dbo].[Sys_DbBackup] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_BackupType]       VARCHAR (50)  NULL,
    [F_DbName]           VARCHAR (50)  NULL,
    [F_FileName]         VARCHAR (50)  NULL,
    [F_FileSize]         VARCHAR (50)  NULL,
    [F_FilePath]         VARCHAR (500) NULL,
    [F_BackupTime]       DATETIME      NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (500) NULL,
    CONSTRAINT [PK_SYS_DBBACKUP] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP]...';


GO
CREATE TABLE [dbo].[Sys_FilterIP] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_Type]             BIT           NULL,
    [F_StartIP]          VARCHAR (50)  NULL,
    [F_EndIP]            VARCHAR (50)  NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (500) NULL,
    CONSTRAINT [PK_SYS_FILTERIP] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_Items]...';


GO
CREATE TABLE [dbo].[Sys_Items] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_ParentId]         VARCHAR (50)  NULL,
    [F_EnCode]           VARCHAR (50)  NULL,
    [F_FullName]         VARCHAR (50)  NULL,
    [F_IsTree]           BIT           NULL,
    [F_Layers]           INT           NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_ITEMS] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail]...';


GO
CREATE TABLE [dbo].[Sys_ItemsDetail] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_ItemId]           VARCHAR (50)  NULL,
    [F_ParentId]         VARCHAR (50)  NULL,
    [F_ItemCode]         VARCHAR (50)  NULL,
    [F_ItemName]         VARCHAR (50)  NULL,
    [F_SimpleSpelling]   VARCHAR (500) NULL,
    [F_IsDefault]        BIT           NULL,
    [F_Layers]           INT           NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_ITEMDETAIL] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_Log]...';


GO
CREATE TABLE [dbo].[Sys_Log] (
    [F_Id]            VARCHAR (50)  NOT NULL,
    [F_Date]          DATETIME      NULL,
    [F_Account]       VARCHAR (50)  NULL,
    [F_NickName]      VARCHAR (50)  NULL,
    [F_Type]          VARCHAR (50)  NULL,
    [F_IPAddress]     VARCHAR (50)  NULL,
    [F_IPAddressName] VARCHAR (50)  NULL,
    [F_ModuleId]      VARCHAR (50)  NULL,
    [F_ModuleName]    VARCHAR (50)  NULL,
    [F_Result]        BIT           NULL,
    [F_Description]   VARCHAR (500) NULL,
    [F_CreatorTime]   DATETIME      NULL,
    [F_CreatorUserId] VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_LOG] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_Module]...';


GO
CREATE TABLE [dbo].[Sys_Module] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_ParentId]         VARCHAR (50)  NULL,
    [F_Layers]           INT           NULL,
    [F_EnCode]           VARCHAR (50)  NULL,
    [F_FullName]         VARCHAR (50)  NULL,
    [F_Icon]             VARCHAR (50)  NULL,
    [F_UrlAddress]       VARCHAR (500) NULL,
    [F_Target]           VARCHAR (50)  NULL,
    [F_IsMenu]           BIT           NULL,
    [F_IsExpand]         BIT           NULL,
    [F_IsPublic]         BIT           NULL,
    [F_AllowEdit]        BIT           NULL,
    [F_AllowDelete]      BIT           NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_MODULE] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton]...';


GO
CREATE TABLE [dbo].[Sys_ModuleButton] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_ModuleId]         VARCHAR (50)  NULL,
    [F_ParentId]         VARCHAR (50)  NULL,
    [F_Layers]           INT           NULL,
    [F_EnCode]           VARCHAR (50)  NULL,
    [F_FullName]         VARCHAR (50)  NULL,
    [F_Icon]             VARCHAR (50)  NULL,
    [F_Location]         INT           NULL,
    [F_JsEvent]          VARCHAR (50)  NULL,
    [F_UrlAddress]       VARCHAR (500) NULL,
    [F_Split]            BIT           NULL,
    [F_IsPublic]         BIT           NULL,
    [F_AllowEdit]        BIT           NULL,
    [F_AllowDelete]      BIT           NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_MODULEBUTTON] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm]...';


GO
CREATE TABLE [dbo].[Sys_ModuleForm] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_ModuleId]         VARCHAR (50)  NULL,
    [F_EnCode]           VARCHAR (50)  NULL,
    [F_FullName]         VARCHAR (50)  NULL,
    [F_FormJson]         VARCHAR (MAX) NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (500) NULL,
    CONSTRAINT [PK_SYS_MODULEFORM] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance]...';


GO
CREATE TABLE [dbo].[Sys_ModuleFormInstance] (
    [F_Id]            VARCHAR (50)  NOT NULL,
    [F_FormId]        VARCHAR (50)  NOT NULL,
    [F_ObjectId]      VARCHAR (50)  NULL,
    [F_InstanceJson]  VARCHAR (MAX) NULL,
    [F_SortCode]      INT           NULL,
    [F_CreatorTime]   DATETIME      NULL,
    [F_CreatorUserId] VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_MODULEFORMINSTANCE] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_Organize]...';


GO
CREATE TABLE [dbo].[Sys_Organize] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_ParentId]         VARCHAR (50)  NULL,
    [F_Layers]           INT           NULL,
    [F_EnCode]           VARCHAR (50)  NULL,
    [F_FullName]         VARCHAR (50)  NULL,
    [F_ShortName]        VARCHAR (50)  NULL,
    [F_CategoryId]       VARCHAR (50)  NULL,
    [F_ManagerId]        VARCHAR (50)  NULL,
    [F_TelePhone]        VARCHAR (20)  NULL,
    [F_MobilePhone]      VARCHAR (20)  NULL,
    [F_WeChat]           VARCHAR (50)  NULL,
    [F_Fax]              VARCHAR (20)  NULL,
    [F_Email]            VARCHAR (50)  NULL,
    [F_AreaId]           VARCHAR (50)  NULL,
    [F_Address]          VARCHAR (500) NULL,
    [F_AllowEdit]        BIT           NULL,
    [F_AllowDelete]      BIT           NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (500) NULL,
    CONSTRAINT [PK_SYS_ORGANIZE] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_Role]...';


GO
CREATE TABLE [dbo].[Sys_Role] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_OrganizeId]       VARCHAR (50)  NULL,
    [F_Category]         INT           NULL,
    [F_EnCode]           VARCHAR (50)  NULL,
    [F_FullName]         VARCHAR (50)  NULL,
    [F_Type]             VARCHAR (50)  NULL,
    [F_AllowEdit]        BIT           NULL,
    [F_AllowDelete]      BIT           NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (500) NULL,
    CONSTRAINT [PK_SYS_ROLE] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize]...';


GO
CREATE TABLE [dbo].[Sys_RoleAuthorize] (
    [F_Id]            VARCHAR (50) NOT NULL,
    [F_ItemType]      INT          NULL,
    [F_ItemId]        VARCHAR (50) NULL,
    [F_ObjectType]    INT          NULL,
    [F_ObjectId]      VARCHAR (50) NULL,
    [F_SortCode]      INT          NULL,
    [F_CreatorTime]   DATETIME     NULL,
    [F_CreatorUserId] VARCHAR (50) NULL,
    CONSTRAINT [PK_SYS_ROLEAUTHORIZE] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_User]...';


GO
CREATE TABLE [dbo].[Sys_User] (
    [F_Id]               VARCHAR (50)  NOT NULL,
    [F_Account]          VARCHAR (50)  NULL,
    [F_RealName]         VARCHAR (50)  NULL,
    [F_NickName]         VARCHAR (50)  NULL,
    [F_HeadIcon]         VARCHAR (50)  NULL,
    [F_Gender]           BIT           NULL,
    [F_Birthday]         DATETIME      NULL,
    [F_MobilePhone]      VARCHAR (20)  NULL,
    [F_Email]            VARCHAR (50)  NULL,
    [F_WeChat]           VARCHAR (50)  NULL,
    [F_ManagerId]        VARCHAR (50)  NULL,
    [F_SecurityLevel]    INT           NULL,
    [F_Signature]        VARCHAR (500) NULL,
    [F_OrganizeId]       VARCHAR (50)  NULL,
    [F_DepartmentId]     VARCHAR (500) NULL,
    [F_RoleId]           VARCHAR (500) NULL,
    [F_DutyId]           VARCHAR (500) NULL,
    [F_IsAdministrator]  BIT           NULL,
    [F_SortCode]         INT           NULL,
    [F_DeleteMark]       BIT           NULL,
    [F_EnabledMark]      BIT           NULL,
    [F_Description]      VARCHAR (500) NULL,
    [F_CreatorTime]      DATETIME      NULL,
    [F_CreatorUserId]    VARCHAR (50)  NULL,
    [F_LastModifyTime]   DATETIME      NULL,
    [F_LastModifyUserId] VARCHAR (50)  NULL,
    [F_DeleteTime]       DATETIME      NULL,
    [F_DeleteUserId]     VARCHAR (500) NULL,
    CONSTRAINT [PK_SYS_USER] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn]...';


GO
CREATE TABLE [dbo].[Sys_UserLogOn] (
    [F_Id]                 VARCHAR (50)  NOT NULL,
    [F_UserId]             VARCHAR (50)  NULL,
    [F_UserPassword]       VARCHAR (50)  NULL,
    [F_UserSecretkey]      VARCHAR (50)  NULL,
    [F_AllowStartTime]     DATETIME      NULL,
    [F_AllowEndTime]       DATETIME      NULL,
    [F_LockStartDate]      DATETIME      NULL,
    [F_LockEndDate]        DATETIME      NULL,
    [F_FirstVisitTime]     DATETIME      NULL,
    [F_PreviousVisitTime]  DATETIME      NULL,
    [F_LastVisitTime]      DATETIME      NULL,
    [F_ChangePasswordDate] DATETIME      NULL,
    [F_MultiUserLogin]     BIT           NULL,
    [F_LogOnCount]         INT           NULL,
    [F_UserOnLine]         BIT           NULL,
    [F_Question]           VARCHAR (50)  NULL,
    [F_AnswerQuestion]     VARCHAR (500) NULL,
    [F_CheckIPAddress]     BIT           NULL,
    [F_Language]           VARCHAR (50)  NULL,
    [F_Theme]              VARCHAR (50)  NULL,
    CONSTRAINT [PK_SYS_USERLOGON] PRIMARY KEY NONCLUSTERED ([F_Id] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'正在创建 [dbo].[Sys_Area].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'行政区域表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_ParentId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'父级', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_ParentId';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_Layers].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'层次', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_Layers';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_EnCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_EnCode';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_FullName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_FullName';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_SimpleSpelling].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'简拼', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_SimpleSpelling';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_Area].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Area', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'数据库备份', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'备份主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_BackupType].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'备份类型', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_BackupType';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_DbName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'数据库名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_DbName';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_FileName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'文件名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_FileName';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_FileSize].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'文件大小', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_FileSize';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_FilePath].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'文件路径', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_FilePath';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_BackupTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'备份时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_BackupTime';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_DbBackup].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_DbBackup', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'过滤IP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'过滤主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_Type].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_Type';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_StartIP].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'开始IP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_StartIP';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_EndIP].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'结束IP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_EndIP';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_FilterIP].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_FilterIP', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'选项主表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'主表主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_ParentId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'父级', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_ParentId';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_EnCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_EnCode';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_FullName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_FullName';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_IsTree].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'树型', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_IsTree';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_Layers].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'层次', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_Layers';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_Items].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Items', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'选项明细表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'明细主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_ItemId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'主表主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_ItemId';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_ParentId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'父级', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_ParentId';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_ItemCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_ItemCode';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_ItemName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_ItemName';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_SimpleSpelling].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'简拼', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_SimpleSpelling';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_IsDefault].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'默认', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_IsDefault';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_Layers].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'层次', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_Layers';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_ItemsDetail].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ItemsDetail', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'系统日志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'日志主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_Date].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_Date';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_Account].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户名', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_Account';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_NickName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'姓名', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_NickName';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_Type].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_Type';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_IPAddress].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP地址', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_IPAddress';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_IPAddressName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'IP所在城市', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_IPAddressName';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_ModuleId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'系统模块Id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_ModuleId';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_ModuleName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'系统模块', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_ModuleName';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_Result].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'结果', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_Result';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_Log].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Log', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'系统模块', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'模块主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_ParentId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'父级', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_ParentId';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_Layers].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'层次', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_Layers';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_EnCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_EnCode';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_FullName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_FullName';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_Icon].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'图标', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_Icon';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_UrlAddress].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'连接', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_UrlAddress';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_Target].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'目标', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_Target';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_IsMenu].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'菜单', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_IsMenu';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_IsExpand].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'展开', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_IsExpand';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_IsPublic].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'公共', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_IsPublic';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_AllowEdit].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许编辑', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_AllowEdit';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_AllowDelete].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许删除', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_AllowDelete';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_Module].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Module', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'模块按钮', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'按钮主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_ModuleId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'模块主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_ModuleId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_ParentId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'父级', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_ParentId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_Layers].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'层次', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_Layers';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_EnCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_EnCode';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_FullName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_FullName';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_Icon].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'图标', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_Icon';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_Location].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'位置', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_Location';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_JsEvent].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'事件', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_JsEvent';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_UrlAddress].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'连接', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_UrlAddress';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_Split].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分开线', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_Split';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_IsPublic].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'公共', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_IsPublic';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_AllowEdit].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许编辑', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_AllowEdit';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_AllowDelete].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许删除', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_AllowDelete';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleButton].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleButton', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'模块表单', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'表单主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_ModuleId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'模块主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_ModuleId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_EnCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_EnCode';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_FullName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_FullName';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_FormJson].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'表单控件Json', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_FormJson';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleForm].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleForm', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'模块表单实例', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'表单实例主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[F_FormId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'表单主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance', @level2type = N'COLUMN', @level2name = N'F_FormId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[F_ObjectId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'对象主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance', @level2type = N'COLUMN', @level2name = N'F_ObjectId';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[F_InstanceJson].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'表单实例Json', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance', @level2type = N'COLUMN', @level2name = N'F_InstanceJson';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_ModuleFormInstance].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_ModuleFormInstance', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'组织表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'组织主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_ParentId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'父级', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_ParentId';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_Layers].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'层次', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_Layers';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_EnCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_EnCode';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_FullName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_FullName';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_ShortName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'简称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_ShortName';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_CategoryId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分类', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_CategoryId';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_ManagerId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'负责人', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_ManagerId';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_TelePhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'电话', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_TelePhone';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_MobilePhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'手机', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_MobilePhone';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_WeChat].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'微信', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_WeChat';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_Fax].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'传真', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_Fax';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_Email].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'邮箱', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_Email';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_AreaId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'归属区域', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_AreaId';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_Address].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'联系地址', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_Address';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_AllowEdit].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许编辑', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_AllowEdit';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_AllowDelete].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许删除', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_AllowDelete';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_Organize].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Organize', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_OrganizeId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'组织主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_OrganizeId';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_Category].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'分类:1-角色2-岗位', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_Category';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_EnCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'编号', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_EnCode';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_FullName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'名称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_FullName';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_Type].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'类型', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_Type';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_AllowEdit].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许编辑', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_AllowEdit';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_AllowDelete].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许删除', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_AllowDelete';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_Role].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_Role', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色授权表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色授权主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_ItemType].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'项目类型1-模块2-按钮3-列表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_ItemType';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_ItemId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'项目主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_ItemId';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_ObjectType].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'对象分类1-角色2-部门-3用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_ObjectType';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_ObjectId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'对象主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_ObjectId';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_RoleAuthorize].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_RoleAuthorize', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_Account].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'账户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_Account';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_RealName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'姓名', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_RealName';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_NickName].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'呢称', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_NickName';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_HeadIcon].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'头像', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_HeadIcon';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_Gender].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'性别', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_Gender';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_Birthday].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'生日', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_Birthday';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_MobilePhone].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'手机', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_MobilePhone';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_Email].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'邮箱', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_Email';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_WeChat].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'微信', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_WeChat';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_ManagerId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'主管主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_ManagerId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_SecurityLevel].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'安全级别', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_SecurityLevel';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_Signature].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'个性签名', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_Signature';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_OrganizeId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'组织主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_OrganizeId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_DepartmentId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'部门主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_DepartmentId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_RoleId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'角色主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_RoleId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_DutyId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'岗位主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_DutyId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_IsAdministrator].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'是否管理员', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_IsAdministrator';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_SortCode].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'排序码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_SortCode';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_DeleteMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_DeleteMark';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_EnabledMark].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'有效标志', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_EnabledMark';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_Description].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'描述', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_Description';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_CreatorTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_CreatorTime';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_CreatorUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'创建用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_CreatorUserId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_LastModifyTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_LastModifyTime';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_LastModifyUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_LastModifyUserId';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_DeleteTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_DeleteTime';


GO
PRINT N'正在创建 [dbo].[Sys_User].[F_DeleteUserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'删除用户', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_User', @level2type = N'COLUMN', @level2name = N'F_DeleteUserId';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户登录信息表', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_Id].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户登录主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_Id';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_UserId].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户主键', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_UserId';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_UserPassword].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户密码', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_UserPassword';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_UserSecretkey].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'用户秘钥', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_UserSecretkey';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_AllowStartTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许登录时间开始', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_AllowStartTime';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_AllowEndTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许登录时间结束', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_AllowEndTime';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_LockStartDate].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'暂停用户开始日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_LockStartDate';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_LockEndDate].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'暂停用户结束日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_LockEndDate';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_FirstVisitTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'第一次访问时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_FirstVisitTime';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_PreviousVisitTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'上一次访问时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_PreviousVisitTime';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_LastVisitTime].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后访问时间', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_LastVisitTime';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_ChangePasswordDate].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'最后修改密码日期', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_ChangePasswordDate';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_MultiUserLogin].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'允许同时有多用户登录', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_MultiUserLogin';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_LogOnCount].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'登录次数', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_LogOnCount';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_UserOnLine].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'在线状态', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_UserOnLine';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_Question].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'密码提示问题', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_Question';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_AnswerQuestion].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'密码提示答案', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_AnswerQuestion';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_CheckIPAddress].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'是否访问限制', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_CheckIPAddress';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_Language].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'系统语言', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_Language';


GO
PRINT N'正在创建 [dbo].[Sys_UserLogOn].[F_Theme].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'系统样式', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Sys_UserLogOn', @level2type = N'COLUMN', @level2name = N'F_Theme';


GO
/*
后期部署脚本模板							
--------------------------------------------------------------------------------------
 此文件包含将附加到生成脚本中的 SQL 语句。		
 使用 SQLCMD 语法将文件包含到后期部署脚本中。			
 示例:      :r .\myfile.sql								
 使用 SQLCMD 语法引用后期部署脚本中的变量。		
 示例:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'6903ab9d-20cd-44c4-a380-09f229366e1f', N'6903ab9d-20cd-44c4-a380-09f229366e1f', N'403ffebb404e8c30c57747baaa522902', N'95aa29b12cf25d9a', NULL, NULL, NULL, NULL, NULL, CAST(0x0000A64F00E68EA8 AS DateTime), CAST(0x0000A65001214D19 AS DateTime), NULL, NULL, 7, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'38c9c1e6-7b89-4aed-b782-4cbf082a4b72', N'38c9c1e6-7b89-4aed-b782-4cbf082a4b72', N'937d91e587120dd071051541cdaad711', N'22a6e8e5d2c06c7b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'b26e59b9-2456-4038-b601-26e8a225e663', N'b26e59b9-2456-4038-b601-26e8a225e663', N'8403ae736e7c399ee30fb2eaaedec4b2', N'd620d7289fcf3ac5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'200cab1a-30df-4cdf-a9a5-258b882a23e7', N'200cab1a-30df-4cdf-a9a5-258b882a23e7', N'ab09b8c4361001755d72a6e241fd86be', N'befa401790768013', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'a9450c22-926d-4afa-ae3b-2c8602762a81', N'a9450c22-926d-4afa-ae3b-2c8602762a81', N'11bca47eedba5e3819b264b334ed1432', N'9792122be7a281e2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'47a95b17-ff8b-46f9-99a4-02a7e6a53550', N'47a95b17-ff8b-46f9-99a4-02a7e6a53550', N'b371ec65231994578825f527e008598a', N'c8f011c890e89304', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'ca40ef7c-88b0-46c9-910d-f9bfbc1d7968', N'ca40ef7c-88b0-46c9-910d-f9bfbc1d7968', N'4eaea9a31404142ec7d19ce62172b922', N'8e7de29e0055247c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'da01cfbe-7094-4573-bf46-c895ba71a28b', N'da01cfbe-7094-4573-bf46-c895ba71a28b', N'cad14e3b9f71575849d8d4f501fd0ccc', N'3bca1d393861e85e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'1ddf560b-c18e-48d4-b132-f90eb7475741', N'1ddf560b-c18e-48d4-b132-f90eb7475741', N'bb4c94e966b72b6e579d146daaf70200', N'453cc3b4dfbeefb8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'b7d73ca6-9c1c-478f-a1f0-9e02bae69872', N'b7d73ca6-9c1c-478f-a1f0-9e02bae69872', N'3a2aa5bcb4fd1f93c71298d01e409c0a', N'237e5b6c90d22292', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'9798d1b6-2ad2-4228-8c1a-6d3107120e29', N'9798d1b6-2ad2-4228-8c1a-6d3107120e29', N'1d64b2c731c41da6cae60918d711286b', N'76656cf041d76ec7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'547be453-cbdc-44d1-a6e5-9852cb044e4a', N'547be453-cbdc-44d1-a6e5-9852cb044e4a', N'a54afef35295713a856a536fed416802', N'a69007a0d0908f26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'75b2c660-c5f8-41f7-980c-d979e8ec9eaa', N'75b2c660-c5f8-41f7-980c-d979e8ec9eaa', N'4d1be6370a2ea7f093056e69ab3a83c3', N'd38c267eade238e8', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'06484cd2-d16f-4038-ae91-7431b126930d', N'06484cd2-d16f-4038-ae91-7431b126930d', N'c177c5ffe23485e0b7615e8f59ab0ba5', N'85632081fca56d83', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'd9bc1853-61aa-48c9-96a4-a8b1075a82ae', N'd9bc1853-61aa-48c9-96a4-a8b1075a82ae', N'c9d3b453c5c3cbc33c5ca0333f86f5b2', N'f49939dbc67bea34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'40075d85-1b80-4da3-b061-76b7b1edb16e', N'40075d85-1b80-4da3-b061-76b7b1edb16e', N'82f0075e56cdf22042dfec1ba4ae2b99', N'42dc0f5d1e6618b4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'cdf5ba74-9751-4808-8893-0100dd188197', N'cdf5ba74-9751-4808-8893-0100dd188197', N'e3354d46804e8002cd1690ba0571b48e', N'2340149e633316e9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'833ad021-6ccc-4db0-8017-5021f5327260', N'833ad021-6ccc-4db0-8017-5021f5327260', N'd5bb347f6d9e2878afd8aeea15c55b8a', N'037f37856f2b1ee2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'6a1e3bb6-49c2-4d64-becc-e5644678178f', N'6a1e3bb6-49c2-4d64-becc-e5644678178f', N'af7e099dafe8613bd71d2caf69eed80b', N'1013e016334d869b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'8b269fcf-9f22-4d32-a269-cabdac469749', N'8b269fcf-9f22-4d32-a269-cabdac469749', N'4f5ec1786ea5507c183f9f4819d0e335', N'9f7e199fdcadbead', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'07491670-be4a-4bb3-8a12-c8a0ce3c52cd', N'07491670-be4a-4bb3-8a12-c8a0ce3c52cd', N'867f4f6817e85b304ba97cb55247aa06', N'df3add4ceb7bab18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'cf3af1b8-d2ce-4f2f-88f3-5838a77f83c7', N'cf3af1b8-d2ce-4f2f-88f3-5838a77f83c7', N'387c8893079b205a1cb0a5e45ea0eefb', N'62459fe053b074e5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'158fa76f-1d82-4a38-a4e2-624239355b4d', N'158fa76f-1d82-4a38-a4e2-624239355b4d', N'd35cb340b74070c6b66616da68ade924', N'6d1319bd4e9af5cb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'acb39d47-8860-49a0-abc0-a21d016c2fff', N'acb39d47-8860-49a0-abc0-a21d016c2fff', N'9b4fee7337fb9e8da74500778687cebc', N'51d8595d7ad0e06e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'13f9bb09-6db1-4932-acdd-36cfc39ce1a3', N'13f9bb09-6db1-4932-acdd-36cfc39ce1a3', N'32888331dd4b600207fe8643898f56a1', N'df4c2b0291d80edf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'0f0ff3de-688c-4370-8a79-15637ed3b20c', N'0f0ff3de-688c-4370-8a79-15637ed3b20c', N'5327a7b8df3bb3f867b2452093686208', N'cdeb1bcfc08d7793', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'4c8909b9-3ddb-4855-baa4-82edc2e3a5c1', N'4c8909b9-3ddb-4855-baa4-82edc2e3a5c1', N'c48e809b05f2114e819de8d845b08b65', N'470ff07e581fc520', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'2b33a324-5548-4d29-9030-d788f7c257fb', N'2b33a324-5548-4d29-9030-d788f7c257fb', N'c287f8ef6399b48c2f43e3eee7518d3c', N'4dbd25f69a0884bb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'b0529548-bbea-4aa6-8ed2-446033c4d90f', N'b0529548-bbea-4aa6-8ed2-446033c4d90f', N'70cfd94171022b96f9f29dfebcca2a8b', N'6a9dac041b8efc10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'9caa1edf-0e06-4481-ab50-139949046e24', N'9caa1edf-0e06-4481-ab50-139949046e24', N'ef74f069700991d01454184220415407', N'5ec364d8c8b0b203', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'f13edee1-43b5-4cac-930f-f7350ec1a473', N'f13edee1-43b5-4cac-930f-f7350ec1a473', N'126edcb8aa68a31297d344f07735289a', N'e5cec574123565ef', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'79756b91-ea5b-4d28-9b46-dd192bb67895', N'79756b91-ea5b-4d28-9b46-dd192bb67895', N'24fcdc7667ab1053c6630ff6956cd49f', N'2c1a584d6a031216', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'32585483-5534-4690-bc20-1b509e737f9c', N'32585483-5534-4690-bc20-1b509e737f9c', N'67dfffb091a188c07c84fe674617272a', N'f97168084920407b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'a8d1b2a1-b4f7-43c8-9750-226f00108bc9', N'a8d1b2a1-b4f7-43c8-9750-226f00108bc9', N'f53f79157cdadaabdad3be62e87c9d97', N'cd8b4b140dc1b331', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'45951653-bd26-482f-a1b5-4ac6c8b7be7b', N'45951653-bd26-482f-a1b5-4ac6c8b7be7b', N'ee19419ba7b7cf7d6cccdb51c73696d5', N'65c9a176b1da85cf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'2fd34599-042a-4caf-a98b-bd227ab6be0f', N'2fd34599-042a-4caf-a98b-bd227ab6be0f', N'1afba5511b4160674d46c11d033260d3', N'e4e931d0634b287b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'caf2caf9-3982-4c88-b29b-2a86b72dc325', N'caf2caf9-3982-4c88-b29b-2a86b72dc325', N'285d32042beddffcc25fc2e160e50a62', N'ebee9b7457804995', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'318ba1e7-f4fa-4d88-869c-aa6e4f8c961c', N'318ba1e7-f4fa-4d88-869c-aa6e4f8c961c', N'a3733001efd792618efc40a9704324ba', N'53fa1546ee62e5c3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'50eab71b-bf70-4037-9a57-8fdff44cffe3', N'50eab71b-bf70-4037-9a57-8fdff44cffe3', N'cfff74f22ba846dc47db33be123e6a2d', N'fb58d08dbf0a850b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'e9dc99ca-b015-47ba-a00e-62d1f98bdb1a', N'e9dc99ca-b015-47ba-a00e-62d1f98bdb1a', N'0c4c4da65422e69fac8394bbd409203e', N'738c8b94f8a36c8c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'f2adf10a-cb2c-417a-a1c5-d4c9c57fc5ef', N'f2adf10a-cb2c-417a-a1c5-d4c9c57fc5ef', N'2e5278253d680ce4504fb6cdfd6ab053', N'f2dbc5e6ed47d50b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'ca57fe20-926d-47b2-a3f2-664a5d1da7ce', N'ca57fe20-926d-47b2-a3f2-664a5d1da7ce', N'dbb3806e80fdc83c599fc7ac79ad0bf3', N'99cde48cd58264b1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'ba637dd7-7fd7-418b-a81f-238cc59adc76', N'ba637dd7-7fd7-418b-a81f-238cc59adc76', N'f709a0d69d844f70bbbe6ed6f5eb29f6', N'4cb9204ebaa0e7b0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'2365e142-9fc9-4837-9be4-5587a07a735f', N'2365e142-9fc9-4837-9be4-5587a07a735f', N'1a4e503a0aa5057d8d7b0d72d18dcb9a', N'b141d6cbdd446b58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'c8c1fa94-f14d-4ccf-bd67-ad97f787d375', N'c8c1fa94-f14d-4ccf-bd67-ad97f787d375', N'9ec89ffb689c96a590f00d30aa5afd9d', N'a47a61679e14887b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'b735ad6a-ba26-4cb8-84cf-07d0c38ac921', N'b735ad6a-ba26-4cb8-84cf-07d0c38ac921', N'1e4849bf0bc1334209d9662a0db3ece2', N'66121148a5250685', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'0090a476-68eb-4b79-ac6c-8fd3c0ff6c89', N'0090a476-68eb-4b79-ac6c-8fd3c0ff6c89', N'e3798df355f401d8857fcfcfaa0d4143', N'ae12fea3ae77e517', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'6c19b537-f44d-4612-b9b0-647cf8672bce', N'6c19b537-f44d-4612-b9b0-647cf8672bce', N'1956541185e787fa0168e1113b9ee9b9', N'1e4c4ce01eb7d910', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'2664b7a9-6a45-40a2-85e0-ea27887b74bb', N'2664b7a9-6a45-40a2-85e0-ea27887b74bb', N'483bcc658d87898656bcca76ac4de7c0', N'11e4becdd232e389', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'cbe6b2fb-7195-4d3a-86b6-ce2dc2d10eea', N'cbe6b2fb-7195-4d3a-86b6-ce2dc2d10eea', N'54a0264abb0847aca4396c9a397df642', N'c0a7dd6d91f8b12c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'2016da68-e116-43d8-9d06-6ea19c559220', N'2016da68-e116-43d8-9d06-6ea19c559220', N'392353351d15bf97debcd94d0e2a5141', N'6ea5646db7ef0060', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'f5c9d584-e4d6-4c28-a145-bf98a08c80f0', N'f5c9d584-e4d6-4c28-a145-bf98a08c80f0', N'b396642ad297a00d8f6d04fcbb8ce0fe', N'0c8c87c1b52379d3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'395d6e38-0e60-4256-b1cc-072c83adec6c', N'395d6e38-0e60-4256-b1cc-072c83adec6c', N'4a74bdfff1ca70780eaac2a411f97802', N'736f1be1c2d1e6b5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'3ed28896-e246-4301-908f-2dfbcf92b33b', N'3ed28896-e246-4301-908f-2dfbcf92b33b', N'f3013370472e618f026ae3bd4dd9bc95', N'89948d57372b8a89', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'e1674f45-4aed-44b8-83d4-fb5373f8ee69', N'e1674f45-4aed-44b8-83d4-fb5373f8ee69', N'0d9e94a2d9ef06f4bcb652e34b0b0c72', N'465292405abd0f41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'daaf6f40-a1a1-4cfd-ab82-8c7d0ed3bad7', N'daaf6f40-a1a1-4cfd-ab82-8c7d0ed3bad7', N'540bfd0a483071ae85d5834f5a61d315', N'9d6ef533b1b25af5', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'e371171e-ee64-4fea-9f5d-4e90f4e668cc', N'e371171e-ee64-4fea-9f5d-4e90f4e668cc', N'640946f6e500c35f84eb709ef4d4b8c9', N'08c002abe194214e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'0d796336-aefe-4012-8294-89a54dce6b62', N'0d796336-aefe-4012-8294-89a54dce6b62', N'094b46078f34e7a4371c059a447f0fe4', N'9535de072ca868aa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'4eee745e-97eb-470f-9372-605ded7f5917', N'4eee745e-97eb-470f-9372-605ded7f5917', N'22ef253591009132347a488f1fac49fa', N'56ffcdda5d92f3b6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'e0c34d25-ae43-46bc-b300-23c4fede6766', N'e0c34d25-ae43-46bc-b300-23c4fede6766', N'a605496007c34f3320b1e8d8fe7d599a', N'431cefa829fbfcd1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'5f1cb307-761f-4c27-bfb3-5571038e87d2', N'5f1cb307-761f-4c27-bfb3-5571038e87d2', N'08cc9554f85705470a4c7b207a65864d', N'98c320aa480c303a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'16c9ed0a-4eb8-49e0-b287-a7115c2066d6', N'16c9ed0a-4eb8-49e0-b287-a7115c2066d6', N'f08d7715c7bd72c008462367de2f6597', N'a013e077c090743a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'd0cd28eb-ffee-44f7-b130-070c31d8819b', N'd0cd28eb-ffee-44f7-b130-070c31d8819b', N'8625f83565ad606742925ceca70470df', N'f951b31dba32f0b2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'812a57a4-5a53-4a52-9eb1-70b6f45ec4a5', N'812a57a4-5a53-4a52-9eb1-70b6f45ec4a5', N'0dc162a500df717b921a72ae28f49b64', N'9d8816b6c7af1506', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'11c4a1c2-daec-439c-9ea0-fc2d5630c4cd', N'11c4a1c2-daec-439c-9ea0-fc2d5630c4cd', N'81a0837dd73dcf4d94aebab5ff14b58a', N'3ecde57b16c010c6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'24a54791-44fb-4fea-95a9-2ba21cf0d3a0', N'24a54791-44fb-4fea-95a9-2ba21cf0d3a0', N'56744f15950d0e3d8bbfd11d8a49928a', N'7eba983a2793541c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'bbffd7f2-97d2-4bb4-a308-651171dbf6af', N'bbffd7f2-97d2-4bb4-a308-651171dbf6af', N'e7241892ec28b8ebcfeffb8a8daa3447', N'a6b7fb7162c31626', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'b05535b3-0d4a-494d-8114-cad9e8e74133', N'b05535b3-0d4a-494d-8114-cad9e8e74133', N'e567dc332181e33bc1938ecec07dded2', N'5dfc083c553e845a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'833333a5-7020-4912-929f-10439423fe44', N'833333a5-7020-4912-929f-10439423fe44', N'1667fe168a587d025bbd2fe4ace30c4b', N'fcc50440bc46d307', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'549bc2c1-c791-45c1-9746-93c871078a03', N'549bc2c1-c791-45c1-9746-93c871078a03', N'107f3dddd3d04786432ae537d8e11ba4', N'2b13936329567b4a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'1c6fb8ad-cc89-414d-835d-1b5be789493d', N'1c6fb8ad-cc89-414d-835d-1b5be789493d', N'216c2cd5281b34c2a7f20b2322958f3d', N'c851b97c830d9e6e', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'0c642247-ebad-4976-ab06-3c7e78e6ad12', N'0c642247-ebad-4976-ab06-3c7e78e6ad12', N'0001e94073a9318413b6cd4bcb7ad248', N'3ad87f3c21e389c4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'702ea347-099f-4afd-a7a2-11091418fc50', N'702ea347-099f-4afd-a7a2-11091418fc50', N'd4044090ed28fe24b57eaf07c4e9d520', N'87c0dfb371059817', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'122b1e73-548d-429c-aa33-3e73635a7f44', N'122b1e73-548d-429c-aa33-3e73635a7f44', N'ce42f8b0479edf0d035bfebd8711b506', N'75fc5ce76611f53f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'd2967e93-4d8b-43d9-b9cb-9cd4a76ad28e', N'd2967e93-4d8b-43d9-b9cb-9cd4a76ad28e', N'46fe6343c14ffe120a93af9c496d52f5', N'd7c9667347faf6fb', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'a9a27d8a-3543-4d3d-903e-71790b20dcd1', N'a9a27d8a-3543-4d3d-903e-71790b20dcd1', N'426472f01692aa21b253101b98833cc1', N'faf940b39f608dad', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'763d5744-89ae-4497-ba19-79dba081646f', N'763d5744-89ae-4497-ba19-79dba081646f', N'f61249d0c25fbfce9872611a9c4d426c', N'1c8aa2c9462416f9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'9428af0b-bc25-429d-a646-ef54275191f3', N'9428af0b-bc25-429d-a646-ef54275191f3', N'd1e1fa23b2788077180e85a9b1962d28', N'752854682fb3fd72', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'e2d42aae-d246-4495-b495-5fc1f7d778e9', N'e2d42aae-d246-4495-b495-5fc1f7d778e9', N'1b2611dea5a26de711582ff790cdbd1b', N'5917c8bf1602358f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'e7facbde-fe78-494b-be09-16931b646a79', N'e7facbde-fe78-494b-be09-16931b646a79', N'e90681d391fc39cf3a189c9c8dda0b45', N'5fc6af6c7efc92d6', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'f8eee1bb-f520-4ee9-b4f7-036fde68b3a2', N'f8eee1bb-f520-4ee9-b4f7-036fde68b3a2', N'e2009649dacf9658b225d86ef162515e', N'ecbbd97f6e56c16a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'0e1ab5fb-93db-4f69-9d79-efaf3bb52129', N'0e1ab5fb-93db-4f69-9d79-efaf3bb52129', N'a55c951c7471dcfe20d9b2f2d655ed16', N'9c12b323030fe547', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'965058ec-138a-4343-8b9b-4936bf2a271a', N'965058ec-138a-4343-8b9b-4936bf2a271a', N'1dc9aa3eacc09fe0e28f6c44625b983c', N'acde5b2b37d2c57f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'6f533c8b-8d8b-4ea9-aa66-603c67a8120a', N'6f533c8b-8d8b-4ea9-aa66-603c67a8120a', N'7991e4a2d47c7a9fca67a428a007df87', N'98efe2ea0e8d0a37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'f2c898a7-c2b4-492f-8a32-dedcd6aa3ba6', N'f2c898a7-c2b4-492f-8a32-dedcd6aa3ba6', N'8dea571e2d17a5f9f8ff3a62a511fead', N'cf1e0baf2022a1f2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'f5229355-4943-4de7-a6c0-113b85b7d551', N'f5229355-4943-4de7-a6c0-113b85b7d551', N'32d3b7e3e42cf76521a2eda7c5763afc', N'0d1608bd501940e0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'596bd87a-ec5a-46e9-bd95-78392e41d6b1', N'596bd87a-ec5a-46e9-bd95-78392e41d6b1', N'e1345ec97380b2c8df7e39346b468872', N'145cca43b48cb82a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'300f8d40-ad2d-4f43-9fd4-937acc8029ed', N'300f8d40-ad2d-4f43-9fd4-937acc8029ed', N'088274e4f00868ad16097e9d16b42fd2', N'42ed8ef6f894da42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'cc73f8a0-1f30-42a9-a52d-67fec237bf99', N'cc73f8a0-1f30-42a9-a52d-67fec237bf99', N'3bc1e0d8683b8d340d0fd4f7498d16fe', N'09b897fcd4eab72b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'c275ad72-c474-4807-864d-aba070e74789', N'c275ad72-c474-4807-864d-aba070e74789', N'6f4451552464e5dc0a221eee89f90e29', N'829c4b17d6b93b55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'bc670040-bfa0-4d42-8b68-e44912f7fd62', N'bc670040-bfa0-4d42-8b68-e44912f7fd62', N'e68479d731ece23a477cac73e0a00850', N'765f9829175a4f03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'9453d365-cbb8-446e-94c2-3d468a0ccfd8', N'9453d365-cbb8-446e-94c2-3d468a0ccfd8', N'8c9af1fd0b2a1301c046865a4cceb430', N'b127575602b8b44c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'd2c6eb5d-1f49-4505-b9aa-82eaaed464e0', N'd2c6eb5d-1f49-4505-b9aa-82eaaed464e0', N'468d43cc3c7bd9865e5106d669f8d302', N'a91a31cfb12e482c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'5fbacb42-35a0-43e2-8912-4754cbd84528', N'5fbacb42-35a0-43e2-8912-4754cbd84528', N'76da5f748bc7322c847bc0b03e474e11', N'65589473d7594631', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'c8417c49-64de-4e86-9ff9-8d51261bdba9', N'c8417c49-64de-4e86-9ff9-8d51261bdba9', N'61fffbba998d9dacbad2291e808e68fe', N'5ba9aff1c2c2def2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'eb3c5b7a-b2a2-4791-b492-28b06d5870c5', N'eb3c5b7a-b2a2-4791-b492-28b06d5870c5', N'e634e71f0548d34cb8b6d1aeb6cfd6ed', N'ea834fec04f83ec2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'90794d73-bfa8-4afe-b352-a2be0ec2065d', N'90794d73-bfa8-4afe-b352-a2be0ec2065d', N'c89947eca26ea7d0f74c2640e26ade88', N'1b8c0873c178c3ea', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'4c1220cd-edc1-4cee-a5dc-44f876389a2c', N'4c1220cd-edc1-4cee-a5dc-44f876389a2c', N'e1165e9915ed4ebede4fe0849048d83c', N'a1f6482cdabb689c', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'6b07511c-cbf8-408c-9090-bf487814d562', N'6b07511c-cbf8-408c-9090-bf487814d562', N'6bc8a245865534c5470ae74ddb2a8db3', N'5e1eb614bbb40f8f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'3bc596ca-1ffc-4cb7-9c26-6ab3afb8256b', N'3bc596ca-1ffc-4cb7-9c26-6ab3afb8256b', N'698d322885cc04c67a988df366a88f23', N'74f0f2a713b6de55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'55fc76db-6557-4711-9032-293886633830', N'55fc76db-6557-4711-9032-293886633830', N'f9bb6f82af9eaca1f9586a63a0401ee7', N'7e1868515e006572', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

print 'Processed 100 total records'
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'1db3b68b-ea00-42ad-b496-d77acd7cab90', N'1db3b68b-ea00-42ad-b496-d77acd7cab90', N'7770516035a6691ad37eb67826bef482', N'4c203f29b3558950', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'6b786b65-206d-44bd-b1b5-df49ebbb1bea', N'6b786b65-206d-44bd-b1b5-df49ebbb1bea', N'e7efc014815d20b581b5fd75856555d7', N'2628e01415628d77', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'0d507044-468b-4a84-b4b7-306f093f9d88', N'0d507044-468b-4a84-b4b7-306f093f9d88', N'549602587e6da4f7684251606e7b94a1', N'68fc0f6c400ef508', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'0fbec5e1-f57d-4cc3-a184-adb97949b2a0', N'0fbec5e1-f57d-4cc3-a184-adb97949b2a0', N'caa894eac9dd9152892a00a01383e50b', N'51e3b7485fc38dc3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'c7d6ee96-86b1-4336-b390-64a9a7bba3fe', N'c7d6ee96-86b1-4336-b390-64a9a7bba3fe', N'7e16f213294d734bceeec82914085c63', N'5730522d8db0663b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'3b3dfd02-4940-4125-b4de-c42f94626872', N'3b3dfd02-4940-4125-b4de-c42f94626872', N'2aa69a77fecd987be85c26c9fafe0c6b', N'2a0887eef4b39d88', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'eb7f826d-b8da-4bb0-baa0-a73c2bfe630f', N'eb7f826d-b8da-4bb0-baa0-a73c2bfe630f', N'48be7f6f4a675a17e1c43d8b8bf84a26', N'23a9823b3a54eda9', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'9d87b542-bb14-4087-ad53-4ab0238b0fef', N'9d87b542-bb14-4087-ad53-4ab0238b0fef', N'60cb353929b6255d72f1f3e0a98091d3', N'6e8100729d8f617a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'ae5bfedb-cfd3-4106-b50e-14abb5205929', N'ae5bfedb-cfd3-4106-b50e-14abb5205929', N'91e4cbb3bfdaafe57fb53014ccbaa8cb', N'37d197c1712ce9fe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'f13a47e1-8490-419c-b117-291691b07175', N'f13a47e1-8490-419c-b117-291691b07175', N'223167bcde36c2c75f672c8ee5ef99f3', N'c0a6e3abc330975f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'01baaf0a-f83f-4af3-9b39-e66538844e66', N'01baaf0a-f83f-4af3-9b39-e66538844e66', N'2394939ac544133129e58af1f57f7c6c', N'7db80cdcc34e24b7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'97884662-b0e8-4870-ae53-492aa8829fbf', N'97884662-b0e8-4870-ae53-492aa8829fbf', N'e090421618138fd37d3b11180ceb7949', N'dc0bceb7ebbf32df', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'69b52c4a-5bf5-4045-a97e-85c47e583e36', N'69b52c4a-5bf5-4045-a97e-85c47e583e36', N'80b314fdffc3bd6ab5d563fb10fe5215', N'7992c14ad807602a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'dfb7c6c7-121f-4ec5-b1fe-b7e880c7c6cf', N'dfb7c6c7-121f-4ec5-b1fe-b7e880c7c6cf', N'2f2f20247e81c9dc5e71dd66b313bd7a', N'c652b8a16f7c68f0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'264e11ac-97c8-468c-a6e0-7e74a8c94b5b', N'264e11ac-97c8-468c-a6e0-7e74a8c94b5b', N'3151169940ea27042b74f31ee5bfceeb', N'15875074967bc6fc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'29acefc8-ce05-4369-81ea-f9e998d1fa02', N'29acefc8-ce05-4369-81ea-f9e998d1fa02', N'ce47dc5526197502c204b60e441af311', N'b98d98670c17766a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'100e3013-2882-45ae-a7fa-b826e51ba65e', N'100e3013-2882-45ae-a7fa-b826e51ba65e', N'66cb1f7a9e2f51dc2f64f5cc54104372', N'ebaa281db502394a', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_UserLogOn] ([F_Id], [F_UserId], [F_UserPassword], [F_UserSecretkey], [F_AllowStartTime], [F_AllowEndTime], [F_LockStartDate], [F_LockEndDate], [F_FirstVisitTime], [F_PreviousVisitTime], [F_LastVisitTime], [F_ChangePasswordDate], [F_MultiUserLogin], [F_LogOnCount], [F_UserOnLine], [F_Question], [F_AnswerQuestion], [F_CheckIPAddress], [F_Language], [F_Theme]) VALUES (N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', N'44c35ab35cb0603e90d168642ca51fb6', N'57d3031d6fc4a34d', NULL, NULL, NULL, NULL, NULL, CAST(0x0000A66400986BEC AS DateTime), CAST(0x0000A66400AE8104 AS DateTime), NULL, NULL, 98, NULL, NULL, NULL, NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'6903ab9d-20cd-44c4-a380-09f229366e1f', N'1010', N'白玉芬', N'白玉芬', NULL, 0, NULL, N'15202701761', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'531F7D18-C49F-4F4F-A920-0074FCB52078', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, N'测试数据', CAST(0x0000A64900000000 AS DateTime), NULL, CAST(0x0000A64D017AADDB AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'38c9c1e6-7b89-4aed-b782-4cbf082a4b72', N'1011', N'陈国祥', N'陈国祥', NULL, 1, NULL, N'18707385959', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'b26e59b9-2456-4038-b601-26e8a225e663', N'1012', N'陈艳华', N'陈艳华', NULL, 0, NULL, N'13105056538', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'200cab1a-30df-4cdf-a9a5-258b882a23e7', N'1013', N'邓海燕', N'邓海燕', NULL, 0, NULL, N'18305105175', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a9450c22-926d-4afa-ae3b-2c8602762a81', N'1014', N'纪海燕', N'纪海燕', NULL, 0, NULL, N'15702775754', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'47a95b17-ff8b-46f9-99a4-02a7e6a53550', N'1015', N'明汉琴', N'明汉琴', NULL, 1, NULL, N'18808336333', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ca40ef7c-88b0-46c9-910d-f9bfbc1d7968', N'1016', N'沈亚杰', N'沈亚杰', NULL, 1, NULL, N'13206006912', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'da01cfbe-7094-4573-bf46-c895ba71a28b', N'1017', N'汤丽丽', N'汤丽丽', NULL, 0, NULL, N'18506055549', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'1ddf560b-c18e-48d4-b132-f90eb7475741', N'1018', N'吴凤祥', N'吴凤祥', NULL, 1, NULL, N'15803726128', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'b7d73ca6-9c1c-478f-a1f0-9e02bae69872', N'1019', N'肖丽丽', N'肖丽丽', NULL, 0, NULL, N'18901406707', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9798d1b6-2ad2-4228-8c1a-6d3107120e29', N'1020', N'徐丽云', N'徐丽云', NULL, 0, NULL, N'18605503509', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'547be453-cbdc-44d1-a6e5-9852cb044e4a', N'1021', N'张珊珊', N'张珊珊', NULL, 0, NULL, N'13003184088', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'75b2c660-c5f8-41f7-980c-d979e8ec9eaa', N'1022', N'郑永军', N'郑永军', NULL, 1, NULL, N'18103232725', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'06484cd2-d16f-4038-ae91-7431b126930d', N'1023', N'周荣锋', N'周荣锋', NULL, 1, NULL, N'17702357081', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'd9bc1853-61aa-48c9-96a4-a8b1075a82ae', N'1024', N'邹丽丽', N'邹丽丽', NULL, 0, NULL, N'15607907660', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'40075d85-1b80-4da3-b061-76b7b1edb16e', N'1025', N'陈翠梅', N'陈翠梅', NULL, 0, NULL, N'17607956297', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'cdf5ba74-9751-4808-8893-0100dd188197', N'1026', N'陈晓静', N'陈晓静', NULL, 0, NULL, N'13005626876', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'833ad021-6ccc-4db0-8017-5021f5327260', N'1027', N'邓正同', N'邓正同', NULL, 1, NULL, N'13403307455', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'6a1e3bb6-49c2-4d64-becc-e5644678178f', N'1028', N'顾爱华', N'顾爱华', NULL, 1, NULL, N'17704790769', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8b269fcf-9f22-4d32-a269-cabdac469749', N'1029', N'郭荣兰', N'郭荣兰', NULL, 1, NULL, N'15602471348', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'07491670-be4a-4bb3-8a12-c8a0ce3c52cd', N'1030', N'胡泽夫', N'胡泽夫', NULL, 1, NULL, N'15603963762', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'cf3af1b8-d2ce-4f2f-88f3-5838a77f83c7', N'1031', N'李海燕', N'李海燕', NULL, 0, NULL, N'13701644341', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'158fa76f-1d82-4a38-a4e2-624239355b4d', N'1032', N'李云', N'李云', NULL, 1, NULL, N'18207194920', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'acb39d47-8860-49a0-abc0-a21d016c2fff', N'1033', N'刘梅', N'刘梅', NULL, 0, NULL, N'18108697334', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'13f9bb09-6db1-4932-acdd-36cfc39ce1a3', N'1034', N'刘玮', N'刘玮', NULL, 1, NULL, N'15206367913', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0f0ff3de-688c-4370-8a79-15637ed3b20c', N'1035', N'罗建东', N'罗建东', NULL, 1, NULL, N'15107851228', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4c8909b9-3ddb-4855-baa4-82edc2e3a5c1', N'1036', N'欧勇华', N'欧勇华', NULL, 1, NULL, N'15506985584', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2b33a324-5548-4d29-9030-d788f7c257fb', N'1037', N'戚容容', N'戚容容', NULL, 1, NULL, N'15305864510', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'b0529548-bbea-4aa6-8ed2-446033c4d90f', N'1038', N'沙海东', N'沙海东', NULL, 1, NULL, N'13903535089', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9caa1edf-0e06-4481-ab50-139949046e24', N'1039', N'施跃', N'施跃', NULL, 1, NULL, N'13905037503', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f13edee1-43b5-4cac-930f-f7350ec1a473', N'1040', N'孙永萍', N'孙永萍', NULL, 0, NULL, N'13104152760', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'79756b91-ea5b-4d28-9b46-dd192bb67895', N'1041', N'汪渠渠', N'汪渠渠', NULL, 1, NULL, N'13401833339', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'32585483-5534-4690-bc20-1b509e737f9c', N'1042', N'王琳琳', N'王琳琳', NULL, 0, NULL, N'13403325753', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a8d1b2a1-b4f7-43c8-9750-226f00108bc9', N'1043', N'王婷婷', N'王婷婷', NULL, 0, NULL, N'17704828166', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'45951653-bd26-482f-a1b5-4ac6c8b7be7b', N'1044', N'吴莉莉', N'吴莉莉', NULL, 0, NULL, N'13302498745', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2fd34599-042a-4caf-a98b-bd227ab6be0f', N'1045', N'夏燕芬', N'夏燕芬', NULL, 1, NULL, N'15603992060', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'caf2caf9-3982-4c88-b29b-2a86b72dc325', N'1046', N'徐清', N'徐清', NULL, 1, NULL, N'13801662639', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'318ba1e7-f4fa-4d88-869c-aa6e4f8c961c', N'1047', N'徐志海', N'徐志海', NULL, 1, NULL, N'13008666995', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'50eab71b-bf70-4037-9a57-8fdff44cffe3', N'1048', N'严晨', N'严晨', NULL, 1, NULL, N'13002280310', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e9dc99ca-b015-47ba-a00e-62d1f98bdb1a', N'1049', N'杨俊', N'杨俊', NULL, 1, NULL, N'17707830889', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f2adf10a-cb2c-417a-a1c5-d4c9c57fc5ef', N'1050', N'尤正岗', N'尤正岗', NULL, 1, NULL, N'18901453303', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ca57fe20-926d-47b2-a3f2-664a5d1da7ce', N'1051', N'张军燕', N'张军燕', NULL, 1, NULL, N'18902945716', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ba637dd7-7fd7-418b-a81f-238cc59adc76', N'1052', N'张雪莲', N'张雪莲', NULL, 0, NULL, N'15002060973', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2365e142-9fc9-4837-9be4-5587a07a735f', N'1053', N'赵亮', N'赵亮', NULL, 1, NULL, N'18607621552', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'F02A66CA-3D8B-491B-8A17-C9ACA3E3B5DD', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'c8c1fa94-f14d-4ccf-bd67-ad97f787d375', N'1054', N'征磊', N'征磊', NULL, 1, NULL, N'13202687743', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'F02A66CA-3D8B-491B-8A17-C9ACA3E3B5DD', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'b735ad6a-ba26-4cb8-84cf-07d0c38ac921', N'1055', N'周鹏', N'周鹏', NULL, 1, NULL, N'13104181058', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'F02A66CA-3D8B-491B-8A17-C9ACA3E3B5DD', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0090a476-68eb-4b79-ac6c-8fd3c0ff6c89', N'1056', N'朱骏', N'朱骏', NULL, 1, NULL, N'13105673472', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'F02A66CA-3D8B-491B-8A17-C9ACA3E3B5DD', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'6c19b537-f44d-4612-b9b0-647cf8672bce', N'1057', N'朱勇军', N'朱勇军', NULL, 1, NULL, N'18204797828', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'F02A66CA-3D8B-491B-8A17-C9ACA3E3B5DD', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2664b7a9-6a45-40a2-85e0-ea27887b74bb', N'1058', N'蒯红梅', N'蒯红梅', NULL, 0, NULL, N'13007744919', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'F02A66CA-3D8B-491B-8A17-C9ACA3E3B5DD', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'cbe6b2fb-7195-4d3a-86b6-ce2dc2d10eea', N'1059', N'宋艾清', N'宋艾清', NULL, 1, NULL, N'15901357333', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2016da68-e116-43d8-9d06-6ea19c559220', N'1060', N'黄青春', N'黄青春', NULL, 1, NULL, N'15902850648', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f5c9d584-e4d6-4c28-a145-bf98a08c80f0', N'1061', N'鲍殷隽', N'鲍殷隽', NULL, 1, NULL, N'18001975004', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'395d6e38-0e60-4256-b1cc-072c83adec6c', N'1062', N'蔡晓艳', N'蔡晓艳', NULL, 0, NULL, N'15303467417', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3ed28896-e246-4301-908f-2dfbcf92b33b', N'1063', N'陈莉', N'陈莉', NULL, 0, NULL, N'18802592674', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e1674f45-4aed-44b8-83d4-fb5373f8ee69', N'1064', N'陈小春', N'陈小春', NULL, 1, NULL, N'18704085088', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'daaf6f40-a1a1-4cfd-ab82-8c7d0ed3bad7', N'1065', N'成殳璟', N'成殳璟', NULL, 1, NULL, N'18705587502', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e371171e-ee64-4fea-9f5d-4e90f4e668cc', N'1066', N'杜春香', N'杜春香', NULL, 1, NULL, N'13804702759', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0d796336-aefe-4012-8294-89a54dce6b62', N'1067', N'葛海静', N'葛海静', NULL, 1, NULL, N'13706195173', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'BD830AEF-0A2E-4228-ACF8-8843C39D41D8', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4eee745e-97eb-470f-9372-605ded7f5917', N'1068', N'顾鹏程', N'顾鹏程', NULL, 1, NULL, N'13707697586', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'BD830AEF-0A2E-4228-ACF8-8843C39D41D8', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e0c34d25-ae43-46bc-b300-23c4fede6766', N'1069', N'江朝琴', N'江朝琴', NULL, 1, NULL, N'15906812843', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'BD830AEF-0A2E-4228-ACF8-8843C39D41D8', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'5f1cb307-761f-4c27-bfb3-5571038e87d2', N'1070', N'李进洋', N'李进洋', NULL, 1, NULL, N'13501879034', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'BD830AEF-0A2E-4228-ACF8-8843C39D41D8', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'16c9ed0a-4eb8-49e0-b287-a7115c2066d6', N'1071', N'李育芹', N'李育芹', NULL, 1, NULL, N'13503372349', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'BD830AEF-0A2E-4228-ACF8-8843C39D41D8', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'812a57a4-5a53-4a52-9eb1-70b6f45ec4a5', N'1073', N'糜金萍', N'糜金萍', NULL, 1, NULL, N'15703990019', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'11c4a1c2-daec-439c-9ea0-fc2d5630c4cd', N'1074', N'彭燕飞', N'彭燕飞', NULL, 1, NULL, N'17706936210', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'24a54791-44fb-4fea-95a9-2ba21cf0d3a0', N'1075', N'沈海云', N'沈海云', NULL, 0, NULL, N'18908438624', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'bbffd7f2-97d2-4bb4-a308-651171dbf6af', N'1076', N'孙琴芳', N'孙琴芳', NULL, 0, NULL, N'15107553881', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'b05535b3-0d4a-494d-8114-cad9e8e74133', N'1077', N'童立新', N'童立新', NULL, 1, NULL, N'18802610972', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'833333a5-7020-4912-929f-10439423fe44', N'1078', N'王粉兰', N'王粉兰', NULL, 0, NULL, N'18704113386', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'549bc2c1-c791-45c1-9746-93c871078a03', N'1079', N'王娟', N'王娟', NULL, 0, NULL, N'13307050478', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'1c6fb8ad-cc89-414d-835d-1b5be789493d', N'1080', N'王素霞', N'王素霞', NULL, 1, NULL, N'15102116668', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0c642247-ebad-4976-ab06-3c7e78e6ad12', N'1081', N'王颖姝', N'王颖姝', NULL, 0, NULL, N'15103619082', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'702ea347-099f-4afd-a7a2-11091418fc50', N'1082', N'韦红玲', N'韦红玲', NULL, 0, NULL, N'15502734339', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'122b1e73-548d-429c-aa33-3e73635a7f44', N'1083', N'吴昊', N'吴昊', NULL, 1, NULL, N'13905671431', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'd2967e93-4d8b-43d9-b9cb-9cd4a76ad28e', N'1084', N'徐建平', N'徐建平', NULL, 1, NULL, N'18708627621', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a9a27d8a-3543-4d3d-903e-71790b20dcd1', N'1085', N'许黎辉', N'许黎辉', NULL, 1, NULL, N'15603684713', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'763d5744-89ae-4497-ba19-79dba081646f', N'1086', N'杨素娟', N'杨素娟', NULL, 1, NULL, N'15006621805', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9428af0b-bc25-429d-a646-ef54275191f3', N'1087', N'殷鹏', N'殷鹏', NULL, 1, NULL, N'15008124218', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e2d42aae-d246-4495-b495-5fc1f7d778e9', N'1088', N'袁洁', N'袁洁', NULL, 1, NULL, N'18703181310', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e7facbde-fe78-494b-be09-16931b646a79', N'1089', N'张雪蕾', N'张雪蕾', NULL, 0, NULL, N'15606127501', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f8eee1bb-f520-4ee9-b4f7-036fde68b3a2', N'1090', N'周海红', N'周海红', NULL, 0, NULL, N'17605252758', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0e1ab5fb-93db-4f69-9d79-efaf3bb52129', N'1091', N'周立萍', N'周立萍', NULL, 0, NULL, N'15508198948', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'965058ec-138a-4343-8b9b-4936bf2a271a', N'1092', N'周勇', N'周勇', NULL, 1, NULL, N'13903256040', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'6f533c8b-8d8b-4ea9-aa66-603c67a8120a', N'1093', N'朱兵', N'朱兵', NULL, 1, NULL, N'18706203132', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f2c898a7-c2b4-492f-8a32-dedcd6aa3ba6', N'1094', N'朱如兄', N'朱如兄', NULL, 1, NULL, N'15601260223', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f5229355-4943-4de7-a6c0-113b85b7d551', N'1095', N'朱永慧', N'朱永慧', NULL, 1, NULL, N'15004206414', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'596bd87a-ec5a-46e9-bd95-78392e41d6b1', N'1096', N'乐丽萍', N'乐丽萍', NULL, 0, NULL, N'18707153506', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'300f8d40-ad2d-4f43-9fd4-937acc8029ed', N'1097', N'黄晓华', N'黄晓华', NULL, 1, NULL, N'13302210597', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'cc73f8a0-1f30-42a9-a52d-67fec237bf99', N'1098', N'张园园', N'张园园', NULL, 1, NULL, N'15105156788', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'c275ad72-c474-4807-864d-aba070e74789', N'1099', N'陈雯', N'陈雯', NULL, 1, NULL, N'18808093879', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'bc670040-bfa0-4d42-8b68-e44912f7fd62', N'1100', N'朱慧蕙', N'朱慧蕙', NULL, 0, NULL, N'15303160971', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9453d365-cbb8-446e-94c2-3d468a0ccfd8', N'1101', N'马亚军', N'马亚军', NULL, 1, NULL, N'15206107162', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'd2c6eb5d-1f49-4505-b9aa-82eaaed464e0', N'1102', N'时燕杰', N'时燕杰', NULL, 1, NULL, N'18901164253', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'5fbacb42-35a0-43e2-8912-4754cbd84528', N'1103', N'吴亚敏', N'吴亚敏', NULL, 1, NULL, N'13507933180', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'c8417c49-64de-4e86-9ff9-8d51261bdba9', N'1104', N'邱艳芬', N'邱艳芬', NULL, 0, NULL, N'18202990272', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'eb3c5b7a-b2a2-4791-b492-28b06d5870c5', N'1105', N'张海峰', N'张海峰', NULL, 1, NULL, N'15905936462', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'90794d73-bfa8-4afe-b352-a2be0ec2065d', N'1106', N'何雪峰', N'何雪峰', NULL, 1, NULL, N'13601003554', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4c1220cd-edc1-4cee-a5dc-44f876389a2c', N'1107', N'王晓芳', N'王晓芳', NULL, 0, NULL, N'18303940645', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'6b07511c-cbf8-408c-9090-bf487814d562', N'1108', N'缪崔云', N'缪崔云', NULL, 1, NULL, N'13006886836', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3bc596ca-1ffc-4cb7-9c26-6ab3afb8256b', N'1109', N'卞宏群', N'卞宏群', NULL, 1, NULL, N'18603407705', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'55fc76db-6557-4711-9032-293886633830', N'1110', N'单玉华', N'单玉华', NULL, 1, NULL, N'13206344796', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'1db3b68b-ea00-42ad-b496-d77acd7cab90', N'1111', N'杜德红', N'杜德红', NULL, 1, NULL, N'13801401888', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

print 'Processed 100 total records'
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'6b786b65-206d-44bd-b1b5-df49ebbb1bea', N'1112', N'冯素梅', N'冯素梅', NULL, 1, NULL, N'15008170814', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'DFA2FB91-C909-44A3-9282-BF946102E1C9', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0d507044-468b-4a84-b4b7-306f093f9d88', N'1113', N'高士勤', N'高士勤', NULL, 1, NULL, N'18803237005', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'DFA2FB91-C909-44A3-9282-BF946102E1C9', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0fbec5e1-f57d-4cc3-a184-adb97949b2a0', N'1114', N'韩坚强', N'韩坚强', NULL, 1, NULL, N'13306174097', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'DFA2FB91-C909-44A3-9282-BF946102E1C9', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'c7d6ee96-86b1-4336-b390-64a9a7bba3fe', N'1115', N'胡新红', N'胡新红', NULL, 0, NULL, N'18902684965', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'DFA2FB91-C909-44A3-9282-BF946102E1C9', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3b3dfd02-4940-4125-b4de-c42f94626872', N'1116', N'季明兰', N'季明兰', NULL, 0, NULL, N'18005632057', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'eb7f826d-b8da-4bb0-baa0-a73c2bfe630f', N'1117', N'茅建安', N'茅建安', NULL, 1, NULL, N'13402142925', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9d87b542-bb14-4087-ad53-4ab0238b0fef', N'1118', N'潘国霞', N'潘国霞', NULL, 1, NULL, N'18105080017', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ae5bfedb-cfd3-4106-b50e-14abb5205929', N'1119', N'颜洪强', N'颜洪强', NULL, 1, NULL, N'18303968042', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f13a47e1-8490-419c-b117-291691b07175', N'1120', N'杨素华', N'杨素华', NULL, 1, NULL, N'13106915134', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'01baaf0a-f83f-4af3-9b39-e66538844e66', N'1121', N'阴定坤', N'阴定坤', NULL, 1, NULL, N'13701972226', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'97884662-b0e8-4870-ae53-492aa8829fbf', N'1122', N'袁广伟', N'袁广伟', NULL, 1, NULL, N'13206363094', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'69b52c4a-5bf5-4045-a97e-85c47e583e36', N'1123', N'赵海燕', N'赵海燕', NULL, 0, NULL, N'13901430186', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, N'111', CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'dfb7c6c7-121f-4ec5-b1fe-b7e880c7c6cf', N'1124', N'周小燕', N'周小燕', NULL, 0, NULL, N'15605821054', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'264e11ac-97c8-468c-a6e0-7e74a8c94b5b', N'1125', N'朱红梅', N'朱红梅', NULL, 0, NULL, N'15008767245', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'29acefc8-ce05-4369-81ea-f9e998d1fa02', N'1126', N'晏登峰', N'晏登峰', NULL, 1, NULL, N'15207646172', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'100e3013-2882-45ae-a7fa-b826e51ba65e', N'1127', N'季冬梅', N'季冬梅', NULL, 0, NULL, N'17702713263', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'2691AB91-3010-465F-8D92-60A97425A45E', N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', 0, NULL, 0, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_User] ([F_Id], [F_Account], [F_RealName], [F_NickName], [F_HeadIcon], [F_Gender], [F_Birthday], [F_MobilePhone], [F_Email], [F_WeChat], [F_ManagerId], [F_SecurityLevel], [F_Signature], [F_OrganizeId], [F_DepartmentId], [F_RoleId], [F_DutyId], [F_IsAdministrator], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', N'admin', N'超级管理员', N'超级管理员', NULL, 1, NULL, N'13600000000', NULL, NULL, NULL, NULL, NULL, N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', NULL, NULL, 0, NULL, 0, 1, N'系统内置账户', CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ccfcea25-cab8-42e7-aee3-61663d89ba93', 2, N'91be873e-ccb7-434f-9a3b-d312d6d5798a', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011949 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'cd061505-61fe-4a4e-a612-41952ba33e3b', 1, N'163DA347-887C-4C91-8298-EB00FFBFEC84', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'd4cd5d85-c730-4bd9-9d62-3233056fa7f3', 2, N'E29FCBA7-F848-4A8B-BC41-A3C668A9005D', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011951 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'da24baba-479c-4017-acee-569b1fa0ce1a', 1, N'54E9D12D-C039-4F01-A6FE-810A147D31D5', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195B AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'e7095efa-4793-44f0-8edb-57e21d4aeea2', 1, N'64A1C550-2C61-4A8C-833D-ACD0C012260F', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011950 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ea573da4-7921-40db-bf8f-447ef980ee31', 1, N'85FAF4F4-9CBE-4904-94B3-2B930CA49F0C', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'eb7aabf3-801e-4751-85e9-8972faec4452', 1, N'AF34B824-439E-4365-99CC-C1D30514D869', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011960 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ebff5f54-bbe5-482a-a763-d6fcce17b655', 2, N'5d708d9d-6ebe-40ea-8589-e3efce9e74ec', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194B AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'f5dc517b-f045-41ba-bae0-f7053a89c6c9', 2, N'f93763ff-51a1-478d-9585-3c86084c54f3', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'f929d1f3-2485-4d0b-8253-ff778dd30add', 2, N'cd65e50a-0bea-45a9-b82e-f2eacdbd209e', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011949 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'fcf8d653-fe9a-4e8f-81d5-f4af1119bbbf', 1, N'F2DAD50B-95DF-48F7-8638-BA503B539143', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011956 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'04d23b62-8401-4e50-8279-aaeb66377daa', 2, N'FD3D073C-4F88-467A-AE3B-CDD060952CE6', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'0f7b0b1b-d925-45d5-adf9-55044a7f4c19', 2, N'5d708d9d-6ebe-40ea-8589-e3efce9e74ec', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1afefe4f-c76d-488b-b165-e797b017c216', 2, N'e75e4efc-d461-4334-a764-56992fec38e6', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'22ddf57d-739d-4da0-b2a7-752459f110a6', 2, N'8a9993af-69b2-4d8a-85b3-337745a1f428', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'244823d7-6b36-4cf9-b63d-c749e91061ae', 2, N'48afe7b3-e158-4256-b50c-cd0ee7c6dcc9', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'250a92b7-a549-4a35-b007-82f90dcf5622', 2, N'104bcc01-0cfd-433f-87f4-29a8a3efb313', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2af34ef2-522e-4ea3-a8df-668b57e3b4e3', 1, N'337A4661-99A5-4E5E-B028-861CACAF9917', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2e467fc2-2e71-45c7-ad7c-fad5eb956adf', 2, N'cd65e50a-0bea-45a9-b82e-f2eacdbd209e', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'32119cfa-864e-4bf9-945b-2d76dad0a31c', 2, N'f93763ff-51a1-478d-9585-3c86084c54f3', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'379e90a9-5628-47e0-8314-da3e0c550fb3', 2, N'88f7b3a8-fd6d-4f8e-a861-11405f434868', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'37b242db-cd74-400f-964b-96d72bd651c6', 2, N'1ee1c46b-e767-4532-8636-936ea4c12003', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3ec593df-c492-4270-9aef-e75d521171da', 2, N'14617a4f-bfef-4bc2-b943-d18d3ff8d22f', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'41105b53-4315-442c-bb7f-9b9204355351', 2, N'4727adf7-5525-4c8c-9de5-39e49c268349', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4ff4e45a-9ed6-4c79-be52-ae6d07d77b3a', 2, N'8c7013a9-3682-4367-8bc6-c77ca89f346b', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'52cce008-0755-4a75-9fdf-6425f74f62b0', 2, N'89d7a69d-b953-4ce2-9294-db4f50f2a157', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'53967381-3765-4bff-ad74-6aa1c9d03596', 2, N'D4FCAFED-7640-449E-80B7-622DDACD5012', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'64f6b88c-7510-4e83-956e-d2d6c163200a', 1, N'F298F868-B689-4982-8C8B-9268CBF0308D', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'68905347-8abf-4f99-bacd-8d3045b06e2b', 2, N'4b876abc-1b85-47b0-abc7-96e313b18ed8', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'6d4f5a20-98b2-40c5-8352-80b15af1b360', 2, N'239077ff-13e1-4720-84e1-67b6f0276979', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'700916e8-3488-45f2-b407-6f30df9b9123', 2, N'B6A9473D-DAA7-4574-9231-13D9E631D379', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'7535204c-60ce-4114-bb12-430a5975b363', 2, N'38e39592-6e86-42fb-8f72-adea0c82cbc1', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'77eafdea-c1e3-4e36-9d70-cdaa7b5200d4', 1, N'38CA5A66-C993-4410-AF95-50489B22939C', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'790dc854-bdbf-4ff0-8cea-2ffffcbe98ed', 2, N'E29FCBA7-F848-4A8B-BC41-A3C668A9005D', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'848319d7-89f3-4ef9-b9fc-fcd99eddf632', 2, N'4bb19533-8e81-419b-86a1-7ee56bf1dd45', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'94fa7a37-986f-4534-87bc-b66bcf7246d0', 1, N'252229DB-35CA-47AE-BDAE-C9903ED5BA7B', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'997a0c17-7de7-4eb3-9adb-c4900b310948', 2, N'74eecdfb-3bee-405d-be07-27a78219c179', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'a06b6fb1-f68a-4856-9e41-44ec8a642139', 2, N'85F5212F-E321-4124-B155-9374AA5D9C10', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'aa5d1775-d95b-4f07-8c2b-7a9820876dc0', 2, N'709a4a7b-4d98-462d-b47c-351ef11db06f', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'af617592-755c-4a6b-99ac-3d1ba457d760', 2, N'91be873e-ccb7-434f-9a3b-d312d6d5798a', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c0a099cf-8ea2-4193-bd66-403f35ac3e42', 1, N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c5c51f2e-4f7d-4aa9-9b90-b0ad1679771d', 2, N'13c9a15f-c50d-4f09-8344-fd0050f70086', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'cbf03b03-096a-4eb3-9983-81637429e51b', 2, N'82f162cb-beb9-4a79-8924-cd1860e26e2e', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'd5f8dc31-4c8d-41a5-8154-9c855553793a', 2, N'ffffe7f8-900c-413a-9970-bee7d6599cce', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'd71845b3-c39b-4a99-a523-f7a93f3ac038', 2, N'abfdff21-8ebf-4024-8555-401b4df6acd9', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'e1a1c00f-e10e-4589-8144-797f38efcd80', 2, N'0d777b07-041a-4205-a393-d1a009aaafc7', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'b52fbff2-78d5-475d-84ca-6d9ed11d3cc6', NULL, N'', 1, N'4B2140D3-E61D-488E-ADF6-FF0EBCBC5D2C', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'e61a0833-aa73-4e15-9c03-83b8089e6bd8', 2, N'9FD543DB-C5BB-4789-ACFF-C5865AFB032C', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'e6c1e0a7-aaaa-4adb-b95d-353134a484c6', 1, N'64A1C550-2C61-4A8C-833D-ACD0C012260F', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'eae52f23-db61-4997-82e0-437978517f6a', 1, N'91A6CFAD-B2F9-4294-BDAE-76DECF412C6C', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'f5c3d009-3d00-4be1-822c-feba6c89ae0a', 1, N'462027E0-0848-41DD-BCC3-025DCAE65555', 1, N'531F7D18-C49F-4F4F-A920-0074FCB52078', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1fd4ae2a-24fd-49e3-8007-5cc987cd05c0', NULL, N'', 1, N'42C44AC0-27FA-482D-B5E3-8F9B38B80A6A', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'df6839d3-60c4-447d-9d48-c75d26d77a7b', NULL, N'', 1, N'7A9CF301-FCDF-4BC9-A52B-A7D4FAE2D344', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2bf9d1bd-510f-463a-9555-4ab8357bfb08', NULL, N'', 1, N'2691AB91-3010-465F-8D92-60A97425A45E', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'f8a6180a-ee18-41f4-b28e-d7e4c5a36045', NULL, N'', 1, N'41652BB4-E2DC-420E-AA8A-8C92784B76E3', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'cf6bf931-ae94-4820-92de-4f80590c615d', NULL, N'', 1, N'2DA8390B-61A4-4E6C-A6E7-8F6794C7EDCE', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'93e3474f-a8c9-4b0e-bf42-1571e9f4e6b8', NULL, N'', 1, N'07A8E061-AE47-49C9-8310-F055F35FF44B', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'fbc0b434-f261-47eb-94c8-0c450dd56cc4', NULL, N'', 1, N'AADB479E-9F87-49B1-AE2D-5DA6FECA3F8E', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4552cc48-1bf9-4bbe-b1e1-f9e91add7055', NULL, N'', 1, N'E5EA792F-915D-44BC-9F4F-EEDB26DE5DFD', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'df6281cb-6ad9-4d4b-aff2-ba6f266c1dd3', NULL, N'', 1, N'8683CB17-5F9D-4A99-A233-A18C4D1CF95B', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'06a71015-42f4-4f16-ad9e-88e0665f7504', NULL, N'', 1, N'F68956A9-9C53-4C08-AFE8-8A4755FE2B8F', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'bb544273-6e31-4235-b507-3f0ffbfded28', NULL, N'', 1, N'F9421969-D85C-4E4C-927F-CCFB18388A59', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'cb31c152-4e34-44ce-a7a8-1f0a46b4aec9', NULL, N'', 1, N'59CEAE05-0FD4-4FD3-A755-A1DFA3803D2B', NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'0000da5b-6305-4b23-b1db-1f55a66daca8', 2, N'FD3D073C-4F88-467A-AE3B-CDD060952CE6', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011952 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'06011f83-df9a-4d5d-bb6f-0b948574256c', 1, N'73FD1267-79BA-4E23-A152-744AF73117E9', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011953 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'12cc8ed7-d769-48cc-ab3c-866466462e70', 1, N'96EE855E-8CD2-47FC-A51D-127C131C9FB9', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011955 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'15b2279f-7082-421e-a6a3-9abd5bca8303', 1, N'337A4661-99A5-4E5E-B028-861CACAF9917', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'166e6255-d5cc-4718-b257-771398b4132b', 2, N'13c9a15f-c50d-4f09-8344-fd0050f70086', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1822a1c4-5a49-4742-a937-b63e4f9bd826', 1, N'FE04386D-1307-4E34-8DFB-B56D9FEC78CE', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195B AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1a81232c-037a-4af8-b2cf-55e19fce1582', 2, N'239077ff-13e1-4720-84e1-67b6f0276979', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1dbe5bcb-3907-49d4-93d9-0d41cc539a1d', 1, N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011950 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1e2c7104-1731-4519-81ac-3594f78bf8dd', 1, N'9F56840F-DF92-4936-A48C-8F65A39291A2', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2078f57a-454a-48c8-9fee-122df8f5786e', 1, N'7B959522-BE45-4747-B89D-592C7F3987A5', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011960 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'237da469-8831-45bf-bb78-0e7ca06f33d7', 1, N'38CA5A66-C993-4410-AF95-50489B22939C', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'243814e8-2279-4749-b84a-4e0c269d2910', 2, N'709a4a7b-4d98-462d-b47c-351ef11db06f', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2c069a5e-8785-49b3-a6e7-355dbad2e89f', 1, N'39E97B05-7B6F-4069-9972-6F9643BC3042', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011962 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3115d827-1419-48ab-88fa-c9b56be6df86', 1, N'822E2523-5105-4AE0-BF48-62459D3641F6', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'335e819a-866c-409d-8233-3449481b0460', 2, N'D4FCAFED-7640-449E-80B7-622DDACD5012', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011952 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'34b49233-b13b-4a6f-bc98-3000bf6b75ee', 1, N'91425AF9-F762-43AF-B784-107D23FFDC85', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011958 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'35753609-e0d7-4829-9685-6cafe02c7ca7', 1, N'462027E0-0848-41DD-BCC3-025DCAE65555', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011948 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3f21e866-1f79-4cac-9f8e-91a0cb1014ce', 2, N'85F5212F-E321-4124-B155-9374AA5D9C10', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011951 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'43ad8ba2-3258-40ce-a121-a4c4c1af0871', 1, N'a3a4742d-ca39-42ec-b95a-8552a6fae579', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011954 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'474417c9-51de-40e9-b2dc-59d169f0bf12', 1, N'ABA7DA44-A291-4A25-9BDC-C310CF1C931C', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4d0ba76b-dbb0-4e4f-b83e-92df13bf702a', 2, N'ffffe7f8-900c-413a-9970-bee7d6599cce', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194B AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4d26e4ba-cf4f-4783-a4bd-84e1f2f9ecb3', 1, N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011956 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'5324f369-ce2d-47cc-a3c5-cf4f690a7914', 1, N'D2ECB516-4CB7-49B1-B536-504382115DD2', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011961 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'577c000a-2997-4915-aa24-412c4acfbb38', 1, N'6BBC3562-1051-4246-98B0-9F37CAC40DC8', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'5ae6902f-0520-4000-a495-6db64d3ff469', 1, N'C3D12056-D906-4D8B-8B9C-954942742BDE', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011957 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'6e725406-22c9-4c19-8f85-054f97ee20f4', 1, N'49F61713-C1E4-420E-BEEC-0B4DBC2D7DE8', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011955 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'6e83c40f-c7fc-4b96-86aa-b17485a2d8ca', 1, N'91A6CFAD-B2F9-4294-BDAE-76DECF412C6C', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'766067c0-ebef-43f6-b49b-a7261634ff05', 2, N'88f7b3a8-fd6d-4f8e-a861-11405f434868', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'77699534-4f0b-44f0-a6d2-3953334be95a', 1, N'A33ADBFC-089B-4981-BFAB-08178052EE36', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'844841a3-a465-4bba-816e-920dbdca9715', 1, N'0EDF1DDB-CA17-4D08-AA25-914FE4E13324', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011957 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'8e81b948-313c-4d2c-b752-92a83197b7e6', 1, N'e72c75d0-3a69-41ad-b220-13c9a62ec788', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011954 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'90a522bb-5e94-48d7-be44-e4180ee7bc3d', 1, N'df9920e0-ba33-4e36-a911-ef08c6ea77ea', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011959 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'90a63c30-1c20-4f47-9cd8-d9bcc44e10d9', 1, N'F298F868-B689-4982-8C8B-9268CBF0308D', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'94a7787a-6659-49cc-a902-7ea63231c177', 2, N'4bb19533-8e81-419b-86a1-7ee56bf1dd45', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011949 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'9c9cfbd1-525a-4f02-a765-30a72c771e23', 2, N'B6A9473D-DAA7-4574-9231-13D9E631D379', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011953 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'9cc97a78-d8ca-45bd-aad5-efbeef4a4c8a', 2, N'8a9993af-69b2-4d8a-85b3-337745a1f428', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'9fef22f9-1962-4cd0-84a6-ba85b9ce29c1', 1, N'B3BF41E1-0299-4EFE-BA76-A7377AC81B38', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011958 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'a8b2ff07-7af6-4e6a-8b9a-5785a25afe8c', 1, N'1F14A1ED-B22E-4E4A-BF10-6CF018507E76', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

print 'Processed 100 total records'
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'a8cf8cde-db46-4f5e-a3b2-883aef62ff7f', 1, N'252229DB-35CA-47AE-BDAE-C9903ED5BA7B', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011948 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'b10ca258-bd85-403c-aded-95b546fecaea', 1, N'ACDBD633-99A0-4BEF-B67C-3A5B41E7C1FD', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001195C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c0257ed1-eae3-4260-9633-0f53b0e3d106', 2, N'9FD543DB-C5BB-4789-ACFF-C5865AFB032C', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011951 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c2e04783-a45a-449d-9f7f-83d6a855ec22', 1, N'7858E329-16FC-49F4-93A1-11E2E7EF2998', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D00011959 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_RoleAuthorize] ([F_Id], [F_ItemType], [F_ItemId], [F_ObjectType], [F_ObjectId], [F_SortCode], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c2e7dba8-b103-4c63-a597-136110a89c7b', 2, N'e75e4efc-d461-4334-a764-56992fec38e6', 1, N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', NULL, CAST(0x0000A64D0001194E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'F0A2B36F-35A7-4660-B46C-D4AB796591EB', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'administrators', N'超级管理员', N'1', 1, 1, 1, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, CAST(0x0000A64D00011946 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4B2140D3-E61D-488E-ADF6-FF0EBCBC5D2C', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'system', N'系统管理员', N'1', 0, 0, 2, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'42C44AC0-27FA-482D-B5E3-8F9B38B80A6A', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'configuration', N'系统配置员', N'2', 0, 0, 3, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'7A9CF301-FCDF-4BC9-A52B-A7D4FAE2D344', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'developer', N'系统开发人员', N'2', 0, 0, 4, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2691AB91-3010-465F-8D92-60A97425A45E', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'innerStaff', N'内部员工', N'2', 0, 0, 5, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'41652BB4-E2DC-420E-AA8A-8C92784B76E3', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'archvist', N'档案管理员', N'2', 0, 0, 6, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'531F7D18-C49F-4F4F-A920-0074FCB52078', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'guest', N'访客人员', N'2', 0, 0, 7, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, CAST(0x0000A64D01032386 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2DA8390B-61A4-4E6C-A6E7-8F6794C7EDCE', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'tester', N'测试人员', N'2', 0, 0, 8, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'07A8E061-AE47-49C9-8310-F055F35FF44B', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'services', N'客服人员', N'2', 0, 0, 9, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'AADB479E-9F87-49B1-AE2D-5DA6FECA3F8E', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'implement', N'实施人员', N'2', 0, 0, 10, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'E5EA792F-915D-44BC-9F4F-EEDB26DE5DFD', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'IPQC', N'环保巡检员', N'2', 0, 0, 11, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8683CB17-5F9D-4A99-A233-A18C4D1CF95B', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'businessPersonnel', N'业务人员', N'2', 0, 0, 12, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'F68956A9-9C53-4C08-AFE8-8A4755FE2B8F', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'inventory', N'库存管理员', N'2', 0, 0, 13, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'F9421969-D85C-4E4C-927F-CCFB18388A59', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'contracts', N'合同专员', N'2', 0, 0, 14, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'59CEAE05-0FD4-4FD3-A755-A1DFA3803D2B', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 1, N'consumer', N'客户维护员', N'2', 0, 0, 15, 0, 1, NULL, CAST(0x0000A63F00000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'23ED024E-0AAA-4C8D-9216-D1AB93348D26', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'employee', N'员工', NULL, 0, 0, 1, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, CAST(0x0000A64700FC65A3 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'D335A5B8-7DED-495C-B8FC-EE933FB30779', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'charge', N'主管', NULL, 0, 0, 2, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, CAST(0x0000A64700FBF745 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0052A230-EA7B-4F3A-A1C9-1611FF26481A', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'manager', N'经理', NULL, NULL, NULL, 3, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'CEEA79E8-2E19-4294-8447-13247053DE04', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'director', N'总监', NULL, NULL, NULL, 4, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'EA56E457-5024-49AF-9410-D5D71D24F14B', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'vicegeneral', N'副总经理', NULL, NULL, NULL, 5, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'796E9C6A-8432-4BA6-8CF6-EFFAB6F2098C', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'general', N'总经理', NULL, NULL, NULL, 6, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'91E09653-D3DE-416A-BF6C-E91E60B4B4CF', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'chairman', N'主任', NULL, NULL, NULL, 7, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'C609D4D6-81F7-4647-BF2F-81BD4CED2C19', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'fileattache', N'档案专员', NULL, NULL, NULL, 8, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'F03EA699-9A0A-4EE9-9D33-27B9A7DFF09B', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'engineer', N'高级工程师', NULL, NULL, NULL, 9, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0CD2A952-2EE0-4CAF-9757-617D5075745B', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'president', N'董事长', NULL, NULL, NULL, 10, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'B2624F67-E092-461A-AAAD-13592A9429D9', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'10018', N'行政助理', NULL, NULL, NULL, 11, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3263446A-D303-4C42-B436-6F46BF7CE86A', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'10019', N'总裁', NULL, NULL, NULL, 12, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'CB116AA3-88CC-4CF7-B0BC-7C55EC502183', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'10020', N'首席执行官', NULL, NULL, NULL, 13, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'7E2639BA-02B9-417A-9AAA-CF6DCF8487E0', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'10022', N'力资源专员', NULL, NULL, NULL, 14, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2B3406F9-B7FF-4D23-BC61-D8EEB6C88D5B', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'10023', N'行业顾问', NULL, NULL, NULL, 15, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'05691457-5284-4FEE-8D7E-C35141F3FF39', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'10024', N'总经理助理', NULL, NULL, NULL, 16, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Role] ([F_Id], [F_OrganizeId], [F_Category], [F_EnCode], [F_FullName], [F_Type], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3A2FD4D7-E73C-44E4-8AED-B6EE5980779E', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'10025', N'大堂经理', NULL, NULL, NULL, 17, 0, 1, NULL, CAST(0x0000A64100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'5AB270C0-5D33-4203-A54F-4552699FDA3C', N'0', 1, N'Company', N'上海东鞋贸易有限公司', NULL, N'Company', N'郭总', NULL, NULL, NULL, NULL, NULL, NULL, N'上海市松江区', NULL, NULL, 1, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'80E10CD5-7591-40B8-A005-BCDE1B961E76', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'Administration ', N'行政部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'5B417E2B-4B96-4F37-8BAA-10E5A812D05E', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'Market', N'市场部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'F02A66CA-3D8B-491B-8A17-C9ACA3E3B5DD', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'Financial', N'财务部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'554C61CE-6AE0-44EB-B33D-A462BE7EB3E1', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'Ministry', N'技术部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'BD830AEF-0A2E-4228-ACF8-8843C39D41D8', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'Purchase', N'采购部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'253EDA1F-F158-4F3F-A778-B7E538E052A2', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'Manufacturing', N'生产部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'DFA2FB91-C909-44A3-9282-BF946102E1C9', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'HumanResourse', N'人事部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Organize] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_ShortName], [F_CategoryId], [F_ManagerId], [F_TelePhone], [F_MobilePhone], [F_WeChat], [F_Fax], [F_Email], [F_AreaId], [F_Address], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'59703D6A-0EC9-4762-824F-A8D9E62E93D2', N'5AB270C0-5D33-4203-A54F-4552699FDA3C', 2, N'Sales', N'营销部', NULL, N'Department', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 0, 1, NULL, CAST(0x0000A62100000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9FD543DB-C5BB-4789-ACFF-C5865AFB032C', N'64A1C550-2C61-4A8C-833D-ACD0C012260F', N'0', 1, N'NF-add', N'新增菜单', NULL, 1, N'btn_add()', N'/SystemManage/Module/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01027E86 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'E29FCBA7-F848-4A8B-BC41-A3C668A9005D', N'64A1C550-2C61-4A8C-833D-ACD0C012260F', N'0', 1, N'NF-edit', N'修改菜单', NULL, 2, N'btn_edit()', N'/SystemManage/Module/Form', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01027772 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'85F5212F-E321-4124-B155-9374AA5D9C10', N'64A1C550-2C61-4A8C-833D-ACD0C012260F', N'0', 1, N'NF-delete', N'删除菜单', NULL, 2, N'btn_delete()', N'/SystemManage/Module/DeleteForm', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E0102867A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'D4FCAFED-7640-449E-80B7-622DDACD5012', N'64A1C550-2C61-4A8C-833D-ACD0C012260F', N'0', 1, N'NF-Details', N'查看菜单', NULL, 2, N'btn_details()', N'/SystemManage/Module/Details', 1, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E0102946D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'FD3D073C-4F88-467A-AE3B-CDD060952CE6', N'64A1C550-2C61-4A8C-833D-ACD0C012260F', N'0', 1, N'NF-modulebutton', N'按钮管理', NULL, 2, N'btn_modulebutton()', N'/SystemManage/ModuleButton/Index', 0, 0, NULL, NULL, 5, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4bb19533-8e81-419b-86a1-7ee56bf1dd45', N'252229DB-35CA-47AE-BDAE-C9903ED5BA7B', N'0', 1, N'NF-delete', N'删除机构', NULL, 2, N'btn_delete()', N'/SystemManage/Organize/DeleteForm', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'709a4a7b-4d98-462d-b47c-351ef11db06f', N'252229DB-35CA-47AE-BDAE-C9903ED5BA7B', N'0', 1, N'NF-Details', N'查看机构', NULL, 2, N'btn_details()', N'/SystemManage/Organize/Details', 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'91be873e-ccb7-434f-9a3b-d312d6d5798a', N'252229DB-35CA-47AE-BDAE-C9903ED5BA7B', N'0', 1, N'NF-edit', N'修改机构', NULL, 2, N'btn_edit()', N'/SystemManage/Organize/Form', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'cd65e50a-0bea-45a9-b82e-f2eacdbd209e', N'252229DB-35CA-47AE-BDAE-C9903ED5BA7B', N'0', 1, N'NF-add', N'新建机构', NULL, 1, N'btn_add()', N'/SystemManage/Organize/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'239077ff-13e1-4720-84e1-67b6f0276979', N'91A6CFAD-B2F9-4294-BDAE-76DECF412C6C', N'0', 1, N'NF-delete', N'删除角色', NULL, 2, N'btn_delete()', N'/SystemManage/Role/DeleteForm', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'5d708d9d-6ebe-40ea-8589-e3efce9e74ec', N'91A6CFAD-B2F9-4294-BDAE-76DECF412C6C', N'0', 1, N'NF-add', N'新建角色', NULL, 1, N'btn_add()', N'/SystemManage/Role/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f93763ff-51a1-478d-9585-3c86084c54f3', N'91A6CFAD-B2F9-4294-BDAE-76DECF412C6C', N'0', 1, N'NF-Details', N'查看角色', NULL, 2, N'btn_details()', N'/SystemManage/Role/Details', 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ffffe7f8-900c-413a-9970-bee7d6599cce', N'91A6CFAD-B2F9-4294-BDAE-76DECF412C6C', N'0', 1, N'NF-edit', N'修改角色', NULL, 2, N'btn_edit()', N'/SystemManage/Role/Form', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'13c9a15f-c50d-4f09-8344-fd0050f70086', N'F298F868-B689-4982-8C8B-9268CBF0308D', N'0', 1, N'NF-add', N'新建岗位', NULL, 1, N'btn_add()', N'/SystemManage/Duty/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'88f7b3a8-fd6d-4f8e-a861-11405f434868', N'F298F868-B689-4982-8C8B-9268CBF0308D', N'0', 1, N'NF-Details', N'查看岗位', NULL, 2, N'btn_details()', N'/SystemManage/Duty/Details', 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8a9993af-69b2-4d8a-85b3-337745a1f428', N'F298F868-B689-4982-8C8B-9268CBF0308D', N'0', 1, N'NF-delete', N'删除岗位', NULL, 2, N'btn_delete()', N'/SystemManage/Duty/DeleteForm', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e75e4efc-d461-4334-a764-56992fec38e6', N'F298F868-B689-4982-8C8B-9268CBF0308D', N'0', 1, N'NF-edit', N'修改岗位', NULL, 2, N'btn_edit()', N'/SystemManage/Duty/Form', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'14617a4f-bfef-4bc2-b943-d18d3ff8d22f', N'38CA5A66-C993-4410-AF95-50489B22939C', N'0', 1, N'NF-delete', N'删除用户', NULL, 2, N'btn_delete()', N'/SystemManage/User/DeleteForm', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E00EB2BC2 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4727adf7-5525-4c8c-9de5-39e49c268349', N'38CA5A66-C993-4410-AF95-50489B22939C', N'0', 1, N'NF-edit', N'修改用户', NULL, 2, N'btn_edit()', N'/SystemManage/User/Form', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E00EB1D4C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'74eecdfb-3bee-405d-be07-27a78219c179', N'38CA5A66-C993-4410-AF95-50489B22939C', N'0', 1, N'NF-add', N'新建用户', NULL, 1, N'btn_add()', N'/SystemManage/User/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E00EB0788 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'abfdff21-8ebf-4024-8555-401b4df6acd9', N'38CA5A66-C993-4410-AF95-50489B22939C', N'0', 1, N'NF-Details', N'查看用户', NULL, 2, N'btn_details()', N'/SystemManage/User/Details', 1, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E00FF345D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'38e39592-6e86-42fb-8f72-adea0c82cbc1', N'38CA5A66-C993-4410-AF95-50489B22939C', N'0', NULL, N'NF-revisepassword', N'密码重置', NULL, 2, N'btn_revisepassword()', N'/SystemManage/User/RevisePassword', 1, 0, 0, 0, 5, NULL, 1, NULL, CAST(0x0000A64E00EBBF7E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'15362a59-b242-494a-bc6e-413b4a63580e', N'38CA5A66-C993-4410-AF95-50489B22939C', N'0', NULL, N'NF-disabled', N'禁用', NULL, 2, N'btn_disabled()', N'/SystemManage/User/DisabledAccount', 0, 0, 0, 0, 6, NULL, 1, NULL, CAST(0x0000A64E00FE4EE8 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', CAST(0x0000A64E00FF08B4 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2a8f5342-5eb7-491c-a1a9-a2631d8eb5d6', N'38CA5A66-C993-4410-AF95-50489B22939C', N'0', NULL, N'NF-enabled', N'启用', NULL, 2, N'btn_enabled()', N'/SystemManage/User/EnabledAccount', 0, 0, 0, 0, 7, NULL, 1, NULL, CAST(0x0000A64E00FEEC37 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'48afe7b3-e158-4256-b50c-cd0ee7c6dcc9', N'337A4661-99A5-4E5E-B028-861CACAF9917', N'0', 1, N'NF-add', N'新建区域', NULL, 1, N'btn_add()', N'/SystemManage/Area/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01001A9F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'89d7a69d-b953-4ce2-9294-db4f50f2a157', N'337A4661-99A5-4E5E-B028-861CACAF9917', N'0', 1, N'NF-edit', N'修改区域', NULL, 2, N'btn_edit()', N'/SystemManage/Area/Form', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01002C82 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8c7013a9-3682-4367-8bc6-c77ca89f346b', N'337A4661-99A5-4E5E-B028-861CACAF9917', N'0', 1, N'NF-delete', N'删除区域', NULL, 2, N'btn_delete()', N'/SystemManage/Area/DeleteForm', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01003A73 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0d777b07-041a-4205-a393-d1a009aaafc7', N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', N'0', 1, N'NF-edit', N'修改字典', NULL, 2, N'btn_edit()', N'/SystemManage/ItemsData/Form', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01018CE3 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'104bcc01-0cfd-433f-87f4-29a8a3efb313', N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', N'0', 1, N'NF-add', N'新建字典', NULL, 1, N'btn_add()', N'/SystemManage/ItemsData/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E010183EE AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'1ee1c46b-e767-4532-8636-936ea4c12003', N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', N'0', 1, N'NF-delete', N'删除字典', NULL, 2, N'btn_delete()', N'/SystemManage/ItemsData/DeleteForm', 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E0101991F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'82f162cb-beb9-4a79-8924-cd1860e26e2e', N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', N'0', 1, N'NF-Details', N'查看字典', NULL, 2, N'btn_details()', N'/SystemManage/ItemsData/Details', 0, 0, 0, 0, 5, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E0101A11D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4b876abc-1b85-47b0-abc7-96e313b18ed8', N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', N'0', NULL, N'NF-itemstype', N'分类管理', NULL, 1, N'btn_itemstype()', N'/SystemManage/ItemsType/Index', 0, 0, 0, 0, 2, NULL, 1, NULL, CAST(0x0000A64E01012D73 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0f0596f6-aa50-4df0-ad8e-af867cb4a9de', N'e72c75d0-3a69-41ad-b220-13c9a62ec788', N'0', 1, N'NF-delete', N'删除备份', NULL, 2, N'btn_delete()', N'/SystemSecurity/DbBackup/DeleteForm', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01045132 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'41862743-f703-4b6d-be54-08d253eb0ebc', N'e72c75d0-3a69-41ad-b220-13c9a62ec788', N'0', 1, N'NF-add', N'新建备份', NULL, 1, N'btn_add()', N'/SystemSecurity/DbBackup/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E010312F0 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'aed66cfb-d78e-43d4-9987-c714546be7eb', N'e72c75d0-3a69-41ad-b220-13c9a62ec788', N'0', 1, N'NF-download', N'下载备份', NULL, 2, N'btn_download()', N'/SystemSecurity/DbBackup/DownloadBackup', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E0104743B AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'329c0326-ce68-4a24-904d-aade67a90fc7', N'a3a4742d-ca39-42ec-b95a-8552a6fae579', N'0', 1, N'NF-Details', N'查看策略', NULL, 2, N'btn_details()', N'/SystemSecurity/FilterIP/Details', 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E0107245F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8379135e-5b13-4236-bfb1-9289e6129034', N'a3a4742d-ca39-42ec-b95a-8552a6fae579', N'0', 1, N'NF-delete', N'删除策略', NULL, 2, N'btn_delete()', N'/SystemSecurity/FilterIP/DeleteForm', 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01071C1E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'aaf58c1b-4af2-4e5f-a3e4-c48e86378191', N'a3a4742d-ca39-42ec-b95a-8552a6fae579', N'0', 1, N'NF-edit', N'修改策略', NULL, 2, N'btn_edit()', N'/SystemSecurity/FilterIP/Form', 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01071360 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'd4074121-0d4f-465e-ad37-409bbe15bf8a', N'a3a4742d-ca39-42ec-b95a-8552a6fae579', N'0', 1, N'NF-add', N'新建策略', NULL, 1, N'btn_add()', N'/SystemSecurity/FilterIP/Form', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E010708F8 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_ModuleButton] ([F_Id], [F_ModuleId], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_Location], [F_JsEvent], [F_UrlAddress], [F_Split], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3a35c662-a356-45e4-953d-00ebd981cad6', N'96EE855E-8CD2-47FC-A51D-127C131C9FB9', N'0', 1, N'NF-removelog', N'清空日志', NULL, 1, N'btn_removeLog()', N'/SystemSecurity/Log/RemoveLog', 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64E01088E16 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e72c75d0-3a69-41ad-b220-13c9a62ec788', N'73FD1267-79BA-4E23-A152-744AF73117E9', NULL, NULL, N'数据备份', NULL, N'/SystemSecurity/DbBackup/Index', N'iframe', 1, 0, 0, 0, 0, 1, NULL, 1, NULL, CAST(0x0000A646016BF4C7 AS DateTime), NULL, CAST(0x0000A649010BFA69 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'462027E0-0848-41DD-BCC3-025DCAE65555', N'0', 1, NULL, N'系统管理', N'fa fa-gears', NULL, N'expand', 0, 1, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B010409F6 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'73FD1267-79BA-4E23-A152-744AF73117E9', N'0', 1, NULL, N'系统安全', N'fa fa-desktop', NULL, N'expand', 0, 1, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B0104154A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', N'0', 1, NULL, N'统计报表', N'fa fa-bar-chart-o', N'fa fa-bar-chart-o', N'expand', 0, 1, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B010425ED AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9F56840F-DF92-4936-A48C-8F65A39291A2', N'0', 1, NULL, N'常用示例', N'fa fa-tags', NULL, N'expand', 0, 1, 0, 0, 0, 5, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B01043548 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a3a4742d-ca39-42ec-b95a-8552a6fae579', N'73FD1267-79BA-4E23-A152-744AF73117E9', NULL, NULL, N'访问控制', NULL, N'/SystemSecurity/FilterIP/Index', N'iframe', 1, 0, 0, 0, 0, 2, NULL, 1, NULL, CAST(0x0000A646016C3EB0 AS DateTime), NULL, CAST(0x0000A649010C141D AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'64A1C550-2C61-4A8C-833D-ACD0C012260F', N'462027E0-0848-41DD-BCC3-025DCAE65555', 2, NULL, N'系统菜单', NULL, N'/SystemManage/Module/Index', N'iframe', 1, 0, 0, 0, 0, 7, 0, 1, N'测试', NULL, NULL, CAST(0x0000A65000B291CC AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'38CA5A66-C993-4410-AF95-50489B22939C', N'462027E0-0848-41DD-BCC3-025DCAE65555', 2, NULL, N'用户管理', NULL, N'/SystemManage/User/Index', N'iframe', 1, 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A643010DEE59 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'252229DB-35CA-47AE-BDAE-C9903ED5BA7B', N'462027E0-0848-41DD-BCC3-025DCAE65555', 2, NULL, N'机构管理', NULL, N'/SystemManage/Organize/Index', N'iframe', 1, 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64401705686 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'91A6CFAD-B2F9-4294-BDAE-76DECF412C6C', N'462027E0-0848-41DD-BCC3-025DCAE65555', 2, NULL, N'角色管理', NULL, N'/SystemManage/Role/Index', N'iframe', 1, 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A643010DE052 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'337A4661-99A5-4E5E-B028-861CACAF9917', N'462027E0-0848-41DD-BCC3-025DCAE65555', 2, NULL, N'区域管理', NULL, N'/SystemManage/Area/Index', N'iframe', 1, 0, 0, 0, 0, 5, 0, 1, NULL, NULL, NULL, CAST(0x0000A643010DA7EE AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'423A200B-FA5F-4B29-B7B7-A3F5474B725F', N'462027E0-0848-41DD-BCC3-025DCAE65555', 2, NULL, N'数据字典', NULL, N'/SystemManage/ItemsData/Index', N'iframe', 1, 0, 0, 0, 0, 6, 0, 1, NULL, NULL, NULL, CAST(0x0000A6440171B901 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'F298F868-B689-4982-8C8B-9268CBF0308D', N'462027E0-0848-41DD-BCC3-025DCAE65555', 2, NULL, N'岗位管理', NULL, N'/SystemManage/Duty/Index', N'iframe', 1, 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A643010DE701 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'96EE855E-8CD2-47FC-A51D-127C131C9FB9', N'73FD1267-79BA-4E23-A152-744AF73117E9', 2, NULL, N'系统日志', NULL, N'/SystemSecurity/Log/Index', N'iframe', 1, 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A649010C27B8 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'df9920e0-ba33-4e36-a911-ef08c6ea77ea', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'饼图', NULL, N'/ReportManage/Highcharts/Sample7', N'iframe', 1, 0, 0, 0, 0, 12, NULL, 1, NULL, CAST(0x0000A649011BDF34 AS DateTime), NULL, CAST(0x0000A64B0103B959 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3A95BBC6-CB5B-4438-869F-5F7B738E2568', NULL, NULL, NULL, N'散点图', NULL, NULL, N'iframe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'49F61713-C1E4-420E-BEEC-0B4DBC2D7DE8', N'73FD1267-79BA-4E23-A152-744AF73117E9', 2, NULL, N'服务器监控', NULL, N'/SystemSecurity/ServerMonitoring/Index', N'iframe', 1, 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A649010C3DD5 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'F2DAD50B-95DF-48F7-8638-BA503B539143', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', 2, NULL, N'折线图', NULL, N'/ReportManage/Highcharts/Sample1', N'iframe', 1, 0, 0, 0, 0, 1, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B01044D25 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0EDF1DDB-CA17-4D08-AA25-914FE4E13324', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', 2, NULL, N'曲线图', NULL, N'/ReportManage/Highcharts/Sample2', N'iframe', 1, 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B010395A3 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'AD4BC418-B66E-48C7-BC13-81590056CD15', NULL, NULL, NULL, N'气泡图', NULL, NULL, N'iframe', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'C3D12056-D906-4D8B-8B9C-954942742BDE', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', 2, NULL, N'面积图', NULL, N'/ReportManage/Highcharts/Sample3', N'iframe', 1, 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B01039C70 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'B3BF41E1-0299-4EFE-BA76-A7377AC81B38', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', 2, NULL, N'柱状图', NULL, N'/ReportManage/Highcharts/Sample4', N'iframe', 1, 0, 0, 0, 0, 5, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B0103A3C1 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'85FAF4F4-9CBE-4904-94B3-2B930CA49F0C', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', 2, NULL, N'综合报表1', NULL, N'/ReportManage/Highcharts/Sample14', N'iframe', 1, 0, 0, 0, 0, 21, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B0103EDAE AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'6BBC3562-1051-4246-98B0-9F37CAC40DC8', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', 2, NULL, N'综合报表2', NULL, N'/ReportManage/Highcharts/Sample15', N'iframe', 1, 0, 0, 0, 0, 22, 0, 1, NULL, NULL, NULL, CAST(0x0000A64B01046635 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'822E2523-5105-4AE0-BF48-62459D3641F6', N'9F56840F-DF92-4936-A48C-8F65A39291A2', 2, NULL, N'外部邮件', NULL, N'/ExampleManage/SendMail/Index', N'iframe', 1, 0, 0, 0, 0, 2, 0, 1, NULL, NULL, NULL, CAST(0x0000A655012FB531 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'7B959522-BE45-4747-B89D-592C7F3987A5', N'9F56840F-DF92-4936-A48C-8F65A39291A2', 2, NULL, N'短信工具', NULL, N'/ExampleManage/SendMessages/Index', N'iframe', 1, 0, 0, 0, 0, 3, 0, 1, NULL, NULL, NULL, CAST(0x0000A655017D63D3 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'AF34B824-439E-4365-99CC-C1D30514D869', N'9F56840F-DF92-4936-A48C-8F65A39291A2', 2, NULL, N'二维码生成', NULL, N'/ExampleManage/BarCode/Index', N'iframe', 1, 0, 0, 0, 0, 4, 0, 1, NULL, NULL, NULL, CAST(0x0000A65501805B13 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'D2ECB516-4CB7-49B1-B536-504382115DD2', N'9F56840F-DF92-4936-A48C-8F65A39291A2', 2, NULL, N'打印测试', NULL, N'/ExampleManage/Print/Index', N'iframe', 1, 0, 0, 0, 0, 5, 0, 1, NULL, NULL, NULL, CAST(0x0000A65700ED716B AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'39E97B05-7B6F-4069-9972-6F9643BC3042', N'9F56840F-DF92-4936-A48C-8F65A39291A2', 2, NULL, N'电子签章', NULL, N'/ExampleManage/Signet/Index', N'iframe', 1, 0, 0, 0, 0, 6, 0, 1, NULL, NULL, NULL, CAST(0x0000A6560176406A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'91425AF9-F762-43AF-B784-107D23FFDC85', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'模拟时钟', NULL, N'/ReportManage/Highcharts/Sample5', N'iframe', 1, 0, 0, 0, 0, 11, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103AB64 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'7858E329-16FC-49F4-93A1-11E2E7EF2998', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'仪表盘', NULL, N'/ReportManage/Highcharts/Sample6', N'iframe', 1, 0, 0, 0, 0, 12, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103B289 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'163DA347-887C-4C91-8298-EB00FFBFEC84', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'雷达图', NULL, N'/ReportManage/Highcharts/Sample8', N'iframe', 1, 0, 0, 0, 0, 13, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103C036 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'1F14A1ED-B22E-4E4A-BF10-6CF018507E76', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'蛛网图', NULL, N'/ReportManage/Highcharts/Sample9', N'iframe', 1, 0, 0, 0, 0, 14, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103C810 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'FE04386D-1307-4E34-8DFB-B56D9FEC78CE', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'玫瑰图', NULL, N'/ReportManage/Highcharts/Sample10', N'iframe', 1, 0, 0, 0, 0, 15, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103CFCE AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'54E9D12D-C039-4F01-A6FE-810A147D31D5', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'漏斗图', NULL, N'/ReportManage/Highcharts/Sample11', N'iframe', 1, 0, 0, 0, 0, 16, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103D7E2 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ACDBD633-99A0-4BEF-B67C-3A5B41E7C1FD', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'蜡烛图', NULL, N'/ReportManage/Highcharts/Sample12', N'iframe', 1, 0, 0, 0, 0, 17, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103DE93 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

INSERT [dbo].[Sys_Module] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_Icon], [F_UrlAddress], [F_Target], [F_IsMenu], [F_IsExpand], [F_IsPublic], [F_AllowEdit], [F_AllowDelete], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'A33ADBFC-089B-4981-BFAB-08178052EE36', N'51174D27-3001-4CCF-AAB2-0AA2A6CEAA50', NULL, NULL, N'流程图', NULL, N'/ReportManage/Highcharts/Sample13', N'iframe', 1, 0, 0, 0, 0, 18, NULL, 0, NULL, NULL, NULL, CAST(0x0000A64B0103E601 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba', NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'8d506220-3694-4877-ba40-2fcb108883f2', CAST(0x0000A64F009F6F33 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A64F009F6F7B AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'daa0254e-381a-4d15-a051-788a9d31f5f1', CAST(0x0000A64F00C1647B AS DateTime), N'admin', N'超级管理员', N'Exit', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'安全退出系统', CAST(0x0000A64F00C164D3 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1af7414a-5ce3-4a3a-b937-db4fd45349e4', CAST(0x0000A64F00C16EEF AS DateTime), N'1010', N'白玉芬', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A64F00C16F2A AS DateTime), N'6903ab9d-20cd-44c4-a380-09f229366e1f')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'bd83b3c1-ff1c-4da1-813f-e5183d62271c', CAST(0x0000A64F00E63063 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A64F00E632FA AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'bf57fda2-656e-47d4-a11e-4a94c041b5a4', CAST(0x0000A64F00E67E99 AS DateTime), N'admin', N'超级管理员', N'Exit', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'安全退出系统', CAST(0x0000A64F00E67ED2 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'399f2844-15f9-4a03-8af6-88afb4deea3c', CAST(0x0000A64F00E6882F AS DateTime), N'1010', N'1010', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A64F00E68958 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3b5ac284-6cae-41c6-9728-7baed0e04e2e', CAST(0x0000A64F00E68F77 AS DateTime), N'1010', N'白玉芬', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A64F00E68FB9 AS DateTime), N'6903ab9d-20cd-44c4-a380-09f229366e1f')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'140d26c9-5210-443a-9c27-926c525a7043', CAST(0x0000A64F00F0923B AS DateTime), N'1010', N'白玉芬', N'Exit', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'安全退出系统', CAST(0x0000A64F00F09286 AS DateTime), N'6903ab9d-20cd-44c4-a380-09f229366e1f')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'a1f7e069-2d53-4fa5-b5f6-6ed5456c4c49', CAST(0x0000A64F00F09EA5 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A64F00F09F00 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'8ce34a97-2d6c-49a0-9917-46d0ce28f109', CAST(0x0000A64F0101A8CD AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A64F0101A90E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c4f2f41e-24ab-4990-a410-8a97f8d28a6c', CAST(0x0000A650009A5222 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A650009A5264 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'50a1606a-e447-4e30-ac55-598e15e2ef17', CAST(0x0000A65000F46AE5 AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65000F46F61 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c808ca13-db6a-457a-934c-906593aa4c82', CAST(0x0000A65000F4BD76 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65000F4BDBF AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'47a5b8a2-7202-41b7-b579-0829119a5963', CAST(0x0000A6500100186B AS DateTime), N'11', N'11', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65001001959 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'666430b7-4ba9-4f01-8652-cec61e122612', CAST(0x0000A65001213AED AS DateTime), N'1010', N'1010', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65001213BE1 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'59574150-5a6a-4aa9-aadc-0778e679624e', CAST(0x0000A65001215A2D AS DateTime), N'1010', N'白玉芬', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65001215A6E AS DateTime), N'6903ab9d-20cd-44c4-a380-09f229366e1f')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'027df934-1d3b-491d-a986-197998aeb108', CAST(0x0000A65100B57FB1 AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65100B580C4 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'54e6c128-4cc9-41dd-8048-f90024f30722', CAST(0x0000A65100B5A063 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65100B5A1DA AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c85da717-2d15-45b4-ad4f-1dd91053e71f', CAST(0x0000A65100C5BAFE AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65100C5BB46 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'f3ec0624-9484-4c8c-abad-b37328b1acea', CAST(0x0000A65100F2674D AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65100F26795 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'178c149d-dd35-4e4a-b067-e9f764b8fd0a', CAST(0x0000A65100FF609B AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65100FF60D9 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c1c946e3-06cf-4fe8-8db0-43b346d0ce7b', CAST(0x0000A6510110380C AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65101103846 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'a7bee54f-26db-4c6f-a7df-bf1588046fe2', CAST(0x0000A65200C12C77 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65200C12CBA AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'20e55b31-0ebf-402e-b017-b05656b7f736', CAST(0x0000A65200C37CF6 AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65200C37D3E AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'0601f1be-1828-4da8-bd3b-8bd650609f77', CAST(0x0000A65200C38497 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65200C384CF AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4069e54e-0b54-48c6-873e-d040a78e273f', CAST(0x0000A655009A2A1C AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A655009A2A5E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'f04d33c6-52b3-4dad-8ff7-f94ba4a5cc3b', CAST(0x0000A65500B13D85 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65500B13DCB AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'b2e62a09-835d-45ac-b724-f9d92050bb18', CAST(0x0000A65500BEB639 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65500BEB67E AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2e0ce39b-d07a-418c-be28-ac60b1689261', CAST(0x0000A65500E90726 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65500E9076A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'0b8c1d55-c34a-48e0-963d-345c4fd87a2c', CAST(0x0000A65500FFEFFF AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65500FFF05C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3e49d705-8bec-4a23-bb55-07d48150c0ed', CAST(0x0000A6550111FC11 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A6550111FC7A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4ba02c37-2f70-4ffc-b543-56a21c1566a1', CAST(0x0000A6550122E9E4 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A6550122EA54 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4f2043b3-beb2-4fd8-ae36-7e4c203ca3d4', CAST(0x0000A6550140B9B9 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A6550140BA25 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ddf6a75c-920b-4ae2-9ae9-1f3c34cee1b2', CAST(0x0000A655017D2A24 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A655017D2CD8 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2635f787-a71c-40d3-ae14-6030cf017df7', CAST(0x0000A6560098C6C7 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A6560098CCED AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ebf1465f-852b-44f9-bd01-39c96e3c59b3', CAST(0x0000A656010C39F3 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A656010C3A2F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'b8ec2d1e-a5f1-4de9-8bba-487a100d3d9c', CAST(0x0000A656017614E7 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A6560176152A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'65bb9c29-109e-4bbb-b1a8-ff6cbabe3070', CAST(0x0000A6570098513F AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65700985265 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'75b69900-aace-474c-9851-4d31abdbf9e3', CAST(0x0000A65700A053D1 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65700A05412 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ded0976f-6419-46e5-b951-1db0e250e5e4', CAST(0x0000A65700E490A2 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65700E490E4 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'8f213bc7-9a99-4485-92e9-48c84c345159', CAST(0x0000A65700F63E78 AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65700F63F46 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4f616240-5613-499b-b06c-6f35a79a5dc1', CAST(0x0000A65700F6C4AD AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65700F6C8E4 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ad0e7547-796f-4999-a590-a85ba1fd94ca', CAST(0x0000A64E01229117 AS DateTime), N'1010', N'白玉芬', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A64E01229150 AS DateTime), N'6903ab9d-20cd-44c4-a380-09f229366e1f')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'8f050437-5b07-4e20-b223-c6c28ddd1a10', CAST(0x0000A65700FA8965 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65700FA89A1 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'4afbdfa9-a639-41f5-9ee7-2a447a4c82f1', CAST(0x0000A6570116DE3F AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A6570116DE81 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'fb3ca457-5889-4a19-9bfb-0fb5f270275a', CAST(0x0000A657011ED674 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A657011ED6B6 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'51dab93c-cc01-44a2-83bd-5bc02d900659', CAST(0x0000A6570126D4D9 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A6570126D51D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'af760450-5e6b-4a02-95cd-441d2b58d71e', CAST(0x0000A657017A003D AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A657017A0084 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'fd9bdf4c-643c-4fa2-bc65-9b487f89f33c', CAST(0x0000A658011E8FFD AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A658011E9042 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'79f282e7-93b0-48ee-8d2f-2fd658b95393', CAST(0x0000A65901116A10 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65901116A52 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2b314b02-fc92-44f6-bbde-262d21a801eb', CAST(0x0000A65901858310 AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A6590185842A AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'0f970678-f504-4e82-b17d-e053936e4be6', CAST(0x0000A65901859B73 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65901859BB8 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'5caaf40e-b2ca-41a0-8c7e-e63d853327dc', CAST(0x0000A65B00E536C1 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65B00E53706 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1857f26a-f794-487a-9082-4c38999fce93', CAST(0x0000A65B00E62B20 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65B00E62B5C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'cc96267d-d96f-4da3-8af6-ff9d1e325fe2', CAST(0x0000A65C00FC9D4B AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65C00FC9ED5 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'd5f87bc4-0664-4e16-8296-cde87b6998f1', CAST(0x0000A65C00FCB0A8 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65C00FCB0E8 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'e6399380-6c32-43a4-9961-620ecb02d357', CAST(0x0000A65C010E5DC2 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65C010E5E03 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'6abf9b7a-5e6c-49c5-b57c-d66919e1b3fc', CAST(0x0000A65C0112263B AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65C01122681 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'43a97eeb-5551-4fd9-b47c-ae6d9205d405', CAST(0x0000A65D00FAC1F7 AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A65D00FAC586 AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'ad7572dc-711b-4e58-b585-008622a660be', CAST(0x0000A65D00FADD68 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65D00FADDAD AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'651c6b3f-9014-4fdb-b98c-20041caa59bc', CAST(0x0000A65D01248AB3 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65D0124915D AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'054de494-b7a1-4ce7-83f7-c8a9c5d28b74', CAST(0x0000A65E00A5AE7D AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65E00A5AEC8 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'a350a669-965a-4d16-b02c-4216efdf7454', CAST(0x0000A65E00AD250D AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65E00AD2548 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'76013c76-e53e-49ef-a30d-751a74d8320d', CAST(0x0000A65E00E9F7E5 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65E00E9F826 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c96cc2cc-cae4-40ac-a616-a711286a154a', CAST(0x0000A65E012B134C AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A65E012B1390 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'b866efe6-e1c0-4caa-ae30-89809f648e4f', CAST(0x0000A66000A808A1 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66000A808E3 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'de104d66-de2b-43ed-812a-556ed1885cb8', CAST(0x0000A66000AC7F5E AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66000AC7FAB AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'922bf293-c03d-4dc7-8216-e59e7ec234b4', CAST(0x0000A66000ADCB1B AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66000ADCB5C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3b1881a7-8693-4628-87c3-da31c3d0cda0', CAST(0x0000A66000AF061F AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A66000AF0729 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c2d23920-7c7c-4b89-9199-af89046d0642', CAST(0x0000A66000B03A29 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66000B03A84 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'1da960da-0905-4fff-aaaf-938904291cce', CAST(0x0000A66000BAB93D AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66000BAB97F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'797acebe-9b59-48ec-9218-5179d5bd0099', CAST(0x0000A66000DE1F9F AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66000DE1FE1 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'c63d5565-88a8-4b6d-adda-963feb22fcaf', CAST(0x0000A66000E563DE AS DateTime), N'System', N'System', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，账户不存在，请重新输入', CAST(0x0000A66000E5648B AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3bd97970-6f29-4be4-ac3c-c8ada98d953a', CAST(0x0000A66000E56F79 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66000E56FB3 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'f59c9a1d-d5cf-4b11-a2ff-75580a6b2a76', CAST(0x0000A66001036F79 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66001036F96 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3d49e69c-e3d5-4d86-8bf7-187e8ffd92f9', CAST(0x0000A660012717EB AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66001271806 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'fa4f8115-2999-42e0-b773-328cdda47a61', CAST(0x0000A660012960A8 AS DateTime), N'admin', N'超级管理员', N'Exit', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'安全退出系统', CAST(0x0000A660012960D2 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'77732c5c-a8f3-4c29-8916-14f6a0f443b2', CAST(0x0000A660012DB55D AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A660012DB5C2 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'7be702ba-7442-4447-be5d-d5161c310526', CAST(0x0000A660012DC3EE AS DateTime), N'admin', N'超级管理员', N'Exit', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'安全退出系统', CAST(0x0000A660012DC449 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'79c111e7-22bf-4e0f-9f8d-52334b6bfb75', CAST(0x0000A660012DD2A7 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A660012DD301 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'3a9d5646-f406-4e38-b7d1-a1c9dd0da452', CAST(0x0000A66300AF7412 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66300AF742F AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'2a5aae0a-3115-4005-8780-a3fc2ab5214d', CAST(0x0000A66300BE424F AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A66300BE4309 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'e0f2f493-f01b-43b3-ac52-352ae6641121', CAST(0x0000A66300C530A5 AS DateTime), N'admin', N'admin', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 0, N'登录失败，验证码错误，请重新输入', CAST(0x0000A66300C530DD AS DateTime), NULL)
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'6265b9ee-e4b1-4d68-809a-f61c5153879e', CAST(0x0000A66300C5553F AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66300C55555 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'301aa067-cc90-4d21-8971-f8c8b5704699', CAST(0x0000A66301879189 AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A663018791B1 AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'e8f4dc3d-4647-4508-af36-6759f29b2fad', CAST(0x0000A66400986E7C AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66400986E9A AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

INSERT [dbo].[Sys_Log] ([F_Id], [F_Date], [F_Account], [F_NickName], [F_Type], [F_IPAddress], [F_IPAddressName], [F_ModuleId], [F_ModuleName], [F_Result], [F_Description], [F_CreatorTime], [F_CreatorUserId]) VALUES (N'66102d61-8116-4013-ae09-2ab7c28222be', CAST(0x0000A66400AE836B AS DateTime), N'admin', N'超级管理员', N'Login', N'117.81.192.182', N'江苏省苏州市 电信', NULL, N'系统登录', 1, N'登录成功', CAST(0x0000A66400AE838C AS DateTime), N'9f2ec079-7d0f-4fe2-90ab-8b09a8302aba')
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'B97BD7F5-B212-40C1-A1F7-DD9A2E63EEF2', N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', NULL, N'Group', N'集团', NULL, NULL, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2C3715AC-16F7-48FC-AB40-B0931DB1E729', N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', NULL, N'Area', N'区域', NULL, NULL, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'D082BDB9-5C34-49BF-BD51-4E85D7BFF646', N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', NULL, N'Company', N'公司', NULL, NULL, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2B540AC5-6E64-4688-BB60-E0C01DFA982C', N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', NULL, N'SubCompany', N'子公司', NULL, NULL, NULL, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'A64EBB80-6A24-48AF-A10E-B6A532C32CA6', N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', NULL, N'Department', N'部门', NULL, NULL, NULL, 5, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'D1F439B9-D80E-4547-9EF0-163391854AB5', N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', NULL, N'SubDepartment', N'子部门', NULL, NULL, NULL, 6, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'19EE595A-E775-409D-A48F-B33CF9F262C7', N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', NULL, N'WorkGroup', N'小组', NULL, 0, NULL, 7, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e5079bae-a8c0-4209-9019-6a2b4a3a7dac', N'D94E4DC1-C2FD-4D19-9D5D-3886D39900CE', NULL, N'1', N'系统角色', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'04aba88d-f09b-46c6-bd90-a38471399b0e', N'D94E4DC1-C2FD-4D19-9D5D-3886D39900CE', NULL, N'2', N'业务角色', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'cc6daa5c-a71c-4b2c-9a98-336bc3ee13c8', N'D94E4DC1-C2FD-4D19-9D5D-3886D39900CE', NULL, N'3', N'其他角色', NULL, 0, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'7a6d1bc4-3ec7-4c57-be9b-b4c97d60d5f6', N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', NULL, N'1', N'草稿', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ce340c73-5048-4940-b86e-e3b3d53fdb2c', N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', NULL, N'2', N'提交', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'41053517-215d-4e11-81cd-367c0e9578d7', N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', NULL, N'3', N'通过', NULL, 0, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e1979a4f-7fc1-42b9-a0e2-52d7059e8fb9', N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', NULL, N'4', N'待审', NULL, 0, NULL, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'63acf96d-6115-4d76-a994-438f59419aad', N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', NULL, N'5', N'退回', NULL, 0, NULL, 5, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8b7b38bf-07c5-4f71-a853-41c5add4a94e', N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', NULL, N'6', N'完成', NULL, 0, NULL, 6, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'49b68663-ad01-4c43-b084-f98e3e23fee8', N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', NULL, N'7', N'废弃', NULL, 0, NULL, 7, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'fa6c1873-888c-4b70-a2cc-59fccbb22078', N'0DF5B725-5FB8-487F-B0E4-BC563A77EB04', NULL, N'SqlServer', N'SqlServer', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'27e85cb8-04e7-447b-911d-dd1e97dfab83', N'0DF5B725-5FB8-487F-B0E4-BC563A77EB04', NULL, N'Oracle', N'Oracle', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'34a642b2-44d4-485f-b3fc-6cce24f68b0f', N'0DF5B725-5FB8-487F-B0E4-BC563A77EB04', NULL, N'MySql', N'MySql', NULL, 0, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'1950efdf-8685-4341-8d2c-ac85ac7addd0', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'1', N'小学', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'433511a9-78bd-41a0-ab25-e4d4b3423055', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'2', N'初中', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'acb128a6-ff63-4e25-b1e8-0a336ed3ab18', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'3', N'高中', NULL, 0, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a4974810-d88d-4d54-82cc-fd779875478f', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'4', N'中专', NULL, 0, NULL, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'486a82e3-1950-425e-b2ce-b5d98f33016a', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'5', N'大专', NULL, 0, NULL, 5, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'34222d46-e0c6-446e-8150-dbefc47a1d5f', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'6', N'本科', NULL, 0, NULL, 6, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3f280e2b-92f6-466c-8cc3-d7c8ff48cc8d', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'7', N'硕士', NULL, 0, NULL, 7, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'930b8de2-049f-4753-b9fd-87f484911ee4', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'8', N'博士', NULL, 0, NULL, 8, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'355ad7a4-c4f8-4bd3-9c72-ff07983da0f0', N'00F76465-DBBA-484A-B75C-E81DEE9313E6', NULL, N'9', N'其他', NULL, 0, NULL, 9, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'5d6def0e-e2a7-48eb-b43c-cc3631f60dd7', N'BDD797C3-2323-4868-9A63-C8CC3437AEAA', NULL, N'1', N'男', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'822baf7c-abdb-4257-9b78-1f550806f544', N'BDD797C3-2323-4868-9A63-C8CC3437AEAA', NULL, N'0', N'女', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'738edf2a-d59f-4992-97ef-d847db23bcb8', N'FA7537E2-1C64-4431-84BF-66158DD63269', NULL, N'1', N'已婚', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a7c4aba2-a891-4558-9b0a-bd7a1100a645', N'FA7537E2-1C64-4431-84BF-66158DD63269', NULL, N'2', N'未婚', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'f9609400-7caf-49af-ae3c-7671a9292fb3', N'FA7537E2-1C64-4431-84BF-66158DD63269', NULL, N'3', N'离异', NULL, 0, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a6f271f9-8653-4c5c-86cf-4cd00324b3c3', N'FA7537E2-1C64-4431-84BF-66158DD63269', NULL, N'4', N'丧偶', NULL, 0, NULL, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'7c1135be-0148-43eb-ae49-62a1e16ebbe3', N'FA7537E2-1C64-4431-84BF-66158DD63269', NULL, N'5', N'其他', NULL, 0, NULL, 5, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'582e0b66-2ee9-4885-9f0c-3ce3ebf96e12', N'8CEB2F71-026C-4FA6-9A61-378127AE7320', NULL, N'1', N'已育', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'de2167f3-40fe-4bf7-b8cb-5b1c554bad7a', N'8CEB2F71-026C-4FA6-9A61-378127AE7320', NULL, N'2', N'未育', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9b6a2225-6138-4cf2-9845-1bbecdf9b3ed', N'8CEB2F71-026C-4FA6-9A61-378127AE7320', NULL, N'3', N'其他', NULL, 0, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'49300258-1227-4b85-b6a2-e948dbbe57a4', N'15023A4E-4856-44EB-BE71-36A106E2AA59', NULL, N'汉族', N'汉族', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'd69cb819-2bb3-4e1d-9917-33b9a439233d', N'2748F35F-4EE2-417C-A907-3453146AAF67', NULL, N'1', N'身份证', NULL, 0, NULL, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4c2f2428-2e00-4336-b9ce-5a61f24193f6', N'2748F35F-4EE2-417C-A907-3453146AAF67', NULL, N'2', N'士兵证', NULL, 0, NULL, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'48c4e0f5-f570-4601-8946-6078762db3bf', N'2748F35F-4EE2-417C-A907-3453146AAF67', NULL, N'3', N'军官证', NULL, 0, NULL, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0096ad81-4317-486e-9144-a6a02999ff19', N'2748F35F-4EE2-417C-A907-3453146AAF67', NULL, N'4', N'护照', NULL, 0, NULL, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ace2d5e8-56d4-4c8b-8409-34bc272df404', N'2748F35F-4EE2-417C-A907-3453146AAF67', NULL, N'5', N'其它', NULL, 0, NULL, 5, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'795f2695-497a-4f5e-ab1d-706095c1edb9', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Other', N'其他', NULL, 0, NULL, 0, NULL, 1, NULL, CAST(0x0000A648011B0C8E AS DateTime), NULL, CAST(0x0000A648012E2B34 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'643209c8-931b-4641-9e04-b8bdd11800af', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Login', N'登录', NULL, 0, NULL, 1, NULL, 1, NULL, CAST(0x0000A648011B14AF AS DateTime), NULL, CAST(0x0000A648012E33AC AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'3c884a03-4f34-4150-b134-966387f1de2a', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Exit', N'退出', NULL, 0, NULL, 2, NULL, 1, NULL, CAST(0x0000A648011B2048 AS DateTime), NULL, CAST(0x0000A648012E3AB9 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ccc8e274-75da-4eb8-bed0-69008ab7c41c', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Visit', N'访问', NULL, 0, NULL, 3, NULL, 1, NULL, CAST(0x0000A648011B2679 AS DateTime), NULL, CAST(0x0000A648012E4214 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'e545061c-93fd-4ca2-ab29-b43db9db798b', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Create', N'新增', NULL, 0, NULL, 4, NULL, 1, NULL, CAST(0x0000A648011B302B AS DateTime), NULL, CAST(0x0000A648012E49D1 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'a13ccf0d-ac8f-44ac-a522-4a54edf1f0fa', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Delete', N'删除', NULL, 0, NULL, 5, NULL, 1, NULL, CAST(0x0000A648011B36F0 AS DateTime), NULL, CAST(0x0000A648012E5239 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'392f88a8-02c2-49eb-8aed-b2acf474272a', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Update', N'修改', NULL, 0, NULL, 6, NULL, 1, NULL, CAST(0x0000A648011B3D12 AS DateTime), NULL, CAST(0x0000A648012E5939 AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'24e39617-f04e-4f6f-9209-ad71e870e7c6', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Submit', N'提交', NULL, 0, NULL, 7, NULL, 1, NULL, CAST(0x0000A648011B4316 AS DateTime), NULL, CAST(0x0000A648012E5FDD AS DateTime), NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_ItemsDetail] ([F_Id], [F_ItemId], [F_ParentId], [F_ItemCode], [F_ItemName], [F_SimpleSpelling], [F_IsDefault], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'7fc8fa11-4acf-409a-a771-aaf1eb81e814', N'9a7079bd-0660-4549-9c2d-db5e8616619f', NULL, N'Exception', N'异常', NULL, 0, NULL, 8, NULL, 1, NULL, CAST(0x0000A648011B49F4 AS DateTime), NULL, CAST(0x0000A648012E67C1 AS DateTime), NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'0', N'Sys_Items', N'通用字典', 0, 1, 1, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9EB4602B-BF9A-4710-9D80-C73CE89BEC5D', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'OrganizeCategory', N'机构分类', 0, 2, 2, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'D94E4DC1-C2FD-4D19-9D5D-3886D39900CE', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'RoleType', N'角色类型', 0, 2, 3, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'0DF5B725-5FB8-487F-B0E4-BC563A77EB04', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'DbType', N'数据库类型', 0, 2, 4, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'9a7079bd-0660-4549-9c2d-db5e8616619f', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'DbLogType', N'系统日志', NULL, NULL, 16, NULL, 1, NULL, CAST(0x0000A648011AD571 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'954AB9A1-9928-4C6D-820A-FC1CDC85CDE0', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'AuditState', N'审核状态', 0, 2, 6, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'2748F35F-4EE2-417C-A907-3453146AAF67', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'Certificate', N'证件名称', 0, 2, 7, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'00F76465-DBBA-484A-B75C-E81DEE9313E6', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'Education', N'学历', 0, 2, 8, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'FA7537E2-1C64-4431-84BF-66158DD63269', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'101', N'婚姻', 0, 2, 12, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8CEB2F71-026C-4FA6-9A61-378127AE7320', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'102', N'生育', 0, 2, 13, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'15023A4E-4856-44EB-BE71-36A106E2AA59', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'103', N'民族', 0, 2, 14, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Items] ([F_Id], [F_ParentId], [F_EnCode], [F_FullName], [F_IsTree], [F_Layers], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'BDD797C3-2323-4868-9A63-C8CC3437AEAA', N'77070117-3F1A-41BA-BF81-B8B85BF10D5E', N'104', N'性别', 0, 2, 15, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_FilterIP] ([F_Id], [F_Type], [F_StartIP], [F_EndIP], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'4e035f2b-a03b-49b5-a38d-1c6d211a2a04', 1, N'192.168.1.1', N'192.168.1.10', NULL, NULL, 1, N'测试', CAST(0x0000A6470126303F AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_FilterIP] ([F_Id], [F_Type], [F_StartIP], [F_EndIP], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'b3fbe66f-82cd-4f4a-ada3-61eb5a2d9eee', 0, N'192.168.0.20', N'192.168.0.25', NULL, NULL, 1, NULL, CAST(0x0000A6470126A63E AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_DbBackup] ([F_Id], [F_BackupType], [F_DbName], [F_FileName], [F_FileSize], [F_FilePath], [F_BackupTime], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'8b3fb1ff-07ab-46bb-a12a-85e65a9a748d', N'1', N'NFineBase', N'201607190929504502.bak', N'2.81 MB', N'/Resource/DbBackup/201607190929504502.bak', CAST(0x0000A648009C85B1 AS DateTime), NULL, NULL, 1, NULL, CAST(0x0000A648009C85E8 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_DbBackup] ([F_Id], [F_BackupType], [F_DbName], [F_FileName], [F_FileSize], [F_FilePath], [F_BackupTime], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'ddbbfaf3-44b7-4e34-b0c5-c79e21aba83a', N'1', N'NFineBase', N'201607181640402083.bak', N'2.81 MB', N'/Resource/DbBackup/201607181640402083.bak', CAST(0x0000A6470112D98C AS DateTime), NULL, NULL, 1, NULL, CAST(0x0000A6470112D9B5 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET ANSI_PADDING OFF
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'120100', N'120000', 2, N'120100', N'天津市', N'tjs', 120100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130100', N'130000', 2, N'130100', N'石家庄市', N'sjzs', 130100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130200', N'130000', 2, N'130200', N'唐山市', N'tss', 130200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130300', N'130000', 2, N'130300', N'秦皇岛市', N'qhds', 130300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130400', N'130000', 2, N'130400', N'邯郸市', N'hds', 130400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130500', N'130000', 2, N'130500', N'邢台市', N'xts', 130500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130600', N'130000', 2, N'130600', N'保定市', N'bds', 130600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130700', N'130000', 2, N'130700', N'张家口市', N'zjks', 130700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130800', N'130000', 2, N'130800', N'承德市', N'cds', 130800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130900', N'130000', 2, N'130900', N'沧州市', N'czs', 130900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'131000', N'130000', 2, N'131000', N'廊坊市', N'lfs', 131000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'131100', N'130000', 2, N'131100', N'衡水市', N'hss', 131100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140100', N'140000', 2, N'140100', N'太原市', N'tys', 140100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140200', N'140000', 2, N'140200', N'大同市', N'dts', 140200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140300', N'140000', 2, N'140300', N'阳泉市', N'yqs', 140300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140400', N'140000', 2, N'140400', N'长治市', N'czs', 140400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140500', N'140000', 2, N'140500', N'晋城市', N'jcs', 140500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140600', N'140000', 2, N'140600', N'朔州市', N'szs', 140600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140700', N'140000', 2, N'140700', N'晋中市', N'jzs', 140700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140800', N'140000', 2, N'140800', N'运城市', N'ycs', 140800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140900', N'140000', 2, N'140900', N'忻州市', N'xzs', 140900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'141000', N'140000', 2, N'141000', N'临汾市', N'lfs', 141000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'141100', N'140000', 2, N'141100', N'吕梁市', N'lls', 141100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150100', N'150000', 2, N'150100', N'呼和浩特市', N'hhhts', 150100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150200', N'150000', 2, N'150200', N'包头市', N'bts', 150200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150300', N'150000', 2, N'150300', N'乌海市', N'whs', 150300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150400', N'150000', 2, N'150400', N'赤峰市', N'cfs', 150400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150500', N'150000', 2, N'150500', N'通辽市', N'tls', 150500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150600', N'150000', 2, N'150600', N'鄂尔多斯市', N'eedss', 150600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150700', N'150000', 2, N'150700', N'呼伦贝尔市', N'hlbes', 150700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150800', N'150000', 2, N'150800', N'巴彦淖尔市', N'bynes', 150800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340400', N'340000', 2, N'340400', N'淮南市', N'hns', 340400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340500', N'340000', 2, N'340500', N'马鞍山市', N'mass', 340500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340600', N'340000', 2, N'340600', N'淮北市', N'hbs', 340600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340700', N'340000', 2, N'340700', N'铜陵市', N'tls', 340700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340800', N'340000', 2, N'340800', N'安庆市', N'aqs', 340800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341000', N'340000', 2, N'341000', N'黄山市', N'hss', 341000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341100', N'340000', 2, N'341100', N'滁州市', N'czs', 341100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341200', N'340000', 2, N'341200', N'阜阳市', N'fys', 341200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341300', N'340000', 2, N'341300', N'宿州市', N'szs', 341300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341500', N'340000', 2, N'341500', N'六安市', N'las', 341500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341600', N'340000', 2, N'341600', N'亳州市', N'bzs', 341600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341700', N'340000', 2, N'341700', N'池州市', N'czs', 341700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'341800', N'340000', 2, N'341800', N'宣城市', N'xcs', 341800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350100', N'350000', 2, N'350100', N'福州市', N'fzs', 350100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350200', N'350000', 2, N'350200', N'厦门市', N'xms', 350200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350300', N'350000', 2, N'350300', N'莆田市', N'pts', 350300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350400', N'350000', 2, N'350400', N'三明市', N'sms', 350400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350500', N'350000', 2, N'350500', N'泉州市', N'qzs', 350500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350600', N'350000', 2, N'350600', N'漳州市', N'zzs', 350600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350700', N'350000', 2, N'350700', N'南平市', N'nps', 350700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350800', N'350000', 2, N'350800', N'龙岩市', N'lys', 350800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350900', N'350000', 2, N'350900', N'宁德市', N'nds', 350900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360100', N'360000', 2, N'360100', N'南昌市', N'ncs', 360100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360200', N'360000', 2, N'360200', N'景德镇市', N'jdzs', 360200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360300', N'360000', 2, N'360300', N'萍乡市', N'pxs', 360300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360400', N'360000', 2, N'360400', N'九江市', N'jjs', 360400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360500', N'360000', 2, N'360500', N'新余市', N'xys', 360500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360600', N'360000', 2, N'360600', N'鹰潭市', N'yts', 360600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360700', N'360000', 2, N'360700', N'赣州市', N'gzs', 360700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360800', N'360000', 2, N'360800', N'吉安市', N'jas', 360800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360900', N'360000', 2, N'360900', N'宜春市', N'ycs', 360900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'361000', N'360000', 2, N'361000', N'抚州市', N'fzs', 361000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'361100', N'360000', 2, N'361100', N'上饶市', N'srs', 361100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370100', N'370000', 2, N'370100', N'济南市', N'jns', 370100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370200', N'370000', 2, N'370200', N'青岛市', N'qds', 370200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370300', N'370000', 2, N'370300', N'淄博市', N'zbs', 370300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370400', N'370000', 2, N'370400', N'枣庄市', N'zzs', 370400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370500', N'370000', 2, N'370500', N'东营市', N'dys', 370500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370600', N'370000', 2, N'370600', N'烟台市', N'yts', 370600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370700', N'370000', 2, N'370700', N'潍坊市', N'wfs', 370700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370800', N'370000', 2, N'370800', N'济宁市', N'jns', 370800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370900', N'370000', 2, N'370900', N'泰安市', N'tas', 370900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371000', N'370000', 2, N'371000', N'威海市', N'whs', 371000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371100', N'370000', 2, N'371100', N'日照市', N'rzs', 371100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371200', N'370000', 2, N'371200', N'莱芜市', N'lws', 371200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371300', N'370000', 2, N'371300', N'临沂市', N'lys', 371300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371400', N'370000', 2, N'371400', N'德州市', N'dzs', 371400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371500', N'370000', 2, N'371500', N'聊城市', N'lcs', 371500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371600', N'370000', 2, N'371600', N'滨州市', N'bzs', 371600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'371700', N'370000', 2, N'371700', N'菏泽市', N'hzs', 371700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410100', N'410000', 2, N'410100', N'郑州市', N'zzs', 410100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410200', N'410000', 2, N'410200', N'开封市', N'kfs', 410200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410300', N'410000', 2, N'410300', N'洛阳市', N'lys', 410300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410400', N'410000', 2, N'410400', N'平顶山市', N'pdss', 410400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410500', N'410000', 2, N'410500', N'安阳市', N'ays', 410500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410600', N'410000', 2, N'410600', N'鹤壁市', N'hbs', 410600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410700', N'410000', 2, N'410700', N'新乡市', N'xxs', 410700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410800', N'410000', 2, N'410800', N'焦作市', N'jzs', 410800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410881', N'410000', 2, N'410881', N'济源市', N'jys', 410881, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410900', N'410000', 2, N'410900', N'濮阳市', N'pys', 410900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411000', N'410000', 2, N'411000', N'许昌市', N'xcs', 411000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411100', N'410000', 2, N'411100', N'漯河市', N'lhs', 411100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411200', N'410000', 2, N'411200', N'三门峡市', N'smxs', 411200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411300', N'410000', 2, N'411300', N'南阳市', N'nys', 411300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411400', N'410000', 2, N'411400', N'商丘市', N'sqs', 411400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411500', N'410000', 2, N'411500', N'信阳市', N'xys', 411500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411600', N'410000', 2, N'411600', N'周口市', N'zks', 411600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'152200', N'150000', 2, N'152200', N'兴安盟', N'xam', 152200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'152500', N'150000', 2, N'152500', N'锡林郭勒盟', N'xlglm', 152500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'152900', N'150000', 2, N'152900', N'阿拉善盟', N'alsm', 152900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

print 'Processed 100 total records'
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210100', N'210000', 2, N'210100', N'沈阳市', N'sys', 210100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210200', N'210000', 2, N'210200', N'大连市', N'dls', 210200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210300', N'210000', 2, N'210300', N'鞍山市', N'ass', 210300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210400', N'210000', 2, N'210400', N'抚顺市', N'fss', 210400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210500', N'210000', 2, N'210500', N'本溪市', N'bxs', 210500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210600', N'210000', 2, N'210600', N'丹东市', N'dds', 210600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210700', N'210000', 2, N'210700', N'锦州市', N'jzs', 210700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210800', N'210000', 2, N'210800', N'营口市', N'yks', 210800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210900', N'210000', 2, N'210900', N'阜新市', N'fxs', 210900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'211000', N'210000', 2, N'211000', N'辽阳市', N'lys', 211000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'211100', N'210000', 2, N'211100', N'盘锦市', N'pjs', 211100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'211200', N'210000', 2, N'211200', N'铁岭市', N'tls', 211200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'211300', N'210000', 2, N'211300', N'朝阳市', N'zys', 211300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'211400', N'210000', 2, N'211400', N'葫芦岛市', N'hlds', 211400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220100', N'220000', 2, N'220100', N'长春市', N'zcs', 220100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220200', N'220000', 2, N'220200', N'吉林市', N'jls', 220200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220300', N'220000', 2, N'220300', N'四平市', N'sps', 220300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220400', N'220000', 2, N'220400', N'辽源市', N'lys', 220400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220500', N'220000', 2, N'220500', N'通化市', N'ths', 220500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220600', N'220000', 2, N'220600', N'白山市', N'bss', 220600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220700', N'220000', 2, N'220700', N'松原市', N'sys', 220700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220800', N'220000', 2, N'220800', N'白城市', N'bcs', 220800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'222400', N'220000', 2, N'222400', N'延边朝鲜族自治州', N'ybzxzzzz', 222400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230100', N'230000', 2, N'230100', N'哈尔滨市', N'hebs', 230100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230200', N'230000', 2, N'230200', N'齐齐哈尔市', N'qqhes', 230200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230300', N'230000', 2, N'230300', N'鸡西市', N'jxs', 230300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230400', N'230000', 2, N'230400', N'鹤岗市', N'hgs', 230400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230500', N'230000', 2, N'230500', N'双鸭山市', N'syss', 230500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230600', N'230000', 2, N'230600', N'大庆市', N'dqs', 230600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230700', N'230000', 2, N'230700', N'伊春市', N'ycs', 230700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230800', N'230000', 2, N'230800', N'佳木斯市', N'jmss', 230800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230900', N'230000', 2, N'230900', N'七台河市', N'qths', 230900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'231000', N'230000', 2, N'231000', N'牡丹江市', N'mdjs', 231000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'231100', N'230000', 2, N'231100', N'黑河市', N'hhs', 231100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'231200', N'230000', 2, N'231200', N'绥化市', N'shs', 231200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'232700', N'230000', 2, N'232700', N'大兴安岭地区', N'dxaldq', 232700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'310100', N'310000', 2, N'310100', N'上海市', N'shs', 310100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320100', N'320000', 2, N'320100', N'南京市', N'njs', 320100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320200', N'320000', 2, N'320200', N'无锡市', N'wxs', 320200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320300', N'320000', 2, N'320300', N'徐州市', N'xzs', 320300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320400', N'320000', 2, N'320400', N'常州市', N'czs', 320400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320500', N'320000', 2, N'320500', N'苏州市', N'szs', 320500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320600', N'320000', 2, N'320600', N'南通市', N'nts', 320600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320700', N'320000', 2, N'320700', N'连云港市', N'lygs', 320700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320800', N'320000', 2, N'320800', N'淮安市', N'has', 320800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320900', N'320000', 2, N'320900', N'盐城市', N'ycs', 320900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'321000', N'320000', 2, N'321000', N'扬州市', N'yzs', 321000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'321100', N'320000', 2, N'321100', N'镇江市', N'zjs', 321100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'321200', N'320000', 2, N'321200', N'泰州市', N'tzs', 321200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'321300', N'320000', 2, N'321300', N'宿迁市', N'sqs', 321300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330100', N'330000', 2, N'330100', N'杭州市', N'hzs', 330100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330200', N'330000', 2, N'330200', N'宁波市', N'nbs', 330200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330300', N'330000', 2, N'330300', N'温州市', N'wzs', 330300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330400', N'330000', 2, N'330400', N'嘉兴市', N'jxs', 330400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330500', N'330000', 2, N'330500', N'湖州市', N'hzs', 330500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330600', N'330000', 2, N'330600', N'绍兴市', N'sxs', 330600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330700', N'330000', 2, N'330700', N'金华市', N'jhs', 330700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330800', N'330000', 2, N'330800', N'衢州市', N'qzs', 330800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330900', N'330000', 2, N'330900', N'舟山市', N'zss', 330900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'331000', N'330000', 2, N'331000', N'台州市', N'tzs', 331000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'331100', N'330000', 2, N'331100', N'丽水市', N'lss', 331100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340100', N'340000', 2, N'340100', N'合肥市', N'hfs', 340100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340200', N'340000', 2, N'340200', N'芜湖市', N'whs', 340200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420100', N'420000', 2, N'420100', N'武汉市', N'whs', 420100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420200', N'420000', 2, N'420200', N'黄石市', N'hss', 420200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420300', N'420000', 2, N'420300', N'十堰市', N'sys', 420300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420500', N'420000', 2, N'420500', N'宜昌市', N'ycs', 420500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420600', N'420000', 2, N'420600', N'襄阳市', N'xys', 420600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420700', N'420000', 2, N'420700', N'鄂州市', N'ezs', 420700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420800', N'420000', 2, N'420800', N'荆门市', N'jms', 420800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420900', N'420000', 2, N'420900', N'孝感市', N'xgs', 420900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'421000', N'420000', 2, N'421000', N'荆州市', N'jzs', 421000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'421100', N'420000', 2, N'421100', N'黄冈市', N'hgs', 421100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'421200', N'420000', 2, N'421200', N'咸宁市', N'xns', 421200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'421300', N'420000', 2, N'421300', N'随州市', N'szs', 421300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'422800', N'420000', 2, N'422800', N'恩施土家族苗族自治州', N'estjzmzzzz', 422800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430100', N'430000', 2, N'430100', N'长沙市', N'zss', 430100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430200', N'430000', 2, N'430200', N'株洲市', N'zzs', 430200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430300', N'430000', 2, N'430300', N'湘潭市', N'xts', 430300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430400', N'430000', 2, N'430400', N'衡阳市', N'hys', 430400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430500', N'430000', 2, N'430500', N'邵阳市', N'sys', 430500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430600', N'430000', 2, N'430600', N'岳阳市', N'yys', 430600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430700', N'430000', 2, N'430700', N'常德市', N'cds', 430700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430800', N'430000', 2, N'430800', N'张家界市', N'zjjs', 430800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430900', N'430000', 2, N'430900', N'益阳市', N'yys', 430900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'431000', N'430000', 2, N'431000', N'郴州市', N'czs', 431000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'431100', N'430000', 2, N'431100', N'永州市', N'yzs', 431100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'431200', N'430000', 2, N'431200', N'怀化市', N'hhs', 431200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'431300', N'430000', 2, N'431300', N'娄底市', N'lds', 431300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'433100', N'430000', 2, N'433100', N'湘西土家族苗族自治州', N'xxtjzmzzzz', 433100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440100', N'440000', 2, N'440100', N'广州市', N'gzs', 440100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440200', N'440000', 2, N'440200', N'韶关市', N'sgs', 440200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440300', N'440000', 2, N'440300', N'深圳市', N'szs', 440300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440400', N'440000', 2, N'440400', N'珠海市', N'zhs', 440400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440500', N'440000', 2, N'440500', N'汕头市', N'sts', 440500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440600', N'440000', 2, N'440600', N'佛山市', N'fss', 440600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440700', N'440000', 2, N'440700', N'江门市', N'jms', 440700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440800', N'440000', 2, N'440800', N'湛江市', N'zjs', 440800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440900', N'440000', 2, N'440900', N'茂名市', N'mms', 440900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'441200', N'440000', 2, N'441200', N'肇庆市', N'zqs', 441200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'441300', N'440000', 2, N'441300', N'惠州市', N'hzs', 441300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

print 'Processed 200 total records'
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'441400', N'440000', 2, N'441400', N'梅州市', N'mzs', 441400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'441500', N'440000', 2, N'441500', N'汕尾市', N'sws', 441500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'441600', N'440000', 2, N'441600', N'河源市', N'hys', 441600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'441700', N'440000', 2, N'441700', N'阳江市', N'yjs', 441700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'441800', N'440000', 2, N'441800', N'清远市', N'qys', 441800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'445100', N'440000', 2, N'445100', N'潮州市', N'czs', 445100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'445200', N'440000', 2, N'445200', N'揭阳市', N'jys', 445200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'445300', N'440000', 2, N'445300', N'云浮市', N'yfs', 445300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450100', N'450000', 2, N'450100', N'南宁市', N'nns', 450100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450200', N'450000', 2, N'450200', N'柳州市', N'lzs', 450200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450300', N'450000', 2, N'450300', N'桂林市', N'gls', 450300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450400', N'450000', 2, N'450400', N'梧州市', N'wzs', 450400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450500', N'450000', 2, N'450500', N'北海市', N'bhs', 450500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450600', N'450000', 2, N'450600', N'防城港市', N'fcgs', 450600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450700', N'450000', 2, N'450700', N'钦州市', N'qzs', 450700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450800', N'450000', 2, N'450800', N'贵港市', N'ggs', 450800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450900', N'450000', 2, N'450900', N'玉林市', N'yls', 450900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'451000', N'450000', 2, N'451000', N'百色市', N'bss', 451000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'451100', N'450000', 2, N'451100', N'贺州市', N'hzs', 451100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'451200', N'450000', 2, N'451200', N'河池市', N'hcs', 451200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'451300', N'450000', 2, N'451300', N'来宾市', N'lbs', 451300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'451400', N'450000', 2, N'451400', N'崇左市', N'czs', 451400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'460100', N'460000', 2, N'460100', N'海口市', N'hks', 460100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'500100', N'500000', 2, N'500100', N'重庆市', N'zqs', 500100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510100', N'510000', 2, N'510100', N'成都市', N'cds', 510100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510300', N'510000', 2, N'510300', N'自贡市', N'zgs', 510300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510400', N'510000', 2, N'510400', N'攀枝花市', N'pzhs', 510400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510500', N'510000', 2, N'510500', N'泸州市', N'lzs', 510500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510700', N'510000', 2, N'510700', N'绵阳市', N'mys', 510700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510800', N'510000', 2, N'510800', N'广元市', N'gys', 510800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510900', N'510000', 2, N'510900', N'遂宁市', N'sns', 510900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511000', N'510000', 2, N'511000', N'内江市', N'njs', 511000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511100', N'510000', 2, N'511100', N'乐山市', N'yss', 511100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511300', N'510000', 2, N'511300', N'南充市', N'ncs', 511300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511400', N'510000', 2, N'511400', N'眉山市', N'mss', 511400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511500', N'510000', 2, N'511500', N'宜宾市', N'ybs', 511500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511600', N'510000', 2, N'511600', N'广安市', N'gas', 511600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511700', N'510000', 2, N'511700', N'达州市', N'dzs', 511700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511800', N'510000', 2, N'511800', N'雅安市', N'yas', 511800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'511900', N'510000', 2, N'511900', N'巴中市', N'bzs', 511900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'512000', N'510000', 2, N'512000', N'资阳市', N'zys', 512000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'513200', N'510000', 2, N'513200', N'阿坝藏族羌族自治州', N'abzzqzzzz', 513200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'513300', N'510000', 2, N'513300', N'甘孜藏族自治州', N'gzzzzzz', 513300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'513400', N'510000', 2, N'513400', N'凉山彝族自治州', N'lsyzzzz', 513400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'520100', N'520000', 2, N'520100', N'贵阳市', N'gys', 520100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'520200', N'520000', 2, N'520200', N'六盘水市', N'lpss', 520200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'520300', N'520000', 2, N'520300', N'遵义市', N'zys', 520300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'520400', N'520000', 2, N'520400', N'安顺市', N'ass', 520400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'522200', N'520000', 2, N'522200', N'铜仁市', N'trs', 522200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'522300', N'520000', 2, N'522300', N'黔西南布依族苗族自治州', N'qxnbyzmzzzz', 522300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'522400', N'520000', 2, N'522400', N'毕节市', N'bjs', 522400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'522600', N'520000', 2, N'522600', N'黔东南苗族侗族自治州', N'qdnmztzzzz', 522600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'522700', N'520000', 2, N'522700', N'黔南布依族苗族自治州', N'qnbyzmzzzz', 522700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530100', N'530000', 2, N'530100', N'昆明市', N'kms', 530100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530300', N'530000', 2, N'530300', N'曲靖市', N'qjs', 530300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530400', N'530000', 2, N'530400', N'玉溪市', N'yxs', 530400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530500', N'530000', 2, N'530500', N'保山市', N'bss', 530500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530600', N'530000', 2, N'530600', N'昭通市', N'zts', 530600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530700', N'530000', 2, N'530700', N'丽江市', N'ljs', 530700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530800', N'530000', 2, N'530800', N'普洱市', N'pes', 530800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530900', N'530000', 2, N'530900', N'临沧市', N'lcs', 530900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'532300', N'530000', 2, N'532300', N'楚雄彝族自治州', N'cxyzzzz', 532300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'532500', N'530000', 2, N'532500', N'红河哈尼族彝族自治州', N'hhhnzyzzzz', 532500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'532600', N'530000', 2, N'532600', N'文山壮族苗族自治州', N'wszzmzzzz', 532600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'532800', N'530000', 2, N'532800', N'西双版纳傣族自治州', N'xsbndzzzz', 532800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'532900', N'530000', 2, N'532900', N'大理白族自治州', N'dlbzzzz', 532900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'533100', N'530000', 2, N'533100', N'德宏傣族景颇族自治州', N'dhdzjpzzzz', 533100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'533300', N'530000', 2, N'533300', N'怒江傈僳族自治州', N'njlszzzz', 533300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'533400', N'530000', 2, N'533400', N'迪庆藏族自治州', N'dqzzzzz', 533400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'540100', N'540000', 2, N'540100', N'拉萨市', N'lss', 540100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'542100', N'540000', 2, N'542100', N'昌都地区', N'cddq', 542100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'542200', N'540000', 2, N'542200', N'山南地区', N'sndq', 542200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'542300', N'540000', 2, N'542300', N'日喀则地区', N'rkzdq', 542300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'542400', N'540000', 2, N'542400', N'那曲地区', N'nqdq', 542400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'542500', N'540000', 2, N'542500', N'阿里地区', N'aldq', 542500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'542600', N'540000', 2, N'542600', N'林芝地区', N'lzdq', 542600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610100', N'610000', 2, N'610100', N'西安市', N'xas', 610100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610200', N'610000', 2, N'610200', N'铜川市', N'tcs', 610200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610300', N'610000', 2, N'610300', N'宝鸡市', N'bjs', 610300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610400', N'610000', 2, N'610400', N'咸阳市', N'xys', 610400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610500', N'610000', 2, N'610500', N'渭南市', N'wns', 610500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610600', N'610000', 2, N'610600', N'延安市', N'yas', 610600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610700', N'610000', 2, N'610700', N'汉中市', N'hzs', 610700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610800', N'610000', 2, N'610800', N'榆林市', N'yls', 610800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610900', N'610000', 2, N'610900', N'安康市', N'aks', 610900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'611000', N'610000', 2, N'611000', N'商洛市', N'sls', 611000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620100', N'620000', 2, N'620100', N'兰州市', N'lzs', 620100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620200', N'620000', 2, N'620200', N'嘉峪关市', N'jygs', 620200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620300', N'620000', 2, N'620300', N'金昌市', N'jcs', 620300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620400', N'620000', 2, N'620400', N'白银市', N'bys', 620400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620500', N'620000', 2, N'620500', N'天水市', N'tss', 620500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'110000', N'0', 1, N'110000', N'北京', N'bj', 110000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'120000', N'0', 1, N'120000', N'天津', N'tj', 120000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'130000', N'0', 1, N'130000', N'河北省', N'hbs', 130000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'140000', N'0', 1, N'140000', N'山西省', N'sxs', 140000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150000', N'0', 1, N'150000', N'内蒙古自治区', N'nmgzzq', 150000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'210000', N'0', 1, N'210000', N'辽宁省', N'lns', 210000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'220000', N'0', 1, N'220000', N'吉林省', N'jls', 220000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'230000', N'0', 1, N'230000', N'黑龙江省', N'hljs', 230000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'310000', N'0', 1, N'310000', N'上海', N'sh', 310000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'320000', N'0', 1, N'320000', N'江苏省', N'jss', 320000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

print 'Processed 300 total records'
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'330000', N'0', 1, N'330000', N'浙江省', N'zjs', 330000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340000', N'0', 1, N'340000', N'安徽省', N'ahs', 340000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'350000', N'0', 1, N'350000', N'福建省', N'fjs', 350000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'360000', N'0', 1, N'360000', N'江西省', N'jxs', 360000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'370000', N'0', 1, N'370000', N'山东省', N'sds', 370000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'410000', N'0', 1, N'410000', N'河南省', N'hns', 410000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'420000', N'0', 1, N'420000', N'湖北省', N'hbs', 420000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'430000', N'0', 1, N'430000', N'湖南省', N'hns', 430000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'440000', N'0', 1, N'440000', N'广东省', N'gds', 440000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'450000', N'0', 1, N'450000', N'广西壮族自治区', N'gxzzzzq', 450000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'460000', N'0', 1, N'460000', N'海南省', N'hns', 460000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'500000', N'0', 1, N'500000', N'重庆', N'zq', 500000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510000', N'0', 1, N'510000', N'四川省', N'scs', 510000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'520000', N'0', 1, N'520000', N'贵州省', N'gzs', 520000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'530000', N'0', 1, N'530000', N'云南省', N'yns', 530000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'540000', N'0', 1, N'540000', N'西藏自治区', N'xzzzq', 540000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'610000', N'0', 1, N'610000', N'陕西省', N'sxs', 610000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620000', N'0', 1, N'620000', N'甘肃省', N'gss', 620000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'630000', N'0', 1, N'630000', N'青海省', N'qhs', 630000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'640000', N'0', 1, N'640000', N'宁夏回族自治区', N'nxhzzzq', 640000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'650000', N'0', 1, N'650000', N'新疆维吾尔自治区', N'xjwwezzq', 650000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'810000', N'0', 1, N'810000', N'香港特别行政区', N'xgtbxzq', 810000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'820000', N'0', 1, N'820000', N'澳门特别行政区', N'amtbxzq', 820000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830000', N'0', 1, N'830000', N'台湾省', N'tws', 830000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'150900', N'150000', 2, N'150900', N'乌兰察布市', N'wlcbs', 150900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'340300', N'340000', 2, N'340300', N'蚌埠市', N'bbs', 340300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'411700', N'410000', 2, N'411700', N'驻马店市', N'zmds', 411700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'510600', N'510000', 2, N'510600', N'德阳市', N'dys', 510600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620600', N'620000', 2, N'620600', N'武威市', N'wws', 620600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620700', N'620000', 2, N'620700', N'张掖市', N'zys', 620700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620800', N'620000', 2, N'620800', N'平凉市', N'pls', 620800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'620900', N'620000', 2, N'620900', N'酒泉市', N'jqs', 620900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'621000', N'620000', 2, N'621000', N'庆阳市', N'qys', 621000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'621100', N'620000', 2, N'621100', N'定西市', N'dxs', 621100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'621200', N'620000', 2, N'621200', N'陇南市', N'lns', 621200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'622900', N'620000', 2, N'622900', N'临夏回族自治州', N'lxhzzzz', 622900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'623000', N'620000', 2, N'623000', N'甘南藏族自治州', N'gnzzzzz', 623000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'630100', N'630000', 2, N'630100', N'西宁市', N'xns', 630100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'632100', N'630000', 2, N'632100', N'海东市', N'hds', 632100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'632200', N'630000', 2, N'632200', N'海北藏族自治州', N'hbzzzzz', 632200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'632300', N'630000', 2, N'632300', N'黄南藏族自治州', N'hnzzzzz', 632300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'632500', N'630000', 2, N'632500', N'海南藏族自治州', N'hnzzzzz', 632500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'632600', N'630000', 2, N'632600', N'果洛藏族自治州', N'glzzzzz', 632600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'632700', N'630000', 2, N'632700', N'玉树藏族自治州', N'yszzzzz', 632700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'632800', N'630000', 2, N'632800', N'海西蒙古族藏族自治州', N'hxmgzzzzzz', 632800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'640100', N'640000', 2, N'640100', N'银川市', N'ycs', 640100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'640200', N'640000', 2, N'640200', N'石嘴山市', N'szss', 640200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'640300', N'640000', 2, N'640300', N'吴忠市', N'wzs', 640300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'640400', N'640000', 2, N'640400', N'固原市', N'gys', 640400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'640500', N'640000', 2, N'640500', N'中卫市', N'zws', 640500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'650100', N'650000', 2, N'650100', N'乌鲁木齐市', N'wlmqs', 650100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'650200', N'650000', 2, N'650200', N'克拉玛依市', N'klmys', 650200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'652100', N'650000', 2, N'652100', N'吐鲁番地区', N'tlfdq', 652100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'652200', N'650000', 2, N'652200', N'哈密地区', N'hmdq', 652200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'652300', N'650000', 2, N'652300', N'昌吉回族自治州', N'cjhzzzz', 652300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'652700', N'650000', 2, N'652700', N'博尔塔拉蒙古自治州', N'betlmgzzz', 652700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'652800', N'650000', 2, N'652800', N'巴音郭楞蒙古自治州', N'byglmgzzz', 652800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'652900', N'650000', 2, N'652900', N'阿克苏地区', N'aksdq', 652900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'653000', N'650000', 2, N'653000', N'克孜勒苏柯尔克孜自治州', N'kzlskekzzzz', 653000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'653100', N'650000', 2, N'653100', N'喀什地区', N'ksdq', 653100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'653200', N'650000', 2, N'653200', N'和田地区', N'htdq', 653200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'654000', N'650000', 2, N'654000', N'伊犁哈萨克自治州', N'ylhskzzz', 654000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'654200', N'650000', 2, N'654200', N'塔城地区', N'tcdq', 654200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'654300', N'650000', 2, N'654300', N'阿勒泰地区', N'altdq', 654300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'810100', N'810000', 2, N'810100', N'香港岛', N'xgd', 810100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'810200', N'810000', 2, N'810200', N'九龙', N'jl', 810200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'810300', N'810000', 2, N'810300', N'新界', N'xj', 810300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'820100', N'820000', 2, N'820100', N'澳门半岛', N'ambd', 820100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'820300', N'820000', 2, N'820300', N'路环岛', N'lhd', 820300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'820400', N'820000', 2, N'820400', N'凼仔岛', N'dzd', 820400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830100', N'830000', 2, N'830100', N'台北市', N'tbs', 830100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830200', N'830000', 2, N'830200', N'高雄市', N'gxs', 830200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830300', N'830000', 2, N'830300', N'台南市', N'tns', 830300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830400', N'830000', 2, N'830400', N'台中市', N'tzs', 830400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830500', N'830000', 2, N'830500', N'南投县', N'ntx', 830500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830600', N'830000', 2, N'830600', N'基隆市', N'jls', 830600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830700', N'830000', 2, N'830700', N'新竹市', N'xzs', 830700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830800', N'830000', 2, N'830800', N'嘉义市', N'jys', 830800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'830900', N'830000', 2, N'830900', N'宜兰县', N'ylx', 830900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831000', N'830000', 2, N'831000', N'新竹县', N'xzx', 831000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831100', N'830000', 2, N'831100', N'桃园县', N'tyx', 831100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831200', N'830000', 2, N'831200', N'苗栗县', N'mlx', 831200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831300', N'830000', 2, N'831300', N'彰化县', N'zhx', 831300, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831400', N'830000', 2, N'831400', N'嘉义县', N'jyx', 831400, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831500', N'830000', 2, N'831500', N'云林县', N'ylx', 831500, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831600', N'830000', 2, N'831600', N'屏东县', N'pdx', 831600, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831700', N'830000', 2, N'831700', N'台东县', N'tdx', 831700, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831800', N'830000', 2, N'831800', N'花莲县', N'hlx', 831800, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'831900', N'830000', 2, N'831900', N'澎湖县', N'phx', 831900, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'832000', N'830000', 2, N'832000', N'新北市', N'xbs', 832000, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'832100', N'830000', 2, N'832100', N'台中县', N'tzx', 832100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'832200', N'830000', 2, N'832200', N'连江县', N'ljx', 832200, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

INSERT [dbo].[Sys_Area] ([F_Id], [F_ParentId], [F_Layers], [F_EnCode], [F_FullName], [F_SimpleSpelling], [F_SortCode], [F_DeleteMark], [F_EnabledMark], [F_Description], [F_CreatorTime], [F_CreatorUserId], [F_LastModifyTime], [F_LastModifyUserId], [F_DeleteTime], [F_DeleteUserId]) VALUES (N'110100', N'110000', 2, N'110100', N'北京市', N'bjs', 110100, NULL, 1, NULL, CAST(0x0000A64900000000 AS DateTime), NULL, NULL, NULL, NULL, NULL)
GO

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'更新完成。';


GO
