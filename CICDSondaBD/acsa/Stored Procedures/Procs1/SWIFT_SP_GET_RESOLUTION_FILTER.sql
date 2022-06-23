-- =============================================
-- Autor:				PEDRO LOUKOTA
-- Fecha de Creacion: 	03-12-2015
-- Description:			Selecciona las resoluciones filtradas
--                      
/*
DECLARE @RC int

-- Ejemplo de Ejecucion:

		EXECUTE  [acsa].[SWIFT_SP_GET_RESOLUTION_FILTER] 
        @AUTH_ASSIGNED_TO = ''
		
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_RESOLUTION_FILTER]
@AUTH_ASSIGNED_TO [varchar](100)
AS
BEGIN

	SELECT  * 
		FROM [$(CICDSondaBD)].[acsa].[SONDA_POS_RES_SAT]
		WHERE  [AUTH_ASSIGNED_TO] = @AUTH_ASSIGNED_TO 

END
