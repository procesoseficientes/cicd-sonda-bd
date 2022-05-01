﻿-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	12/27/2016 @ A-TEAM Sprint  
-- Description:			Obtiene todas las bodegas que NO tienen el centro de distribucion asociado

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_WAREHOUSE_NOT_ASSOCIATE_BY_DISTRIBUTION_CENTER]
					
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_WAREHOUSE_NOT_ASSOCIATE_BY_DISTRIBUTION_CENTER]

AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT 
		[W].[WAREHOUSE]
		,[W].[CODE_WAREHOUSE]
		,[W].[DESCRIPTION_WAREHOUSE]
		,[W].[WEATHER_WAREHOUSE]
		,[W].[STATUS_WAREHOUSE]
		,[W].[LAST_UPDATE]
		,[W].[LAST_UPDATE_BY]
		,[W].[IS_EXTERNAL]
		,[W].[BARCODE_WAREHOUSE]
		,[W].[SHORT_DESCRIPTION_WAREHOUSE]
		,[W].[TYPE_WAREHOUSE]
		,[W].[ERP_WAREHOUSE]
		,[W].[ADDRESS_WAREHOUSE]
		,[W].[GPS_WAREHOUSE]
	FROM [acsa].[SWIFT_WAREHOUSES] [W]
		--INNER JOIN [acsa].[SWIFT_WAREHOUSES] [W] ON [W].[CODE_WAREHOUSE] = [SWDC].[CODE_WAREHOUSE]
	WHERE [W].[CODE_WAREHOUSE] NOT IN (
			SELECT [SWDC].[CODE_WAREHOUSE]
			FROM [acsa].[SWIFT_WAREHOUSE_X_DISTRIBUTION_CENTER] [SWDC]
			WHERE [SWDC].[CODE_WAREHOUSE] IS NOT NULL
		)

END




