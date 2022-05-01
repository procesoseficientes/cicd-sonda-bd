﻿CREATE TABLE [acsa].[SWIFT_SPECIAL_PRICE_PRIORITY] (
    [SPECIAL_PRICE_PRIORITY_ID]                  INT           IDENTITY (1, 1) NOT NULL,
    [DESCRIPTION]                                VARCHAR (250) NULL,
    [ORDER]                                      INT           NULL,
    [ACTIVE_SWIFT_EXPRESS]                       INT           NULL,
    [ACTIVE_SWIFT_INTERFACE_ONLINE]              INT           NULL,
    [SP_SWIFT_EXPRESS]                           VARCHAR (250) NULL,
    [SP_SWIFT_INTERFACE_ONLINE]                  VARCHAR (250) NULL,
    [LINKED_TO]                                  VARCHAR (250) NULL,
    [SP_SWIFT_EXPRESS_GENERAL_AMOUNT]            VARCHAR (250) NULL,
    [SP_SWIFT_EXPRESS_GENERAL_AMOUNT_AND_FAMILY] VARCHAR (250) NULL,
    [SP_SWIFT_EXPRESS_FAMILY_AND_PAYMENT_TYPE]   VARCHAR (250) NULL,
    CONSTRAINT [PK_SWIFT_SPECIAL_PRICE_PRIORITY] PRIMARY KEY CLUSTERED ([SPECIAL_PRICE_PRIORITY_ID] ASC)
);

