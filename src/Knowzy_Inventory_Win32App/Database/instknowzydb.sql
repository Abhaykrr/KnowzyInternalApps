SET NOCOUNT ON
GO

USE master
GO
if exists (select * from sysdatabases where name='KnowzyDB')
		drop database KnowzyDB
go

DECLARE @device_directory NVARCHAR(520)
SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

EXECUTE (N'CREATE DATABASE KnowzyDB
  ON PRIMARY (NAME = N''KnowzyDB'', FILENAME = N''' + @device_directory + N'KnowzyDB.mdf'')
  LOG ON (NAME = N''KnowzyDB_log'',  FILENAME = N''' + @device_directory + N'KnowzyDB.ldf'')')
go

exec sp_dboption 'KnowzyDB','trunc. log on chkpt.','true'
exec sp_dboption 'KnowzyDB','select into/bulkcopy','true'
GO

set quoted_identifier on
GO

SET DATEFORMAT mdy
GO
use "KnowzyDB"
go

CREATE TABLE Inventory (
	Id nvarchar(50),
	Engineer nvarchar(50),
	Name nvarchar(50),
	RawMaterial nvarchar(50),
	Status nvarchar(50),
	DevelopmentStartDate datetime,
	ExpectedCompletionDate datetime,
	SupplyManagementContact nvarchar(50),
	Notes nvarchar(max),
	ImageSource nvarchar(50))


INSERT INTO Inventory
  SELECT *
  FROM OPENROWSET (BULK 'C:\Projects\KnowzyInternalApps\src\Knowzy_Inventory_Win32App\src\Microsoft.Knowzy.WPF\products.json', SINGLE_CLOB) as j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH( 
	Id nvarchar(50) '$.Id',
	Engineer nvarchar(50) '$.Engineer',
	Name nvarchar(50) '$.Name',
	RawMaterial nvarchar(50) '$.RawMaterial',
	Status nvarchar(50) '$.Status',
	DevelopmentStartDate datetime '$.DevelopmentStartDate',
	ExpectedCompletionDate datetime '$.ExpectedCompletionDate',
	SupplyManagementContact nvarchar(50) '$.SupplyManagementContact',
	Notes nvarchar(max) '$.Notes',
	ImageSource nvarchar(50) '$.ImageSource'	
	)
