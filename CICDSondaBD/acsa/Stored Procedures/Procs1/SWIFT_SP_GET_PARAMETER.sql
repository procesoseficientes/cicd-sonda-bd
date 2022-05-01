-- =============================================
-- Autor:				pablo.aguilar
-- Fecha de Creacion: 	14-05-2016
-- Description:			Obtiene la parametrizacion 

/*
Ejemplo de Ejecucion:
          EXEC [acsa].[SWIFT_SP_GET_PARAMETER]
			@GROUP_ID = 'SALES_ORDER', @PARAMETER_ID = 'PRINT_UM'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_PARAMETER] 
(@GROUP_ID VARCHAR(250)
,@PARAMETER_ID VARCHAR(250))
AS
BEGIN
  SET NOCOUNT ON;
  --
  SELECT acsa.SWIFT_FN_GET_PARAMETER ( @GROUP_ID, @PARAMETER_ID) [Value]
    
  
END



