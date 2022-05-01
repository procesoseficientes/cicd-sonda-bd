﻿-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	13-09-2016 @ A-TEAM Sprint 1
-- Description:			Obtiene los productos disponigles para agregarle descuento en acuerdo comercial

-- Modificacion 2/10/2017 @ A-Team Sprint Chatuluka
					-- rodrigo.gomez
					-- se agregaron las columnas de UM

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].SWIFT_SP_GET_SKU_WITHOUT_DISCOUNT_IN_TRADE_AGREEMENT
          @TRADE_AGREEMENT_ID = 43
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_SKU_WITHOUT_DISCOUNT_IN_TRADE_AGREEMENT]
  @TRADE_AGREEMENT_ID INT
AS
BEGIN
	SELECT
		ROW_NUMBER() OVER (ORDER BY VS.[CODE_SKU],[PU].[PACK_UNIT]) [ID]
		,VS.CODE_SKU
		,VS.DESCRIPTION_SKU
		,ISNULL(FS.CODE_FAMILY_SKU, 'N/A') AS CODE_FAMILY_SKU
		,ISNULL(FS.DESCRIPTION_FAMILY_SKU, 'N/A') AS DESCRIPTION_FAMILY_SKU  
		,[PU].[PACK_UNIT]
		,[PU].[DESCRIPTION_PACK_UNIT]
	FROM [acsa].SWIFT_VIEW_ALL_SKU VS  
	INNER JOIN [acsa].[SONDA_PACK_CONVERSION] [PC] ON (
		[PC].[CODE_SKU] = VS.[CODE_SKU]
	)
	INNER JOIN [acsa].[SONDA_PACK_UNIT] [PU] ON (
		[PU].[CODE_PACK_UNIT] = [PC].[CODE_PACK_UNIT_FROM]
	)
	--LEFT JOIN [acsa].SWIFT_TRADE_AGREEMENT_DISCOUNT TAD ON (
	--		VS.CODE_SKU = TAD.CODE_SKU
	--		AND [TAD].[PACK_UNIT] = [PU].[PACK_UNIT]
	--		AND TAD.TRADE_AGREEMENT_ID = @TRADE_AGREEMENT_ID
	--	)
	LEFT JOIN [acsa].SWIFT_FAMILY_SKU FS ON (
			FS.CODE_FAMILY_SKU = VS.CODE_FAMILY_SKU
		)
  --WHERE TAD.TRADE_AGREEMENT_ID IS NULL

END

