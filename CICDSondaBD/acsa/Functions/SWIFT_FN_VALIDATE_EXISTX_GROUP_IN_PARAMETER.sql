-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		23-Mar-17 @ A-Team Sprint Fenyang
-- Description:			    Valida que existan un grupo en parametros

/*
-- Ejemplo de Ejecucion:
        SELECT [acsa].[SWIFT_FN_VALIDATE_EXISTX_GROUP_IN_PARAMETER]('LABEL')
*/
-- =============================================
CREATE FUNCTION [acsa].[SWIFT_FN_VALIDATE_EXISTX_GROUP_IN_PARAMETER]
(
	@GROUP_ID VARCHAR(250)
)
RETURNS INT
AS
BEGIN
	DECLARE @EXISTS_GROUP INT = 0
	--
	SELECT TOP 1 @EXISTS_GROUP = 1
	FROM [acsa].[SWIFT_PARAMETER] [P]
	WHERE [P].[GROUP_ID] = @GROUP_ID
	--
	RETURN @EXISTS_GROUP
END
