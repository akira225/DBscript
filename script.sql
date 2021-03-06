USE [master]
GO
/****** Object:  Database [ProjectManagementDB]    Script Date: 06.07.2020 14:34:13 ******/
CREATE DATABASE [ProjectManagementDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ProjectManagementDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\ProjectManagementDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ProjectManagementDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\ProjectManagementDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [ProjectManagementDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ProjectManagementDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ProjectManagementDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ProjectManagementDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ProjectManagementDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ProjectManagementDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ProjectManagementDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ProjectManagementDB] SET  MULTI_USER 
GO
ALTER DATABASE [ProjectManagementDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ProjectManagementDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ProjectManagementDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ProjectManagementDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ProjectManagementDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ProjectManagementDB] SET QUERY_STORE = OFF
GO
USE [ProjectManagementDB]
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 06.07.2020 14:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Projects](
	[Project_ID] [int] IDENTITY(1,1) NOT NULL,
	[Project_Name] [nvarchar](255) NOT NULL,
	[Notes] [text] NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[Project_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Commitment]    Script Date: 06.07.2020 14:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Commitment](
	[Project_ID] [int] NOT NULL,
	[Employee_ID] [int] NOT NULL,
	[Employee_CommitmentLevel] [int] NOT NULL,
	[Notes] [text] NULL,
 CONSTRAINT [PK_Commitment] PRIMARY KEY CLUSTERED 
(
	[Project_ID] ASC,
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[Top5_Committed_Projects]    Script Date: 06.07.2020 14:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Top5_Committed_Projects] as
select top 5 Projects.Project_ID, Projects.Project_Name,
count(Commitment.Employee_CommitmentLevel) as Number_Of_Employess,
sum(Commitment.Employee_CommitmentLevel) as Overall_Commitmet_Level
from Projects left outer join Commitment on Projects.Project_ID = Commitment.Project_ID
group by Projects.Project_ID, Projects.Project_Name
order by Overall_Commitmet_Level desc
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 06.07.2020 14:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[Employee_ID] [int] IDENTITY(1,1) NOT NULL,
	[Employee_FirstName] [nvarchar](50) NOT NULL,
	[Employee_LastName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Empoyees] PRIMARY KEY CLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Employee_Commitment]    Script Date: 06.07.2020 14:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Employee_Commitment]
AS
SELECT        dbo.Employees.Employee_ID, dbo.Employees.Employee_FirstName, dbo.Employees.Employee_LastName, COALESCE (100 - SUM(dbo.Commitment.Employee_CommitmentLevel), 100) 
                         AS Employee_Remaining_Resource
FROM            dbo.Employees LEFT OUTER JOIN
                         dbo.Commitment ON dbo.Employees.Employee_ID = dbo.Commitment.Employee_ID
GROUP BY dbo.Employees.Employee_ID, dbo.Employees.Employee_FirstName, dbo.Employees.Employee_LastName
GO
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (1, 1, 40, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (1, 2, 10, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (2, 1, 50, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (2, 3, 25, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (2, 11, 100, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (3, 4, 100, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (3, 5, 30, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (4, 3, 40, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (4, 5, 70, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (4, 9, 100, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (4, 10, 75, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (4, 13, 40, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (5, 6, 100, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (6, 2, 30, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (6, 7, 50, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (7, 12, 100, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (7, 13, 30, NULL)
INSERT [dbo].[Commitment] ([Project_ID], [Employee_ID], [Employee_CommitmentLevel], [Notes]) VALUES (7, 14, 90, NULL)
GO
SET IDENTITY_INSERT [dbo].[Employees] ON 

INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (1, N'A', N'A')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (2, N'B', N'B')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (3, N'C', N'C')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (4, N'D', N'D')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (5, N'E', N'E')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (6, N'F', N'F')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (7, N'G', N'G')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (8, N'H', N'H')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (9, N'I', N'I')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (10, N'J', N'J')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (11, N'K', N'K')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (12, N'L', N'L')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (13, N'M', N'M')
INSERT [dbo].[Employees] ([Employee_ID], [Employee_FirstName], [Employee_LastName]) VALUES (14, N'N', N'N')
SET IDENTITY_INSERT [dbo].[Employees] OFF
GO
SET IDENTITY_INSERT [dbo].[Projects] ON 

INSERT [dbo].[Projects] ([Project_ID], [Project_Name], [Notes]) VALUES (1, N'Proj_1', NULL)
INSERT [dbo].[Projects] ([Project_ID], [Project_Name], [Notes]) VALUES (2, N'Proj_2', NULL)
INSERT [dbo].[Projects] ([Project_ID], [Project_Name], [Notes]) VALUES (3, N'Proj_3', NULL)
INSERT [dbo].[Projects] ([Project_ID], [Project_Name], [Notes]) VALUES (4, N'Proj_4', NULL)
INSERT [dbo].[Projects] ([Project_ID], [Project_Name], [Notes]) VALUES (5, N'Proj_5', NULL)
INSERT [dbo].[Projects] ([Project_ID], [Project_Name], [Notes]) VALUES (6, N'Proj_6', NULL)
INSERT [dbo].[Projects] ([Project_ID], [Project_Name], [Notes]) VALUES (7, N'Proj_7', NULL)
SET IDENTITY_INSERT [dbo].[Projects] OFF
GO
ALTER TABLE [dbo].[Commitment]  WITH CHECK ADD  CONSTRAINT [FK_Commitment_Empoyees] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employees] ([Employee_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Commitment] CHECK CONSTRAINT [FK_Commitment_Empoyees]
GO
ALTER TABLE [dbo].[Commitment]  WITH CHECK ADD  CONSTRAINT [FK_Commitment_Projects] FOREIGN KEY([Project_ID])
REFERENCES [dbo].[Projects] ([Project_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Commitment] CHECK CONSTRAINT [FK_Commitment_Projects]
GO
ALTER TABLE [dbo].[Commitment]  WITH CHECK ADD  CONSTRAINT [CK_ValidPercent] CHECK  (([Employee_CommitmentLevel]<=(100) AND [Employee_CommitmentLevel]>=(0)))
GO
ALTER TABLE [dbo].[Commitment] CHECK CONSTRAINT [CK_ValidPercent]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Employees"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Commitment"
            Begin Extent = 
               Top = 120
               Left = 38
               Bottom = 250
               Right = 299
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Employee_Commitment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Employee_Commitment'
GO
USE [master]
GO
ALTER DATABASE [ProjectManagementDB] SET  READ_WRITE 
GO
