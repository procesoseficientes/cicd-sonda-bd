-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	7/5/2018 @ GFORCE-Team Sprint Faisan 
-- Description:			Obtiene el reporte semanal de ventas por vendedor

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_WEEKLY_GOAL_REPORT_BY_SELLER] @LOGIN = 'adolfo@acsa',
			@TASK_TYPE = 'PRESALE'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_WEEKLY_GOAL_REPORT_BY_SELLER]
    (
     @LOGIN VARCHAR(50)
    ,@TASK_TYPE VARCHAR(15)
    )
AS
BEGIN
    SET NOCOUNT ON;
	--
    SELECT
       [DG].[DOC_TYPE]
       ,[DG].[LOGIN]
       ,[DG].[SELLER_NAME]
       ,[DG].[DOCUMENT_QTY]
       ,[DG].[DOCUMENT_TOTAL]
       ,DATENAME(WEEKDAY, [DG].[DATE]) [WEEKDAY]
    FROM
        [acsa].[SWIFT_DAILY_GOAL_BY_SELLER] [DG]
    INNER JOIN [acsa].[SWIFT_GOAL_HEADER] [GH] ON [GH].[TEAM_ID] = [DG].[TEAM_ID]
                                                   AND [GH].[STATUS] = 1
                                                   AND [DG].[DATE] BETWEEN [GH].[GOAL_DATE_FROM]
                                                              AND
                                                              [GH].[GOAL_DATE_TO]
    INNER JOIN [acsa].[USERS] [U] ON [U].[LOGIN] = [DG].[LOGIN]
    INNER JOIN [acsa].[SWIFT_TEAM] [T] ON [T].[TEAM_ID] = [DG].[TEAM_ID]
    INNER JOIN [acsa].[SWIFT_GOAL_DETAIL] [GD] ON [GD].[GOAL_HEADER_ID] = [GH].[GOAL_HEADER_ID]
                                                   AND [U].[CORRELATIVE] = [GD].[SELLER_ID]
    WHERE
        [DG].[LOGIN] = @LOGIN
        AND [DG].[DOC_TYPE] = @TASK_TYPE
        AND DATEPART(WEEK, [DG].[DATE]) = DATEPART(WEEK, GETDATE());
END;
