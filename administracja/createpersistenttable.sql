USE tempdb;
GO

CREATE TABLE AvailableMeal
(
	MealTypeName VARCHAR(25),
	RecipeName VARCHAR(25),
	ServingQuantity TINYINT,
	IngredientName VARCHAR(25)
);
USE baza;
GO

CREATE PROCEDURE dbo.CreatePersistentTable
AS
	CREATE TABLE ##AvailableMeal
	(
		MealTypeName VARCHAR(25),
		RecipeName VARCHAR(25),
		ServingQuantity TINYINT,
		IngredientName VARCHAR(25)
	);
GO
EXEC sp_procoption 'CreatePersistentTable', 'startup', 'true'