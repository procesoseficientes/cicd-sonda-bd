-- =============================================
-- Autor:					jonathan.salvador
-- Fecha de Creacion: 		10/23/2019 
-- Description:			    SP que actualiza el monto de pedido minimo por usuario

-- =============================================

CREATE PROCEDURE [acsa].[SWIFT_SP_UPDATE_MINIMUM_ORDERT_BY_USER]
(@XML XML)
AS
BEGIN
    -- ------------------------------------------------------------------
    -- Inicia proceso
    -- ------------------------------------------------------------------
    BEGIN TRY

        -- -------------------------------------------------------------------------------
        -- Tabla que almacena la informacion obtenida desde XML
        -- -------------------------------------------------------------------------------
        DECLARE @ORDERS_UPDATED TABLE
        (
            [LOGIN] VARCHAR(50),
            [MINIMUM_AMOUNT] NUMERIC(10, 4)
        );

        -- -------------------------------------------------------------------------------
        -- Obtenemos los datos que se enviaron desde XML
        -- -------------------------------------------------------------------------------

        INSERT INTO @ORDERS_UPDATED
        (
            [LOGIN],
            [MINIMUM_AMOUNT]
        )
        SELECT [x].[Rec].[query]('./USER').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./MINIMUM_ORDER').[value]('.', 'numeric(10,4)')
        FROM @XML.[nodes]('ArrayOfPedidoMinimo/PedidoMinimo') AS [x]([Rec]);

        -- -------------------------------------------------------------------------------
        -- Actualizamos el monto de pedido minimo por usuario
        -- -------------------------------------------------------------------------------

        UPDATE [MOU]
        SET [MOU].[MINIMUM_ORDER] = [OU].[MINIMUM_AMOUNT]
        FROM [acsa].[SWIFT_MINIMUM_ORDER_BY_USER] AS [MOU]
            INNER JOIN @ORDERS_UPDATED AS [OU]
                ON [MOU].[USER] = [OU].[LOGIN]
        WHERE [MOU].[USER] = [OU].[LOGIN];

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
