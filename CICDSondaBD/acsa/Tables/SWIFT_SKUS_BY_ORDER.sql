﻿CREATE TABLE [acsa].[SWIFT_SKUS_BY_ORDER] (
    [ORDER_ID]        NVARCHAR (50)   NOT NULL,
    [SKU_ID]          NVARCHAR (50)   NOT NULL,
    [SKU_DESCRIPTION] NVARCHAR (150)  NULL,
    [QTY]             DECIMAL (18, 2) NULL,
    [SKU_PRICE]       FLOAT (53)      NULL,
    [TOTAL_LINE]      FLOAT (53)      NULL,
    CONSTRAINT [PK_SWIFT_SKUS_BY_ORDER_1] PRIMARY KEY CLUSTERED ([ORDER_ID] ASC, [SKU_ID] ASC)
);

