-- =============================================
-- Autor:				Denis.Villagran
-- Fecha de Creacion: 	12-09-2019
-- Description:			SP que obtiene rutas solicitadas por XML

/* Ejemplo de ejecucion
	 
	 EXEC acsa.[SWIFT_SP_GET_ROUTES_SELECTED] 
	 @XML =
	'<Data>
	<routes>
	<CodeRoute>46</CodeRoute>
	</routes>
	</Data>'


	*/
--
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ROUTES_SELECTED] @XML XML
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RUTAS_SELECCIONADAS TABLE
    (
        [ROUTE] [INT],
        [CODE_ROUTE] [VARCHAR](50),
        [NAME_ROUTE] [VARCHAR](50),
        [GEOREFERENCE_ROUTE] [VARCHAR](50),
        [COMMENT_ROUTE] [VARCHAR](MAX),
        [LAST_UPDATE] [DATETIME],
        [LAST_UPDATE_BY] [VARCHAR](50),
        [IS_ACTIVE_ROUTE] [INT],
        [CODE_COUNTRY] [VARCHAR](250),
        [NAME_COUNTRY] [VARCHAR](250),
        [SELLER_CODE] [VARCHAR](50),
        [TRADE_AGREEMENT_ID] [INT]
    );

    -----
    BEGIN TRY
        -- ------------------------------------------------------------------------------------------------------------------------- --
        --	OBTENGO LAS RUTAS QUE SE MANDARON A TRAVÉS DE XML                                                                         --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        INSERT INTO @RUTAS_SELECCIONADAS
        (
            [ROUTE],
            [CODE_ROUTE],
            [NAME_ROUTE],
            [GEOREFERENCE_ROUTE],
            [COMMENT_ROUTE],
            [LAST_UPDATE],
            [LAST_UPDATE_BY],
            [IS_ACTIVE_ROUTE],
            [CODE_COUNTRY],
            [NAME_COUNTRY],
            [SELLER_CODE],
            [TRADE_AGREEMENT_ID]
        )
        SELECT [x].[Rec].[query]('./Route').[value]('.', 'int'),
               [x].[Rec].[query]('./CodeRoute').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./NameRoute').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./GeoreferenceRoute').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./CommentRoute').[value]('.', 'varchar(MAX)'),
               [x].[Rec].[query]('./LastUpdate').[value]('.', 'datetime'),
               [x].[Rec].[query]('./LastUpdateBy').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./IsActiveRoute').[value]('.', 'int'),
               [x].[Rec].[query]('./CodeCountry').[value]('.', 'varchar(250)'),
               [x].[Rec].[query]('./NameCountry').[value]('.', 'varchar(250)'),
               [x].[Rec].[query]('./SellerCode').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./TradeAgreementId').[value]('.', 'int')
        FROM @XML.[nodes]('Data/routes') AS [x]([Rec]);

        -- ------------------------------------------------------------------------------------------------------------------------- --
        --	DEVUELVO LAS RUTAS AGRUPADAS POR TIPO DE TAREA                                                                            --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        SELECT DISTINCT
               [F].[CODE_ROUTE],
               [R].[NAME_ROUTE],
               [F].[TYPE_TASK],
               SUM([F].[SUNDAY]) [SUNDAY],
               SUM([F].[MONDAY]) [MONDAY],
               SUM([F].[TUESDAY]) [TUESDAY],
               SUM([F].[WEDNESDAY]) [WEDNESDAY],
               SUM([F].[THURSDAY]) [THURSDAY],
               SUM([F].[FRIDAY]) [FRIDAY],
               SUM([F].[SATURDAY]) [SATURDAY]
        FROM @RUTAS_SELECCIONADAS [RS]
            INNER JOIN [acsa].[SWIFT_FREQUENCY] [F]
                ON ([RS].[CODE_ROUTE] = [F].[CODE_ROUTE])
            INNER JOIN [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] [FC]
                ON ([F].[ID_FREQUENCY] = [FC].[ID_FREQUENCY])
            INNER JOIN [acsa].[SWIFT_ROUTES] [R]
                ON ([F].[CODE_ROUTE] = [R].[CODE_ROUTE])
        GROUP BY [F].[TYPE_TASK],
                 [F].[CODE_ROUTE],
                 [R].[NAME_ROUTE]
        ORDER BY 3 ASC;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @ERROR VARCHAR(1000) = ERROR_MESSAGE();
        PRINT 'CATCH: ' + @ERROR;
        RAISERROR(@ERROR, 16, 1);
    END CATCH;
END;
