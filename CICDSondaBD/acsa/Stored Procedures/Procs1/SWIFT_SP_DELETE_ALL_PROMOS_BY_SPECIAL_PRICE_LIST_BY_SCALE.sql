-- =============================================
-- Autor:	        christian.hernandez
-- Fecha de Creacion: 	14/11/2018 @ MAMUT
-- Description:	    elimina todas los skus a la promocion 

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_DELETE_ALL_PROMOS_BY_SPECIAL_PRICE_LIST_BY_SCALE]
					@PROMO_ID = 82
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_ALL_PROMOS_BY_SPECIAL_PRICE_LIST_BY_SCALE] (@PROMO_ID INT)
AS
BEGIN
  SET NOCOUNT ON;
  --
  BEGIN TRY
    DELETE FROM acsa.SWIFT_PROMO_SPECIAL_PRICE_LIST_BY_SCALE 
    WHERE [PROMO_ID] = @PROMO_ID
    --
    SELECT
      1 AS Resultado
     ,'Proceso Exitoso' Mensaje
     ,0 Codigo
     ,CAST(@PROMO_ID AS VARCHAR) DbData
  END TRY
  BEGIN CATCH
    SELECT
      -1 AS Resultado
     ,CASE CAST(@@error AS VARCHAR)
        WHEN '2627' THEN 'Error al eliminar los skus.'
        ELSE ERROR_MESSAGE()
      END Mensaje
     ,@@error Codigo
  END CATCH
END
