-- =============================================
-- Autor:	        hector.gonzalez
-- Fecha de Creacion: 	2017-07-03 @ Team REBORN - Sprint Anpassung
-- Description:	        SP que trae las bonificaciones por monto general por promocion id

/*
-- Ejemplo de Ejecucion:
			EXEC  [acsa].[SWIFT_SP_GET_BONUS_BY_GENERAL_AMOUNT_FROM_PROMO] @PROMO_ID = 1103
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_BONUS_BY_GENERAL_AMOUNT_FROM_PROMO] (@PROMO_ID INT) WITH RECOMPILE
AS
BEGIN
  SET NOCOUNT ON;
  --

  SELECT
    [BGA].[PROMO_BONUS_BY_GENERAL_AMOUNT_ID]
   ,[BGA].[LOW_LIMIT]
   ,[BGA].[HIGH_LIMIT]
   ,[BGA].[CODE_SKU_BONUS]
   ,[VAS].[DESCRIPTION_SKU]
   ,[BGA].[PACK_UNIT_BONUS]
   ,[PU].[DESCRIPTION_PACK_UNIT]
   ,[BGA].[BONUS_QTY]
  FROM [acsa].[SWIFT_PROMO_BONUS_BY_GENERAL_AMOUNT] [BGA]
  INNER JOIN [acsa].[SWIFT_VIEW_ALL_SKU] [VAS]
    ON [BGA].[CODE_SKU_BONUS] = [VAS].[CODE_SKU]
  INNER JOIN [acsa].[SONDA_PACK_UNIT] [PU]
    ON [PU].[PACK_UNIT] = [BGA].[PACK_UNIT_BONUS]
  WHERE [BGA].[PROMO_ID] = @PROMO_ID  

END

