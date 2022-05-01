-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	25-Nov-16 @ A-TEAM Sprint 5
-- Description:			SP que obtiene las monedas

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_CURRENCY]					 
				-- 				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CURRENCY]
AS
BEGIN
  	
		SELECT 
      C.[CURRENCY_ID]
      ,C.[CODE_CURRENCY]
      ,C.[NAME_CURRENCY]
      ,C.[SYMBOL_CURRENCY]
      ,C.[IS_DEFAULT]
      ,CASE C.[IS_DEFAULT]
        WHEN 1 THEN 'SI'
        ELSE 'NO'
       END [IS_DEFAULT_DESCRIPTION]
    FROM [acsa].[SWIFT_CURRENCY] C
      
	
END


