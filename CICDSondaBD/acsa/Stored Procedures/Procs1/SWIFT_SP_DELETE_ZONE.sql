-- =============================================
-- Autor:				pablo.aguilar
-- Fecha de Creacion: 	14-Dec-16 @ A-TEAM Sprint 6 
-- Description:			SP que actualiza una zona 

/*
-- Ejemplo de Ejecucion:
				EXEC  [acsa].[SWIFT_SP_DELETE_ZONE] @ZONE_ID = 2
SELECT * FROM [acsa].[SWIFT_ZONE]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_ZONE] (
  @ZONE_ID INT
  )
AS
BEGIN
  SET NOCOUNT ON;
  --

  -- ------------------------------------------------------------------------------------
  -- Operar
  -- ------------------------------------------------------------------------------------
DELETE [acsa].[SWIFT_ZONE]
WHERE ZONE_ID = @ZONE_ID;


END

