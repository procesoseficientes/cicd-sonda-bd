-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	11/17/2017 @ A-TEAM Sprint   
-- Description:			SP que obtiene los registros de 

/*
-- Ejemplo de Ejecucion:
	DECLARE @PARAM_VALUE INT = NULL;

				EXEC [acsa].[SONDA_SP_VALIDATE_IN_ROUTE_BILLING_FOR_DELIVERY_TASK]
				@INVOICE_IN_ROUTE = @PARAM_VALUE OUTPUT
	SELECT @PARAM_VALUE AS INVOICE_IN_ROUTE
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_VALIDATE_IN_ROUTE_BILLING_FOR_DELIVERY_TASK](
	@INVOICE_IN_ROUTE INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT NULL VALUE 
	--SELECT @INVOICE_IN_ROUTE = [VALUE] FROM OPENQUERY([WMS3PL], '
	--	SELECT
	--		VALUE
	--	FROM [OP_WMS_NAVE].[NAVE].[OP_WMS_PARAMETER]
	--	WHERE [GROUP_ID] = ''DELIVERY'' AND [PARAMETER_ID] = ''INVOICE_IN_ROUTE''
	--')
	--
END
