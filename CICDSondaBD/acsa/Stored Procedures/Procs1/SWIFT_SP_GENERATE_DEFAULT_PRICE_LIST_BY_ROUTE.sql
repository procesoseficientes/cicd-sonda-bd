-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	03-May-17 @ A-TEAM Sprint Hondo
-- Description:			SP para generar la lista de precios por defecto por ruta

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GENERATE_DEFAULT_PRICE_LIST_BY_ROUTE]
					@CODE_ROUTE = 'D-01'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GENERATE_DEFAULT_PRICE_LIST_BY_ROUTE](
	@CODE_ROUTE VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @DEFAULT_PRICE_LIST VARCHAR(50)

	--
	--SELECT @DEFAULT_PRICE_LIST = [CODE_PRICE_LIST]
	--FROM [acsa].[USERS]
	--WHERE [SELLER_ROUTE] = @CODE_ROUTE
	SELECT @DEFAULT_PRICE_LIST = ISNULL([CODE_PRICE_LIST], [acsa].[SWIFT_FN_GET_PARAMETER] ('ERP_HARDCODE_VALUES','PRICE_LIST'))
	FROM [acsa].[USERS]
	WHERE [SELLER_ROUTE] = @CODE_ROUTE
	--
	INSERT INTO [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE_FOR_ROUTE]
			(
				[CODE_ROUTE]
				,[CODE_PRICE_LIST]
				,[CODE_SKU]
				,[CODE_PACK_UNIT]
				,[PRIORITY]
				,[LOW_LIMIT]
				,[HIGH_LIMIT]
				,[PRICE]
			)
	SELECT
		@CODE_ROUTE
		,'-1' --[SPS].[CODE_PRICE_LIST]
		,[SPS].[CODE_SKU]
		,[SPS].[CODE_PACK_UNIT]
		,[SPS].[PRIORITY]
		,[SPS].[LOW_LIMIT]
		,[SPS].[HIGH_LIMIT]
		,[SPS].[PRICE]
	FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE] [SPS]
	WHERE [SPS].[CODE_PRICE_LIST] = @DEFAULT_PRICE_LIST
END
