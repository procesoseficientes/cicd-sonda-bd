﻿-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	6/29/2017 @ A-TEAM Sprint Anpassung  
-- Description:			SP que obtiene UNO O TODOS los registros de promociones de Descuento por Monto General filtrados por PROMO_ID

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_DISCOUNT_FROM_PROMO_OF_DISCOUNT_BY_SCALE]
				@PROMO_ID = 2121
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_DISCOUNT_FROM_PROMO_OF_DISCOUNT_BY_SCALE](
	@PROMO_ID INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT [PDS].[PROMO_DISCOUNT_ID]
			,[PDS].[PROMO_ID]
			,[PDS].[CODE_SKU]
			,[VAS1].[DESCRIPTION_SKU]
			,FS.[CODE_FAMILY_SKU]
			,FS.[DESCRIPTION_FAMILY_SKU]
			,[PDS].[PACK_UNIT]
			,[PU1].[DESCRIPTION_PACK_UNIT]
			,[PDS].[LOW_LIMIT]
			,[PDS].[HIGH_LIMIT]
			,[PDS].[DISCOUNT]
			,CASE [PDS].[DISCOUNT_TYPE]
				WHEN 'PERCENTAGE' THEN 'PORCENTAJE'
				WHEN 'MONETARY' THEN 'MONETARIO' 
			END [DISCOUNT_TYPE], 
			CASE [PDS].IS_UNIQUE WHEN 1 THEN 'UNICO'
			WHEN 0 THEN 'NO UNICO' END [UNIQUE], 
			[PDS].IS_UNIQUE
	FROM [acsa].[SONDA_PACK_UNIT] [PU1] 
		INNER JOIN [acsa].[SWIFT_PROMO_DISCOUNT_BY_SCALE] [PDS] ON [PU1].[PACK_UNIT] = [PDS].[PACK_UNIT] 
		INNER JOIN [acsa].[SWIFT_VIEW_ALL_SKU] [VAS1] ON [VAS1].[CODE_SKU] = [PDS].[CODE_SKU]	COLLATE DATABASE_DEFAULT
		LEFT JOIN acsa.[SWIFT_FAMILY_SKU] FS ON [FS].[CODE_FAMILY_SKU] = [VAS1].[CODE_FAMILY_SKU] COLLATE DATABASE_DEFAULT
	WHERE [PDS].[PROMO_ID] = @PROMO_ID

END
