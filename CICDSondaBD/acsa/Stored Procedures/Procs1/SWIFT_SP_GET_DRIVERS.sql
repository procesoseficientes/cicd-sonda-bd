
-- =============================================
-- Autor:				        hector.gonzalez
-- Fecha de Creacion: 	18-Oct-16 @ A-TEAM Sprint 3
-- Description:			SP que obtiene los pilotos

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_DRIVERS]
				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_DRIVERS] 
AS
BEGIN

	SELECT * FROM SWIFT_VIEW_DRIVER

END

