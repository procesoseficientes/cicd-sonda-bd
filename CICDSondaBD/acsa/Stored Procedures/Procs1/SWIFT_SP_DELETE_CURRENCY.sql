-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	25-Nov-16 @ A-TEAM Sprint 5
-- Description:			SP que elimina una moneda

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_DELETE_CURRENCY]
					 @CURRENCY_ID = 1          
				-- 
				SELECT * FROM [acsa].[SWIFT_CURRENCY]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_CURRENCY](  
  @CURRENCY_ID INT
)
AS
BEGIN
	BEGIN TRY		
		--
	  DELETE [acsa].[SWIFT_CURRENCY]
    WHERE CURRENCY_ID = @CURRENCY_ID

		--
		SELECT  1 as Resultado , 'Proceso Exitoso' Mensaje ,  0 Codigo, '0' DbData
	END TRY
	BEGIN CATCH
		SELECT  -1 as Resultado
		,ERROR_MESSAGE() Mensaje 
		,@@ERROR Codigo 
	END CATCH
END


