-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		12-05-2016
-- Description:			    SP que envia la lista de precios por escalas y unidad de medida

-- Modificacion 17-Feb-17 @ A-Team Sprint Chatulika
					-- alberto.ruiz
					-- Se agrego distinct al select final
/*
-- Ejemplo de Ejecucion:
        EXEC [acsa].[SWIFT_SP_GET_PRICE_LIST_BY_SKU_PACK_SCALE]
			@CODE_ROUTE = 'HUE0003@acsa'
*/
-- =============================================
create PROCEDURE [acsa].[SWIFT_SP_GET_PRICE_LIST_BY_SKU_PACK_SCALE_by_wh] (
	@CODE_ROUTE VARCHAR(50)
)
AS
BEGIN
		DECLARE @WAREHOUSES VARCHAR(50)
	SELECT @WAREHOUSES =PRESALE_WAREHOUSE FROM acsa.USERS
	WHERE SELLER_ROUTE=@CODE_ROUTE
	

	

	DECLARE @PRICE_LIST_BY_WH VARCHAR(25)
	SELECT @PRICE_LIST_BY_WH = acsa.[SWIFT_FN_GET_PRICE_LIST_BY_WH](@WAREHOUSES)


	--
	SELECT DISTINCT
		PL.[CODE_PRICE_LIST]
		,PL.[CODE_SKU]
		,PL.[CODE_PACK_UNIT]
		,PL.[PRIORITY]
		,PL.[LOW_LIMIT]
		,PL.[HIGH_LIMIT]
		,PL.[PRICE]
	FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE] AS PL
	WHERE CODE_PRICE_LIST=@PRICE_LIST_BY_WH 

END
