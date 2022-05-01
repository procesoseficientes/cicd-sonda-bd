-- =============================================
-- Autor:				Christian Hernandez 
-- Fecha de Creacion: 	07-13-2018
-- Description:			Selecciona el detalle de pagos hechos en facturas 

-- Modificacion 		7/8/2019 @ G-Force Team Sprint ESTOCOLMO
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 30230: Visualizacion de Facturas Vencidas
-- Descripcion: 		7/8/2019 - Se envia columna [PAYED_AMOUNT] para que en el BO refleje el monto pagado en el documento seleccionado
--						Se agregan columnas AMOUNT_TO_DATE, PENDING_AMOUNT ya que estaba mostrando mal los datos del documento de pago

/*
-- Ejemplo de Ejecucion:				
	exec [acsa].SWIFT_SP_GET_INVOICE_OVERDUE_BY_RECEIPTS
	@PAYMENT_HEADER_ID = 111
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_INVOICE_OVERDUE_BY_RECEIPTS]
(@PAYMENT_HEADER_ID AS INT)
AS
BEGIN
    --
    SET NOCOUNT ON;

    --
    SELECT [SPD].[INVOICE_ID],
           [SPH].[POSTED_DATE],
           [SPH].[CREATED_DATE],
           [OIC].[TOTAL_AMOUNT],
           [SPD].[AMOUNT_TO_DATE],
           [SPD].[PAYED_AMOUNT] AS [AMOUNT_PAYED],
           [SPD].[PENDING_AMOUNT] AS [PENDING_TO_PAID]
    FROM [acsa].[SONDA_OVERDUE_INVOICE_PAYMENT_HEADER] [SPH]
        INNER JOIN [acsa].[SONDA_OVERDUE_INVOICE_PAYMENT_DETAIL] [SPD]
            ON [SPH].[ID] = [SPD].[PAYMENT_HEADER_ID]
        INNER JOIN [acsa].[SWIFT_OVERDUE_INVOICE_BY_CUSTOMER] [OIC]
            ON [OIC].[INVOICE_ID] = [SPD].[INVOICE_ID]
    WHERE [SPD].[PAYMENT_HEADER_ID] = @PAYMENT_HEADER_ID;
END;
