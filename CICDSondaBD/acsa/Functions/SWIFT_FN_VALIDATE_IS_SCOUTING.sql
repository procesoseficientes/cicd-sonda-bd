-- =============================================
-- Autor:				        hector.gonzalez
-- Fecha de Creacion: 	25-07-2016
-- Description:			    Valida si el poligono tine hijos 


/*
	SELECT [acsa].SWIFT_FN_VALIDATE_IS_SCOUTING ('0110000006') AS VALUE
*/
-- =============================================
CREATE FUNCTION [acsa].[SWIFT_FN_VALIDATE_IS_SCOUTING] (@ID_COSTUMER VARCHAR(50))
RETURNS INT
AS
BEGIN
  DECLARE @IS_SCOUTING INT = 1
  SELECT TOP 1
    @IS_SCOUTING = 0
  FROM acsa.SWIFT_VIEW_ALL_COSTUMER svac
  WHERE svac.CODE_CUSTOMER = @ID_COSTUMER
  RETURN @IS_SCOUTING
END

