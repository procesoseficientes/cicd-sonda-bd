-- =============================================
-- Autor:				fernando.monroy
-- Fecha de Creacion: 	24-9-2019 @ G-Force - TEAM Sonda Nav Team SPRINT Kansas
-- Historia/Bug:		Product Backlog Item 32317: Visualizacion de la Estadistica de Venta del cliente
-- Descripcion: 		Datos para estadistica de ventas

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_STATISTIC_SALES_BY_CUSTOMER]
	@CODE_ROUTE = '46'
*/
-- =============================================
CREATE PROCEDURE [SONDA_SP_STATISTIC_SALES_BY_CUSTOMER] (@CODE_ROUTE VARCHAR(50))
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
            ON [srp].[RELATED_CLIENT_CODE] = [sssbc].[CLIENT_ID] COLLATE DATABASE_DEFAULT
        INNER JOIN [acsa].[SWIFT_VIEW_ALL_SKU] AS [svas]
            ON [svas].[CODE_SKU] = [sssbc].[CODE_SKU] COLLATE DATABASE_DEFAULT
    WHERE [srp].[CODE_ROUTE] = @CODE_ROUTE
          AND [srp].[TASK_TYPE] = 'SALE';
END;