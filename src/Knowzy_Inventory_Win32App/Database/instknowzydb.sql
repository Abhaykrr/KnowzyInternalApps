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
  SELECT Id, Engineer, Name, RawMaterial, Status, DevelopmentStartDate, ExpectedCompletionDate, SupplyManagementContact, Notes, ImageSource
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
