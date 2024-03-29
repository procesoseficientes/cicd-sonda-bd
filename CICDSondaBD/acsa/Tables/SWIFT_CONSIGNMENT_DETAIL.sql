﻿CREATE TABLE [acsa].[SWIFT_CONSIGNMENT_DETAIL] (
    [CONSIGNMENT_ID]  INT             NOT NULL,
    [SKU]             VARCHAR (25)    NOT NULL,
    [LINE_NUM]        INT             NOT NULL,
    [QTY]             INT             NOT NULL,
    [PRICE]           NUMERIC (18, 6) NOT NULL,
    [DISCOUNT]        NUMERIC (18, 6) NULL,
    [TOTAL_LINE]      NUMERIC (18, 6) NOT NULL,
    [POSTED_DATETIME] DATETIME        NOT NULL,
    [PAYMENT_ID]      INT             NULL,
    [HANDLE_SERIAL]   INT             DEFAULT ((0)) NOT NULL,
    [SERIAL_NUMBER]   VARCHAR (150)   NULL,
    PRIMARY KEY CLUSTERED ([CONSIGNMENT_ID] ASC, [LINE_NUM] ASC)
);

