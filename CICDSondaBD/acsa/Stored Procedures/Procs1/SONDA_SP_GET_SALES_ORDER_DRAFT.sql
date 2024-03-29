﻿-- =============================================
-- Autor:				hector.gonzalez
-- Fecha de Creacion: 	12-4-2015
-- Description:			Obtine las Ordens de Venta que son DRAFT dependiendo de la ruta que se envie como parametro

/*
-- Ejemplo de Ejecucion:
				exec [acsa].[SONDA_SP_GET_SALES_ORDER_DRAFT]  @CODE_ROUTE = 'RUDI@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_SALES_ORDER_DRAFT]
	@CODE_ROUTE VARCHAR(50)

AS
BEGIN
	SET NOCOUNT ON;

  UPDATE acsa.SONDA_SALES_ORDER_HEADER 
    SET IS_ACTIVE_ROUTE = 1    
    WHERE POS_TERMINAL = @CODE_ROUTE 
      AND IS_DRAFT = 1
      AND IS_VOID = 0
	  AND IS_READY_TO_SEND=1


	SELECT 
		H.[SALES_ORDER_ID]
		,H.[TERMS]
		,H.[POSTED_DATETIME]
		,H.[CLIENT_ID]
		,H.[POS_TERMINAL]
		,H.[GPS_URL]
		,H.[TOTAL_AMOUNT]
		,H.[STATUS]
		,H.[POSTED_BY]
		,H.[IMAGE_1]
		,H.[IMAGE_2]
		,H.[IMAGE_3]
		,H.[DEVICE_BATTERY_FACTOR]
		,H.[VOID_DATETIME]
		,H.[VOID_REASON]
		,H.[VOID_NOTES]
		,H.[VOIDED]
		,H.[CLOSED_ROUTE_DATETIME]
		,H.[IS_ACTIVE_ROUTE]
		,H.[GPS_EXPECTED]
		,H.[DELIVERY_DATE]
		,H.[SALES_ORDER_ID_HH]
		,H.[ATTEMPTED_WITH_ERROR]
		,H.[IS_POSTED_ERP]
		,H.[POSTED_ERP]
		,H.[POSTED_RESPONSE]
		,H.[IS_PARENT]
		,H.[REFERENCE_ID]
		,H.[WAREHOUSE]
		,H.[TIMES_PRINTED]
		,H.[DOC_SERIE]
		,H.[DOC_NUM]
		,H.[IS_VOID]
		,H.[SALES_ORDER_TYPE]
		,H.[DISCOUNT]
		,H.[IS_DRAFT]
	FROM [acsa].SONDA_SALES_ORDER_HEADER H
	WHERE H.POS_TERMINAL = @CODE_ROUTE 
    AND H.IS_DRAFT = 1
    AND H.IS_VOID = 0
	AND H.IS_READY_TO_SEND=1
END
