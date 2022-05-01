-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	12/7/2019 @ G-Force - TEAM Sprint 
-- Historia/Bug:		
-- Descripcion: 		12/7/2019 - SP que obtiene el detalle de los primeros 5 documentos de contingencia para enviarlos a firmar a FEL

-- Modificacion 		12/13/2019 @ G-Force Team Sprint Oslo
-- Autor: 				DENIS.VILLAGRAN
-- Historia/Bug:		Product Backlog Item 33796: Solicitud de Firma Electronica para documentos de Contingencia
-- Descripcion: 		12/13/2019 - A la línea de detalle de la factura se le suma 1 porque no se puede enviar un valor igual a 0.

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_GET_DETAIL_OF_CONTINGENCY_DOCUMENTS]
	@CONTINGENCY_DOCUMENTS = '
	<Data>
    <Data>
        <InvoiceNum>8</InvoiceNum>
        <Terms>CASH</Terms>
        <PostedDateTime>Thu Dec 05 2019 04:26:18 GMT-0600 (Central Standard Time)</PostedDateTime>
        <ClientId>SO-151337</ClientId>
        <ClientName>TIENDA CONDOR</ClientName>
        <PosTerminal>46</PosTerminal>
        <Gps>14.6499061,-90.5397054</Gps>
        <TotalAmount>13.4</TotalAmount>
        <ErpInvoiceId>CF</ErpInvoiceId>
        <IsPosted>2</IsPosted>
        <PostedBy>adolfo@acsa</PostedBy>
        <Status>5</Status>
        <IsCreditNote>0</IsCreditNote>
        <VoidReason>null</VoidReason>
        <VoidNotes>null</VoidNotes>
        <VoidInvoiceId>null</VoidInvoiceId>
        <PrintRequests>0</PrintRequests>
        <PrintedCount>0</PrintedCount>
        <AuthId>1323123</AuthId>
        <SatSerie></SatSerie>
        <Change>6.6</Change>
        <ConsignmentId>0</ConsignmentId>
        <IsPaidConsignment>0</IsPaidConsignment>
        <InPlanRoute>1</InPlanRoute>
        <IdBo>13981</IdBo>
        <IsPostedValidated>2</IsPostedValidated>
        <DetailQty>0</DetailQty>
        <HandleTax>0</HandleTax>
        <TaxPercent>0</TaxPercent>
        <TelephoneNumber></TelephoneNumber>
        <Comment>NA</Comment>
        <ElectronicSignature></ElectronicSignature>
        <DocumentSeries></DocumentSeries>
        <DocumentNumber>0</DocumentNumber>
        <DocumentUrl>null</DocumentUrl>
        <Shipment>0</Shipment>
        <ValidationResult>false</ValidationResult>
        <ShipmentDatetime>null</ShipmentDatetime>
        <ShipmentResponse></ShipmentResponse>
        <ClientAddress>LOTE 19 AVENIDAD PRINCIPAL ALDEA FISCAL</ClientAddress>
        <Department>GUATEMALA</Department>
        <Municipality>EL CHATO</Municipality>
        <Nit>CF</Nit>
        <FelDocumentType>FACT</FelDocumentType>
        <FelStablishmentCode>123</FelStablishmentCode>
        <InvoiceDetail>null</InvoiceDetail>
    </Data>
    <Data>
        <InvoiceNum>9</InvoiceNum>
        <Terms>CASH</Terms>
        <PostedDateTime>Thu Dec 05 2019 09:50:21 GMT-0600 (Central Standard Time)</PostedDateTime>
        <ClientId>SO-151109</ClientId>
        <ClientName>TIENDA ERICK</ClientName>
        <PosTerminal>46</PosTerminal>
        <Gps>14.6499039,-90.5397053</Gps>
        <TotalAmount>20.1</TotalAmount>
        <ErpInvoiceId>CF</ErpInvoiceId>
        <IsPosted>2</IsPosted>
        <PostedBy>adolfo@acsa</PostedBy>
        <Status>5</Status>
        <IsCreditNote>0</IsCreditNote>
        <VoidReason>null</VoidReason>
        <VoidNotes>null</VoidNotes>
        <VoidInvoiceId>null</VoidInvoiceId>
        <PrintRequests>0</PrintRequests>
        <PrintedCount>0</PrintedCount>
        <AuthId>1323123</AuthId>
        <SatSerie></SatSerie>
        <Change>0.9</Change>
        <ConsignmentId>0</ConsignmentId>
        <IsPaidConsignment>0</IsPaidConsignment>
        <InPlanRoute>1</InPlanRoute>
        <IdBo>13983</IdBo>
        <IsPostedValidated>2</IsPostedValidated>
        <DetailQty>0</DetailQty>
        <HandleTax>0</HandleTax>
        <TaxPercent>0</TaxPercent>
        <TelephoneNumber></TelephoneNumber>
        <Comment>NA</Comment>
        <ElectronicSignature>1B3E7032-5228-4056-9DC1-38EF7F0B4904</ElectronicSignature>
        <DocumentSeries>**PRUEBAS**</DocumentSeries>
        <DocumentNumber>0</DocumentNumber>
        <DocumentUrl>null</DocumentUrl>
        <Shipment>0</Shipment>
        <ValidationResult>false</ValidationResult>
        <ShipmentDatetime>null</ShipmentDatetime>
        <ShipmentResponse></ShipmentResponse>
        <ClientAddress>LOTE 6  MANZANA B  COLONIA PIEDRAS VERDES</ClientAddress>
        <Department>GUATEMALA</Department>
        <Municipality>EL CHATO</Municipality>
        <Nit>CF</Nit>
        <FelDocumentType>FACT</FelDocumentType>
        <FelStablishmentCode>123</FelStablishmentCode>
        <InvoiceDetail>null</InvoiceDetail>
    </Data>
    <Data>
        <InvoiceNum>10</InvoiceNum>
        <Terms>CASH</Terms>
        <PostedDateTime>Thu Dec 05 2019 10:06:43 GMT-0600 (Central Standard Time)</PostedDateTime>
        <ClientId>SO-151569</ClientId>
        <ClientName>TIENDA GUADALUPE</ClientName>
        <PosTerminal>46</PosTerminal>
        <Gps>14.6499032,-90.5397049</Gps>
        <TotalAmount>6.7</TotalAmount>
        <ErpInvoiceId>CF</ErpInvoiceId>
        <IsPosted>2</IsPosted>
        <PostedBy>adolfo@acsa</PostedBy>
        <Status>5</Status>
        <IsCreditNote>0</IsCreditNote>
        <VoidReason>null</VoidReason>
        <VoidNotes>null</VoidNotes>
        <VoidInvoiceId>null</VoidInvoiceId>
        <PrintRequests>0</PrintRequests>
        <PrintedCount>0</PrintedCount>
        <AuthId>1323123</AuthId>
        <SatSerie></SatSerie>
        <Change>3.3</Change>
        <ConsignmentId>0</ConsignmentId>
        <IsPaidConsignment>0</IsPaidConsignment>
        <InPlanRoute>1</InPlanRoute>
        <IdBo>13996</IdBo>
        <IsPostedValidated>2</IsPostedValidated>
        <DetailQty>0</DetailQty>
        <HandleTax>0</HandleTax>
        <TaxPercent>0</TaxPercent>
        <TelephoneNumber></TelephoneNumber>
        <Comment>NA</Comment>
        <ElectronicSignature></ElectronicSignature>
        <DocumentSeries></DocumentSeries>
        <DocumentNumber>0</DocumentNumber>
        <DocumentUrl>null</DocumentUrl>
        <Shipment>0</Shipment>
        <ValidationResult>false</ValidationResult>
        <ShipmentDatetime>null</ShipmentDatetime>
        <ShipmentResponse></ShipmentResponse>
        <ClientAddress>0 AV  LOTE 32  CALLE PRINCIPAL ALDEA FISCAL</ClientAddress>
        <Department>GUATEMALA</Department>
        <Municipality>EL CHATO</Municipality>
        <Nit>CF</Nit>
        <FelDocumentType>FACT</FelDocumentType>
        <FelStablishmentCode>123</FelStablishmentCode>
        <InvoiceDetail>null</InvoiceDetail>
    </Data>
    <Data>
        <InvoiceNum>11</InvoiceNum>
        <Terms>CASH</Terms>
        <PostedDateTime>Thu Dec 05 2019 10:16:37 GMT-0600 (Central Standard Time)</PostedDateTime>
        <ClientId>SO-151569</ClientId>
        <ClientName>TIENDA GUADALUPE</ClientName>
        <PosTerminal>46</PosTerminal>
        <Gps>14.6499047,-90.5397047</Gps>
        <TotalAmount>20.1</TotalAmount>
        <ErpInvoiceId>CF</ErpInvoiceId>
        <IsPosted>2</IsPosted>
        <PostedBy>adolfo@acsa</PostedBy>
        <Status>5</Status>
        <IsCreditNote>0</IsCreditNote>
        <VoidReason>null</VoidReason>
        <VoidNotes>null</VoidNotes>
        <VoidInvoiceId>null</VoidInvoiceId>
        <PrintRequests>0</PrintRequests>
        <PrintedCount>0</PrintedCount>
        <AuthId>1323123</AuthId>
        <SatSerie></SatSerie>
        <Change>0.9</Change>
        <ConsignmentId>0</ConsignmentId>
        <IsPaidConsignment>0</IsPaidConsignment>
        <InPlanRoute>1</InPlanRoute>
        <IdBo>14003</IdBo>
        <IsPostedValidated>2</IsPostedValidated>
        <DetailQty>0</DetailQty>
        <HandleTax>0</HandleTax>
        <TaxPercent>0</TaxPercent>
        <TelephoneNumber></TelephoneNumber>
        <Comment>NA</Comment>
        <ElectronicSignature></ElectronicSignature>
        <DocumentSeries></DocumentSeries>
        <DocumentNumber>0</DocumentNumber>
        <DocumentUrl>null</DocumentUrl>
        <Shipment>0</Shipment>
        <ValidationResult>false</ValidationResult>
        <ShipmentDatetime>null</ShipmentDatetime>
        <ShipmentResponse></ShipmentResponse>
        <ClientAddress>0 AV  LOTE 32  CALLE PRINCIPAL ALDEA FISCAL</ClientAddress>
        <Department>GUATEMALA</Department>
        <Municipality>EL CHATO</Municipality>
        <Nit>CF</Nit>
        <FelDocumentType>FACT</FelDocumentType>
        <FelStablishmentCode>123</FelStablishmentCode>
        <InvoiceDetail>null</InvoiceDetail>
    </Data>
    <Data>
        <InvoiceNum>13</InvoiceNum>
        <Terms>CASH</Terms>
        <PostedDateTime>Thu Dec 05 2019 11:12:59 GMT-0600 (Central Standard Time)</PostedDateTime>
        <ClientId>SO-171809</ClientId>
        <ClientName>TIENDA SARITA</ClientName>
        <PosTerminal>46</PosTerminal>
        <Gps>14.6499041,-90.5397048</Gps>
        <TotalAmount>225</TotalAmount>
        <ErpInvoiceId>CF</ErpInvoiceId>
        <IsPosted>2</IsPosted>
        <PostedBy>adolfo@acsa</PostedBy>
        <Status>5</Status>
        <IsCreditNote>0</IsCreditNote>
        <VoidReason>null</VoidReason>
        <VoidNotes>null</VoidNotes>
        <VoidInvoiceId>null</VoidInvoiceId>
        <PrintRequests>0</PrintRequests>
        <PrintedCount>0</PrintedCount>
        <AuthId>1323123</AuthId>
        <SatSerie></SatSerie>
        <Change>75</Change>
        <ConsignmentId>0</ConsignmentId>
        <IsPaidConsignment>0</IsPaidConsignment>
        <InPlanRoute>1</InPlanRoute>
        <IdBo>14095</IdBo>
        <IsPostedValidated>2</IsPostedValidated>
        <DetailQty>0</DetailQty>
        <HandleTax>0</HandleTax>
        <TaxPercent>0</TaxPercent>
        <TelephoneNumber></TelephoneNumber>
        <Comment>NA</Comment>
        <ElectronicSignature></ElectronicSignature>
        <DocumentSeries></DocumentSeries>
        <DocumentNumber>0</DocumentNumber>
        <DocumentUrl>null</DocumentUrl>
        <Shipment>0</Shipment>
        <ValidationResult>false</ValidationResult>
        <ShipmentDatetime>null</ShipmentDatetime>
        <ShipmentResponse></ShipmentResponse>
        <ClientAddress>LOTE 1 COLONIA TRES SABANAS CHINAUTLA</ClientAddress>
        <Department>GUATEMALA</Department>
        <Municipality>ALDEA TRES SABANAS</Municipality>
        <Nit>CF</Nit>
        <FelDocumentType>FACT</FelDocumentType>
        <FelStablishmentCode>123</FelStablishmentCode>
        <InvoiceDetail>null</InvoiceDetail>
    </Data>
