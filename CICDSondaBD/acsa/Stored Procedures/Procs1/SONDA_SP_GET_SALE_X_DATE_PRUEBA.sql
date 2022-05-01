-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	11-17-2015
-- Description:			Obtine todas las ventas entre un rango de fechas

--Yo Pedro Pablo Loukota cambio el procedimiento almacenado [acsa].[SONDA_SP_GET_SALE_X_DATE] el 15 de Diciembre del 2015.
	
-- Modificado 15-12-2015
		-- ppablo.loukota
		-- Por motivo de agregar nuevas condicionales usando [SWIFT_ROUTE_BY_USER] como pivote 
		-- y utilizar la variable @LOGIN como filtro

-- Modificado 11-02-2016
		-- alberto.ruiz
		-- Se agregaron las columnas WAREHOUSE, DOC_SERIE, DOC_NUM y IS_VOID

-- Modificado 10-05-2016
		-- alberto.ruiz
		-- Se agrego la columna [ASSIGNED_BY]

-- Modificado 12-05-2016
		-- hector.gonzalez
		-- Se modifico los campos TOTAL_AMOUNT agregando la funcion SWIFT_FN_GET_DISPLAY_NUMBER a dischos campos

-- Modificado 22-06-2016
		-- hector.gonzalez
		-- Se agregaron las columnas CASH_AMOUT y CREDIT_AMOUNT 

-- Modificacion 24-06-2016
					-- alberto.ruiz
					-- Se cambio para el uso de la funcion de los decimales
/*
-- Ejemplo de Ejecucion:
	exec [acsa].[SONDA_SP_GET_SALE_X_DATE_PRUEBA] 
	@POSTED_DATETIME='2017-01-25 00:00:00',@CLOSED_ROUTE_DATETIME='2017-01-25 09:00:00',@LOGIN=N'gerente@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_SALE_X_DATE_PRUEBA]
	@POSTED_DATETIME DATETIME
	,@CLOSED_ROUTE_DATETIME DATETIME
	,@LOGIN VARCHAR(50)
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
	SET @QUERY = N'
	SELECT TOP 10
		SALES_ORDER_ID 
		,E.CLIENT_ID
		,VC.NAME_CUSTOMER
		,VC.ADRESS_CUSTOMER
		,CONTACT_CUSTOMER
		,VR.NAME_ROUTE
		,VR.CODE_ROUTE
		,E.GPS_URL
		,E.POSTED_DATETIME
		,E.POSTED_BY
		,E.DELIVERY_DATE
		,E.IMAGE_1
		,E.IMAGE_2
		,E.IS_PARENT
		,CASE E.IS_PARENT		
			WHEN 0 THEN ''Restante''
			ELSE ''Principal''
		END IS_PARENT_DESCRIPTION
		,REFERENCE_ID
		,CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER(E.TOTAL_AMOUNT)) [TOTAL_AMOUNT]
		,W.CODE_WAREHOUSE
		,W.DESCRIPTION_WAREHOUSE
		,E.DOC_SERIE
		,E.DOC_NUM
		,CASE E.IS_VOID
			WHEN 1 THEN ''ANULADA''
			ELSE ''ACTIVA''
		END IS_VOID
		,CASE E.[ASSIGNED_BY] 
			WHEN ''BO'' THEN ''BackOffice''
			ELSE ''Handheld''
		END AS [ASSIGNED_BY],
		CASE E.SALES_ORDER_TYPE
				WHEN ''CASH'' THEN ''Contado''
				ELSE ''Credito''
			END AS ''SALES_ORDER_TYPE''
		,CASE E.SALES_ORDER_TYPE
			WHEN ''CASH'' THEN CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER(E.TOTAL_AMOUNT))
			ELSE 0
		END [CASH_AMOUNT]
		,CASE E.SALES_ORDER_TYPE
			WHEN ''CREDIT'' THEN CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER(E.TOTAL_AMOUNT))
			ELSE 0
		END [CREDIT_AMOUNT]
	  ,CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER(E.DISCOUNT)) [DISCOUNT]
	  ,CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),acsa.SWIFT_FN_GET_DISPLAY_NUMBER(E.TOTAL_AMOUNT-(E.TOTAL_AMOUNT*(E.DISCOUNT/100)))) [TOTAL_CD]
	 
	  , CASE CAST(E.IS_POSTED_ERP AS VARCHAR)
			WHEN ''1'' THEN ''Enviado''
			ELSE ''Pendiente''
		END IS_POSTED_ERP_DESCRIPTION
		
	from [acsa].[SONDA_SALES_ORDER_HEADER] as E
		INNER JOIN [acsa].[SWIFT_VIEW_ALL_COSTUMER] VC ON (E.CLIENT_ID = VC.CODE_CUSTOMER)
		INNER JOIN [acsa].[SWIFT_VIEW_ALL_ROUTE] VR ON (VR.CODE_ROUTE = E.POS_TERMINAL)
		INNER JOIN [acsa].[SWIFT_ROUTE_BY_USER] RUS ON (RUS.CODE_ROUTE = E.POS_TERMINAL)
		LEFT JOIN [acsa].[SWIFT_VIEW_WAREHOUSES] W ON (W.CODE_WAREHOUSE = E.WAREHOUSE)
	WHERE CONVERT(DATE,E.POSTED_DATETIME) Between CONVERT(DATE,''' + CONVERT(VARCHAR(25),@POSTED_DATETIME,101) + ''') AND CONVERT(DATE,''' + CONVERT(VARCHAR(25),@CLOSED_ROUTE_DATETIME,101) + ''')
		AND RUS.[LOGIN] = ''' + @LOGIN + ''''
	--
	PRINT '----> @QUERY: ' + @QUERY
	--
	EXEC(@QUERY)
	--
	PRINT '----> DESPUES DE @QUERY'
END
