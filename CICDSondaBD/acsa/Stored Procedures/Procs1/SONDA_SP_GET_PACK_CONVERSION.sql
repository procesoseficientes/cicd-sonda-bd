
-- =============================================
-- Author:         diego.as
-- Create date:    15-02-2016
-- Description:    Obtiene los registros de la Tabla 
--				   [acsa].[SONDA_PACK_CONVERSION]
--				   con control de errores.

/*
Ejemplo de Ejecucion:

		EXEC [acsa].[SONDA_SP_GET_PACK_CONVERSION]	
				
*/
-- =============================================

CREATE PROCEDURE [acsa].[SONDA_SP_GET_PACK_CONVERSION]
AS
BEGIN
  SET NOCOUNT ON;
  SELECT
    [SPC].[PACK_CONVERSION]
   ,[SPC].[CODE_SKU]
   ,[SPC].[CODE_PACK_UNIT_FROM]
   ,[SPC].[CODE_PACK_UNIT_TO]
   ,[SPC].[CONVERSION_FACTOR]
   ,[SPC].[ORDER]
  FROM [acsa].[SONDA_PACK_CONVERSION] AS SPC
END