</Data>
	'
*/
-- =============================================
CREATE PROCEDURE [SONDA_SP_GET_DETAIL_OF_CONTINGENCY_DOCUMENTS]
(@CONTINGENCY_DOCUMENTS XML)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CONTINGENCY_DOCUMENT_HEADER TABLE
    (
        [ID] INT IDENTITY(1, 1),
        [INVOICE_ID_BO] INT NOT NULL
    );

    -- ---------------------------------------------------------------
    -- Se obtienen los identificadores de los encabezados de documentos
    -- de contingencia
    -- ---------------------------------------------------------------
    INSERT INTO @CONTINGENCY_DOCUMENT_HEADER
    (
        [INVOICE_ID_BO]
    )
    SELECT [x].[Rec].[query]('./IdBo').[value]('.', 'int')
    FROM @CONTINGENCY_DOCUMENTS.[nodes]('/Data/Data') AS [x]([Rec]);

    -- ---------------------------------------------------------------
    -- Se obtienen los detalles de los documentos de contingencia
    -- ---------------------------------------------------------------
    SELECT [CDH].[INVOICE_ID_BO] AS [InvoiceNum],
           [ID].[SKU] AS [Sku],
           (
               SELECT TOP (1)
                      [VAS].[DESCRIPTION_SKU]
               FROM [acsa].[SWIFT_VIEW_ALL_SKU] AS [VAS]
               WHERE [VAS].[CODE_SKU] = [ID].[SKU]
               ORDER BY [VAS].[SKU]
           ) AS [SkuName],
           [ID].[QTY] AS [Qty],
           [ID].[PRICE] AS [Price],
           [ID].[DISCOUNT] AS [Discount],
           [ID].[TOTAL_LINE] AS [TotalLine],
           [ID].[SERIE] AS [Serie],
           [ID].[SERIE_2] AS [Serie2],
           [ID].[REQUERIES_SERIE] AS [RequeriesSerie],
           ISNULL([ID].[LINE_SEQ], 0) + 1 AS [LineSeq],
           [ID].[IS_ACTIVE_ROUTE] AS [IsActive],
           [ID].[COMBO_REFERENCE] AS [ComboReference],
           [ID].[PARENT_SEQ] AS [ParentSeq],
           0 AS [Exposure],
           NULL AS [Phone],
           --[ID].[SALES_PACK_UNIT] AS [SalesPackUnit]
           NULL AS [SalesPackUnit]
    FROM [acsa].[SONDA_POS_INVOICE_DETAIL] AS [ID]
        INNER JOIN @CONTINGENCY_DOCUMENT_HEADER AS [CDH]
            ON ([CDH].[INVOICE_ID_BO] = [ID].[ID]);

END;