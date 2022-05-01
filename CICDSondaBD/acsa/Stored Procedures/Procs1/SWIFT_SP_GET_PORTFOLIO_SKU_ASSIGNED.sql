-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	2-Nov-16 @ A-TEAM Sprint 4
-- Description:			SP que obtiene el los productos asignados al portafolio

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_PORTFOLIO_SKU_ASSIGNED]  @CODE_PORTFOLIO = 4
*/
-- =============================================
CREATE PROC [acsa].[SWIFT_SP_GET_PORTFOLIO_SKU_ASSIGNED]
	@CODE_PORTFOLIO VARCHAR(50)
AS	
	SELECT S.*
	FROM [acsa].SWIFT_VIEW_ALL_SKU S
		INNER JOIN [acsa].SWIFT_VIEW_PORTFOLIO_BY_SKU PS ON S.CODE_SKU = PS.CODE_SKU
	WHERE PS.CODE_PORTFOLIO = @CODE_PORTFOLIO

