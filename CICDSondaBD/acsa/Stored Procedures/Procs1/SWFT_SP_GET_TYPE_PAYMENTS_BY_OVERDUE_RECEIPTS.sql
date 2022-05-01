-- =============================================
-- Autor:				Christian Hernandez 
-- Fecha de Creacion: 	07-13-2018
-- Description:			Selecciona los tipos de pagos por facturas vencidas de sonda pos

-- Modificacion 		7/9/2019 @ G-Force Team Sprint ESTOCOLMO
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 30230: Visualizacion de Facturas Vencidas
-- Descripcion: 		7/9/2019 - Se elimina "AND PT.PAYMENT_TYPE <> 'CASH'" ya que no mostraba tipo de pago en efectivo en la pantalla del BO

/*
-- Ejemplo de Ejecucion:				
				--exec [acsa].[SWFT_SP_GET_TYPE_PAYMENTS_BY_RECEIPTS]
							   	@PAYMENT_HEADER_ID = 1 
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWFT_SP_GET_TYPE_PAYMENTS_BY_OVERDUE_RECEIPTS] @PAYMENT_HEADER_ID AS INT
AS
SELECT [PT].[PAYMENT_TYPE_ID],
       [PT].[PAYMENT_HEADER_ID],
       CASE [PT].[PAYMENT_TYPE]
           WHEN 'BANK_CHECK' THEN
               'Cheque'
           WHEN 'BANK_DEPOSIT' THEN
               'Deposito'
           ELSE
               'Efectivo'
       END AS [PAYMENT_TYPE],
       [PT].[AMOUNT],
       [PT].[DOCUMENT_NUMBER],
       [PT].[BANK_NAME],
       [PT].[FRONT_IMAGE],
       [PT].[BACK_IMAGE]
FROM [acsa].[SONDA_PAYMENT_TYPE_DETAIL_FOR_OVERDUE_INVOICE_PAYMENT] [PT]
WHERE [PT].[PAYMENT_HEADER_ID] = @PAYMENT_HEADER_ID;
