-- =============================================
-- Autor:				fernando.monroy
-- Fecha de Creacion: 	19-9-2019 @ G-Force - TEAM Sprint Sonda Nav Team
-- Historia/Bug:		Estadistica de Venta del dia por cliente
-- Descripcion: 		DESCRIPCION

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[GET_STATISTIC_SALES_BY_CUSTOMER]
*/
-- =============================================
CREATE PROCEDURE [acsa].[GET_STATISTIC_SALES_BY_CUSTOMER]
AS
BEGIN
    DECLARE @WEEKSOLD INT = NULL;
    SELECT @WEEKSOLD = [acsa].[SWIFT_FN_GET_PARAMETER]('STADISTICS', 'WEEKS_OLD_FOR_CUSTOMER_SALES_SATISTICS');

    -- -----------------------------------------------------
    -- OBTENES LOS IDENTIFICADORES DE LAS FREQUENCIAS DEL DIA ACTUAL (EN BASE A LA FECHA DEL SERVIDOR)
    -- -----------------------------------------------------
    DECLARE @CURRENT_DATE DATETIME;
    DECLARE @FREQUENCIES TABLE
    (
        [ID] INT IDENTITY(1, 1),
        [ID_FREQUENCY] INT NOT NULL
    );

    -- -----------------------------------------------------
    -- Obtenemos las frequencias del dia actual
    -- -----------------------------------------------------
    SELECT @CURRENT_DATE = GETDATE();
    INSERT INTO @FREQUENCIES
    (
        [ID_FREQUENCY]
    )
    EXEC [acsa].[SWIFT_SP_GET_FREQUENCY_X_TASK] @DATE = @CURRENT_DATE;

    -- -----------------------------------------------------
    -- Truncamos los resultados de la tabla en cada ejecucion
    -- -----------------------------------------------------
    TRUNCATE TABLE [acsa].[SONDA_STATISTIC_SALES_BY_CUSTOMER];

    -- -----------------------------------------------------
    -- Obtenemos e insertamos los resultados del promedio de ventas y su unidad de venta vendida
    -- -----------------------------------------------------
    INSERT INTO [acsa].[SONDA_STATISTIC_SALES_BY_CUSTOMER]
    (
        [CLIENT_ID],
        [CODE_SKU],
        [QTY],
        [SALE_PACK_UNIT]
    )
    SELECT [spih].[CLIENT_ID],
           MAX([spid].[SKU]) AS [CODE_SKU],
           ROUND(AVG([spid].[QTY]), 0) AS [QTY],
           MAX([spid].[SALES_PACK_UNIT]) AS [SALE_PACK_UNIT]
    FROM [acsa].[SONDA_POS_INVOICE_DETAIL] AS [spid]
        INNER JOIN [acsa].[SONDA_POS_INVOICE_HEADER] AS [spih]
            ON ([spih].[ID] = [spid].[ID])
        INNER JOIN [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] AS [sfxc]
            ON ([sfxc].[CODE_CUSTOMER] = [spih].[CLIENT_ID])
        INNER JOIN @FREQUENCIES AS [f]
            ON ([f].[ID_FREQUENCY] = [sfxc].[ID_FREQUENCY])
    WHERE [spih].[POSTED_DATETIME] BETWEEN DATEADD(wk,-@WEEKSOLD, @CURRENT_DATE) AND @CURRENT_DATE
    GROUP BY [spih].[CLIENT_ID],
             [spid].[SKU],
             [spid].[SALES_PACK_UNIT];
END;
