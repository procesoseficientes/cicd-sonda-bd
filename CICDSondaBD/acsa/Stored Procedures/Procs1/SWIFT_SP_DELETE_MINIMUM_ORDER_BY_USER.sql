-- =============================================
-- Autor:					jonathan.salvador
-- Fecha de Creacion: 		10/23/2019 
-- Description:			    SP que elimina los registros de pedido minimo por usuario
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_MINIMUM_ORDER_BY_USER]
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
            [LOGIN] VARCHAR(50)
        );

        -- -------------------------------------------------------------------------------
        -- Obtenemos los datos que se enviaron desde XML
        -- -------------------------------------------------------------------------------

        INSERT INTO @ORDERS_UPDATED
        (
            [LOGIN]
        )
        SELECT [x].[Rec].[query]('./USER').[value]('.', 'varchar(50)')
        FROM @XML.[nodes]('ArrayOfPedidoMinimo/PedidoMinimo') AS [x]([Rec]);

        -- -------------------------------------------------------------------------------
        -- Se elimina el pedido minimo por usuario
        -- -------------------------------------------------------------------------------

        DELETE FROM [acsa].[SWIFT_MINIMUM_ORDER_BY_USER]
        WHERE [USER] IN
              (
                  SELECT [LOGIN] FROM @ORDERS_UPDATED
              );

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
