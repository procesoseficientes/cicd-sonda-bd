﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	04-11-2015
-- Description:			Disminulle el inventario de una bodega

/*
-- Ejemplo de Ejecucion:
				declare @pRESULT varchar(MAX)
				--
				exec [acsa].[SWIFT_SP_UPDATE_INVENTORY_BY_SONDA]
					@QTY = 3
					,@DEFAULTWHS = 'BODEGA_CENTRAL'
					,@SKU = '4000000'
					,@COMBOREFERENCE = '4000000'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_UPDATE_INVENTORY_BY_SONDA]
	@QTY			 INT
	,@DEFAULTWHS	 VARCHAR(150)
	,@SKU			 VARCHAR(25)
	,@COMBOREFERENCE VARCHAR(50)
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @INVENTORY INT, @ON_HAND INT

    UPDATE SONDA_POS_SKUS 
	SET ON_HAND = (ON_HAND - @QTY)
	WHERE ROUTE_ID = @DEFAULTWHS 
		AND SKU = @SKU 
		AND PARENT_SKU = @COMBOREFERENCE 
		AND EXPOSURE = 1
	
	SELECT 
		I.INVENTORY
		,I.ON_HAND
	INTO #NuevoInventario
	FROM SWIFT_INVENTORY I
	where I.WAREHOUSE = @DEFAULTWHS
		AND I.SKU = @SKU
		AND I.ON_HAND > 0

	WHILE (@QTY > 0)
	BEGIN
		SELECT TOP 1
			@INVENTORY = INVENTORY
			,@ON_HAND = ON_HAND
		FROM #NuevoInventario
		WHERE ON_HAND > 0
		ORDER BY ON_HAND DESC

		IF (@QTY <= @ON_HAND)
		BEGIN
			UPDATE #NuevoInventario SET ON_HAND = (ON_HAND - @QTY) WHERE INVENTORY = @INVENTORY
			SET @QTY = 0
		END
		ELSE
		BEGIN
			UPDATE #NuevoInventario SET ON_HAND = 0 WHERE INVENTORY = @INVENTORY
			SET @QTY = (@QTY - @ON_HAND)
		END
	END

	UPDATE I
	SET I.ON_HAND = T.ON_HAND
	FROM SWIFT_INVENTORY I
	INNER JOIN #NuevoInventario T ON (I.INVENTORY = t.INVENTORY)

END


