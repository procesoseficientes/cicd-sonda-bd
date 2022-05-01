﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	09-Feb-17 @ A-TEAM Sprint Chatuluka
-- Description:			SP que obtiene los combos de un acuerdo comercial

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_COMBOS_IN_TRADE_AGREEMENT]
					@TRADE_AGREEMENT_ID = 21
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_COMBOS_IN_TRADE_AGREEMENT](
	@TRADE_AGREEMENT_ID INT
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT
		[C].[COMBO_ID]
		,MAX([C].[NAME_COMBO]) [NAME_COMBO]
		,MAX([C].[DESCRIPTION_COMBO]) [DESCRIPTION_COMBO]
		,SUM([SC].[QTY]) [QTY]
	FROM [acsa].[SWIFT_COMBO] [C]
	INNER JOIN [acsa].[SWIFT_SKU_BY_COMBO] [SC] ON (
		[SC].[COMBO_ID] = [C].[COMBO_ID]
	)
	INNER JOIN [acsa].[SWIFT_TRADE_AGREEMENT_BY_COMBO_BONUS_RULE] [CR] ON (
		[CR].[COMBO_ID] = [C].[COMBO_ID]
	)
	INNER JOIN [acsa].[SWIFT_TRADE_AGREEMENT_BY_BONUS_RULE] [TAR] ON (
		[TAR].[TRADE_AGREEMENT_BONUS_RULE_BY_COMBO_ID] = [CR].[TRADE_AGREEMENT_BONUS_RULE_BY_COMBO_ID]
	)
	WHERE [TAR].[TRADE_AGREEMENT_ID] = @TRADE_AGREEMENT_ID
	GROUP BY [C].[COMBO_ID]
END
