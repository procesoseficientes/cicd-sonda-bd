/*=======================================================
-- Author:         hector.gonzalez
-- Create date:    13-07-2016
-- Description:    Elimina las etiquetas por cliente con cambios en la tabla [SWIFT_TAG_X_CUSTOMER_CHANGE]

-- EJEMPLO DE EJECUCION: 
		EXEC [acsa].[SWIFT_SP_DELETE_TAGS_BY_CUSTOMER_CHANGE]
			@TAG_COLOR = '#33CCCC'
			,@CUSTOMER_ID = '3'
			,@LOGIN = 'gerente@acsa'
=========================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_TAGS_BY_CUSTOMER_CHANGE]
( 
	@TAG_COLOR VARCHAR(250),
	@CUSTOMER VARCHAR(250),
	@LOGIN VARCHAR(250)
) AS 
BEGIN
	--
	BEGIN TRY
		--
		DELETE FROM [acsa].[SWIFT_TAG_X_CUSTOMER_CHANGE]
		WHERE [TAG_COLOR] = @TAG_COLOR
			  AND [CUSTOMER] = @CUSTOMER

		--
		UPDATE [acsa].[SWIFT_CUSTOMER_CHANGE]
			SET [LAST_UPDATE] = GETDATE()
				,[LAST_UPDATE_BY] = @LOGIN
			WHERE [CUSTOMER] = @CUSTOMER
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

