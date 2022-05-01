-- =============================================
-- Author:         diego.as
-- Create date:    15-02-2016
-- Description:    Trae TODOS los registros de la Tabla 
--				   [acsa].[OP_WMS_CERTIFICATE_DEPOSIT_HEADER] 
/*
Ejemplo de Ejecucion:
				--
				EXEC acsa.OP_WMS_SP_GET_ALL_CERTIFICATE_DEPOSIT_HEADER 
				--	
*/
-- =============================================

CREATE PROCEDURE [acsa].[OP_WMS_SP_GET_ALL_CERTIFICATE_DEPOSIT_HEADER]
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

END
