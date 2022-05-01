-- =============================================
-- Autor:				Denis.Villagran
-- Fecha de Creacion: 	12-09-2019
-- Description:			SP que obtiene los clientes y sus frecuencias por codigo de ruta

/* Ejemplo de ejecucion
	 
	EXEC [acsa].[SWIFT_SP_GET_FREQUENCIES_BY_ROUTE] 
					@CODE_ROUTE = '99'
					,@TYPE_TASK = 'PRESALE'
					,@DAY = 3

	*/

-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_FREQUENCIES_BY_ROUTE]
    @CODE_ROUTE VARCHAR(50),
    @TYPE_TASK VARCHAR(50),
    @DAY INT
AS
BEGIN
    BEGIN TRY
        -- ------------------------------------------------------------------------------------------------------------------------- --
        --	OBTENGO LAS FRECUENCIAS QUE ESTÁN DENTRO DE ESA RUTA                                                                      --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        SELECT [F].[ID_FREQUENCY],
               [F].[CODE_ROUTE],
               [F].[TYPE_TASK],
               @DAY [DAY]
        INTO [#FREQUENCIES]
        FROM [acsa].[SWIFT_FREQUENCY] [F]
            INNER JOIN [acsa].[SWIFT_FREQUENCY_BY_POLYGON] [PBR]
                ON ([PBR].[ID_FREQUENCY] = [F].[ID_FREQUENCY])
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
        --	DEVUELVO LAS RUTAS AGRUPADAS POR TIPO DE TAREA                                                                            --
        -- ------------------------------------------------------------------------------------------------------------------------- --
        SELECT [FC].[CODE_CUSTOMER],
               [C].[NAME_CUSTOMER],
               [FC].[PRIORITY],
               [C].[GPS],
               [F].[TYPE_TASK],
               [F].[CODE_ROUTE],
               [F].[DAY],
               [C].[LATITUDE],
               [C].[LONGITUDE]
        FROM [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] [FC]
            INNER JOIN [acsa].[SWIFT_VIEW_ALL_COSTUMER] [C]
                ON ([FC].[CODE_CUSTOMER] = [C].[CODE_CUSTOMER])
            INNER JOIN [#FREQUENCIES] [F]
                ON ([F].[ID_FREQUENCY] = [FC].[ID_FREQUENCY])
        WHERE [F].[TYPE_TASK] = @TYPE_TASK
        ORDER BY [PRIORITY];

    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @ERROR VARCHAR(1000) = ERROR_MESSAGE();
        PRINT 'CATCH: ' + @ERROR;
        RAISERROR(@ERROR, 16, 1);
    END CATCH;
END;
