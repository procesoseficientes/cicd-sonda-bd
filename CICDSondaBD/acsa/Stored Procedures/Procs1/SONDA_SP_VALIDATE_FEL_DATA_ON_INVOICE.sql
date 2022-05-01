-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	12/5/2019 @ G-Force - TEAM Sprint 
-- Historia/Bug:		
-- Descripcion: 		12/5/2019 - SP que verifica si una factura (como documento de contingencia) ya fue firmada en FEL

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_VALIDATE_FEL_DATA_ON_INVOICE]
	 @CODE_ROUTE = '46',
     @INVOICE_NUM = 180,
     @FEL_SHIPMENT = 1
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_VALIDATE_FEL_DATA_ON_INVOICE]
(
    @CODE_ROUTE VARCHAR(50),
    @INVOICE_NUM INT,
    @FEL_SHIPMENT INT = 1
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [IH].[INVOICE_ID],
           [IH].[ID] AS [BO_ID],
           [IH].[ELECTRONIC_SIGNATURE],
           [IH].[DOCUMENT_SERIES],
           [IH].[DOCUMENT_NUMBER],
           [IH].[DOCUMENT_URL],
           [IH].[SHIPMENT],
           [IH].[VALIDATION_RESULT],
           [IH].[SHIPMENT_DATETIME],
           [IH].[SHIPMENT_RESPONSE],
           [IH].[CONTINGENCY_DOC_SERIE],
           [IH].[CONTINGENCY_DOC_NUM]
    FROM [acsa].[SONDA_POS_INVOICE_HEADER] AS [IH]
        INNER JOIN [acsa].[SONDA_POS_RES_SAT] AS [SR]
            ON (
                   [SR].[AUTH_ID] = [IH].[CDF_RESOLUCION]
                   AND [SR].[AUTH_SERIE] = [IH].[CDF_SERIE]
               )
    WHERE [SR].[AUTH_ASSIGNED_TO] = @CODE_ROUTE
          AND [IH].[INVOICE_ID] = @INVOICE_NUM
          AND [IH].[SHIPMENT] = @FEL_SHIPMENT;
END;
