-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	6/13/2017 @ A-TEAM Sprint Jibade 
-- Description:			SP que borra un registro de la tabla SWIFT_PROMO_BONUS_BY_MULTIPLE

/*
-- Ejemplo de Ejecucion:
				SELECT * FROM [acsa].SWIFT_PROMO_BONUS_BY_MULTIPLE
				--
				EXEC [acsa].[SWIFT_SP_DELETE_PROMO_OF_BONUS_BY_MULTIPLE]
					@PROMO_BONUS_BY_MULTIPLE_ID = 149
				-- 
				SELECT * FROM [acsa].SWIFT_PROMO_BONUS_BY_MULTIPLE
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_PROMO_OF_BONUS_BY_MULTIPLE](
	@PROMO_BONUS_BY_MULTIPLE_ID INT
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	BEGIN TRY
		DELETE FROM [acsa].[SWIFT_PROMO_BONUS_BY_MULTIPLE]
		WHERE [PROMO_BONUS_BY_MULTIPLE_ID] = @PROMO_BONUS_BY_MULTIPLE_ID
		--
		SELECT  1 as Resultado , 'Proceso Exitoso' Mensaje ,  0 Codigo, '' DbData
	END TRY
	BEGIN CATCH
		SELECT  -1 as Resultado
		,ERROR_MESSAGE() Mensaje 
		,@@ERROR Codigo 
	END CATCH
END

