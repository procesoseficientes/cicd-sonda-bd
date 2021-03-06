CREATE TABLE [acsa].[SWIFT_DISCOUNT_LIST_BY_SKU_BK] (
    [DISCOUNT_LIST_ID] INT             NOT NULL,
    [CODE_SKU]         VARCHAR (50)    NOT NULL,
    [DISCOUNT]         NUMERIC (18, 6) NULL,
    PRIMARY KEY CLUSTERED ([DISCOUNT_LIST_ID] ASC, [CODE_SKU] ASC)
);

