-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	08-Nov-16 @ A-TEAM Sprint 4 
-- Description:			

-- Autor:				        hector.gonzalez
-- Fecha de Creacion: 	13-Dic-16 @ A-TEAM Sprint 6
-- Description:			    Se agrego columna SERIE

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_INVOICE_BY_SKU_TYPE]
					@START_DATETIME = '20160101 00:00:00.000'
					,@END_DATETIME = '20170101 00:00:00.000'
					,@LOGIN = 'GERENTE@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_INVOICE_BY_SKU_type](
	@START_DATETIME DATETIME
	,@END_DATETIME DATETIME
	,@LOGIN VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE 
		@DEFAULT_DISPLAY_DECIMALS INT
		,@QUERY NVARCHAR(4000)

	-- ------------------------------------------------------------------------------------
	-- Coloca parametros iniciales
	--------------------------------------------------------------------------------------
	SELECT @DEFAULT_DISPLAY_DECIMALS = [acsa].[SWIFT_FN_GET_PARAMETER]('CALCULATION_RULES','DEFAULT_DISPLAY_DECIMALS')

	-- ------------------------------------------------------------------------------------
	-- Muestra el resultado
	-- ------------------------------------------------------------------------------------
	SET @QUERY = N'SELECT
		[IH].[POS_TERMINAL] [CODE_ROUTE]
		,[R].[NAME_ROUTE]
		,[IH].[POSTED_BY] [LOGIN]
		,[U].[NAME_USER]
		,[IH].[CDF_RESOLUCION]
		,[IH].[CDF_SERIE]
		,[IH].[INVOICE_ID]
		,CASE CAST(ISNULL([IH].[VOIDED_INVOICE],0) AS VARCHAR)
			WHEN ''0'' THEN ''VIGENTE''
			ELSE ''ANULADA''
		END [STATUS]
		,[IH].[CLIENT_ID]
		,[IH].[CDF_NOMBRECLIENTE]
		,[IH].[CDF_NIT]
		,[IH].[POSTED_DATETIME]
		,[IH].[VOIDED_INVOICE]
		,[IH].[VOID_REASON]
		,[IH].[VOID_DATETIME]
		,[IH].[GPS_EXPECTED]
		,CASE WHEN CONSIGNMENT_ID IS NULL then ''VENTA'' else ''PAGO'' END [TIPO]
    ,SUBSTRING([IH].[GPS_EXPECTED], 1, CHARINDEX('','', [IH].[GPS_EXPECTED]) - 1)  AS LATITUDE_EXPECTED
    ,SUBSTRING([IH].[GPS_EXPECTED], CHARINDEX('','', [IH].[GPS_EXPECTED]) + 1, LEN([IH].[GPS_EXPECTED])) AS LONGITUDE_EXPECTED
		,[IH].[GPS_URL]
    ,SUBSTRING([IH].[GPS_URL], 1, CHARINDEX('','', [IH].[GPS_URL]) - 1)  AS LATITUDE
    ,SUBSTRING([IH].[GPS_URL], CHARINDEX('','', [IH].[GPS_URL]) + 1, LEN([IH].[GPS_URL])) AS LONGITUDE
		,[ID].[SKU]
		,[S].[DESCRIPTION_SKU]
		,[ID].[QTY]
		,CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER([ID].[PRICE])) [PRICE]
		,CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER([ID].[TOTAL_LINE])) [TOTAL_LINE]
		,CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER([IH].[TOTAL_AMOUNT])) [TOTAL_AMOUNT]
    ,[IH].[IS_CREDIT_NOTE]
    ,DBO.SONDA_FN_CALCULATE_DISTANCE([IH].[GPS_EXPECTED],[IH].[GPS_URL]) [GPS_DISTANCE]
    ,[ID].SERIE
	FROM [acsa].[SONDA_POS_INVOICE_DETAIL] [ID]
	INNER JOIN [acsa].[SONDA_POS_INVOICE_HEADER] [IH] ON (
		[IH].[INVOICE_ID] = [ID].[INVOICE_ID]
	)
	INNER JOIN [acsa].[SWIFT_ROUTE_BY_USER] [RBU] ON (
		[RBU].[CODE_ROUTE] = [IH].[POS_TERMINAL]
	)
	INNER JOIN [acsa].[SWIFT_VIEW_ALL_SKU] [S] ON (
		[S].[CODE_SKU] = [ID].[SKU]
	)
	INNER JOIN [acsa].[SWIFT_ROUTES] [R] ON (
		[R].[CODE_ROUTE] = [IH].[POS_TERMINAL]
	)
	INNER JOIN [acsa].[USERS] [U] ON (
		[U].[LOGIN] = [IH].[POSTED_BY]
	)
	WHERE [IH].[IS_CREDIT_NOTE] = 0
		AND [RBU].[LOGIN] = ''' + @LOGIN + '''
		AND [IH].[POSTED_DATETIME] BETWEEN ''' + CONVERT(VARCHAR,@START_DATETIME,121) + ''' AND ''' + CONVERT(VARCHAR,@END_DATETIME,121) + '''
	ORDER BY [IH].[POSTED_DATETIME],[ID].[LINE_SEQ]'
	--
	PRINT '----> @QUERY: ' + @QUERY
	--
	EXEC(@QUERY)
	--
	PRINT '----> DESPUES DE @QUERY'
END
