
-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	1-09-2016
-- Description:			obtiene los pallets por tarea

/*
-- Ejemplo de Ejecucion:				
				--
EXECUTE  [acsa].[SWIFT_SP_GET_PALLETS_BY_TASK] 
		@@TASK = 1
		, @CODE_SKU = '4000001'

				--				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_PALLETS_BY_TASK]
    @TASK INT,
	@CODE_SKU VARCHAR(50),
	@STATUS VARCHAR(20)
		
AS
BEGIN 

	SET NOCOUNT ON;

	SELECT
		PL.[PALLET_ID]
		,PL.[BATCH_ID]
		,PL.[STATUS]
		,PL.[QTY]      
		,[WAREHOUSE]
		,[LOCATION]
		,PL.[TASK_ID]
	FROM [acsa].[SWIFT_PALLET] PL
	INNER JOIN [acsa].[SWIFT_BATCH] BT ON (PL.BATCH_ID = BT.BATCH_ID)	
	WHERE 
		PL.TASK_ID = @TASK		
		AND BT.SKU = @CODE_SKU
		AND (@STATUS  IS NULL OR PL.STATUS = @STATUS)
	ORDER BY PL.PALLET_ID DESC

END








