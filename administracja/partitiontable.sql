USE Menu;
GO

ALTER DATABASE Menu ADD FILEGROUP RecipeHistory2018;
ALTER DATABASE Menu ADD FILEGROUP RecipeHistory2019Q1;
ALTER DATABASE Menu ADD FILEGROUP RecipeHistory2019Q2;
ALTER DATABASE Menu ADD FILEGROUP RecipeHistory2019Q3;
USE master;
GO

ALTER DATABASE Menu
ADD FILE
(
	NAME = RecipeHistFG2018,
	FILENAME = 'D:\SQLData\RecipeHistFG2018.ndf',
	SIZE = 50MB
)
TO FILEGROUP RecipeHistory2018;

ALTER DATABASE Menu
ADD FILE
(
	NAME = RecipeHistFG2019Q1,
	FILENAME = 'D:\SQLData\RecipeHistFG2019Q1.ndf',
	SIZE = 50MB
)
TO FILEGROUP RecipeHistory2019Q1;

ALTER DATABASE Menu
ADD FILE
(
	NAME = RecipeHistFG2019Q2,
	FILENAME = 'D:\SQLData\RecipeHistFG2019Q2.ndf',
	SIZE = 50MB
)
TO FILEGROUP RecipeHistory2019Q2;

ALTER DATABASE Menu
ADD FILE
(
	NAME = RecipeHistFG2019Q3,
	FILENAME = 'D:\SQLData\RecipeHistFG2019Q3.ndf',
	SIZE = 50MB
)
TO FILEGROUP RecipeHistory2019Q3;
USE Menu;
GO

CREATE PARTITION FUNCTION RecipeHistFunc(DATETIME)
AS RANGE RIGHT FOR VALUES
(
	'01/01/2019',
	'04/01/2019',
	'07/01/2019'
);
USE Menu;
GO

CREATE PARTITION SCHEME RecipeHistRange
AS PARTITION RecipeHistFunc TO
(
	RecipeHistory2018,
	RecipeHistory2019Q1,
	RecipeHistory2019Q2,
	RecipeHistory2019Q3
);
USE Menu;
GO

ALTER DATABASE Menu ADD FILEGROUP RecipeHistory2019Q4;

ALTER DATABASE Menu
ADD FILE
(
	NAME = RecipeHistFG2019Q4,
	FILENAME = 'D:\SQLData\RecipeHistFG2019Q4.ndf',
	SIZE = 50MB
)
TO FILEGROUP RecipeHistory2019Q4;

ALTER PARTITION FUNCTION RecipeHistFunc(DATETIME2)
AS SPLIT RANGE ('10/01/2019');

ALTER PARTITION SCHEME RecipeHistRange
NEXT USED RecipeHistory2019Q4;
USE Menu;
GO

CREATE TABLE dbo.RecipeHistory
(
	RecipeHistoryID BIGINT NOT NULL IDENTITY(1,1),
	RecipeID SMALLINT NOT NULL,
	RecipeHistoryStatusID TINYINT NOT NULL,
	DateCreated DATETIME NOT NULL,
	DateModified DATETIME NULL,
	CONSTRAINT pk_RecipeHistory_RecipeHistoryID
		PRIMARY KEY NONCLUSTERED (RecipeHistoryID, DateCreated),
	CONSTRAINT fk_RecipeHistory_RecipeID
		FOREIGN KEY (RecipeID)
		REFERENCES dbo.Recipe(RecipeID),
	CONSTRAINT fk_RecipeHistory_RecipeHistoryStatusID
		FOREIGN KEY (RecipeHistoryStatusID)
		REFERENCES dbo.RecipeHistoryStatus (RecipeHistoryStatusID)
)
ON RecipeHistRange (DateCreated);
