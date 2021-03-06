CREATE TABLE [acsa].[SWIFT_TRADE_AGREEMENT_BY_PROMO] (
    [TRADE_AGREEMENT_ID] INT          NOT NULL,
    [PROMO_ID]           INT          NOT NULL,
    [FREQUENCY]          VARCHAR (50) NOT NULL,
    [LAST_UPDATE]        DATETIME     DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([TRADE_AGREEMENT_ID] ASC, [PROMO_ID] ASC),
    CONSTRAINT [FK__SWIFT_TRA__PROMO__14A6EE59] FOREIGN KEY ([PROMO_ID]) REFERENCES [acsa].[SWIFT_PROMO] ([PROMO_ID]),
    CONSTRAINT [FK__SWIFT_TRA__TRADE__159B1292] FOREIGN KEY ([TRADE_AGREEMENT_ID]) REFERENCES [acsa].[SWIFT_TRADE_AGREEMENT] ([TRADE_AGREEMENT_ID])
);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_TRADE_AGREEMENT_BY_PROMO_LAST_UPDATE]
    ON [acsa].[SWIFT_TRADE_AGREEMENT_BY_PROMO]([LAST_UPDATE] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_TRADE_AGREEMENT_BY_PROMO_PROMO_ID]
    ON [acsa].[SWIFT_TRADE_AGREEMENT_BY_PROMO]([PROMO_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_TRADE_AGREEMENT_BY_PROMO_PROMO_ID_TRADE_AGREEMENT_ID]
    ON [acsa].[SWIFT_TRADE_AGREEMENT_BY_PROMO]([PROMO_ID] ASC, [TRADE_AGREEMENT_ID] ASC)
    INCLUDE([FREQUENCY]);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_TRADE_AGREEMENT_BY_PROMO_TRADE_AGREEMENT_ID]
    ON [acsa].[SWIFT_TRADE_AGREEMENT_BY_PROMO]([TRADE_AGREEMENT_ID] ASC);

