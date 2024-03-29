﻿
/*=======================================================
-- Author:         diego.as
-- Create date:    20-06-2016
-- Description:    Elimina TODAS las etiquetas del cliente en 
					la tabla SWIFT_TAG_X_CUSTOMER_NEW
					
-- Modificacion: 25-06-2016
--			Autor: diego.as
--			Descripcion: Se modifico proceso de eliminacion para que retorne 
						 algun tipo de mensaje en cualquiera de los casos (error de operacion, proceso exitoso) 	   

-- EJEMPLO DE EJECUCION: 
		EXEC [acsa].[SWIFT_SP_DELETE_ALL_TAGS_BY_SCOUTING]
			@CUSTOMER_ID = '2290'
		------------------------------------------------
		SELECT * FROM [acsa].[SWIFT_TAG_X_CUSTOMER_NEW]
		WHERE [CUSTOMER]= '2290'
		------------------------------------------------
=========================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_ALL_TAGS_BY_SCOUTING]
( 
	@CUSTOMER_ID VARCHAR(250)
) AS 
BEGIN
	--
	BEGIN TRY
		--
		DELETE FROM [acsa].[SWIFT_TAG_X_CUSTOMER_NEW]
		WHERE [CUSTOMER] = @CUSTOMER_ID
		--
		IF @@error = 0 BEGIN		
			SELECT  1 AS RESULTADO , 'Proceso Exitoso' MENSAJE ,  0 CODIGO
		END		
		ELSE BEGIN		
			SELECT  -1 AS RESULTADO , ERROR_MESSAGE() MENSAJE ,  @@ERROR CODIGO
		END
		--
	END TRY
	BEGIN CATCH
		SELECT  -1 AS RESULTADO , ERROR_MESSAGE() MENSAJE ,  @@ERROR CODIGO
	END CATCH
	--
END

