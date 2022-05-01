-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	7/6/2018 @ GFORCE-Team Sprint FAISAN 
-- Description:			Guarda el reporte de todas las venta sy preventas del dia en la tabla SWIFT_DAILY_GOAL_BY_SELLER

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_SAVE_DAILY_SALE_REPORT]
				--
				SELECT * FROM [acsa].[SWIFT_DAILY_GOAL_BY_SELLER]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_SAVE_DAILY_SALE_REPORT]
AS
BEGIN
    SET NOCOUNT ON;
	--
    DECLARE @RESULT TABLE
        (
         [TEAM_ID] INT
        ,[DOC_TYPE] VARCHAR(50)
        ,[LOGIN] VARCHAR(50)
        ,[SELLER_NAME] VARCHAR(100)
        ,[DOCUMENT_QTY] INT
        ,[DOCUMENT_TOTAL] DECIMAL(18, 6)
        ,[DATE] DATE
        ,[DATE_FROM] DATETIME
        ,[DATE_TO] DATETIME
        ,[INCLUDE_SATURDAY] INT
        );
	
	-- ------------------------------------------------------------------------------------
	-- Obtiene los datos de la tareas de preventa
	-- ------------------------------------------------------------------------------------
    INSERT  INTO @RESULT
            (
             [TEAM_ID]
            ,[DOC_TYPE]
            ,[LOGIN]
            ,[SELLER_NAME]
            ,[DOCUMENT_QTY]
            ,[DOCUMENT_TOTAL]
            ,[DATE]
            ,[DATE_FROM]
            ,[DATE_TO]
            ,[INCLUDE_SATURDAY]
	        )
    SELECT
        [UT].[TEAM_ID]
       ,[T].[TASK_TYPE] [DOC_TYPE]
       ,[U].[LOGIN]
       ,[U].[NAME_USER] [SELLER_NAME]
       ,COUNT([SOH].[SALES_ORDER_ID]) [DOCUMENT_QTY]
       ,SUM([acsa].[SWIFT_FN_GET_SALES_ORDER_TOTAL]([SOH].[SALES_ORDER_ID])) [DOCUMENT_TOTAL]
       ,GETDATE()
       ,[GH].[GOAL_DATE_FROM]
       ,[GH].[GOAL_DATE_TO]
       ,[GH].[INCLUDE_SATURDAY]
    FROM
        [acsa].[SWIFT_TASKS] [T]
    INNER JOIN [acsa].[USERS] [U] ON [T].[ASSIGEND_TO] = [U].[LOGIN]
    INNER JOIN [acsa].[SWIFT_USER_BY_TEAM] [UT] ON [UT].[USER_ID] = [U].[CORRELATIVE]
    LEFT JOIN [acsa].[SONDA_SALES_ORDER_HEADER] [SOH] ON [SOH].[TASK_ID] = [T].[TASK_ID]
                                                          AND [SOH].[IS_READY_TO_SEND] = 1
    LEFT JOIN [acsa].[SWIFT_GOAL_HEADER] [GH] ON [UT].[TEAM_ID] = [GH].[TEAM_ID]
                                                  AND [GH].[SALE_TYPE] = 'PRE'
                                                  AND [T].[TASK_DATE] BETWEEN [GH].[GOAL_DATE_FROM]
                                                              AND
                                                              [GH].[GOAL_DATE_TO]
    WHERE
        FORMAT([T].[TASK_DATE], 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd')
        AND [T].[TASK_TYPE] = 'PRESALE'
    GROUP BY
        [UT].[TEAM_ID]
       ,[T].[TASK_TYPE]
       ,[U].[LOGIN]
       ,[U].[NAME_USER]
       ,[GH].[GOAL_DATE_FROM]
       ,[GH].[GOAL_DATE_TO]
       ,[GH].[INCLUDE_SATURDAY]
    HAVING
        COUNT([T].[TASK_ID]) > 0;
	
	-- ------------------------------------------------------------------------------------
	-- Obtiene los datos de las facturas
	-- ------------------------------------------------------------------------------------
    SELECT
        [U].[LOGIN]
       ,COUNT([SPH].[INVOICE_ID]) [DOCUMENT_QTY]
       ,SUM([SPH].[TOTAL_AMOUNT]) [DOCUMENT_TOTAL]
       ,MAX([SPH].[POSTED_DATETIME]) [LAST_UPDATE]
    INTO
        [#INVOICES]
    FROM
        [acsa].[SONDA_POS_INVOICE_HEADER] [SPH]
    INNER JOIN [acsa].[USERS] [U] ON [SPH].[POSTED_BY] = [U].[LOGIN]
    INNER JOIN [acsa].[SWIFT_USER_BY_TEAM] [UT] ON [UT].[USER_ID] = [U].[CORRELATIVE]
    WHERE
        FORMAT([SPH].[POSTED_DATETIME], 'yyyyMMdd') = FORMAT(GETDATE(),
                                                             'yyyyMMdd')
        AND [SPH].[IS_READY_TO_SEND] = 1
    GROUP BY
        [U].[LOGIN];

    INSERT  INTO @RESULT
            (
             [TEAM_ID]
            ,[DOC_TYPE]
            ,[LOGIN]
            ,[SELLER_NAME]
            ,[DOCUMENT_QTY]
            ,[DOCUMENT_TOTAL]
            ,[DATE]
            ,[DATE_FROM]
            ,[DATE_TO]
            ,[INCLUDE_SATURDAY]
	        )
    SELECT
        [UT].[TEAM_ID]
       ,[T].[TASK_TYPE] [DOC_TYPE]
       ,[U].[LOGIN]
       ,[U].[NAME_USER] [SELLER_NAME]
       ,ISNULL([I].[DOCUMENT_QTY], 0)
       ,ISNULL([I].[DOCUMENT_TOTAL], 0)
       ,GETDATE()
       ,[GH].[GOAL_DATE_FROM]
       ,[GH].[GOAL_DATE_TO]
       ,[GH].[INCLUDE_SATURDAY]
    FROM
        [acsa].[SWIFT_TASKS] [T]
    INNER JOIN [acsa].[USERS] [U] ON [T].[ASSIGEND_TO] = [U].[LOGIN]
    INNER JOIN [acsa].[SWIFT_USER_BY_TEAM] [UT] ON [UT].[USER_ID] = [U].[CORRELATIVE]
    LEFT JOIN [#INVOICES] [I] ON [I].[LOGIN] = [U].[LOGIN]
    LEFT JOIN [acsa].[SWIFT_GOAL_HEADER] [GH] ON [UT].[TEAM_ID] = [GH].[TEAM_ID]
                                                  AND [GH].[SALE_TYPE] = 'VEN'
                                                  AND [T].[TASK_DATE] BETWEEN [GH].[GOAL_DATE_FROM]
                                                              AND
                                                              [GH].[GOAL_DATE_TO]
    WHERE
        FORMAT([T].[TASK_DATE], 'yyyyMMdd') = FORMAT(GETDATE(), 'yyyyMMdd')
        AND [T].[TASK_TYPE] = 'SALE'
    GROUP BY
        [I].[DOCUMENT_QTY]
       ,[I].[DOCUMENT_TOTAL]
       ,[UT].[TEAM_ID]
       ,[T].[TASK_TYPE]
       ,[U].[LOGIN]
       ,[U].[NAME_USER]
       ,[GH].[GOAL_DATE_FROM]
       ,[GH].[GOAL_DATE_TO]
       ,[GH].[INCLUDE_SATURDAY]
    HAVING
        COUNT([T].[TASK_ID]) > 0;

	-- ------------------------------------------------------------------------------------
	-- Inserta en la tabla de SWIFT_DAILY_GOAL_BY_SELLER
	-- ------------------------------------------------------------------------------------
    INSERT  INTO [acsa].[SWIFT_DAILY_GOAL_BY_SELLER]
            (
             [TEAM_ID]
            ,[DOC_TYPE]
            ,[LOGIN]
            ,[SELLER_NAME]
            ,[DOCUMENT_QTY]
            ,[DOCUMENT_TOTAL]
            ,[DATE]
            ,[DAYS_LEFT]
            ,[DAYS_PASSED]
            )
    SELECT
        [TEAM_ID]
       ,[DOC_TYPE]
       ,[LOGIN]
       ,[SELLER_NAME]
       ,ISNULL([DOCUMENT_QTY], 0)
       ,ISNULL([DOCUMENT_TOTAL], 0)
       ,[DATE]
       ,[acsa].[SWIFT_FN_GET_GOAL_WORK_DAYS]([DATE],
                                              '2018-08-01 00:00:00.000', 1)
       ,[acsa].[SWIFT_FN_GET_GOAL_WORK_DAYS]('2018-07-01 00:00:00.000',
                                              [DATE], 1)
    FROM
        @RESULT;
END;
