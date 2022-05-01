-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	3/9/2017 @ A-TEAM Sprint Ebonne 
-- Description:			Obtiene el DEVICE_ID y VALIDATION_TYPE asignado al usuario.

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_DEVICE_ID_FROM_USER]
					@LOGIN = 'rudi@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_DEVICE_ID_FROM_USER](
	@LOGIN VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT [DEVICE_ID]
			,[VALIDATION_TYPE] 
	FROM [acsa].[USERS]
	WHERE [LOGIN] = @LOGIN
END
