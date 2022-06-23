﻿-- =============================================
-- Autor:				joel.delcompare
-- Fecha de Creacion: 	05-11-2015
-- Description:			alteracion del sp para que no vea la tabla de usuarios de dbo

-- Modificado Fecha
-- joel.delcompare
-- Error de privilegios a la hora de ejecutar el sp

-- Modifiación: 	2017-06-29 @ Team Reborn - Sprint Anpassung 
-- Autor:	        rudi.garcia
-- Description:	  Se agrega la condicion que solo retornara los registros "[IS_SCREEN] = 1"

/*
-- Ejemplo de Ejecucion:
      USE [$(CICDSondaBD)]
      GO
      
      DECLARE	@return_value int
      
      EXEC	@return_value = [acsa].[SWIFT_SP_GET_PRIVILEGES]
      		@USER = N'gerente@acsa'
      
      SELECT	'Return Value' = @return_value
      
      GO
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_PRIVILEGES] @USER VARCHAR(50)  WITH RECOMPILE
AS

  SELECT
    U.[LOGIN]
   ,P.PRIVILEGE_ID AS NAME
   ,P.DISPLAY_NAME
  FROM [acsa].USERS U
  INNER JOIN [acsa].[SWIFT_ROLE] R
    ON (
    R.ROLE_ID = U.USER_ROLE
    )
  INNER JOIN [acsa].[SWIFT_PRIVILEGES_X_ROLE] PR
    ON (
    R.ROLE_ID = PR.ROLE_ID
    )
  INNER JOIN [acsa].[SWIFT_PRIVILEGES] P
    ON (
    PR.PRIVILEGE_ID = P.ID
    AND [P].[IS_SCREEN] = 1
    )
  WHERE U.LOGIN = @USER
  ORDER BY [p].[SEQUENCE] ASC
  RETURN 0

