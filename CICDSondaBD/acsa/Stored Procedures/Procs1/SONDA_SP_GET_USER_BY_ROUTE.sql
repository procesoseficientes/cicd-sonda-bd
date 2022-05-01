-- =============================================
-- Autor:				ppablo.loukota
-- Fecha de Creacion: 	03-12-2015
-- Description:			Selecciona los usuarios filtrados
--       
-- Modificado: 05-05-2016
-- diego.as
-- Se agrego el campo USE_PACK_UNIT a la consulta.               

-- Modificacion 4/21/2017 @ A-Team Sprint Hondo
					-- rodrigo.gomez
					-- Se obtiene el vendedor y el owner de vendedor

/*
-- Ejemplo de Ejecucion:
	EXECUTE[acsa].[SONDA_SP_GET_USER_BY_ROUTE] @CODE_ROUTE = 'ES000003'
GO
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_USER_BY_ROUTE]
	@CODE_ROUTE [varchar](50)
AS
BEGIN
	SELECT
		 USR.[CORRELATIVE]
		,USR.[LOGIN]
		,USR.[IMAGE]
		,USR.[SELLER_ROUTE]
		,USR.[DEFAULT_WAREHOUSE]
		,USR.[PRESALE_WAREHOUSE]
		,ISNULL(WRH.[DESCRIPTION_WAREHOUSE],'No tiene Bodega') AS DEFAULT_WAREHOUSE_DESCRIPTION
		,ISNULL(WRHT.[DESCRIPTION_WAREHOUSE],'No tiene Bodega')  AS PRESALE_WAREHOUSE_DESCRIPTION
		,USR.USE_PACK_UNIT
		,USR.[RELATED_SELLER]
		,ISNULL(SLLR.[OWNER], '') AS SELLER_OWNER
		,ISNULL([CMP].[COMPANY_ID],0) AS SELLER_OWNER_ID
	FROM [acsa].[USERS] AS USR 
		LEFT JOIN [acsa].[SWIFT_WAREHOUSES] AS WRH ON (USR.[DEFAULT_WAREHOUSE] = WRH.[CODE_WAREHOUSE])
		LEFT JOIN [acsa].[SWIFT_WAREHOUSES] AS WRHT ON (USR.[PRESALE_WAREHOUSE] = WRHT.[CODE_WAREHOUSE])
		LEFT JOIN [acsa].[SWIFT_SELLER] AS SLLR ON ([SLLR].[SELLER_CODE] = [USR].[RELATED_SELLER])
		LEFT JOIN [acsa].[SWIFT_COMPANY] AS CMPN ON ([CMPN].[COMPANY_NAME] = [SLLR].[OWNER])
		LEFT JOIN [acsa].[SWIFT_COMPANY] AS CMP ON ([SLLR].[OWNER] = [CMP].[COMPANY_NAME])
	WHERE [SELLER_ROUTE] = @CODE_ROUTE
END
