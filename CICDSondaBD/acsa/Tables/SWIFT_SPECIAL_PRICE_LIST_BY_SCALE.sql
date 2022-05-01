CREATE TABLE [acsa].[SWIFT_SPECIAL_PRICE_LIST_BY_SCALE] (
    [SPECIAL_PRICE_LIST_ID] INT             NOT NULL,
    [CODE_SKU]              VARCHAR (50)    NOT NULL,
    [PACK_UNIT]             INT             NOT NULL,
    [LOW_LIMIT]             INT             NOT NULL,
    [HIGH_LIMIT]            INT             NOT NULL,
    [SPECIAL_PRICE]         NUMERIC (18, 6) NOT NULL,
    [PROMO_ID]              INT             NULL,
    [PROMO_NAME]            VARCHAR (250)   NULL,
    [PROMO_TYPE]            VARCHAR (50)    NULL,
    [FREQUENCY]             VARCHAR (50)    NULL,
    [APPLY_DISCOUNT]        INT             NOT NULL,
    CONSTRAINT [PK_SWIFT_SPECIAL_PRICE_LIST_BY_SCALE] PRIMARY KEY CLUSTERED ([SPECIAL_PRICE_LIST_ID] ASC, [CODE_SKU] ASC, [PACK_UNIT] ASC, [LOW_LIMIT] ASC, [HIGH_LIMIT] ASC)
);

