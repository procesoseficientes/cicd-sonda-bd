-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	8/20/2019 @ G-Force - TEAM Sprint 
-- Historia/Bug:		Product Backlog Item 31508: Galeria de Imagenes del Producto
-- Descripcion: 		8/20/2019 - Obtiene las imagenes para cada uno de los productos de la ruta

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_GET_IMAGE_BY_SKU]
	@CODE_ROUTE = '46'
*/
-- =============================================
CREATE PROCEDURE [SONDA_SP_GET_IMAGE_BY_SKU] @CODE_ROUTE VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- ---------------------------------------------------------------
    -- Tabla temporal que almacenara los productos de la ruta
    -- ---------------------------------------------------------------
    DECLARE @SKUS TABLE
    (
        [WAREHOUSE] VARCHAR(50) NOT NULL,
        [SKU] VARCHAR(50) NOT NULL,
        [SKU_NAME] VARCHAR(MAX) NULL,
        [ON_HAND] INT NOT NULL,
        [IS_COMITED] INT NOT NULL,
        [DIFFERENCE] INT NOT NULL,
        [SKU_PRICE] NUMERIC(18, 6) NOT NULL,
        [CODE_FAMILY_SKU] VARCHAR(50) NULL,
        [DESCRIPTION_FAMILY_SKU] VARCHAR(250) NULL,
        [SALES_PACK_UNIT] VARCHAR(25) NOT NULL,
        [HANDLE_DIMENSION] INT NOT NULL,
        [OWNER] VARCHAR(50) NULL,
        [OWNER_ID] VARCHAR(50) NOT NULL,
        [HANDLE_SERIAL_NUMBER] VARCHAR(2) NOT NULL,
        [PACK_UNIT] INT NOT NULL,
        [CODE_PACK_UNIT] VARCHAR(25) NULL
    );

    -- ---------------------------------------------------------------
    -- Se obtienen los productos de la ruta
    -- ---------------------------------------------------------------
    INSERT INTO @SKUS
    EXEC [acsa].[SONDA_SP_GET_SKU] @CODE_ROUTE = @CODE_ROUTE;

    -- ---------------------------------------------------------------
    -- Se eliminan los registros duplicados
    -- ---------------------------------------------------------------

    WITH [FILA_DUPLICADA]
    AS (SELECT ROW_NUMBER() OVER (PARTITION BY [SKU] ORDER BY [SKU]) AS [FILA_DUPLICADA],
               [S].[WAREHOUSE],
               [S].[SKU],
               [S].[SKU_NAME],
               [S].[ON_HAND],
               [S].[IS_COMITED],
               [S].[DIFFERENCE],
               [S].[SKU_PRICE],
               [S].[CODE_FAMILY_SKU],
               [S].[DESCRIPTION_FAMILY_SKU],
               [S].[SALES_PACK_UNIT],
               [S].[HANDLE_DIMENSION],
               [S].[OWNER],
               [S].[OWNER_ID],
               [S].[HANDLE_SERIAL_NUMBER],
               [S].[PACK_UNIT],
               [S].[CODE_PACK_UNIT]
        FROM @SKUS AS [S]
        WHERE [S].[SKU] IN (
                               SELECT DISTINCT [SKU] FROM @SKUS WHERE [SKU] IS NOT NULL
                           ))
    DELETE FROM [FILA_DUPLICADA]
    WHERE [FILA_DUPLICADA] > 1;

    -- ---------------------------------------------------------------
    -- Devuelve el listado de imagenes para los productos de la ruta
    -- ---------------------------------------------------------------
    SELECT [IBS].[ID],
           [IBS].[CODE_SKU],
           [IBS].[IMAGE1],
           [IBS].[IMAGE2],
           [IBS].[IMAGE3],
           [IBS].[IMAGE4],
           [IBS].[IMAGE5]
    FROM [acsa].[IMAGE_BY_SKU] AS [IBS]
        INNER JOIN @SKUS AS [S]
            ON ([S].[SKU] = [IBS].[CODE_SKU]);
END;