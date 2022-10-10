-- =============================================
-- Autor:				Denis.Villagran
-- Fecha de Creacion: 	16-Sep-2019 
-- Description:			Obtiene la cantidad de clientes por codigo de vendedor

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_COUNT_CUSTOMER_IN_ROUTE_BY_SELLER]
					@LOGIN = 'gerente@acsa'
					,@SELLER_ROUTE = '-1'
				--
				EXEC [acsa].[SWIFT_SP_GET_COUNT_CUSTOMER_IN_ROUTE_BY_SELLER]
					@LOGIN = 'gerente@acsa'
					,@SELLER_ROUTE = '-1|1'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_COUNT_CUSTOMER_IN_ROUTE_BY_SELLER]
(
    @LOGIN VARCHAR(50),
    @SELLER_CODE VARCHAR(4000)
)
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE @DELIMITER CHAR(1),
            @DAY_NUMBER INT,
            @QUERY NVARCHAR(2000),
            @NAME_COL VARCHAR(200);

    -- ------------------------------------------------------------------------------------
    -- Coloca parametros iniciales
    --------------------------------------------------------------------------------------
    SELECT @DELIMITER = [acsa].[SWIFT_FN_GET_PARAMETER]('DELIMITER', 'DEFAULT_DELIMITER'),
           @DAY_NUMBER = 0,
           @NAME_COL = '';

    -- ------------------------------------------------------------------------------------
    -- Obtiene los vendedores a filtrar
    -- ------------------------------------------------------------------------------------
    SELECT DISTINCT
           [SS].[SELLER_CODE],
           [SS].[SELLER_NAME]
    INTO [#SELLER]
    FROM [acsa].[Split](@SELLER_CODE, @DELIMITER) [S]
        INNER JOIN [acsa].[SWIFT_SELLER] [SS]
            ON ([SS].[SELLER_CODE] = [S].[Data]);

    -- ------------------------------------------------------------------------------------
    -- Obtiene las rutas que puede ver el login
    -- ------------------------------------------------------------------------------------
    SELECT [RUS].[CODE_ROUTE]
    INTO [#ROUTE]
    FROM [acsa].[SWIFT_ROUTE_BY_USER] [RUS]
    WHERE [RUS].[LOGIN] = @LOGIN;

    -- ------------------------------------------------------------------------------------
    -- Obtiene las frecuencias
    -- ------------------------------------------------------------------------------------
       SELECT DISTINCT
           f.[ID_FREQUENCY]
    INTO [#FREQUENCY]
    FROM acsa.[SWIFT_FREQUENCY] f
        INNER JOIN acsa.[SWIFT_ROUTES] [R]
            ON ([R].[CODE_ROUTE] = f.[CODE_ROUTE])
        INNER JOIN [#SELLER] [S]
            ON ([S].[SELLER_CODE] = [R].[SELLER_CODE])
        INNER JOIN [#ROUTE] [RUS]
            ON ([RUS].[CODE_ROUTE] = [R].[CODE_ROUTE]);

    -- ------------------------------------------------------------------------------------
    -- Obtiene la cantidad de clientes por dia
    -- ------------------------------------------------------------------------------------
    SELECT DISTINCT
           [F].[CODE_ROUTE],
           [F].[TYPE_TASK],
           [F].[FREQUENCY_WEEKS],
           SUM([F].[SUNDAY]) [SUNDAY],
           SUM([F].[MONDAY]) [MONDAY],
           SUM([F].[TUESDAY]) [TUESDAY],
           SUM([F].[WEDNESDAY]) [WEDNESDAY],
           SUM([F].[THURSDAY]) [THURSDAY],
           SUM([F].[FRIDAY]) [FRIDAY],
           SUM([F].[SATURDAY]) [SATURDAY]
    INTO [#CUSTOMER_BY_DAY]
    FROM acsa.[SWIFT_FREQUENCY_X_CUSTOMER] [FC] 
        INNER JOIN acsa.[SWIFT_FREQUENCY] [F]
            ON ([FC].[ID_FREQUENCY] = [F].[ID_FREQUENCY])
        INNER JOIN [#FREQUENCY] [TF]
            ON ([TF].[ID_FREQUENCY] = [FC].[ID_FREQUENCY])
    GROUP BY [F].[CODE_ROUTE],
             [F].[TYPE_TASK],
             [F].[FREQUENCY_WEEKS]
    ORDER BY [F].[CODE_ROUTE],
             [F].[TYPE_TASK],
             [F].[FREQUENCY_WEEKS];


    -- ------------------------------------------------------------------------------------
    -- Obtiene los datos generales
    -- ------------------------------------------------------------------------------------
    SELECT DISTINCT
           [S].[SELLER_CODE],
           [S].[SELLER_NAME],
           [R].[CODE_ROUTE],
           [R].[NAME_ROUTE],
           CASE CAST([PBR].[IS_MULTIPOLYGON] AS VARCHAR)
               WHEN '0' THEN
                   'Multi-Frecuencia'
               ELSE
                   'Frecuencia Unica'
           END [POLYGON_TYPE]
    INTO [#INFO]
    FROM acsa.[SWIFT_POLYGON_BY_ROUTE] [PBR]
        INNER JOIN ACSA.[SWIFT_ROUTES] [R]
            ON ([R].[ROUTE] = [PBR].[ROUTE])
        INNER JOIN [#SELLER] [S]
            ON ([S].[SELLER_CODE] = [R].[SELLER_CODE])
        INNER JOIN [#ROUTE] [RUS]
            ON ([RUS].[CODE_ROUTE] = [R].[CODE_ROUTE]);


    -- ------------------------------------------------------------------------------------
    -- Muestra el resultado
    -- ------------------------------------------------------------------------------------
    SELECT [I].[SELLER_CODE],
           [I].[SELLER_NAME],
           [I].[CODE_ROUTE],
           [I].[NAME_ROUTE],
           [CBD].[TYPE_TASK], --ISNULL([CBD].[TYPE_TASK],'NA') [TYPE_TASK]
           ISNULL(2, 0) [FREQUENCY_WEEKS],
           ISNULL([CBD].[SUNDAY], 0) [SUNDAY],
           ISNULL([CBD].[MONDAY], 0) [MONDAY],
           ISNULL([CBD].[TUESDAY], 0) [TUESDAY],
           ISNULL([CBD].[WEDNESDAY], 0) [WEDNESDAY],
           ISNULL([CBD].[THURSDAY], 0) [THURSDAY],
           ISNULL([CBD].[FRIDAY], 0) [FRIDAY],
           ISNULL([CBD].[SATURDAY], 0) [SATURDAY]
    FROM [#INFO] [I]
        LEFT JOIN [#CUSTOMER_BY_DAY] [CBD]
            ON ([CBD].[CODE_ROUTE] = [I].[CODE_ROUTE]);
END;
