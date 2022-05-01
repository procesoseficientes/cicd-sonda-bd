﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	17-Nov-16 @ A-TEAM Sprint 5 
-- Description:			SP que obtiene las liquidaciones por ruta y fecha

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_LIQUIDATION_BY_ROUTE_AND_DATE]
					@CODE_ROUTE = 'RUDI@acsa'
					,@LIQUIDATION_DATE = '20161117'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_LIQUIDATION_BY_ROUTE_AND_DATE](
	@CODE_ROUTE VARCHAR(50)
	,@LIQUIDATION_DATE DATETIME
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @LIQUIDATION_END_DATETIME DATETIME = (DATEADD(HOUR,23,@LIQUIDATION_DATE))
	SELECT
		[L].[LIQUIDATION_ID]
		,[L].[CODE_ROUTE]
		,[L].[LOGIN]
		,[L].[LIQUIDATION_DATE]
		,[L].[LAST_UPDATE]
		,[L].[LAST_UPDATE_BY]
		,[L].[LIQUIDATION_STATUS]
		,[L].[STATUS]
		,[L].[TYPE_ROUTE]
		,[L].[LIQUIDATION_COMMENT] 
	FROM [acsa].[SONDA_LIQUIDATION] [L]
	WHERE [L].[LIQUIDATION_ID] > 0
		AND [L].[STATUS] = 'PENDING'
		AND [L].[LIQUIDATION_DATE] BETWEEN @LIQUIDATION_DATE AND @LIQUIDATION_END_DATETIME
	ORDER BY [L].[LIQUIDATION_ID] ASC
END


