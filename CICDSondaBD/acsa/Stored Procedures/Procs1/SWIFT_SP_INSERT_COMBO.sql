-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	08-Feb-17 @ A-TEAM Sprint Chatuluka
-- Description:			SP para agregar combos

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_INSERT_COMBO]
					@NAME_COMBO = 'combo 1'
					,@DESCRIPTION_COMBO = 'combo 1'
				-- 
				SELECT * FROM [acsa].[SWIFT_COMBO]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_INSERT_COMBO](
	@NAME_COMBO VARCHAR(250)
	,@DESCRIPTION_COMBO VARCHAR(250)
)
AS
BEGIN
	BEGIN TRY
		DECLARE @ID INT
		--
		INSERT INTO [acsa].[SWIFT_COMBO]
				(
					[NAME_COMBO]
					,[DESCRIPTION_COMBO]
				)
		VALUES
				(
					@NAME_COMBO
					,@DESCRIPTION_COMBO
				)
		--
		SET @ID = SCOPE_IDENTITY()
		--
		SELECT  1 as Resultado , 'Proceso Exitoso' Mensaje ,  0 Codigo, CAST(@ID AS VARCHAR) DbData
	END TRY
	BEGIN CATCH
		SELECT  -1 as Resultado
		,CASE CAST(@@ERROR AS VARCHAR)
			WHEN '2627' THEN 'Ya existe un combo con el nombre: ' + @NAME_COMBO
			ELSE ERROR_MESSAGE() 
		END Mensaje 
		,@@ERROR Codigo 
	END CATCH
END
