-- =============================================
-- Author:         diego.as
-- Create date:    15-02-2016
-- Description:    Trae los ENCABEZADOS DE CERTIFICADO DE DEPOSITO de la Tabla 
--				   [acsa].[OP_WMS_CERTIFICATE_DEPOSIT_HEADER] 
--					DE UN CLIENTE EN ESPECIFICO.
/*
Ejemplo de Ejecucion:
				--
				EXEC acsa.OP_WMS_SP_GET_ALL_CERTIFICATE_DEPOSIT_HEADER_BY_CLIENT_CODE
					@CLIENT_CODE =  '123'
				
				--	
*/
-- =============================================

CREATE PROCEDURE [acsa].[OP_WMS_SP_GET_ALL_CERTIFICATE_DEPOSIT_HEADER_BY_CLIENT_CODE]
(
	@CLIENT_CODE VARCHAR(25)
)
AS
BEGIN
    SET NOCOUNT ON;

        SELECT 
			[CDH].[CERTIFICATE_DEPOSIT_ID_HEADER]
			,[CDH].[VALID_FROM]
			,[CDH].[VALID_TO]
			,[CDH].[LAST_UPDATED]
			,[CDH].[LAST_UPDATED_BY]
			,[CDH].[STATUS]
			,[CDH].[CLIENT_CODE]
		FROM [acsa].[OP_WMS_CERTIFICATE_DEPOSIT_HEADER] AS CDH
		WHERE CDH.[CLIENT_CODE] = @CLIENT_CODE

END
