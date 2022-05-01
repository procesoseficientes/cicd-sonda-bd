/*
Ejemplo de Ejecucion:
		EXEC [acsa].[SONDA_SP_GET_SALES_ORDER_POSTED_TO_ERP]	@StartDate='2016-02-27', @EndDate='2017-02-27'
*/
-- =============================================

CREATE PROCEDURE [SONDA_SP_GET_SALES_ORDER_POSTED_TO_ERP] (@StartDate varchar(20), @EndDate varchar(20))
AS
BEGIN
  SET NOCOUNT ON;
	SELECT 
		ISNULL(POSTED_RESPONSE,'ENVIADO') AS RespuestaERP
		,ERP_REFERENCE as ReferenciaERP
		,CLIENT_ID as Cliente
		,POS_TERMINAL as Ruta
		,POSTED_BY as Usuario
		,POSTED_DATETIME as FechaPedido
		,POSTED_ERP as FechaPosteo
	FROM acsa.SONDA_SALES_ORDER_HEADER
	WHERE POSTED_DATETIME BETWEEN CAST(@StartDate AS date) AND CAST(@EndDate AS date)
		AND IS_POSTED_ERP=1
	ORDER BY POSTED_DATETIME 
END