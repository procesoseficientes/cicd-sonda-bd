-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	12/7/2019 @ G-Force - TEAM Sprint 
-- Historia/Bug:		
-- Descripcion: 		12/7/2019 - SP que obtiene los primeros 5 documentos de contingencia para enviarlos a firmar a FEL

-- Modificacion 		12/9/2019 @ G-Force Team Sprint Oslo
-- Autor: 				DENIS.VILLAGRAN
-- Historia/Bug:		
-- Descripcion: 		12/9/2019 - Se agrega validacion de INTENTOS DE ENVIO

-- Modificacion 		12/9/2019 @ G-Force Team Sprint Oslo
-- Autor: 				DENIS.VILLAGRAN
-- Historia/Bug:		
-- Descripcion: 		12/9/2019 - Se agregan campos CONTINGENCY_DOC_NUM, CONTINGENCY_DOC_SERIE

-- Modificacion 		12/11/2019 @ G-Force Team Sprint Oslo
-- Autor: 				DENIS.VILLAGRAN
-- Historia/Bug:		
-- Descripcion: 		12/11/2019 - Se agregan campos Se agrega validación [IH].[VALIDATION_RESULT] <> 1 en
--						la verificación WHERE

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_GET_TOP5_CONTINGENCY_DOCUMENTS]
  
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_TOP5_CONTINGENCY_DOCUMENTS]
AS
BEGIN
select  * FROM [acsa].[SWIFT_VIEW_ALL_COSTUMER]

END;

--    DECLARE @SHIPMENT_ATTEMPTS VARCHAR(250);

--    SELECT @SHIPMENT_ATTEMPTS
--        = [acsa].[SWIFT_FN_GET_PARAMETER]('SONDA_FEL_CONFIGURATION', 'FEL_CONTINGENCY_DOCUMENT_SHIPMENT_ATTEMPTS');


--    SELECT TOP (5)
--           [IH].[CONTINGENCY_DOC_NUM] AS [InvoiceNum],
--           [IH].[TERMS] AS [Terms],
--           [IH].[POSTED_DATETIME] AS [PostedDateTime],
--           [IH].[CLIENT_ID] AS [ClientId],
--           [IH].[CDF_NOMBRECLIENTE] AS [ClientName],
--           [IH].[POS_TERMINAL] AS [PosTerminal],
--           [IH].[GPS_URL] AS [Gps],
--           [IH].[TOTAL_AMOUNT] AS [TotalAmount],
--           [IH].[CDF_NIT] AS [ErpInvoiceId],
--           2 AS [IsPosted],
--           [IH].[POSTED_BY] AS [PostedBy],
--           CAST([IH].[STATUS] AS VARCHAR(250)) AS [Status],
--           [IH].[IS_CREDIT_NOTE] AS [IsCreditNote],
--           [IH].[VOID_REASON] AS [VoidReason],
--           [IH].[VOID_NOTES] AS [VoidNotes],
--           [IH].[VOIDED_INVOICE] AS [VoidInvoiceId],
--           [IH].[CDF_PRINTED_COUNT] AS [PrintRequests],
--           [IH].[CDF_PRINTED_COUNT] AS [PrintedCount],
--           [IH].[CDF_RESOLUCION] AS [AuthId],
--           [IH].[CONTINGENCY_DOC_SERIE] AS [SatSerie],
--           [IH].[CHANGE] AS [Change],
--           [IH].[CONSIGNMENT_ID] AS [ConsignmentId],
--           0 AS [IsPaidConsignment],
--           [IH].[IN_ROUTE_PLAN] AS [InPlanRoute],
--           [IH].[ID] AS [IdBo],
--           2 AS [IsPostedValidated],
--           0 AS [DetailQty],
--           [IH].[HANDLE_TAX] AS [HandleTax],
--           [IH].[TAX_PERCENT] AS [TaxPercent],
--           [IH].[TELEPHONE_NUMBER] AS [TelephoneNumber],
--           [IH].[COMMENT] AS [Comment],
--           [IH].[ELECTRONIC_SIGNATURE] AS [ElectronicSignature],
--           [IH].[DOCUMENT_SERIES] AS [DocumentSeries],
--           [IH].[DOCUMENT_NUMBER] AS [DocumentNumber],
--           [IH].[DOCUMENT_URL] AS [DocumentUrl],
--           [IH].[SHIPMENT] AS [Shipment],
--           [IH].[VALIDATION_RESULT] AS [ValidationResult],
--           [IH].[SHIPMENT_DATETIME] AS [ShipmentDatetime],
--           [IH].[SHIPMENT_RESPONSE] AS [ShipmentResponse],
--           (
--               SELECT TOP (1)
--                      ISNULL([VAC].[ADRESS_CUSTOMER], 'SIN DIRECCION')
--               FROM [acsa].[SWIFT_VIEW_ALL_COSTUMER] AS [VAC]
--               WHERE [VAC].[CODE_CUSTOMER] = [IH].[CLIENT_ID]
--               ORDER BY [VAC].[CODE_CUSTOMER]
--           ) AS [ClientAddress],
--           (
--               SELECT TOP (1)
--                      ISNULL([VC].[DEPARTAMENT], 'N/A')
--               FROM [acsa].[SWIFT_VIEW_CUSTOMERS] AS [VC]
--               WHERE [VC].[CODE_CUSTOMER] = [IH].[CLIENT_ID] COLLATE DATABASE_DEFAULT 
--               ORDER BY [VC].[CODE_CUSTOMER]
--           ) AS [Department],
--           (
--               SELECT TOP (1)
--                      ISNULL([VC].[MUNICIPALITY], 'N/A')
--               FROM [acsa].[SWIFT_VIEW_CUSTOMERS] AS [VC]
--               WHERE [VC].[CODE_CUSTOMER] = [IH].[CLIENT_ID] COLLATE DATABASE_DEFAULT 
--               ORDER BY [VC].[CODE_CUSTOMER]
--           ) AS [Municipality],
--           [IH].[CDF_NIT] AS [Nit],
--           [IH].[FEL_DOCUMENT_TYPE] AS [FelDocumentType],
--           [IH].[FEL_STABLISHMENT_CODE] AS [FelStablishmentCode],
--           [IH].[CONTINGENCY_DOC_SERIE] AS [ContingencyDocSerie],
--           [IH].[CONTINGENCY_DOC_NUM] AS [ContingencyDocNum],
--           NULL AS [InvoiceDetail]
--    FROM [acsa].[SONDA_POS_INVOICE_HEADER] AS [IH]
--    WHERE [IH].[IS_CONTINGENCY_DOCUMENT] = 1
--          AND [IH].[IS_READY_TO_SEND] = 1
--          AND [IH].[VALIDATION_RESULT] <> 1
--          AND ISNULL([IH].[FEL_CONTINGENCY_DOCUMENT_SHIPMENT_ATTEMPTS], 0) <= CAST(@SHIPMENT_ATTEMPTS AS INT)
--    ORDER BY [IH].[POSTED_DATETIME] ASC;
--END;
