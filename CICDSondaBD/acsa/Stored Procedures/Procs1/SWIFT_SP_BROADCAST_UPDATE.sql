-- =============================================
-- Autor:				alberto.ruiz	
-- Fecha de Creacion: 	03-12-2015
-- Description:			Se actualiza el estado del broadcast de un destinatario

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_BROADCAST_UPDATE] @CODE_BROADCAST = '',@ADDRESSEE = '' ,@STATUS = 'RECEIVED'
				--
				SELECT * FROM [acsa].[SWIFT_PENDING_BROADCAST]
				--
				SELECT * FROM [acsa].[SWIFT_ROUTES] WHERE IS_ACTIVE_ROUTE = 1
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_BROADCAST_UPDATE]
	@CODE_BROADCAST VARCHAR(150)
	,@ADDRESSEE VARCHAR(50)
	,@STATUS VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
    --
	UPDATE [acsa].[SWIFT_PENDING_BROADCAST]
	SET STATUS = @STATUS
	WHERE CODE_BROADCAST = @CODE_BROADCAST
		AND ADDRESS = @ADDRESSEE

END


