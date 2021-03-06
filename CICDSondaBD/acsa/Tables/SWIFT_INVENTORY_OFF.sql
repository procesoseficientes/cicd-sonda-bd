CREATE TABLE [acsa].[SWIFT_INVENTORY_OFF] (
    [INVENTORY]            INT           IDENTITY (1, 1) NOT NULL,
    [SERIAL_NUMBER]        VARCHAR (150) NULL,
    [WAREHOUSE]            VARCHAR (50)  NULL,
    [LOCATION]             VARCHAR (50)  NULL,
    [SKU]                  VARCHAR (50)  NULL,
    [SKU_DESCRIPTION]      VARCHAR (MAX) NULL,
    [ON_HAND]              FLOAT (53)    NULL,
    [BATCH_ID]             VARCHAR (150) NULL,
    [LAST_UPDATE]          DATETIME      NULL,
    [LAST_UPDATE_BY]       VARCHAR (50)  NULL,
    [TXN_ID]               INT           NULL,
    [IS_SCANNED]           INT           NULL,
    [RELOCATED_DATE]       DATETIME      NULL,
    [PALLET_ID]            INT           NULL,
    [OWNER]                VARCHAR (50)  NULL,
    [OWNER_ID]             VARCHAR (50)  NULL,
    [CODE_PACK_UNIT_STOCK] VARCHAR (100) NULL,
    CONSTRAINT [PK_SWIFT_INVENTORY_OFF] PRIMARY KEY CLUSTERED ([INVENTORY] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_SERIAL_NUMBER_WAREHOUSE_SKU_INVENTORY_OFF]
    ON [acsa].[SWIFT_INVENTORY_OFF]([SERIAL_NUMBER] ASC, [WAREHOUSE] ASC, [SKU] ASC)
    INCLUDE([INVENTORY], [ON_HAND]);


GO
CREATE NONCLUSTERED INDEX [IDX_WAREHOUSE_INVENTORY_OFF]
    ON [acsa].[SWIFT_INVENTORY_OFF]([WAREHOUSE] ASC)
    INCLUDE([INVENTORY], [SERIAL_NUMBER], [SKU], [ON_HAND]);

