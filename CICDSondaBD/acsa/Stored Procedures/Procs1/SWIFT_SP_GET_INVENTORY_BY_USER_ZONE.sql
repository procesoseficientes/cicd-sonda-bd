-- =============================================
-- Autor:				pablo.aguilar
-- Fecha de Creacion: 	14-Dec-16 @ A-TEAM Sprint 6 
-- Description:			SP que obtiene el inventario de una zona asociada a un login 

-- Modificacion 20-Jun-17 @ A-Team Sprint Khalid
					-- alberto.ruiz
					-- Se cambia para que consuma la tabla [SONDA_INVENTORY_ONLINE]

/*
-- Ejemplo de Ejecucion:
				EXEC  [acsa].[SWIFT_SP_GET_INVENTORY_BY_USER_ZONE] @CODE_ROUTE = '44'
                                                    ,@CODE_SKU = '100002'
				--
			SELECT * FROM [acsa].[SONDA_INVENTORY_ONLINE] [s]

*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_INVENTORY_BY_USER_ZONE] (
	@CODE_ROUTE VARCHAR(50)
	,@CODE_SKU VARCHAR(50)
) AS
BEGIN
  SET NOCOUNT ON;
  --
	SELECT
		[SI].[CODE_SKU] [SKU]--@CODE_SKU [SKU]
		,SUM([SI].[ON_HAND]) [ON_HAND]
		,[SI].[CODE_WAREHOUSE] [WAREHOUSE]
		,MAX(S.[DESCRIPTION_SKU]) [DESCRIPTION_SKU]
	FROM [acsa].[SONDA_INVENTORY_ONLINE] [SI]
	INNER JOIN [acsa].[SWIFT_WAREHOUSES] [W] ON ([SI].[CODE_WAREHOUSE] = [W].[CODE_WAREHOUSE])
	INNER JOIN [acsa].[SWIFT_WAREHOUSE_X_ZONE] [WZ] ON ([W].[CODE_WAREHOUSE] = [WZ].[CODE_WAREHOUSE])
	INNER JOIN [acsa].[SWIFT_VIEW_ALL_SKU] [S] ON ([S].[CODE_SKU] = [SI].[CODE_SKU])
	INNER JOIN [acsa].[USERS] [U] ON ([U].[ZONE_ID] = [WZ].[ID_ZONE])
	WHERE [SI].[INVENTORY_ONLINE] > 0
		AND [SI].[CODE_SKU] LIKE ('%' + @CODE_SKU + '%')
		AND [U].[SELLER_ROUTE] = @CODE_ROUTE
	GROUP BY [SI].[CODE_WAREHOUSE], [SI].[CODE_SKU];
END
