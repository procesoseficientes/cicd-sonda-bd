-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	26-JUN-2018 @ G-FORCE Sprint Elefante
-- Description:			Sp que agrega el encabezado del equipo

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_DELETE_TEAM]
					  @TEAM_ID = 1          
				-- 
				SELECT * FROM [acsa].[SWIFT_TEAM]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_TEAM] (@TEAM_ID INT)
AS
BEGIN
  BEGIN TRY
    --
    DELETE FROM [acsa].[SWIFT_USER_BY_TEAM] WHERE [TEAM_ID] = @TEAM_ID
    --
    DELETE FROM [acsa].[SWIFT_TEAM] WHERE [TEAM_ID] = @TEAM_ID
    --
    SELECT
      1 AS Resultado
     ,'Proceso Exitoso' Mensaje
     ,0 Codigo
     ,CAST(@TEAM_ID AS VARCHAR) DbData
  END TRY
  BEGIN CATCH
    SELECT
      -1 AS Resultado
     ,CASE CAST(@@ERROR AS VARCHAR)
        WHEN '2627' THEN 'Error: Ya existe el equipo'
        ELSE ERROR_MESSAGE()
      END Mensaje
     ,@@ERROR Codigo
  END CATCH
END
