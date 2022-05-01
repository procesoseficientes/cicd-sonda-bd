-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	05-10-16 @ A-TEAM Sprint 2
-- Description:			

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_DISASSOCIATE_POLYGON_X_ROUTE]
					@ROUTE = 1
					,@POLYGON_ID = 63
					,@ID_FREQUENCY = 24
				-- 
				EXEC [acsa].[SWIFT_SP_INSERT_POLYGON_X_ROUTE]
					@ROUTE = 1
					,@POLYGON_ID = 63
					,@ID_FREQUENCY = 24
					,@IS_MULTIPOLYGON = 1
				-- 
				SELECT * FROM [acsa].[SWIFT_POLYGON_BY_ROUTE] 
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DISASSOCIATE_POLYGON_X_ROUTE] (@POLYGON_ID INT)
AS
BEGIN
  BEGIN TRY

    ------------------------------------------------------------
    -- Borramos loc clientes de la frecuencia
    -- ------------------------------------------------------------
    DELETE FC
      FROM [acsa].SWIFT_FREQUENCY_X_CUSTOMER FC
      INNER JOIN [acsa].SWIFT_POLYGON_X_CUSTOMER PC
        ON (
        PC.CODE_CUSTOMER = FC.CODE_CUSTOMER
        )
    WHERE PC.POLYGON_ID = @POLYGON_ID

    ------------------------------------------------------------
    -- Borramos la asociacion del poligono y la ruta
    -- ------------------------------------------------------------
    DELETE [acsa].SWIFT_POLYGON_BY_ROUTE
    WHERE POLYGON_ID = @POLYGON_ID
    
    ------------------------------------------------------------
    -- Actualizamos los clientes para que no tenga frecuencia
    -- ------------------------------------------------------------
    UPDATE [acsa].SWIFT_POLYGON_X_CUSTOMER
    SET HAS_FREQUENCY = 0
    WHERE POLYGON_ID = @POLYGON_ID
      
    ------------------------------------------------------------
    -- Actualizamos el poligono para que este disponible para asociar
    -- ------------------------------------------------------------

    UPDATE [acsa].SWIFT_POLYGON
    SET AVAILABLE = 1
    WHERE POLYGON_ID = @POLYGON_ID

    -- ------------------------------------------------------------
    -- Muetra el resutlado
    -- ------------------------------------------------------------

    IF @@error = 0
    BEGIN
      SELECT
        1 AS RESULTADO
       ,'Proceso Exitoso' MENSAJE
       ,0 CODIGO
       ,'0' AS DbData
    END
    ELSE
    BEGIN
      SELECT
        -1 AS RESULTADO
       ,ERROR_MESSAGE() MENSAJE
       ,@@ERROR CODIGO
       ,'0' AS DbData
    END
  END TRY
  BEGIN CATCH
    SELECT
      -1 AS Resultado
     ,ERROR_MESSAGE() Mensaje
     ,@@ERROR Codigo
  END CATCH
END

