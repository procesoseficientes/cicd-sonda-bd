-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	1/12/2017 @ A-TEAM Sprint Adeben 
-- Description:			SP que elimina la asociacion entre un acuerdo comercial y una ruta

-- Autor:	        hector.gonzalez
-- Fecha de Creacion: 	2017-08-16 @ Team REBORN - Sprint 
-- Description:	   Se agrego update a talba SWIFT_TRADE_AGREEMENT

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_DISASSOCIATE_ROUTE_FROM_TRADE_AGREEMENT]
					@CODE_ROUTE = 'R004'
				-- 
				SELECT * FROM [acsa].[SWIFT_ROUTES]
        SELECT * FROM [acsa].[SWIFT_TRADE_AGREEMENT]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DISASSOCIATE_ROUTE_FROM_TRADE_AGREEMENT] (@CODE_ROUTE VARCHAR(50))
AS
BEGIN
  BEGIN TRY

    DECLARE @TRADE_AGREEMENT_ID INT;

    SET @TRADE_AGREEMENT_ID = (SELECT TOP 1
        [TRADE_AGREEMENT_ID]
      FROM [acsa].[SWIFT_ROUTES]
      WHERE [CODE_ROUTE] = @CODE_ROUTE)

    UPDATE [acsa].[SWIFT_ROUTES]
    SET [TRADE_AGREEMENT_ID] = NULL
    WHERE @CODE_ROUTE = [CODE_ROUTE]
    --
    UPDATE [acsa].[SWIFT_TRADE_AGREEMENT]
    SET [LAST_UPDATE] = GETDATE()
    WHERE [TRADE_AGREEMENT_ID] = @TRADE_AGREEMENT_ID;

    SELECT
      1 AS Resultado
     ,'Proceso Exitoso' Mensaje
     ,0 Codigo
     ,'' DbData
  END TRY
  BEGIN CATCH
    SELECT
      -1 AS Resultado
     ,CASE CAST(@@error AS VARCHAR)
        WHEN '2627' THEN 'No se pudo desasociar el acuerdo comercial a la ruta.'
        ELSE ERROR_MESSAGE()
      END Mensaje
     ,@@error Codigo
  END CATCH
END

