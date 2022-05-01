CREATE TABLE [acsa].[SWIFT_PROMO_SPECIAL_PRICE_LIST_BY_SCALE] (
    [SPECIAL_PRICE_LIST_BY_SCALE_ID] INT             IDENTITY (1, 1) NOT NULL,
    [PROMO_ID]                       INT             NOT NULL,
    [CODE_SKU]                       VARCHAR (50)    NOT NULL,
    [PACK_UNIT]                      INT             NOT NULL,
    [LOW_LIMIT]                      INT             NOT NULL,
    [HIGH_LIMIT]                     INT             NOT NULL,
    [PRICE]                          NUMERIC (18, 6) NOT NULL,
    [LAST_UPDATE]                    DATETIME        NOT NULL,
    [INCLUDE_DISCOUNT]               INT             NOT NULL,
    PRIMARY KEY CLUSTERED ([SPECIAL_PRICE_LIST_BY_SCALE_ID] ASC)
);

