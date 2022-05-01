CREATE TABLE [acsa].[TEMP_SONDA_SALES_ORDER_DETAIL] (
    [SALES_ORDER_ID]  INT             NOT NULL,
    [SKU]             VARCHAR (25)    NOT NULL,
    [LINE_SEQ]        INT             NOT NULL,
    [QTY]             NUMERIC (18, 2) NULL,
    [PRICE]           MONEY           NULL,
    [DISCOUNT]        MONEY           NULL,
    [TOTAL_LINE]      MONEY           NULL,
    [POSTED_DATETIME] DATETIME        NULL,
    [SERIE]           VARCHAR (50)    NULL,
    [SERIE_2]         VARCHAR (50)    NULL,
    [REQUERIES_SERIE] INT             NULL,
    [COMBO_REFERENCE] VARCHAR (50)    NULL,
    [PARENT_SEQ]      INT             NULL,
    [IS_ACTIVE_ROUTE] INT             NULL,
    [CODE_PACK_UNIT]  VARCHAR (50)    NULL,
    [IS_BONUS]        INT             NULL
);

