-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	17-01-2016
-- Description:			Insertar un nuevo registro en inventario del registro ajustado
-- =============================================
-- Autor:				gustavo.garcia
-- Fecha de Creacion: 	26-03-2019
-- Description:			Se agregan campos faltantes de la tabla para que pueda ser actualizado automaticamente
--						para CI/CD
-- =============================================
/*
-- Ejemplo de Ejecucion:				
				--
				EXEC [acsa].[SWIFT_SP_INVENTORY_INSERT_BY_ADJUSTMENT]
						@PALLET_ID_OLD = 41
						,@PALLET_ID_NEW = 42
						,@QTY = 1
						,@LAST_UPDATE_BY = 'OPER2@acsa'
						,@TXN_ID = 618
				--
				SELECT * from [acsa].[SWIFT_INVENTORY] I WHERE I.PALLET_ID in (41,42)
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_INVENTORY_INSERT_BY_ADJUSTMENT]
	@PALLET_ID_OLD INT
	,@PALLET_ID_NEW INT
	,@BATCH_ID_NEW int
	,@QTY INT
	,@LAST_UPDATE_BY VARCHAR(50)
	,@TXN_ID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO [acsa].[SWIFT_INVENTORY]
	SELECT TOP 1
      I.[SERIAL_NUMBER]
      ,I.[WAREHOUSE]
      ,I.[LOCATION]
      ,I.[SKU]
      ,I.[SKU_DESCRIPTION]
      ,@QTY
      ,@BATCH_ID_NEW
      ,GETDATE()
      ,@LAST_UPDATE_BY
      ,@TXN_ID
      ,I.[IS_SCANNED]
      ,I.[RELOCATED_DATE]
      ,@PALLET_ID_NEW
	  ,I.[OWNER] 
	  ,I.[OWNER_ID]
	  ,I.[CODE_PACK_UNIT_STOCK]
	FROM [acsa].[SWIFT_INVENTORY] I
	WHERE I.PALLET_ID = @PALLET_ID_OLD
END
