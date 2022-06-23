-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		14-06-2016
-- Description:			    SP para el reporte de complimiento de ruta

/*
-- Ejemplo de Ejecucion:
				--
				EXEC [acsa].[SWIFT_SP_GET_COMPLIANCE_ROUTE]
					@TASK_DATE = '20160623'
					,@CODE_ROUTE = 'rudi@acsa'
				--
				EXEC [acsa].[SWIFT_SP_GET_COMPLIANCE_ROUTE]
					@TASK_DATE = '20160614'
					,@CODE_ROUTE = 'rudi@acsa|oper1@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_COMPLIANCE_ROUTE]
	@TASK_DATE DATE
	,@CODE_ROUTE VARCHAR(4000)
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE 
		@DELIMITER CHAR(1)
		,@DEFAULT_DISPLAY_DECIMALS INT
		,@QUERY NVARCHAR(2000)

	-- ------------------------------------------------------------------------------------
	-- Coloca parametros iniciales
	--------------------------------------------------------------------------------------
	SELECT 
		@DELIMITER = [acsa].SWIFT_FN_GET_PARAMETER('DELIMITER','DEFAULT_DELIMITER')
		,@DEFAULT_DISPLAY_DECIMALS = [acsa].[SWIFT_FN_GET_PARAMETER]('CALCULATION_RULES','DEFAULT_DISPLAY_DECIMALS')

	-- ------------------------------------------------------------------------------------
	-- Obtiene las rutas a filtrar
	-- ------------------------------------------------------------------------------------
	SELECT [Data] [CODE_ROUTE]
	INTO #ROUTE
	FROM [acsa].[Split](@CODE_ROUTE,@DELIMITER)
	--FROM [acsa].[SWIFT_FN_SPLIT](@CODE_ROUTE,@DELIMITER)

	-- ------------------------------------------------------------------------------------
	-- Obtiene las tareas filtradas
	-- ------------------------------------------------------------------------------------
	SELECT 
		[T].[TASK_ID]
		,[T].[TASK_TYPE]
		,CASE [T].[TASK_TYPE]
			WHEN 'PRESALE' THEN 'Preventa'
			WHEN 'TAKE_INVENTORY' THEN 'Toma de Inventario'
			WHEN 'SALE' THEN 'Venda Directa'
			ELSE [T].[TASK_TYPE]
		END [TASK_TYPE_DESCIPTION]
		,[T].[SCHEDULE_FOR]
		,[T].[ASSIGEND_TO]
		,CONCAT([T].[COSTUMER_CODE],'-',[T].[COSTUMER_NAME]) [NAME_USER]
		,[R].[CODE_ROUTE]
		,[R].[NAME_ROUTE]
		,[T].[TASK_STATUS]
		,CASE [T].[TASK_STATUS]
			WHEN 'ASSIGNED' THEN 'Asignada'
			WHEN 'ACCEPTED' THEN 'Aceptada'
			WHEN 'COMPLETED' THEN 'Completada'
			ELSE [T].[TASK_STATUS]
		END [TASK_STATUS_DESCIPTION]
		,[T].[COSTUMER_CODE]
		,[T].[COSTUMER_NAME]
		,[T].[CUSTOMER_PHONE]
		,[T].[TASK_ADDRESS]
		,[T].[COMPLETED_SUCCESSFULLY]
		,CASE 
			WHEN CAST([T].[COMPLETED_SUCCESSFULLY] AS VARCHAR) IS NULL THEN 'Sin Operar'
			WHEN CAST([T].[COMPLETED_SUCCESSFULLY] AS VARCHAR) = '1' THEN 'Realizo Gestión'			
			ELSE ISNULL([T].[REASON] ,'Sin Razón')
		END [COMPLETED_SUCCESSFULLY_DESCRIPTION]
		,ISNULL([T].[REASON],'Sin Razón') [REASON_TYPE]
		,ISNULL([T].[REASON] ,'Sin Razón') [REASON]
		,[T].[ACCEPTED_STAMP]
		,[T].[COMPLETED_STAMP]
		,DATEDIFF(MINUTE,[T].[ACCEPTED_STAMP],[T].[COMPLETED_STAMP]) LAPSE_TIME
	INTO #TASK
	FROM [acsa].[SWIFT_TASKS] [T]
	INNER JOIN [acsa].[USERS] [U] ON (
		[T].[ASSIGEND_TO] = [U].[LOGIN]
	)
	INNER JOIN [#ROUTE] [F] ON (
		[U].[SELLER_ROUTE] = [F].[CODE_ROUTE]
	)
	INNER JOIN [acsa].[SWIFT_ROUTES] [R] ON (
		[U].[SELLER_ROUTE] = [R].[CODE_ROUTE]
	)
	WHERE [T].[SCHEDULE_FOR] = @TASK_DATE
		AND [T].[TASK_TYPE] NOT IN ('RECEPTION','PICKING','DRAFT')

	-- ------------------------------------------------------------------------------------
	-- Obtiene el monto por tarea de preventa
	-- ------------------------------------------------------------------------------------
	SELECT
		[T].[TASK_ID]
		,SUM([H].[TOTAL_AMOUNT]) [TOTAL_AMOUNT]
	INTO #SALES_ORDER
	FROM [acsa].[SONDA_SALES_ORDER_HEADER] [H]
	INNER JOIN [#TASK] [T] ON (
		[T].[TASK_ID] = [H].[TASK_ID]
	)
	WHERE [H].IS_READY_TO_SEND=1
	GROUP BY [T].[TASK_ID]

	INSERT INTO [#SALES_ORDER]
	SELECT
		[T].[TASK_ID]
		,SUM([H].[TOTAL_AMOUNT]) [TOTAL_AMOUNT]
	FROM [acsa].[SONDA_POS_INVOICE_HEADER] [H]
	INNER JOIN [#TASK] [T] 
		ON ([T].[COSTUMER_CODE] = [H].[CLIENT_ID] 
			AND CAST([T].[SCHEDULE_FOR] AS DATE) = CAST([H].[POSTED_DATETIME] AS DATE) )
	WHERE [H].[IS_READY_TO_SEND] = 1 AND CAST([H].[POSTED_DATETIME] AS DATE) = @TASK_DATE
	GROUP BY [T].[TASK_ID]

	-- ------------------------------------------------------------------------------------
	-- Muestra el resultado
	-- ------------------------------------------------------------------------------------
	SET @QUERY = N'
	SELECT DISTINCT
		[T].[TASK_ID]
		,[T].[TASK_TYPE]
		,[T].[TASK_TYPE_DESCIPTION]
		,[T].[SCHEDULE_FOR]
		,[T].[ASSIGEND_TO]
		,[T].[NAME_USER]
		,[T].[CODE_ROUTE]
		,[T].[NAME_ROUTE]
		,[T].[TASK_STATUS]
		,[T].[TASK_STATUS_DESCIPTION]
		,[T].[COSTUMER_CODE]
		,[T].[COSTUMER_NAME]
		,[T].[CUSTOMER_PHONE]
		,[T].[TASK_ADDRESS]
		,[T].[COMPLETED_SUCCESSFULLY]
		,[T].[COMPLETED_SUCCESSFULLY_DESCRIPTION]
		,[T].[REASON_TYPE]
		,[T].[REASON]
		,[T].[ACCEPTED_STAMP]
		,[T].[COMPLETED_STAMP]
		,[T].[LAPSE_TIME]
		,CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),[acsa].[SWIFT_FN_GET_DISPLAY_NUMBER](ISNULL([S].[TOTAL_AMOUNT],0.00))) [TOTAL_AMOUNT]
	FROM [#TASK] [T]
	LEFT JOIN [#SALES_ORDER] [S] ON (
		[S].[TASK_ID] = [T].[TASK_ID]
	)

	ORDER BY [T].[TASK_ID]'
	--
	PRINT '----> @QUERY: ' + @QUERY
	--
	EXEC(@QUERY)
	--
	PRINT '----> DESPUES DE @QUERY'
END
