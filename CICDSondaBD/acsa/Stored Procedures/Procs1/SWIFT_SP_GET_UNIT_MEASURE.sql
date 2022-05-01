
-- =============================================
-- Autor:				ppablo.loukota
-- Fecha de Creacion: 	12-01-2016
-- Description:			Obtiene las unidades de medida por tipo

/*
-- Ejemplo de Ejecucion:				
				--
EXECUTE  [acsa].[SWIFT_SP_GET_UNIT_MEASURE] 
@TYPE = 'PESO'

				--				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_UNIT_MEASURE]
    @TYPE [varchar](50)
AS
BEGIN 


	SET NOCOUNT ON;

	SELECT [CODE]
		  ,[DESCRIPTION]
		  ,[TYPE]
	FROM [SWIFT_EXPRESS_R].[acsa].[SWIFT_MEASURE_UNIT]
	WHERE [TYPE] = @TYPE 
	ORDER BY [DESCRIPTION] ASC


END



