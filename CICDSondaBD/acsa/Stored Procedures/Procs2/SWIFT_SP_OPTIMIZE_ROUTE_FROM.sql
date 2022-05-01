-- =============================================
-- Autor:				Denis.Villagran
-- Fecha de Creacion: 	12-09-2019
-- Description:			SP que reordena los clientes a partir de uno especifico al que se le ha cambiado la prioridad

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_OPTIMIZE_ROUTE_FROM]  
				@NEW_SEQUENCE = 1, 
				@CODE_ROUTE = 99, 
				@CODE_CUSTOMER = 'SO-156876', 
				@DAY = 6, 
				@TYPE_TASK = 'SALE'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_OPTIMIZE_ROUTE_FROM]
    @NEW_SEQUENCE INT,
    @CODE_ROUTE VARCHAR(50),
    @CODE_CUSTOMER VARCHAR(50),
    @DAY INT,
    @TYPE_TASK VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    -----------------------------------
    CREATE TABLE [#CUSTOMERS]
    (
        [ID_FREQUENCY] INT,
        [CODE_CUSTOMER] VARCHAR(50),
        [PRIORITY] INT,
        [GPS] VARCHAR(50),
        [DISTANCE] NUMERIC(18, 6)
    );
    -----------------------------------
    DECLARE @PRIORITY INT,
            @GPS_CUSTOMER VARCHAR(50),
            @DISTANCE FLOAT,
            @ID_FREQUENCY INT;

    BEGIN TRAN;
    BEGIN TRY
        -- ------------------------------------------------------------------------------------------------------------------------- --
        -- OBTENGO LOS PARÁMETROS INICIALES NECESARIOS PARA LAS COMPARACIONES ENTRE TABLAS Y PARA TENER LA LOCALIZACIÓN A PARTIR DE  --
        -- LA CUAL OPTIMIZAREMOS LA RUTA DEL VENDEDOR                                                                                --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        SELECT @GPS_CUSTOMER = [C].[GPS],
               @ID_FREQUENCY = [FC].[ID_FREQUENCY]
        FROM [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] [FC]
            INNER JOIN [acsa].[SWIFT_VIEW_ALL_COSTUMER] [C]
                ON ([FC].[CODE_CUSTOMER] = [C].[CODE_CUSTOMER])
            INNER JOIN [acsa].[SWIFT_FREQUENCY] [F]
                ON ([FC].[ID_FREQUENCY] = [F].[ID_FREQUENCY])
        WHERE [F].[TYPE_TASK] = @TYPE_TASK
              AND [FC].[CODE_CUSTOMER] = @CODE_CUSTOMER
        ORDER BY [PRIORITY];

        -- ------------------------------------------------------------------------------------------------------------------------- --
        -- MANDO A LLAMAR LAS FRECUENCIAS A PARTIR DE LAS CUALES SE REALIZARÁ LA LISTA DE CLIENTES                                   --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        SELECT DISTINCT
               [F].[ID_FREQUENCY],
               [F].[CODE_ROUTE],
               [F].[TYPE_TASK]
        INTO [#FREQUENCIES]
        FROM [acsa].[SWIFT_FREQUENCY] [F]
        WHERE (CASE @DAY
                   WHEN 1 THEN
                       [F].[SUNDAY]
                   WHEN 2 THEN
                       [F].[MONDAY]
                   WHEN 3 THEN
                       [F].[TUESDAY]
                   WHEN 4 THEN
                       [F].[WEDNESDAY]
                   WHEN 5 THEN
                       [F].[THURSDAY]
                   WHEN 6 THEN
                       [F].[FRIDAY]
                   WHEN 7 THEN
                       [F].[SATURDAY]
               END
              ) = 1
              AND [CODE_ROUTE] = @CODE_ROUTE;

        -- ------------------------------------------------------------------------------------------------------------------------- --
        -- ACTUALIZO EL REGISTRO QUE SOLICITÓ MODIFICAR EL VENDEDOR CON LA SECUENCIA REQUERIDA POR EL MISMO                          --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        UPDATE [acsa].[SWIFT_FREQUENCY_X_CUSTOMER]
        SET [PRIORITY] = @NEW_SEQUENCE
        FROM [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] [FC]
            INNER JOIN [acsa].[SWIFT_FREQUENCY] [F]
                ON ([FC].[ID_FREQUENCY] = [F].[ID_FREQUENCY])
        WHERE [CODE_CUSTOMER] = @CODE_CUSTOMER
              AND [F].[TYPE_TASK] = @TYPE_TASK;

        -- ------------------------------------------------------------------------------------------------------------------------- --
        -- INSERTO LOS CLIENTES EN UNA TABLA PARA PODER RECORRER LA TABLA Y ASÍ REALIZAR LA OPTIMIZACIÓN DE LA RUTA                  --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        INSERT INTO [#CUSTOMERS]
        SELECT DISTINCT
               [FC].[ID_FREQUENCY],
               [FC].[CODE_CUSTOMER],
               [FC].[PRIORITY],
               [C].[GPS],
               [dbo].[SONDA_FN_CALCULATE_DISTANCE](@GPS_CUSTOMER, [C].[GPS]) AS [DISTANCE]
        FROM [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] [FC]
            INNER JOIN [acsa].[SWIFT_VIEW_ALL_COSTUMER] [C]
                ON ([FC].[CODE_CUSTOMER] = [C].[CODE_CUSTOMER])
            INNER JOIN [#FREQUENCIES] [F]
                ON ([F].[ID_FREQUENCY] = [FC].[ID_FREQUENCY])
        WHERE [FC].[PRIORITY] >= @NEW_SEQUENCE
              AND [F].[TYPE_TASK] = @TYPE_TASK
              AND [FC].[CODE_CUSTOMER] != @CODE_CUSTOMER
        ORDER BY [DISTANCE];

        PRINT '------------------------------------------------';
        PRINT '@ID_FREQUENCY: ' + CAST(@ID_FREQUENCY AS VARCHAR);
        PRINT '@CODE_ROUTE: ' + @CODE_ROUTE;
        PRINT '@GPS_CUSTOMER: ' + @GPS_CUSTOMER;
        PRINT '@CODE_CUSTOMER: ' + @CODE_CUSTOMER;
        PRINT '@PRIORITY: ' + CAST(@PRIORITY AS VARCHAR);

        -- ------------------------------------------------------------------------------------------------------------------------- --
        --	RECORRO LA TABLA DE LOS CLIENTES PARA REALIZAR LE MEDIDA DE DISTANCIAS Y HACER LA OPTIMIZACIÓN                            --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        WHILE EXISTS (SELECT TOP 1 1 FROM [#CUSTOMERS])
        BEGIN
            DECLARE @CODE_CUST VARCHAR(50);

            -- ------------------------------------------------------------------------------------------------------------------------- --
            --	OBTENGO LOS DATOS NECESARIOS PARA MANDARLOS AL SP QUE REALIZARÁ LA ACTUALIZACIÓN DE LA PRIORIDAD DEL CLIENTE              --
            -- ------------------------------------------------------------------------------------------------------------------------- --
            SELECT TOP 1
                   @NEW_SEQUENCE += 1,
                   @ID_FREQUENCY = [ID_FREQUENCY],
                   @CODE_CUST = [CODE_CUSTOMER],
                   @PRIORITY = @NEW_SEQUENCE,
                   @DISTANCE = [DISTANCE],
                   @GPS_CUSTOMER = [GPS]
            FROM [#CUSTOMERS]
            ORDER BY [DISTANCE];

            PRINT '------------------------------------------------';
            PRINT '@ID_FREQUENCY: ' + CAST(@ID_FREQUENCY AS VARCHAR);
            PRINT '@CODE_ROUTE: ' + @CODE_ROUTE;
            PRINT '@GPS_CUSTOMER: ' + @GPS_CUSTOMER;
            PRINT '@CODE_CUSTOMER: ' + @CODE_CUST;
            PRINT '@PRIORITY: ' + CAST(@PRIORITY AS VARCHAR);

            -- ------------------------------------------------------------------------------------------------------------------------- --
            --	SP QUE REALIZA LA ACTUALIZACIÓN DE LA PRIORIDAD DEL CLIENTE                                                               --
            -- ------------------------------------------------------------------------------------------------------------------------- --
            EXEC [acsa].[SWIFT_SP_SET_CUSTOMER_PRIORITY_IN_FREQUENCY] @ID_FREQUENCY,
                                                                       @CODE_CUST,
                                                                       @PRIORITY,
                                                                       @DISTANCE;

            -- ------------------------------------------------------------------------------------------------------------------------- --
            --	ELIMIN EL PRIMER CLIENTE PARA SEGUIR ACTUALIZANDO DESDE EL QUE SIGUE                                                      --
            -- ------------------------------------------------------------------------------------------------------------------------- --
            DELETE FROM [#CUSTOMERS]
            WHERE [CODE_CUSTOMER] = @CODE_CUST;

            -- ------------------------------------------------------------------------------------------------------------------------- --
            --	ACTUALIZO LAS DISTANCIAS ENTRE EL ANTERIOR PUNTO Y LOS DEMÁS PARA ENCONTRAR EL NUEVO PUNTO MÁS CERCANO                    --
            -- ------------------------------------------------------------------------------------------------------------------------- --
            UPDATE [#CUSTOMERS]
            SET [DISTANCE] = [dbo].[SONDA_FN_CALCULATE_DISTANCE](@GPS_CUSTOMER, [GPS]);
        END;
        COMMIT;

        SELECT 1 AS [Resultado],
               'Proceso Exitoso' [Mensaje],
               0 [Codigo],
               '0' [DbData];
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK;
        END;
        DECLARE @ERROR VARCHAR(1000) = ERROR_MESSAGE();
        SELECT -1 AS [Resultado],
               @ERROR [Mensaje],
               0 [Codigo],
               '0' [DbData];
    END CATCH;
END;
