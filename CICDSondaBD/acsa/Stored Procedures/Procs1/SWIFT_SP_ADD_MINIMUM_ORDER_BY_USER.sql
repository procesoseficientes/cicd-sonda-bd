-- =============================================
-- Autor:				Jonathan.Salvador
-- Fecha de Creacion: 	18-10-2019 
-- Description:			SP que agrega pedido minimo por usuario por medio de XML
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_ADD_MINIMUM_ORDER_BY_USER]
(@XML XML)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY

        --
        -- -------------------------------------------------------------------------------
        -- Tabla para almacenar la informacion obtenida por XML
        -- -------------------------------------------------------------------------------
        DECLARE @ORDERS TABLE
        (
            [LOGIN] VARCHAR(50),
            [MINIMUM_AMOUNT] NUMERIC(10, 4)
        );
        --

        -- -------------------------------------------------------------------------------
        -- Obtenemos los datos que se enviaron por XML
        -- -------------------------------------------------------------------------------
        INSERT INTO @ORDERS
        (
            [LOGIN],
            [MINIMUM_AMOUNT]
        )
        SELECT [x].[Rec].[query]('./USER').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./MINIMUM_ORDER').[value]('.', 'numeric(10,4)')
        FROM @XML.[nodes]('ArrayOfPedidoMinimo/PedidoMinimo') AS [x]([Rec]);

        INSERT INTO [acsa].[SWIFT_MINIMUM_ORDER_BY_USER]
        (
            [USER],
            [MINIMUM_ORDER]
        )
        SELECT [LOGIN],
               [MINIMUM_AMOUNT]
        FROM @ORDERS;


        -- -------------------------------------------------------------------------------
        -- Se obtiene un resultado exitoso o si ocurrio algun error
        -- -------------------------------------------------------------------------------
        SELECT 1 AS [Resultado],
               'Proceso Exitoso' [Mensaje],
               0 [Codigo],
               '0' [DbData];
    END TRY
    BEGIN CATCH
        DECLARE @ERROR VARCHAR(1000) = ERROR_MESSAGE();
        SELECT -1 AS [Resultado],
               @ERROR [Mensaje],
               0 [Codigo],
               '0' [DbData];
    END CATCH;
END;
