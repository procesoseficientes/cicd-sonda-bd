-- =============================================
-- Autor:				alejandro.ochoa
-- Fecha de Creacion: 	20-07-2016
-- Description:			SP que importa Familias de SKU

/*
-- Ejemplo de Ejecucion:
				-- 
				EXEC [acsa].[BULK_DATA_SP_IMPORT_SKU_FAMILY]
*/
-- =============================================
CREATE PROCEDURE [acsa].[BULK_DATA_SP_IMPORT_SKU_FAMILY]
AS
BEGIN
  SET NOCOUNT ON;
  --
  -- ------------------------------------------------------------------------------------
  -- Obtiene las familias de productos
  -- ------------------------------------------------------------------------------------
  MERGE SWIFT_EXPRESS_R.acsa.[SWIFT_SKU_FAMILY] TRG
  USING (SELECT
      *
    FROM SWIFT_INTERFACES_ONLINE_R.acsa.[ERP_VIEW_SKU_FAMILY]) AS SRC
  ON TRG.CODE_FAMILY_SKU = SRC.CODE_FAMILY_SKU
  WHEN MATCHED
    THEN UPDATE
      SET TRG.[DESCRIPTION_FAMILY_SKU] = SRC.[DESCRIPTION_FAMILY_SKU]
         ,TRG.[ORDER] = SRC.[ORDER]
         ,TRG.[LAST_UPDATE] = SRC.[LAST_UPDATE]
         ,TRG.[LAST_UPDATE_BY] = SRC.[LAST_UPDATE_BY]
  WHEN NOT MATCHED
    THEN INSERT ([CODE_FAMILY_SKU],
		[DESCRIPTION_FAMILY_SKU],
		[ORDER],
		[LAST_UPDATE],
		[LAST_UPDATE_BY])
        VALUES (SRC.[CODE_FAMILY_SKU],
			SRC.[DESCRIPTION_FAMILY_SKU],
			SRC.[ORDER],
			SRC.[LAST_UPDATE],
			SRC.[LAST_UPDATE_BY]);

END