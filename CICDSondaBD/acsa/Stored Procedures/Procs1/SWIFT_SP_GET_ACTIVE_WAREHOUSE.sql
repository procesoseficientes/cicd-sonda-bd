-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	04-04-2016
-- Description:			obtiene los operadores

/*
-- Ejemplo de Ejecucion:
        USE $(CICDSondaBD)
        GO
        --
        EXEC [acsa].[SWIFT_SP_GET_ACTIVE_WAREHOUSE]
			@CODE_WAREHOUSE = 'C001'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ACTIVE_WAREHOUSE]
	@CODE_WAREHOUSE VARCHAR(50) = NULL
AS
BEGIN
	DECLARE @ACTIVE_WAREHOUSE VARCHAR(50)
	--
	SELECT @ACTIVE_WAREHOUSE = P.VALUE
	FROM [acsa].SWIFT_PARAMETER P
	WHERE P.GROUP_ID = 'WAREHOUSE'
		AND P.PARAMETER_ID = 'ACTIVE_WAREHOUSE'
	--
	SELECT
		W.WAREHOUSE
		,W.CODE_WAREHOUSE
		,W.DESCRIPTION_WAREHOUSE
		,W.WEATHER_WAREHOUSE
		,W.STATUS_WAREHOUSE
		,W.IS_EXTERNAL
		,W.ERP_WAREHOUSE
		,W.ADDRESS_WAREHOUSE
		,W.BARCODE_WAREHOUSE
		,W.SHORT_DESCRIPTION_WAREHOUSE
		,W.TYPE_WAREHOUSE
		,W.GPS_WAREHOUSE
	FROM [acsa].[SWIFT_VIEW_WAREHOUSES] W
	WHERE STATUS_WAREHOUSE = @ACTIVE_WAREHOUSE
		AND (@CODE_WAREHOUSE IS NULL OR W.CODE_WAREHOUSE = @CODE_WAREHOUSE)
END

