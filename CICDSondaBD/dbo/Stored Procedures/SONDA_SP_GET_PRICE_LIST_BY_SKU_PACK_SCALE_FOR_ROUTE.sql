
-- =============================================
-- Autor:					Christian Hernandez
-- Fecha de Creacion: 		25-05-2018
-- Description:			    SP que envia la lista de precios por escalas y unidad de medida
-- ==============================================

CREATE PROCEDURE [SONDA_SP_GET_PRICE_LIST_BY_SKU_PACK_SCALE_FOR_ROUTE]
	(
		@CODE_ROUTE VARCHAR(50)
	)
AS
	BEGIN
		SET NOCOUNT ON;
  --
		DECLARE	@PRICE_LISTS TABLE
			(
				[CODE_ROUTE] VARCHAR(100)
				,[CODE_PRICE_LIST] VARCHAR(100)
			);
		
	-- ------------------------------------------------------------------------
	-- SE OBTIENEN LAS LISTAS DE PRECIOS DE LOS CLIENTES EN EL PLAN DE RUTA
	-- ------------------------------------------------------------------------
		INSERT	INTO @PRICE_LISTS
				(
					[CODE_ROUTE]
					,[CODE_PRICE_LIST]
				)
		SELECT
			@CODE_ROUTE
			,[PBCFR].[CODE_PRICE_LIST]
		FROM
			[ACSA].[SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE] [PBCFR]
		WHERE
			[PBCFR].[CODE_CUSTOMER] IN (
			SELECT
				[RP].[RELATED_CLIENT_CODE]
			FROM
				[ACSA].[SONDA_ROUTE_PLAN] [RP]
			WHERE
				[RP].[CODE_ROUTE] = @CODE_ROUTE
				AND [RP].[TASK_TYPE] = 'SALE'
				--AND CAST([RP].[TASK_DATE] AS DATE) = CAST(GETDATE() AS DATE)
				);

	-- ------------------------------------------------------------------------
	-- SE OBTIENE LA LISTA DE PRECIOS DEFAULT
	-- ------------------------------------------------------------------------
		INSERT	INTO @PRICE_LISTS
				([CODE_PRICE_LIST] ,[CODE_ROUTE])
		VALUES
				('-1'  -- CODE_PRICE_LIST - varchar(100)
					,@CODE_ROUTE);


		SELECT DISTINCT
			[PBSPS].[CODE_PRICE_LIST]
			,[PBSPS].[CODE_SKU]
			,[PBSPS].[CODE_PACK_UNIT]
			,[PBSPS].[PRIORITY]
			,[PBSPS].[LOW_LIMIT]
			,[PBSPS].[HIGH_LIMIT]
			,[PBSPS].[PRICE]
		FROM
			[ACSA].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE_FOR_ROUTE] AS [PBSPS]
		INNER JOIN @PRICE_LISTS AS [PL]
		ON	([PL].[CODE_PRICE_LIST] = [PBSPS].[CODE_PRICE_LIST])
		INNER JOIN [ACSA].[USERS] [FU]
		ON	([PBSPS].[CODE_ROUTE] = [FU].[SELLER_ROUTE])
		INNER JOIN [ACSA].[SONDA_POS_SKUS] AS [PS]
		ON	(
				[PS].[SKU] = [PBSPS].[CODE_SKU]
				AND [PS].[ROUTE_ID] = [FU].[DEFAULT_WAREHOUSE]
			)
		WHERE
			[PBSPS].[CODE_ROUTE] = @CODE_ROUTE
		ORDER BY
			[PBSPS].[CODE_PRICE_LIST]
			,[PBSPS].[CODE_SKU];
			


	END;