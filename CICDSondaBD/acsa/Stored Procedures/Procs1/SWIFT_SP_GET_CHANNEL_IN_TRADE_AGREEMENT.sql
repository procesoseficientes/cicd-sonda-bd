﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	12-09-2016 @ A-TEAM Sprint 1
-- Description:			SP que obtiene todos los canales de un acuerdo comercial

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].SWIFT_SP_GET_CHANNEL_IN_TRADE_AGREEMENT
					@TRADE_AGREEMENT_ID = 1
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CHANNEL_IN_TRADE_AGREEMENT](
	@TRADE_AGREEMENT_ID INT
)
AS
BEGIN
	SELECT
		C.CHANNEL_ID
		,C.CODE_CHANNEL
		,C.NAME_CHANNEL
		,C.DESCRIPTION_CHANNEL
		,C.TYPE_CHANNEL
		,(CASE WHEN TAC.CHANNEL_ID IS NULL THEN 'NO ASIGNADO' ELSE 'ASIGNADO' END) AS [STATUS]
	FROM [acsa].SWIFT_TRADE_AGREEMENT_BY_CHANNEL TAC
	INNER JOIN [acsa].SWIFT_CHANNEL C ON (
		TAC.CHANNEL_ID = C.CHANNEL_ID
	)
	WHERE TAC.TRADE_AGREEMENT_ID = @TRADE_AGREEMENT_ID
END

