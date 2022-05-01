-- =============================================
-- Author:         hector.gonzalez
-- Create date:    20-05-2016
-- Description:    Obtiene una lista de skus dependiendo de una parte del codigo ingresado por medio de un LIKE

/*
Ejemplo de Ejecucion:
		EXEC [acsa].SONDA_SP_GET_SKUS_BY_CODE_SEARCH @CODE_CUSTUMER = 'as'
				
*/
-- =============================================

CREATE PROCEDURE [acsa].[SONDA_SP_GET_SKUS_BY_CODE_SEARCH]
  @CODE_CUSTUMER VARCHAR(50)
AS 
  SELECT VS.CODE_SKU, VS.DESCRIPTION_SKU
				FROM [acsa].[SWIFT_VIEW_ALL_SKU] VS
				WHERE VS.[CODE_SKU] LIKE + '%' + @CODE_CUSTUMER + '%'

