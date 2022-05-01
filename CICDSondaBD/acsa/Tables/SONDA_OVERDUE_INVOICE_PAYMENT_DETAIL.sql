CREATE TABLE [acsa].[SONDA_OVERDUE_INVOICE_PAYMENT_DETAIL] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [PAYMENT_HEADER_ID] INT             NOT NULL,
    [INVOICE_ID]        VARCHAR (250)   NOT NULL,
    [DOC_ENTRY]         VARCHAR (250)   NOT NULL,
    [DOC_SERIE]         VARCHAR (250)   NOT NULL,
    [DOC_NUM]           INT             NOT NULL,
    [PAYED_AMOUNT]      NUMERIC (18, 6) NOT NULL,
    [AMOUNT_TO_DATE]    NUMERIC (18, 6) NULL,
    [PENDING_AMOUNT]    NUMERIC (18, 6) NULL,
    CONSTRAINT [PK_SondaOverdueInvoicePaymentDetail_paymentHeaderId_invoiceId_docEntry] PRIMARY KEY CLUSTERED ([PAYMENT_HEADER_ID] ASC, [INVOICE_ID] ASC, [DOC_ENTRY] ASC)
);

