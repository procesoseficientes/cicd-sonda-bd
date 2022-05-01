/****** Object:  StoredProcedure [acsa].[SWIFT_SP_GET_WAREHOUSE_BY_FILTER]    Script Date: 20/12/2015 9:09:38 AM ******/
-- =============================================
-- Autor:				jose.garcia
-- Fecha de Creacion: 	02-12-2015
-- Description:			Trae todas las bodegas que existen filtradas por el usuario por pasillo, rack o columna
--    
 --Modificacion 14-01-2016
		-- Autor: ppablo.loukota
		-- Descripción: Se agregan los campos nuevos de bodega
		--				                
/*
-- Ejemplo de Ejecucion:				
				--
				exec [acsa].[SWIFT_SP_GET_WAREHOUSE_BY_FILTER] @FILTER_WH='klm'		--				

*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_WAREHOUSE_BY_FILTER]
 @FILTER_WH VARCHAR (50) 
AS
SELECT DISTINCT( H.CODE_WAREHOUSE)
FROM [acsa].[SWIFT_LOCATIONS] L
INNER JOIN [acsa].[SWIFT_WAREHOUSES] H ON (L.CODE_WAREHOUSE = H.CODE_WAREHOUSE)
WHERE h.CODE_WAREHOUSE LIKE '%' +@FILTER_WH+'%'
	or L.HALL_LOCATION LIKE '%' +@FILTER_WH+'%'
	OR L.RACK_LOCATION LIKE '%' +@FILTER_WH+'%'
	OR L.COLUMN_LOCATION LIKE '%' +@FILTER_WH+'%'
ORDER BY (H.CODE_WAREHOUSE)










