-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	2/23/2017 @ A-TEAM Sprint Donkor 
-- Description:			SP que borra un registro de la tabla SWIFT_SALES_ORGANIZATION

/*
-- Ejemplo de Ejecucion:
				SELECT * FROM [acsa].SWIFT_SALES_ORGANIZATION 
				--
				EXEC [acsa].[SWIFT_SP_DELETE_SALES_ORGANIZATION]
					@SALES_ORGANIZATION_ID = 1
				-- 
				SELECT * FROM [acsa].SWIFT_SALES_ORGANIZATION 
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_SALES_ORGANIZATION](
	@SALES_ORGANIZATION_ID INT
)
AS
BEGIN
	BEGIN TRY
		DELETE FROM SWIFT_SALES_ORGANIZATION
		WHERE [SALES_ORGANIZATION_ID] = @SALES_ORGANIZATION_ID
		--
		SELECT  1 as Resultado , 'Proceso Exitoso' Mensaje ,  0 Codigo, '' DbData
	END TRY
	BEGIN CATCH
    	SELECT  -1 as Resultado
    	,CASE 
      	  WHEN CAST(@@ERROR AS VARCHAR) = '547' THEN 'La organizacion de ventas tiene oficinas asociadas'
      	  ELSE ERROR_MESSAGE()
    	END Mensaje 
    	,@@ERROR Codigo 
  	END CATCH
END

