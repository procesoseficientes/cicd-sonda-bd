-- =============================================
-- Autor:				alejandro.ochoa
-- Fecha de Creacion: 	18-08-2017
-- Description:			Actualiza totales del encabezado del pedido por descuadre en milesimas de Centavo

/*
-- Ejemplo de Ejecucion:
        USE $(CICDSondaBD)
        GO
        --
        EXEC [acsa].[SONDA_SP_SET_ORDER_HEADER_AMOUNT]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_SET_ORDER_HEADER_AMOUNT]
AS
BEGIN
	SET NOCOUNT ON;
	--
	BEGIN TRY
		UPDATE [B]
		SET B.[TOTAL_AMOUNT]=[A].[TOTAL_LINES]
		FROM (SELECT d.[SALES_ORDER_ID],SUM([TOTAL_LINE]) TOTAL_LINES FROM acsa.[SONDA_SALES_ORDER_DETAIL] d
		INNER JOIN [acsa].[SONDA_SALES_ORDER_HEADER] h ON [h].[SALES_ORDER_ID] = [d].[SALES_ORDER_ID]
		WHERE [IS_READY_TO_SEND]=1
		AND ISNULL(h.[IS_POSTED_ERP],0)=0
		GROUP BY d.[SALES_ORDER_ID],h.[TOTAL_AMOUNT]
		HAVING h.[TOTAL_AMOUNT] <> SUM([TOTAL_LINE])) A
		INNER JOIN [acsa].[SONDA_SALES_ORDER_HEADER] B ON [B].[SALES_ORDER_ID] = [A].[SALES_ORDER_ID]

		PRINT ('UPDATED: ' + CAST(@@ROWCOUNT AS VARCHAR (20)) + ' ROWS.' )

	END TRY
	BEGIN CATCH
		PRINT ('CRASH IN UPDATE: ' + ERROR_MESSAGE() )
	END CATCH

END
