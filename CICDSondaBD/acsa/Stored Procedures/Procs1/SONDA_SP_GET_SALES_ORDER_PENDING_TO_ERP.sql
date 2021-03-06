/*
Ejemplo de Ejecucion:
		EXEC [acsa].[SONDA_SP_GET_SALES_ORDER_PENDING_TO_ERP]	@StartDate='2016-02-27', @EndDate='2017-02-27'
*/
-- =============================================

CREATE PROCEDURE [acsa].[SONDA_SP_GET_SALES_ORDER_PENDING_TO_ERP] (@StartDate varchar(20), @EndDate varchar(20))
AS
BEGIN
  SET NOCOUNT ON;
	SELECT 
		ISNULL(POSTED_RESPONSE,'EN COLA DE ENVIO') AS RespuestaERP
		,ISNULL(ERP_REFERENCE,'PENDIENTE DE ENVIO') as ReferenciaERP
		,CLIENT_ID as Cliente
		,POS_TERMINAL as Ruta
		,POSTED_BY as Usuario
		,POSTED_DATETIME as FechaPedido
		,ATTEMPTED_WITH_ERROR as IntentosDeEnvio
		,POSTED_ERP as FechaPosteo
	FROM acsa.SONDA_SALES_ORDER_HEADER
	WHERE POSTED_DATETIME BETWEEN CAST(@StartDate AS date) AND CAST(@EndDate AS date)
		AND (IS_POSTED_ERP<>1 or IS_POSTED_ERP is null)
	ORDER BY 1,POSTED_DATETIME 
END
