-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	14-Oct-16 @ A-TEAM Sprint 3 
-- Description:			SP que anula la consignacion

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_VOID_CONSIGNMENT]
					@DOC_SERIE = 'Serie Re-Consignación'
					,@DOC_NUM = 18
					,@REASON = 'Ya no queria el producto'
					,@DEFAULT_WAREHOUSE = 'C001'
				--
				SELECT * FROM [acsa].[SWIFT_CONSIGNMENT_HEADER] 
				WHERE [DOC_SERIE] = 'Serie Re-Consignación'
					AND [DOC_NUM] = 18
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_VOID_CONSIGNMENT](
	@DOC_SERIE VARCHAR(50)
	,@DOC_NUM INT
	,@REASON VARCHAR(250)
	,@DEFAULT_WAREHOUSE VARCHAR(250)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	UPDATE [acsa].[SWIFT_CONSIGNMENT_HEADER]
	SET [REASON] = @REASON
		,[STATUS] = 'VOID'
		,[IS_CLOSED] = 1
		,[IS_POSTED] = 5
		,[DATE_UPDATE] = GETDATE()
	WHERE [DOC_SERIE] = @DOC_SERIE
		AND [DOC_NUM] = @DOC_NUM

	-- --------------------------------------------------------------------------------
	-- ACTUALIZA [acsa].SONDA_POS_SKUS
	-- --------------------------------------------------------------------------------
	UPDATE POS_SKUS
	SET
		POS_SKUS.ON_HAND = (POS_SKUS.ON_HAND + CONS_DETAIL.QTY)
	FROM
		[acsa].[SONDA_POS_SKUS] AS POS_SKUS
		INNER JOIN [acsa].[SWIFT_CONSIGNMENT_DETAIL] AS CONS_DETAIL
			ON(POS_SKUS.SKU = CONS_DETAIL.SKU)
	WHERE CONS_DETAIL.CONSIGNMENT_ID = (
			SELECT TOP 1 CONSIGNMENT_ID FROM [acsa].[SWIFT_CONSIGNMENT_HEADER] AS CH 
			WHERE CH.DOC_SERIE = @DOC_SERIE AND CH.DOC_NUM = @DOC_NUM
	) AND POS_SKUS.ROUTE_ID = @DEFAULT_WAREHOUSE
	
	-- --------------------------------------------------------------------------------
	-- ACTUALIZA [acsa].[SWIFT_INVENTORY]
	-- --------------------------------------------------------------------------------
	UPDATE INVENTORY
	SET
		INVENTORY.ON_HAND = (INVENTORY.ON_HAND + CONS_DETAIL.QTY)
	FROM
		[acsa].[SWIFT_INVENTORY] AS INVENTORY
		INNER JOIN [acsa].[SWIFT_CONSIGNMENT_DETAIL] AS CONS_DETAIL
			ON(INVENTORY.SKU = CONS_DETAIL.SKU)
	WHERE CONS_DETAIL.CONSIGNMENT_ID = (
			SELECT TOP 1 CONSIGNMENT_ID FROM [acsa].[SWIFT_CONSIGNMENT_HEADER] AS CH 
			WHERE CH.DOC_SERIE = @DOC_SERIE AND CH.DOC_NUM = @DOC_NUM
	) AND INVENTORY.WAREHOUSE = @DEFAULT_WAREHOUSE
END

