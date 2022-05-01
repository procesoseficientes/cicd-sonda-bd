-- =============================================
-- Autor:				ppablo.loukota
-- Fecha de Creacion: 	07-01-2016
-- Description:			Valida si el Pallet tiene Batchs todavia para poderse cerrar

/*
-- Ejemplo de Ejecucion:
				SELECT [acsa].[SWIFT_FN_VALIDATE_PALLET_BATCH]1
*/
-- =============================================


CREATE FUNCTION [acsa].[SWIFT_FN_VALIDATE_PALLET_BATCH]
(
	@BATCH_ID INT 
)
RETURNS INT
AS
BEGIN


	DECLARE @QUANT INT 


	SELECT  @QUANT = COUNT(*)/COUNT(*)
	FROM [acsa].[SWIFT_PALLET]
	WHERE [BATCH_ID] = @BATCH_ID 

	RETURN @QUANT



END

