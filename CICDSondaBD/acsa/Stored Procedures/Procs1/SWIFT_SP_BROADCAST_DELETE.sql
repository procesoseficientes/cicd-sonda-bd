-- =============================================
-- Autor:				alberto.ruiz	
-- Fecha de Creacion: 	03-12-2015
-- Description:			Borra el broadcast de un destinatario

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_BROADCAST_DELETE] @CODE_BROADCAST = '', @ADDRESSEE = ''
				--
				SELECT * FROM [acsa].[SWIFT_PENDING_BROADCAST]
				--
				SELECT * FROM [acsa].[SWIFT_ROUTES] WHERE IS_ACTIVE_ROUTE = 1
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_BROADCAST_DELETE]
	@CODE_BROADCAST VARCHAR(150)
	,@ADDRESSEE VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
    --
	DELETE [acsa].[SWIFT_PENDING_BROADCAST]
	WHERE CODE_BROADCAST = @CODE_BROADCAST
		AND ADDRESS = @ADDRESSEE

END


