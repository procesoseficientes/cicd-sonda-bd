-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	06-Dec-16 @ A-TEAM Sprint 6 
-- Description:			SP que obtiene las bodegas asociadas a una zona 

/*
-- Ejemplo de Ejecucion:
				EXEC  [acsa].[SWIFT_SP_INSERT_WAREHOUSE_BY_ZONE] @ID_ZONE = 1, @CODE_WAREHOUSE = '01'
SELECT * FROM [acsa].[SWIFT_WAREHOUSE_X_ZONE]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_INSERT_WAREHOUSE_BY_ZONE] (@ID_ZONE INT
  , @CODE_WAREHOUSE VARCHAR(50)
  )
AS
BEGIN
  SET NOCOUNT ON;
  --

  -- ------------------------------------------------------------------------------------
  -- Muestra el resultado
  -- ------------------------------------------------------------------------------------
INSERT INTO [acsa].[SWIFT_WAREHOUSE_X_ZONE] ([ID_ZONE], [CODE_WAREHOUSE])
  VALUES (@ID_ZONE, @CODE_WAREHOUSE);


END

