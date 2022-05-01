﻿-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	04-07-2016 Sprint ζ
-- Description:			Obtine todas las ordenes de ventas por sku

/*
-- Ejemplo de Ejecucion:
	exec [acsa].SWIFT_SP_GET_SALES_ORDERS_FOR_ROUTE @STAR_DATE='20160511 00:00:00.000', @END_DATE='20161222 00:00:00.000'
*/
-- =============================================

CREATE PROCEDURE [acsa].[SWIFT_SP_GET_SALES_ORDERS_FOR_ROUTE]
  @STAR_DATE DATETIME
  ,@END_DATE DATETIME
AS 
  DECLARE 
		@DEFAULT_DISPLAY_DECIMALS INT
		,@QUERY NVARCHAR(2000)

	-- ------------------------------------------------------------------------------------
	-- Coloca parametros iniciales
	--------------------------------------------------------------------------------------
	SELECT @DEFAULT_DISPLAY_DECIMALS = [acsa].[SWIFT_FN_GET_PARAMETER]('CALCULATION_RULES','DEFAULT_DISPLAY_DECIMALS')
  
  SET @QUERY = N'
  SELECT 
    VR.CODE_ROUTE
    , VR.NAME_ROUTE
    , VC.CODE_CUSTOMER
    , VC.NAME_CUSTOMER
    , VU.LOGIN
    , VU.NAME_USER
    , OH.SALES_ORDER_ID
    , OH.DOC_SERIE
    , OH.DOC_NUM
    , VS.CODE_SKU AS SKU
    , VS.DESCRIPTION_SKU    
    , CASE OH.SALES_ORDER_TYPE
				WHEN ''CASH'' THEN ''Contado''
				ELSE ''Credito''
			END AS ''SALES_ORDER_TYPE''
    , OD.QTY
    , CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),[acsa].SWIFT_FN_GET_DISPLAY_NUMBER(OD.PRICE)) [PRICE]
    , CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),[acsa].SWIFT_FN_GET_DISPLAY_NUMBER(OD.DISCOUNT)) [DISCOUNT]
    , CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),[acsa].SWIFT_FN_GET_DISPLAY_NUMBER(OH.TOTAL_AMOUNT-(OH.TOTAL_AMOUNT*(OH.DISCOUNT/100)))) [TOTAL_CD]
    , CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),[acsa].SWIFT_FN_GET_DISPLAY_NUMBER(OD.TOTAL_LINE)) [TOTAL_LINE]
    , CONVERT(DECIMAL(18,' + CAST(@DEFAULT_DISPLAY_DECIMALS AS VARCHAR) + '),[acsa].SWIFT_FN_GET_DISPLAY_NUMBER(OH.TOTAL_AMOUNT)) [TOTAL_AMOUNT]
    , OH.POSTED_DATETIME    
  FROM  [acsa].SONDA_SALES_ORDER_DETAIL AS OD
  INNER JOIN [acsa].SONDA_SALES_ORDER_HEADER AS OH ON (OD.SALES_ORDER_ID = OH.SALES_ORDER_ID)
  INNER JOIN [acsa].SWIFT_VIEW_ALL_ROUTE AS VR ON (OH.POS_TERMINAL = VR.CODE_ROUTE)
  INNER JOIN [acsa].SWIFT_VIEW_USERS AS VU ON (OH.POSTED_BY = VU.LOGIN)
  INNER JOIN [acsa].SWIFT_VIEW_ALL_SKU AS VS ON (OD.SKU = VS.CODE_SKU)
  INNER JOIN [acsa].SWIFT_VIEW_ALL_COSTUMER AS VC ON(OH.CLIENT_ID = VC.CODE_CUSTOMER)
  WHERE CONVERT(DATE,OH.POSTED_DATETIME) Between CONVERT(DATE,''' + CONVERT(VARCHAR(25),@STAR_DATE,101) + ''') AND CONVERT(DATE,''' + CONVERT(VARCHAR(25),@END_DATE,101) + ''')
  '

  PRINT '----> @QUERY: ' + @QUERY
	--
	EXEC(@QUERY)
	--
	PRINT '----> DESPUES DE @QUERY'

