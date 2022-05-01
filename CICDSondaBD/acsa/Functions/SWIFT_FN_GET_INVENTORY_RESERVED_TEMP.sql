-- =============================================
-- Author:		rudi.garcia
-- Create date: 1-19-2016
-- Description:	Obtiene el inventario reservado temporal
-- =============================================

/*Ejemplo de Ejecucion:				
				--
				SELECT * FROM [acsa].[SWIFT_FN_GET_INVENTORY_RESERVED_TEMP]()
				--				
*/


CREATE FUNCTION [acsa].[SWIFT_FN_GET_INVENTORY_RESERVED_TEMP]
(	
)
RETURNS TABLE
AS
RETURN 
(
	SELECT CODE_SKU, SUM(DISPATCH) AS QYT_RESERVED
	FROM [acsa].SWIFT_TEMP_PICKING_DETAIL
	GROUP BY CODE_SKU	
)

