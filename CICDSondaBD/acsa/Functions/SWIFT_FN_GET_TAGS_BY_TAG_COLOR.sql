-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	11-12-2015
-- Description:			Obtiene la etique

/*
-- Ejemplo de Ejecucion:
				SELECT * FROM [acsa].[SWIFT_FN_GET_TAGS_BY_TAG_COLOR]('#CCFFCC')
*/
-- =============================================
CREATE FUNCTION [acsa].[SWIFT_FN_GET_TAGS_BY_TAG_COLOR]
(		
	@TAG_COLOR varchar(50) = NULL
)
RETURNS TABLE
AS
RETURN 
(
	SELECT
		TAG_COLOR
		,TAG_VALUE_TEXT
		,TAG_PRIORITY
		,TAG_COMMENTS
		,TYPE
	FROM [acsa].[SWIFT_TAGS]
	WHERE TYPE = 'CUSTOMER'
		AND @TAG_COLOR IS NULL OR TAG_COLOR = @TAG_COLOR
)

