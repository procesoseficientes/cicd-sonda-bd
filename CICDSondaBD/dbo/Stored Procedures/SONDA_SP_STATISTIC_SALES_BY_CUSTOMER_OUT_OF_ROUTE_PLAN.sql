-- =============================================
-- Autor:				fernando.monroy
-- Fecha de Creacion: 	26-9-2019 @ G-Force - TEAM Sprint Sonda Nav Team
-- Historia/Bug:		Product Backlog Item 32317: Visualizacion de la Estadistica de Venta del cliente
-- Descripcion: 		Obtiene las estadisticas de ventas de los clientes que estan fuera del plan de ruta

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_STATISTIC_SALES_BY_CUSTOMER_OUT_OF_ROUTE_PLAN]
	@CODE_ROUTE = '46', @CLIENT_ID = 'SO-152137'
*/
-- =============================================

CREATE PROCEDURE [SONDA_SP_STATISTIC_SALES_BY_CUSTOMER_OUT_OF_ROUTE_PLAN]
(
    @CODE_ROUTE VARCHAR(50),
    @CLIENT_ID VARCHAR(150)
)
AS
BEGIN
    SELECT DISTINCT
           [sssbc].[ID] AS [ID],
           [sssbc].[CLIENT_ID] AS [CLIENT_ID],
           [svas].[CODE_SKU] AS [CODE_SKU],
           [svas].[DESCRIPTION_SKU] AS [SKU_NAME],
           [sssbc].[QTY] AS [QTY],
           [sssbc].[SALE_PACK_UNIT]
    FROM [acsa].[SONDA_STATISTIC_SALES_BY_CUSTOMER] AS [sssbc]
        INNER JOIN [acsa].[SONDA_ROUTE_PLAN] AS [srp]
            ON [srp].[RELATED_CLIENT_CODE] = [sssbc].[CLIENT_ID]
        INNER JOIN [acsa].[SWIFT_VIEW_ALL_SKU] AS [svas]
            ON [svas].[CODE_SKU] = [sssbc].[CODE_SKU]
    WHERE [sssbc].[CLIENT_ID] = @CLIENT_ID
          AND [srp].[CODE_ROUTE] = @CODE_ROUTE;

END;