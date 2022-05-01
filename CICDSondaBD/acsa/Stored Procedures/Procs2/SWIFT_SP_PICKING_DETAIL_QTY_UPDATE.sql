-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	21-01-2016
-- Description:			Actualiza el picking detail
-- =============================================
/*
-- Ejemplo de Ejecucion:
					--
					EXEC [acsa].[SWIFT_SP_PICKING_DETAIL_QTY_UPDATE]
						@PICKING_NUMBER = 143
						,@CODE_SKU = 'GF 230'
						,@QTY = 2
						,@LAST_UPDATE_BY = 'OPER2@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_PICKING_DETAIL_QTY_UPDATE]
	@PICKING_NUMBER INT
	,@CODE_SKU VARCHAR(50)
	,@QTY INT
	,@LAST_UPDATE_BY VARCHAR(50)
AS
BEGIN	
	SET NOCOUNT ON;

    UPDATE [acsa].[SWIFT_PICKING_DETAIL] SET
		SCANNED = (SCANNED + @QTY)
		,LAST_UPDATE = GETDATE()
		,LAST_UPDATE_BY = @LAST_UPDATE_BY
	WHERE PICKING_HEADER = @PICKING_NUMBER
		AND CODE_SKU = @CODE_SKU
END



