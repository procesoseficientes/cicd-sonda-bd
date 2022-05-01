﻿CREATE TABLE [acsa].[SWIFT_TRADE_AGREEMENT_DISCOUNT] (
    [TRADE_AGREEMENT_DISCUOUNT_ID] INT             IDENTITY (1, 1) NOT NULL,
    [TRADE_AGREEMENT_ID]           INT             NOT NULL,
    [CODE_SKU]                     VARCHAR (50)    NOT NULL,
    [PACK_UNIT]                    INT             NOT NULL,
    [LOW_LIMIT]                    INT             NOT NULL,
    [HIGH_LIMIT]                   INT             NOT NULL,
    [DISCOUNT]                     NUMERIC (18, 2) NOT NULL,
    CONSTRAINT [PK__SWIFT_TR__1A1128C553F9FFE6] PRIMARY KEY CLUSTERED ([TRADE_AGREEMENT_DISCUOUNT_ID] ASC),
    CONSTRAINT [FK__SWIFT_TRA__PACK___7D85F3E4] FOREIGN KEY ([PACK_UNIT]) REFERENCES [acsa].[SONDA_PACK_UNIT] ([PACK_UNIT]),
    CONSTRAINT [FK__SWIFT_TRA__TRADE__7C91CFAB] FOREIGN KEY ([TRADE_AGREEMENT_ID]) REFERENCES [acsa].[SWIFT_TRADE_AGREEMENT] ([TRADE_AGREEMENT_ID])
);

