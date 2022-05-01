-- =============================================
-- Autor:				Yaqueline Canahui
-- Fecha de Creacion: 	05-07-2018
-- Description:			Cancelacion de metas

/*
-- Ejemplo de Ejecucion:
				exec [acsa].[SWIFT_SP_CANCEL_GOAL]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_CANCEL_GOAL] @GOAL_HEADER_ID AS INT,
@CLOSED_BY AS VARCHAR(25)
AS
BEGIN
  DECLARE @CURRENT_STATUS AS VARCHAR(50) = 'CANCELED';
  BEGIN TRY
    --Se realizan los calculos para la meta diaria por vendedor
    BEGIN
      --Validamos el estado actual de la meta
      SELECT
        @CURRENT_STATUS = STATUS
      FROM [acsa].SWIFT_GOAL_HEADER
      WHERE GOAL_HEADER_ID = @GOAL_HEADER_ID;

      IF @CURRENT_STATUS <> 'FINISHED' --Solo si la meta esta en progreso
      BEGIN
        --Se elimina el detalle de la meta
        UPDATE [acsa].SWIFT_GOAL_HEADER
        SET STATUS = 'CANCELED'
           ,GOAL_CLOSE_DATE = GETDATE()
           ,CLOSED_BY = @CLOSED_BY
        WHERE GOAL_HEADER_ID = @GOAL_HEADER_ID;

        -- -----------------------------------------------------------
        -- Se devuelve resultado positivo
        -- -----------------------------------------------------------
        SELECT
          1 AS Resultado
         ,'Proceso Exitoso' Mensaje
         ,0 Codigo
         ,'0' DbData;
      END;
    END;
  END TRY
  BEGIN CATCH
    SELECT
      -1 AS Resultado
     ,ERROR_MESSAGE() Mensaje
     ,@@ERROR Codigo;
  END CATCH;
END;
