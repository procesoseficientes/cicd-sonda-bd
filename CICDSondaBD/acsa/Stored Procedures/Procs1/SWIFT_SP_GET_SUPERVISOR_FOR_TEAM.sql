-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	26-JUN-2018 @ G-FORCE Sprint Elefante
-- Description:			Sp que obtine los supervisores disponibles

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_SUPERVISOR_FOR_TEAM] 
				--
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_SUPERVISOR_FOR_TEAM](@TEAM_ID INT)
AS
BEGIN

  SELECT
    [U].[CORRELATIVE]
   ,[U].[LOGIN]
   ,[U].[NAME_USER]
  FROM [acsa].[USERS] [U]
  LEFT JOIN [acsa].[SWIFT_TEAM] [T]
    ON (
    [U].[CORRELATIVE] = [T].[SUPERVISOR]    
    )
  WHERE ([T].[SUPERVISOR] IS NULL OR ([T].[SUPERVISOR] = [U].[CORRELATIVE] AND [T].[TEAM_ID] = @TEAM_ID))
END
