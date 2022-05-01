CREATE PROCEDURE [acsa].[SWIFT_SP_GET_INVENTORY_MOVEMENT_2](
	@START_DATETIME DATETIME
	,@END_DATETIME DATETIME
)AS	
BEGIN
	SET NOCOUNT ON;
	
	-- ------------------------------------------------------------------------------------
	-- Se generan tablas 
	-- ------------------------------------------------------------------------------------
	DECLARE @TXN_TYPE TABLE (
		[TXN_TYPE] VARCHAR(25)
	)
	--
	DECLARE @QTY_TXN_TYPE TABLE (
		[TXN_TYPE] VARCHAR(25)
		,[QTY] INT
	)

	-- ------------------------------------------------------------------------------------
	-- Se obtienen los tipos de tarea
	-- ------------------------------------------------------------------------------------
	INSERT INTO @TXN_TYPE VALUES('INIT')
	INSERT INTO @TXN_TYPE VALUES('PUTAWAY')
	INSERT INTO @TXN_TYPE VALUES('PICKING')
	--

	-- ------------------------------------------------------------------------------------
	-- Se obtiene cantidad por tipo de tarea
	-- ------------------------------------------------------------------------------------
	INSERT INTO @QTY_TXN_TYPE
	SELECT
		[TD].[TXN_TYPE]
		,COUNT([TD].[TXN_TYPE])
	FROM [acsa].[SWIFT_TXNS] [TD]
	INNER JOIN @TXN_TYPE [TT] ON (
		[TD].[TXN_TYPE] = [TT].[TXN_TYPE]
	)
	WHERE [TD].[TXN_CREATED_STAMP] BETWEEN @START_DATETIME AND @END_DATETIME
	GROUP BY [TD].[TXN_TYPE]

	SELECT
		[TXN_ID]
		,[TH].[TXN_TYPE]
		,[TXN_CREATED_STAMP]
		,[TXN_CODE_SKU] AS [SKU]
		,[TXN_DESCRIPTION_SKU] AS [SKU_DESCRIPTION]
		,CASE [TH].[TXN_TYPE]
			WHEN 'PICKING' THEN ([QTT].[QTY] * -1)
			ELSE [QTT].[QTY]
			END AS [QTY]
		,ISNULL((
					SELECT
						SUM(CASE [TD].[TXN_TYPE]
								WHEN 'INIT' THEN [TD].[TXN_QTY]
								WHEN 'PUTAWAY' THEN [TD].[TXN_QTY]
								WHEN 'PICKING' THEN ([TD].[TXN_QTY] * -1)
							END)
					FROM
						[acsa].[SWIFT_TXNS] [TD]
					WHERE
						[TD].[TXN_CREATED_STAMP] < [TH].[TXN_CREATED_STAMP]
						AND [TD].[TXN_CODE_SKU] = [TH].[TXN_CODE_SKU]
				) ,0) AS [SALDO_ANTERIOR]
		,ISNULL((
					SELECT
						SUM(CASE [TD].[TXN_TYPE]
								WHEN 'INIT' THEN [TD].[TXN_QTY]
								WHEN 'PUTAWAY' THEN [TD].[TXN_QTY]
								WHEN 'PICKING' THEN ([TD].[TXN_QTY] * -1)
							END)
					FROM
						[acsa].[SWIFT_TXNS] [TD]
					WHERE
						[TD].[TXN_CREATED_STAMP] < [TH].[TXN_CREATED_STAMP]
						AND [TD].[TXN_CODE_SKU] = [TH].[TXN_CODE_SKU]
				) ,0) + (CASE [TH].[TXN_TYPE]
							WHEN 'INIT' THEN [TH].[TXN_QTY]
							WHEN 'PUTAWAY' THEN [TH].[TXN_QTY]
							WHEN 'PICKING' THEN ([TH].[TXN_QTY] * -1)
							END) AS [NUEVO_SALDO]
		,[PT].[PALLET_ID]
		,[BT].[BATCH_SUPPLIER]
		,[BS].[BATCH_SUPPLIER_EXPIRATION_DATE]
	FROM [acsa].[SWIFT_TXNS] [TH]
	INNER JOIN @TXN_TYPE [TT] ON (
		[TH].[TXN_TYPE] = [TT].[TXN_TYPE]
	)
	INNER JOIN @QTY_TXN_TYPE [QTT] ON (
		[TH].[TXN_TYPE] = [QTT].[TXN_TYPE]
	)
	LEFT JOIN [acsa].[SWIFT_PALLET] [PS] ON (
		[PS].[PALLET_ID] = [TH].[TXN_SOURCE_PALLET_ID]
	)
	LEFT JOIN [acsa].[SWIFT_BATCH] [BS] ON (
		[BS].[BATCH_ID] = [PS].[BATCH_ID]
	)
	LEFT JOIN [acsa].[SWIFT_PALLET] [PT] ON (
		[PT].[PALLET_ID] = [TH].[TXN_TARGET_PALLET_ID]
	)
	LEFT JOIN [acsa].[SWIFT_BATCH] [BT] ON (
		[BT].[BATCH_ID] = [PT].[BATCH_ID]
	)
	WHERE [TXN_CREATED_STAMP] BETWEEN @START_DATETIME AND @END_DATETIME
	ORDER BY
		[TXN_CODE_SKU]
		,[TXN_CREATED_STAMP]
END
