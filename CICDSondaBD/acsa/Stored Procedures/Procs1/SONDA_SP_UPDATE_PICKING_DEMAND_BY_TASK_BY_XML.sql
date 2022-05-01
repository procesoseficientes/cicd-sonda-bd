-- =============================================
-- Autor:				hector.gonzalez
-- Fecha de Creacion: 	17/11/2017 @ Reborn - TEAM Sprint Eberhard
-- Description:			SP que actualiza el estado de un picking en una entrega y si no existe lo agrega

-- Modificacion 		8/1/2019 @ G-Force Team Sprint Groenlandia
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 30515: Entrega a clientes con multiples direcciones
-- Descripcion: 		8/1/2019 - Se reemplaza MERGE por JOINS entre la informacion enviada por el movil
--						y la que esta actualmente en la BD

/*
-- Ejemplo de Ejecucion:
EXEC [acsa].[SONDA_SP_UPDATE_PICKING_DEMAND_BY_TASK_BY_XML]
@XML = '
<Data>
    <demandasDespachoPorTarea>        
        <pickingDemandHeaderId>15</pickingDemandHeaderId>        
        <pickingDemandStatus>PENDING</pickingDemandStatus>
        <taskId>132</taskId>        
        <isPosted>0</isPosted>                       
    </demandasDespachoPorTarea>
    <dbuser>UDIPROCOM</dbuser>
    <dbuserpass>DIPROCOMServer1237710</dbuserpass>
    <routeid>46</routeid>
    <loginId>hector@acsa</loginId>
</Data>'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_UPDATE_PICKING_DEMAND_BY_TASK_BY_XML] (@XML XML)
AS
BEGIN
    BEGIN TRY
        --
        -- ---------------------------------------------------------------
        -- Se declara tabla temporal para almacenar la informacion
        -- recibida desde el movil
        -- ---------------------------------------------------------------
        DECLARE @PICKING_DEMAND_BY_TASK TABLE
        (
            [ID] INT IDENTITY(1, 1),
            [TASK_ID] INT,
            [PICKING_DEMAND_HEADER_ID] INT,
            [IS_POSTED] INT NULL,
            [PICKING_DEMAND_STATUS] VARCHAR(250)
        );

        -- ---------------------------------------------------------------
        -- Obtenemos la informacion enviada por el movil
        -- ---------------------------------------------------------------
        INSERT INTO @PICKING_DEMAND_BY_TASK
        (
            [TASK_ID],
            [PICKING_DEMAND_HEADER_ID],
            [PICKING_DEMAND_STATUS],
            [IS_POSTED]
        )
        SELECT [x].[Rec].[query]('./taskId').[value]('.', 'int') [TASK_ID],
               [x].[Rec].[query]('./pickingDemandHeaderId').[value]('.', 'int') [PICKING_DEMAND_HEADER_ID],
               CASE [x].[Rec].[query]('./pickingDemandStatus').[value]('.', 'varchar(50)')
                   WHEN 'NULL' THEN
                       NULL
                   WHEN 'UNDEFINED' THEN
                       NULL
                   ELSE
                       [x].[Rec].[query]('./pickingDemandStatus').[value]('.', 'varchar(50)')
               END [PICKING_DEMAND_STATUS],
               2 [IS_POSTED]
        FROM @XML.[nodes]('Data/demandasDespachoPorTarea') AS [x]([Rec]);

        -- ---------------------------------------------------------------
        -- Actualizamos los registros, segun sea necesario
        -- ---------------------------------------------------------------
        UPDATE [PDBT]
        SET [PDBT].[PICKING_DEMAND_STATUS] = [SRC].[PICKING_DEMAND_STATUS],
            [PDBT].[IS_POSTED] = [SRC].[IS_POSTED]
        FROM [acsa].[SONDA_PICKING_DEMAND_BY_TASK] AS [PDBT]
            INNER JOIN @PICKING_DEMAND_BY_TASK [SRC]
                ON ([SRC].[PICKING_DEMAND_HEADER_ID] = [PDBT].[PICKING_DEMAND_HEADER_ID] AND [SRC].[TASK_ID] = [PDBT].[TASK_ID])
        WHERE [SRC].[ID] > 0;

        -- ---------------------------------------------------------------
        -- Insertamos los nuevos registros (si se tiene alguno)
        -- ---------------------------------------------------------------
        INSERT INTO [acsa].[SONDA_PICKING_DEMAND_BY_TASK]
        (
            [PICKING_DEMAND_HEADER_ID],
            [TASK_ID],
            [PICKING_DEMAND_STATUS],
            [IS_POSTED]
        )
        SELECT [SRC].[PICKING_DEMAND_HEADER_ID],
               [SRC].[TASK_ID],
               [SRC].[PICKING_DEMAND_STATUS],
               [SRC].[IS_POSTED]
        FROM @PICKING_DEMAND_BY_TASK AS [SRC]
            LEFT JOIN [acsa].[SONDA_PICKING_DEMAND_BY_TASK] AS [PDBT]
                ON ([PDBT].[PICKING_DEMAND_HEADER_ID] = [SRC].[PICKING_DEMAND_HEADER_ID])
        WHERE [PDBT].[PICKING_DEMAND_HEADER_ID] IS NULL;

        -- ---------------------------------------------------------------
        -- Se devuelve cada uno de los resultados como exitosos
        -- ---------------------------------------------------------------
        SELECT 1 AS [RESULTADO],
               [TASK_ID],
               [PICKING_DEMAND_HEADER_ID],
               2 AS [IS_POSTED],
               [PICKING_DEMAND_STATUS]
        FROM @PICKING_DEMAND_BY_TASK;

    END TRY
    BEGIN CATCH
        -- ---------------------------------------------------------------
        -- Devolvemos el resultado como fallido
        -- ---------------------------------------------------------------
        SELECT -1 AS [RESULTADO],
               ERROR_MESSAGE() [Mensaje],
               @@error [Codigo],
               0 [DbData];
    END CATCH;
END;
