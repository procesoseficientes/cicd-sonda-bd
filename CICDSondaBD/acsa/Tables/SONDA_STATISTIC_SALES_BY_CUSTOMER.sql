CREATE TABLE [acsa].[SONDA_STATISTIC_SALES_BY_CUSTOMER] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [CLIENT_ID]      VARCHAR (50)  NOT NULL,
    [CODE_SKU]       VARCHAR (50)  NOT NULL,
    [QTY]            INT           NOT NULL,
    [SALE_PACK_UNIT] VARCHAR (150) NULL
);

