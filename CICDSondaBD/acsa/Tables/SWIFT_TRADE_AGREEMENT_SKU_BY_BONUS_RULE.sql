﻿CREATE TABLE [acsa].[SWIFT_TRADE_AGREEMENT_SKU_BY_BONUS_RULE] (
    [TRADE_AGREEMENT_BONUS_RULE_BY_COMBO_ID] INT          NOT NULL,
    [CODE_SKU]                               VARCHAR (50) NOT NULL,
    [PACK_UNIT]                              INT          NOT NULL,
    [QTY]                                    INT          NOT NULL,
    [IS_MULTIPLE]                            INT          DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([TRADE_AGREEMENT_BONUS_RULE_BY_COMBO_ID] ASC, [CODE_SKU] ASC, [PACK_UNIT] ASC),
    CONSTRAINT [FK__SWIFT_TRA__PACK___0CC83774] FOREIGN KEY ([PACK_UNIT]) REFERENCES [acsa].[SONDA_PACK_UNIT] ([PACK_UNIT]),
    CONSTRAINT [FK__SWIFT_TRA__TRADE__0BD4133B] FOREIGN KEY ([TRADE_AGREEMENT_BONUS_RULE_BY_COMBO_ID]) REFERENCES [acsa].[SWIFT_TRADE_AGREEMENT_BY_COMBO_BONUS_RULE] ([TRADE_AGREEMENT_BONUS_RULE_BY_COMBO_ID])
);

