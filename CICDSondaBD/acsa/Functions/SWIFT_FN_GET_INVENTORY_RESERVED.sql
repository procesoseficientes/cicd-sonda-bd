-- =============================================
-- Author:		rudi.garcia
-- Create date: 1-19-2016
-- Description:	Obtiene el inventario reservado
-- =============================================
-- =============================================
-- Autor:				gustavo.garcia
-- Fecha de Creacion: 	26-03-2019
-- Description:			Se agregan campos faltantes de la tabla para que pueda ser actualizado automaticamente
--						para CI/CD
-- =============================================
--Modificacion 02-03-2016
          -- Se agrego el parametro CODE_WAREHOUSE para la condicion

/*Ejemplo de Ejecucion:				
				--
				SELECT * FROM [ACSA].[SWIFT_FN_GET_INVENTORY_RESERVED]()
				--				
*/
CREATE FUNCTION [acsa].[SWIFT_FN_GET_INVENTORY_RESERVED]
(
  @CODE_WAREHOUSE VARCHAR(50)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT PD.CODE_SKU, SUM( DISPATCH) QYT_RESERVED
	FROM [ACSA].SWIFT_PICKING_DETAIL PD 
	LEFT OUTER JOIN [ACSA].SWIFT_PICKING_HEADER PH ON (PD.PICKING_HEADER = PH.PICKING_HEADER)
	WHERE 
		PH.STATUS <> 'CLOSED' 
		AND PH.STATUS <> 'COMPLETED'
    AND (@CODE_WAREHOUSE IS NULL OR PH.CODE_WAREHOUSE_SOURCE = @CODE_WAREHOUSE)
	GROUP BY PD.CODE_SKU
)
