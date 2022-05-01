﻿-- =============================================
-- Autor:					rodrigo.gomez
-- Fecha de Creacion: 		3/17/2017 @ A-Team Sprint Ebonne
-- Description:			    Obtiene el tipo de validacion asociada al usuario

/*
-- Ejemplo de Ejecucion:
        SELECT [acsa].[SWIFT_FN_GET_VALIDATION_TYPE]('rudi@acsa');
*/
-- =============================================

CREATE FUNCTION [acsa].[SWIFT_FN_GET_VALIDATION_TYPE]
    (@LOGIN AS VARCHAR(50))
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @VALIDATION_TYPE VARCHAR(50)

	SELECT @VALIDATION_TYPE = [VALIDATION_TYPE] 
	FROM [acsa].[USERS]
	WHERE [LOGIN] = @LOGIN

    RETURN @VALIDATION_TYPE
END
