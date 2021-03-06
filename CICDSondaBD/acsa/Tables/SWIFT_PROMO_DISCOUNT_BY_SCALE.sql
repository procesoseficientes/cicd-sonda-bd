CREATE TABLE [acsa].[SWIFT_PROMO_DISCOUNT_BY_SCALE] (
    [PROMO_DISCOUNT_ID] INT             IDENTITY (1, 1) NOT NULL,
    [PROMO_ID]          INT             NOT NULL,
    [CODE_SKU]          VARCHAR (50)    NOT NULL,
    [PACK_UNIT]         INT             NOT NULL,
    [LOW_LIMIT]         INT             NOT NULL,
    [HIGH_LIMIT]        INT             NOT NULL,
    [DISCOUNT]          NUMERIC (18, 6) NOT NULL,
    [DISCOUNT_TYPE]     VARCHAR (50)    CONSTRAINT [DF__SWIFT_PRO__DISCO__26A5A303] DEFAULT ('PERCENTAGE') NOT NULL,
    [LAST_UPDATE]       DATETIME        CONSTRAINT [DF__SWIFT_PRO__LAST___2799C73C] DEFAULT (getdate()) NOT NULL,
    [IS_UNIQUE]         INT             CONSTRAINT [DF__SWIFT_PRO__IS_UN__288DEB75] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__SWIFT_PR__86779CDB0ED01184] PRIMARY KEY CLUSTERED ([PROMO_DISCOUNT_ID] ASC),
    CONSTRAINT [FK__SWIFT_PRO__PACK___6E814571] FOREIGN KEY ([PACK_UNIT]) REFERENCES [acsa].[SONDA_PACK_UNIT] ([PACK_UNIT]),
    CONSTRAINT [FK__SWIFT_PRO__PROMO__6F7569AA] FOREIGN KEY ([PROMO_ID]) REFERENCES [acsa].[SWIFT_PROMO] ([PROMO_ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_SWIFT_PROMO_DISCOUNT_BY_SCALE_T0]
    ON [acsa].[SWIFT_PROMO_DISCOUNT_BY_SCALE]([CODE_SKU] ASC, [PACK_UNIT] ASC, [PROMO_ID] ASC)
    INCLUDE([HIGH_LIMIT], [LOW_LIMIT], [PROMO_DISCOUNT_ID], [DISCOUNT], [DISCOUNT_TYPE]);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_PROMO_DISCOUNT_BY_SCALE_LAST_UPDATE]
    ON [acsa].[SWIFT_PROMO_DISCOUNT_BY_SCALE]([LAST_UPDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_PROMO_DISCOUNT_BY_SCALE_PROMO_ID]
    ON [acsa].[SWIFT_PROMO_DISCOUNT_BY_SCALE]([PROMO_ID] ASC)
    INCLUDE([CODE_SKU], [PACK_UNIT], [LOW_LIMIT], [HIGH_LIMIT], [DISCOUNT], [DISCOUNT_TYPE]);

