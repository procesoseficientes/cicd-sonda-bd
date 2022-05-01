-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	30-Jan-17 @ A-TEAM Sprint Bankole 
-- Description:			SP que obtiene el detalle de una transferencia 

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_TRANSFER_DETAIL_BY_TRANSFER_ID]
					@TRANSFER_ID = 119
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_TRANSFER_DETAIL_BY_TRANSFER_ID](
	@TRANSFER_ID INT
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT
        [TD].[TRANSFER_ID]
        ,[TD].[SKU_CODE]
        ,S.[DESCRIPTION_SKU]
        ,[TD].[QTY]
        ,[TD].[STATUS]
        ,[TD].[SERIE]
        ,[s].[CODE_PACK_UNIT] AS [SALES_PACK_UNIT]
        ,'ST' AS [CODE_PACK_UNIT_STOCK] 
		,[S].[VAT_CODE]
    FROM [acsa].[SWIFT_TRANSFER_DETAIL] [TD]
    INNER JOIN acsa.[SWIFT_VIEW_ALL_SKU] [S] ON([S].[CODE_SKU] = [TD].[SKU_CODE])
    WHERE [TD].[TRANSFER_ID] = @TRANSFER_ID
END
