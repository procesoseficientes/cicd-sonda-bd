-- exec 
-- =============================================
-- Autor:				jose.garcia
-- Fecha de Creacion: 	21-01-2016
-- Description:			Trae todas las locaciones de bodega

/*
-- Ejemplo de Ejecucion:				
				-- EXEC [acsa].[SWIFT_SP_GET_ALL_LOCATIONES]
				--				
*/
-- =============================================

CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ALL_LOCATIONES]
AS
Select L.[CODE_LOCATION]
from [acsa].[SWIFT_LOCATIONS] L



