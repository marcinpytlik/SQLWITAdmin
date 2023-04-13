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
---------------
-- lookup
USE Menu;
GO

SELECT tbl.[name] AS TableName,
	sch.[name] AS PartitionScheme,
	fnc.[name] AS PartitionFunction,
	prt.partition_number,
	fnc.[type_desc],
	rng.boundary_id,
	rng.[value] AS BoundaryValue,
	prt.[rows]
FROM sys.tables tbl
	INNER JOIN sys.indexes idx
	ON tbl.[object_id] = idx.[object_id]
	INNER JOIN sys.partitions prt
	ON idx.[object_id] = prt.[object_id]
	AND idx.index_id = prt.index_id
	INNER JOIN sys.partition_schemes AS sch
	ON idx.data_space_id = sch.data_space_id
	INNER JOIN sys.partition_functions AS fnc
	ON sch.function_id = fnc.function_id
	LEFT JOIN sys.partition_range_values AS rng
	ON fnc.function_id = rng.function_id
	AND rng.boundary_id = prt.partition_number
WHERE tbl.[name] = 'RecipeHistory'
	AND idx.[type] <= 1
ORDER BY prt.partition_number; 
-- sum 
USE Menu;
GO

SELECT
	SUM(
		CASE WHEN DateCreated < '1/1/2019'
			THEN 1
			ELSE 0
		END
	) AS Partition1,
	SUM(
		CASE WHEN DateCreated < '4/1/2019'
			THEN 1
			ELSE 0
		END
	) AS Partition2,
	SUM(
		CASE WHEN DateCreated < '7/1/2019'
			THEN 1
			ELSE 0
		END
	) AS Partition3,
	SUM(
		CASE WHEN DateCreated >= '7/1/2019'
			THEN 1
			ELSE 0
		END
	) AS Partition4
FROM dbo.RecipeHistory;
-- partition existing table
