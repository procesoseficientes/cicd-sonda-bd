﻿CREATE TABLE [acsa].[SONDA_POS_INVOICE_DETAIL_HIST] (
    [INVOICE_ID]         INT             NOT NULL,
    [INVOICE_SERIAL]     VARCHAR (50)    NOT NULL,
    [SKU]                VARCHAR (25)    NOT NULL,
    [LINE_SEQ]           INT             NOT NULL,
    [QTY]                NUMERIC (18, 2) NULL,
    [PRICE]              MONEY           NULL,
    [DISCOUNT]           MONEY           NULL,
    [TOTAL_LINE]         MONEY           NULL,
    [POSTED_DATETIME]    DATETIME        NULL,
    [SERIE]              VARCHAR (50)    NULL,
    [SERIE_2]            VARCHAR (50)    NULL,
    [REQUERIES_SERIE]    INT             NULL,
    [COMBO_REFERENCE]    VARCHAR (50)    NULL,
    [INVOICE_RESOLUTION] VARCHAR (50)    NOT NULL,
    [PARENT_SEQ]         INT             NULL,
    [IS_ACTIVE_ROUTE]    INT             NULL,
    [ID]                 INT             NOT NULL,
    [TAX_CODE]           VARCHAR (25)    NULL,
    [SALES_PACK_UNIT]    VARCHAR (50)    NULL,
    [STOCK_PACK_UNIT]    VARCHAR (50)    NULL,
    [CONVERSION_FACTOR]  NUMERIC (18, 6) NULL
);

