-- =============================================
-- Autor:				PEDRO LOUKOTA
-- Fecha de Creacion: 	03-12-2015
-- Description:			Selecciona las resoluciones de venta filtradas
--                      
/*
-- Ejemplo de Ejecucion:				
				--EXECUTE [acsa].[SWIFT_SP_GET_SALES_RESOLUTION_FILTER]
							   @AUTH_ASSIGNED_TO = ''
							  ,@AUTH_TYPE = ''
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_SALES_RESOLUTION_FILTER]
	@AUTH_ASSIGNED_TO [varchar](100)
	,@AUTH_TYPE [varchar](150)
AS
BEGIN
	SELECT S.*
	FROM [acsa].[SWIFT_DOCUMENT_SEQUENCE] S
	WHERE S.[DOC_TYPE] = @AUTH_TYPE
		AND S.[ASSIGNED_TO] = @AUTH_ASSIGNED_TO 
END
