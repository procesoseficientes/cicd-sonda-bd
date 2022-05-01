-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	12-11-2015
-- Description:			Se insertar los sku para la preventa

/*
-- Ejemplo de Ejecucion:
				exec [acsa].[SWIFT_SP_INSERT_IS_COMITED_PRESALE]
				select * from [acsa].[SONDA_IS_COMITED_BY_WAREHOUSE]
*/

CREATE PROC [acsa].[SWIFT_SP_INSERT_IS_COMITED_PRESALE]
	  
AS
BEGIN	
	TRUNCATE TABLE  [acsa].[SONDA_IS_COMITED_BY_WAREHOUSE]
	--
	INSERT INTO [acsa].[SONDA_IS_COMITED_BY_WAREHOUSE]
	SELECT DISTINCT I.WAREHOUSE , I.SKU, 0
	FROM  [acsa].[SWIFT_INVENTORY] I
	INNER JOIN [acsa].[USERS] U ON (U.PRESALE_WAREHOUSE = I.WAREHOUSE)
	GROUP BY  I.WAREHOUSE , I.SKU	
END



