USE [master]
GO
/****** Object:  Database [wabbajack_prod]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE DATABASE [wabbajack_prod]
    CONTAINMENT = NONE
    ON  PRIMARY
    ( NAME = N'wabbajack_dev', FILENAME = N'/home/tbald/postgresql/wabbajack_prod.mdf' , SIZE = 3678208KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
    LOG ON
    ( NAME = N'wabbajack_dev_log', FILENAME = N'/home/tbald/postgresql/wabbajack_prod_log.ldf' , SIZE = 13639680KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
    WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [wabbajack_prod] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
    begin
        EXEC [wabbajack_prod].[dbo].[sp_fulltext_database] @action = 'enable'
    end
GO
ALTER DATABASE [wabbajack_prod] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [wabbajack_prod] SET ANSI_NULLS OFF
GO
ALTER DATABASE [wabbajack_prod] SET ANSI_PADDING OFF
GO
ALTER DATABASE [wabbajack_prod] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [wabbajack_prod] SET ARITHABORT OFF
GO
ALTER DATABASE [wabbajack_prod] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [wabbajack_prod] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [wabbajack_prod] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [wabbajack_prod] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [wabbajack_prod] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [wabbajack_prod] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [wabbajack_prod] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [wabbajack_prod] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [wabbajack_prod] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [wabbajack_prod] SET  DISABLE_BROKER
GO
ALTER DATABASE [wabbajack_prod] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [wabbajack_prod] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [wabbajack_prod] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [wabbajack_prod] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [wabbajack_prod] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [wabbajack_prod] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [wabbajack_prod] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [wabbajack_prod] SET RECOVERY FULL
GO
ALTER DATABASE [wabbajack_prod] SET  MULTI_USER
GO
ALTER DATABASE [wabbajack_prod] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [wabbajack_prod] SET DB_CHAINING OFF
GO
ALTER DATABASE [wabbajack_prod] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO
ALTER DATABASE [wabbajack_prod] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO
ALTER DATABASE [wabbajack_prod] SET DELAYED_DURABILITY = DISABLED
GO
ALTER DATABASE [wabbajack_prod] SET QUERY_STORE = OFF
GO
USE [wabbajack_prod]
GO
/****** Object:  User [wabbajack]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE USER [wabbajack] FOR LOGIN [wabbajack] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [wabbajack]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [wabbajack]
GO
/****** Object:  UserDefinedTableType [dbo].[ArchiveContentType]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE TYPE [dbo].[ArchiveContentType] AS TABLE(
                                                   [Parent] [bigint] NOT NULL,
                                                   [Child] [bigint] NOT NULL,
                                                   [Path] [nvarchar](max) NOT NULL
                                               )
GO
/****** Object:  UserDefinedTableType [dbo].[IndexedFileType]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE TYPE [dbo].[IndexedFileType] AS TABLE(
                                                [Hash] [bigint] NOT NULL,
                                                [Sha256] [binary](32) NOT NULL,
                                                [Sha1] [binary](20) NOT NULL,
                                                [Md5] [binary](16) NOT NULL,
                                                [Crc32] [int] NOT NULL,
                                                [Size] [bigint] NOT NULL
                                            )
GO
/****** Object:  UserDefinedFunction [dbo].[Base64ToLong]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[Base64ToLong]
(
    -- Add the parameters for the function here
    @Input varchar
)
    RETURNS bigint
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar bigint

    -- Add the T-SQL statements to compute the return value here
    SELECT @ResultVar = CAST('string' as varbinary(max)) FOR XML PATH(''), BINARY BASE64

    -- Return the result of the function
    RETURN @ResultVar

END
GO
/****** Object:  UserDefinedFunction [dbo].[MaxMetricDate]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[MaxMetricDate]
(
)
    RETURNS date
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result date

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = max(Timestamp) from dbo.Metrics where MetricsKey is not null

    -- Return the result of the function
    RETURN @Result

END
GO
/****** Object:  UserDefinedFunction [dbo].[MinMetricDate]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[MinMetricDate]
(
)
    RETURNS date
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Result date

    -- Add the T-SQL statements to compute the return value here
    SELECT @Result = min(Timestamp) from dbo.Metrics WHERE MetricsKey is not null

    -- Return the result of the function
    RETURN @Result

END
GO
/****** Object:  Table [dbo].[IndexedFile]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndexedFile](
                                    [Hash] [bigint] NOT NULL,
                                    [Sha256] [binary](32) NOT NULL,
                                    [Sha1] [binary](20) NOT NULL,
                                    [Md5] [binary](16) NOT NULL,
                                    [Crc32] [int] NOT NULL,
                                    [Size] [bigint] NOT NULL,
                                    CONSTRAINT [PK_IndexedFile] PRIMARY KEY CLUSTERED
                                        (
                                         [Hash] ASC
                                            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArchiveContent]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArchiveContent](
                                       [Parent] [bigint] NOT NULL,
                                       [Child] [bigint] NOT NULL,
                                       [Path] [nvarchar](max) NULL,
                                       [PathHash]  AS (CONVERT([binary](32),hashbytes('SHA2_256',[Path]))) PERSISTED NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AllFilesInArchive]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllFilesInArchive](
                                          [TopParent] [bigint] NOT NULL,
                                          [Child] [bigint] NOT NULL,
                                          CONSTRAINT [PK_AllFilesInArchive] PRIMARY KEY CLUSTERED
                                              (
                                               [TopParent] ASC,
                                               [Child] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AllArchiveContent]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[AllArchiveContent]
            WITH SCHEMABINDING
AS
SELECT af.TopParent, ac.Parent, af.Child, ac.Path, idx.Size
FROM
    dbo.AllFilesInArchive af
        LEFT JOIN dbo.ArchiveContent ac on af.Child = ac.Child
        LEFT JOIN dbo.IndexedFile idx on af.Child = idx.Hash
GO
/****** Object:  Table [dbo].[Metrics]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Metrics](
                                [Id] [bigint] IDENTITY(1,1) NOT NULL,
                                [Timestamp] [datetime] NOT NULL,
                                [Action] [varchar](64) NOT NULL,
                                [Subject] [varchar](max) NOT NULL,
                                [MetricsKey] [varchar](64) NULL,
                                [GroupingSubject]  AS (substring([Subject],(0),case when patindex('%[0-9].%',[Subject])=(0) then len([Subject])+(1) else patindex('%[0-9].%',[Subject]) end)),
                                CONSTRAINT [PK_Metrics] PRIMARY KEY CLUSTERED
                                    (
                                     [Id] ASC
                                        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_Child]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE NONCLUSTERED INDEX [IX_Child] ON [dbo].[AllFilesInArchive]
    (
     [Child] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ArchiveContent_Child]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE NONCLUSTERED INDEX [IX_ArchiveContent_Child] ON [dbo].[ArchiveContent]
    (
     [Child] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [PK_ArchiveContent]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [PK_ArchiveContent] ON [dbo].[ArchiveContent]
    (
     [Parent] ASC,
     [PathHash] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_IndexedFile_By_SHA256]    Script Date: 2/3/2020 9:57:23 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_IndexedFile_By_SHA256] ON [dbo].[IndexedFile]
    (
     [Sha256] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[MergeAllFilesInArchive]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MergeAllFilesInArchive]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    MERGE dbo.AllFilesInArchive t USING (
        SELECT DISTINCT TopParent, unpvt.Child
        FROM
            (SELECT a3.Parent AS P3, a2.Parent as P2, a1.Parent P1, a0.Parent P0, a0.Parent as Parent, a0.Child FROM
                dbo.ArChiveContent a0
                    LEFT JOIN dbo.ArChiveContent a1 ON a0.Parent = a1.Child
                    LEFT JOIN dbo.ArChiveContent a2 ON a1.Parent = a2.Child
                    LEFT JOIN dbo.ArChiveContent a3 ON a2.Parent = a3.Child) p
                UNPIVOT
                (TopParent For C IN (p.P3, p.P2, p.P1, p.P0)) as unpvt
                LEFT JOIN dbo.IndexedFile idf on unpvt.Child = idf.Hash
        WHERE TopParent is not null) s
    ON t.TopParent = s.TopParent AND t.Child = s.Child
    WHEN NOT MATCHED
        THEN INSERT (TopParent, Child) VALUES (s.TopParent, s.Child);
END
GO
/****** Object:  StoredProcedure [dbo].[MergeIndexedFiles]    Script Date: 2/3/2020 9:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MergeIndexedFiles]
    -- Add the parameters for the stored procedure here
    @Files dbo.IndexedFileType READONLY,
    @Contents dbo.ArchiveContentType READONLY
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    MERGE dbo.IndexedFile AS TARGET
    USING (SELECT DISTINCT * FROM @Files) as SOURCE
    ON (TARGET.Hash = SOURCE.HASH)
    WHEN NOT MATCHED BY TARGET
        THEN INSERT (Hash, Sha256, Sha1, Md5, Crc32, Size)
             VALUES (Source.Hash, Source.Sha256, Source.Sha1, Source.Md5, Source.Crc32, Source.Size);

    MERGE dbo.ArchiveContent AS TARGET
    USING (SELECT DISTINCT * FROM @Contents) as SOURCE
    ON (TARGET.Parent = SOURCE.Parent AND TARGET.PathHash = CAST(HASHBYTES('SHA2_256', SOURCE.Path) as binary(32)))
    WHEN NOT MATCHED
        THEN INSERT (Parent, Child, Path)
             VALUES (Source.Parent, Source.Child, Source.Path);

    MERGE dbo.AllFilesInArchive t USING (
        SELECT DISTINCT TopParent, unpvt.Child
        FROM
            (SELECT a3.Parent AS P3, a2.Parent as P2, a1.Parent P1, a0.Parent P0, a0.Parent as Parent, a0.Child FROM
                dbo.ArChiveContent a0
                    LEFT JOIN dbo.ArChiveContent a1 ON a0.Parent = a1.Child
                    LEFT JOIN dbo.ArChiveContent a2 ON a1.Parent = a2.Child
                    LEFT JOIN dbo.ArChiveContent a3 ON a2.Parent = a3.Child) p
                UNPIVOT
                (TopParent For C IN (p.P3, p.P2, p.P1, p.P0)) as unpvt
                LEFT JOIN dbo.IndexedFile idf on unpvt.Child = idf.Hash
        WHERE TopParent is not null
          AND Child in (SELECT DISTINCT Hash FROM @Files)) s
    ON t.TopParent = s.TopParent AND t.Child = s.Child
    WHEN NOT MATCHED
        THEN INSERT (TopParent, Child) VALUES (s.TopParent, s.Child);

    COMMIT;

END
GO
USE [master]
GO
ALTER DATABASE [wabbajack_prod] SET  READ_WRITE
GO
