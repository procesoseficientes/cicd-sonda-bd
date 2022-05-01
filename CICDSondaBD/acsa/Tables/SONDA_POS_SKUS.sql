﻿CREATE TABLE [acsa].[SONDA_POS_SKUS] (
    [SKU]                  VARCHAR (50)    NOT NULL,
    [SKU_NAME]             VARCHAR (150)   NULL,
    [SKU_PRICE]            MONEY           NULL,
    [REQUERIES_SERIE]      INT             NULL,
    [IS_KIT]               INT             NULL,
    [ON_HAND]              NUMERIC (18, 6) NULL,
    [ROUTE_ID]             VARCHAR (25)    NOT NULL,
    [IS_PARENT]            INT             NULL,
    [PARENT_SKU]           VARCHAR (50)    NOT NULL,
    [EXPOSURE]             INT             NULL,
    [PRIORITY]             INT             NULL,
    [QTY_RELATED]          INT             NULL,
    [CODE_FAMILY_SKU]      VARCHAR (50)    NULL,
    [SALES_PACK_UNIT]      VARCHAR (25)    NULL,
    [INITIAL_QTY]          NUMERIC (18, 6) NULL,
    [TAX_CODE]             VARCHAR (20)    NULL,
    [CODE_PACK_UNIT_STOCK] VARCHAR (100)   NULL,
    CONSTRAINT [PK_SONDA_POS_SKUS] PRIMARY KEY CLUSTERED ([SKU] ASC, [ROUTE_ID] ASC, [PARENT_SKU] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_ROUTE_ID_SKUS]
    ON [acsa].[SONDA_POS_SKUS]([ROUTE_ID] ASC)
    INCLUDE([SKU], [SKU_NAME], [SKU_PRICE], [REQUERIES_SERIE], [IS_KIT], [ON_HAND], [IS_PARENT], [PARENT_SKU], [EXPOSURE], [PRIORITY], [QTY_RELATED], [CODE_FAMILY_SKU], [SALES_PACK_UNIT], [INITIAL_QTY]);

