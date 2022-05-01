-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	07-12-2015
-- Description:			Obtiene las clasificaciones por grupo
--                      
/*
-- Ejemplo de Ejecucion:				
				--


-- TODO: Set parameter values here.

	EXECUTE [acsa].[SWIFT_SP_GET_CLASSFICATION_BY_GROUP] 'WAREHOUSE'


				--				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CLASSFICATION_BY_GROUP]
	@GROUP_CLASSIFICATION VARCHAR(50)
AS
BEGIN
	SELECT
		CLASSIFICATION
		,VALUE_TEXT_CLASSIFICATION
	   ,NAME_CLASSIFICATION
	FROM [acsa].[SWIFT_CLASSIFICATION]
	WHERE GROUP_CLASSIFICATION = @GROUP_CLASSIFICATION
END


