-- =============================================
-- Autor:				jose.garcia
-- Fecha de Creacion: 	09-12-2015
-- Description:			Obtiene lista de precios por  bodega regional

/*
-- Ejemplo de Ejecucion:
				SELECT acsa.[SWIFT_FN_GET_PRICE_LIST_BY_WH](DEFAULT)
*/
-- =============================================
CREATE FUNCTION [SWIFT_FN_GET_PRICE_LIST_BY_WH]
(
	@WH VARCHAR(50) 
)
RETURNS VARCHAR(25)
AS
BEGIN
	DECLARE @CODE_PRICE_LIST VARCHAR(25)
	--
		
		SELECT @CODE_PRICE_LIST = VALUE_TEXT_CLASSIFICATION
		FROM acsa.SWIFT_CLASSIFICATION
		WHERE 
			GROUP_CLASSIFICATION ='WAREHOUSE_PRICELIST' 
			AND NAME_CLASSIFICATION =@WH
	
	--
	RETURN @CODE_PRICE_LIST
END