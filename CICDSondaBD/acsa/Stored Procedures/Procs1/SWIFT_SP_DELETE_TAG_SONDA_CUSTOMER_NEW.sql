-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	6/21/2017 @ A-TEAM Sprint Khalid 
-- Description:			SP que borra una etiqueta de los scoutings de la tabla SONDA_CUSTOMER_NEW

/*
-- Ejemplo de Ejecucion:
				SELECT * FROM [acsa].[SONDA_TAG_X_CUSTOMER_NEW] WHERE TAG_COLOR = '#335210' AND CUSTOMER_ID = 3
				--
				EXEC [acsa].[SWIFT_SP_DELETE_TAG_SONDA_CUSTOMER_NEW]
					@TAG_COLOR = '#335210'
					,@CUSTOMER_ID = 3
					,@LOGIN = 'gerente@acsa'
				-- 
				SELECT * FROM [acsa].[SONDA_TAG_X_CUSTOMER_NEW] WHERE TAG_COLOR = '#335210' AND CUSTOMER_ID = 3
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_TAG_SONDA_CUSTOMER_NEW](
	@TAG_COLOR VARCHAR(50)
	,@CUSTOMER_ID INT
	,@LOGIN VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	BEGIN TRY
		DELETE FROM [acsa].[SONDA_TAG_X_CUSTOMER_NEW]
		WHERE [TAG_COLOR] = @TAG_COLOR AND [CUSTOMER_ID] = @CUSTOMER_ID
		--
		UPDATE [acsa].[SONDA_CUSTOMER_NEW]
			SET [LAST_UPDATE] = GETDATE()
				,[LAST_UPDATE_BY] = @LOGIN
				,[UPDATED_FROM_BO] = 1
			WHERE [CUSTOMER_ID] = @CUSTOMER_ID
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
		SELECT  -1 as Resultado
		,ERROR_MESSAGE() Mensaje 
		,@@ERROR Codigo 
	END CATCH
END

