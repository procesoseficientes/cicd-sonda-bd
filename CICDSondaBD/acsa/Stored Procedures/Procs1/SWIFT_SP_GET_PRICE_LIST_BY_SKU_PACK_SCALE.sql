-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		12-05-2016
-- Description:			    SP que envia la lista de precios por escalas y unidad de medida

-- Modificacion 17-Feb-17 @ A-Team Sprint Chatuluka
-- alberto.ruiz
-- Se agrego distinct al select final

-- Modificacion 3/7/2017 @ A-Team Sprint Ebonne
-- rodrigo.gomez
-- Se agrego la lista de precios establecida al usuario

-- Modificacion 03-May-17 @ A-Team Sprint Hondo
-- alberto.ruiz
-- Se cambia para que obtenga la lista de precios de la tabla SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE_FOR_ROUTE

-- Modificacion 14-Jun-17 @ A-Team Sprint Jibade
-- alberto.ruiz
-- Se ajusta envio de precios para que solo obtenga los del plan de ruta

/*
-- Ejemplo de Ejecucion:
        EXEC [acsa].[SWIFT_SP_GET_PRICE_LIST_BY_SKU_PACK_SCALE]
			@CODE_ROUTE = '137' 
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_PRICE_LIST_BY_SKU_PACK_SCALE] (@CODE_ROUTE VARCHAR(50))
AS
BEGIN
  SET NOCOUNT ON;
  --
  DECLARE @PRICE_LIST TABLE (
    [CODE_ROUTE] VARCHAR(50)
   ,[CODE_PRICE_LIST] VARCHAR(50)
  )

  -- ------------------------------------------------------------------------------------
  -- Obtiene las listas de precios
  -- ------------------------------------------------------------------------------------
  INSERT INTO @PRICE_LIST ([CODE_ROUTE]
  , [CODE_PRICE_LIST])
    SELECT DISTINCT
      @CODE_ROUTE
     ,PL.[CODE_PRICE_LIST]
    FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE_FOR_ROUTE] AS PL
    INNER JOIN [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE] CR
      ON [CR].[CODE_PRICE_LIST] = [PL].[CODE_PRICE_LIST]
      AND [CR].[CODE_ROUTE] = [PL].[CODE_ROUTE]
    INNER JOIN [acsa].[SONDA_ROUTE_PLAN] [RP]
      ON ([RP].[CODE_ROUTE] = [PL].[CODE_ROUTE]
      AND CR.[CODE_CUSTOMER] = [RP].[RELATED_CLIENT_CODE])
    WHERE [PL].[CODE_ROUTE] = @CODE_ROUTE

  INSERT INTO @PRICE_LIST ([CODE_ROUTE]
  , [CODE_PRICE_LIST])
    SELECT DISTINCT
      @CODE_ROUTE
     ,CR.[CODE_PRICE_LIST]
    FROM [acsa].[SWIFT_VIEW_ALL_COSTUMER] AS SVAC
	INNER JOIN [acsa].[USERS] [US] ON [US].[RELATED_SELLER] = [SVAC].[SELLER_DEFAULT_CODE]
    INNER JOIN [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE] CR
      ON [CR].[CODE_CUSTOMER]= [SVAC].[CODE_CUSTOMER]
      AND [CR].[CODE_ROUTE] = [US].[SELLER_ROUTE]
	LEFT JOIN @PRICE_LIST [PL] ON [PL].[CODE_PRICE_LIST] = [CR].[CODE_PRICE_LIST]
    WHERE [US].[SELLER_ROUTE] = @CODE_ROUTE AND [PL].[CODE_PRICE_LIST] IS NULL

  --
  INSERT INTO @PRICE_LIST ([CODE_ROUTE], [CODE_PRICE_LIST])
    VALUES (@CODE_ROUTE, '-1')

  -- ------------------------------------------------------------------------------------
  -- Muestra el resultado
  -- ------------------------------------------------------------------------------------
  SELECT DISTINCT
    [PL].[CODE_PRICE_LIST]
   ,[PL].[CODE_SKU]
   ,[PL].[CODE_PACK_UNIT]
   ,[PL].[PRIORITY]
   ,[PL].[LOW_LIMIT]
   ,[PL].[HIGH_LIMIT]
   ,[PL].[PRICE]
  FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE_FOR_ROUTE] AS [PL]
  INNER JOIN @PRICE_LIST [RP]
    ON (
    [RP].[CODE_ROUTE] = [PL].[CODE_ROUTE]
    AND [RP].[CODE_PRICE_LIST] = [PL].[CODE_PRICE_LIST]
    )
  ORDER BY [PL].[CODE_PRICE_LIST], [PL].[CODE_SKU]


END


