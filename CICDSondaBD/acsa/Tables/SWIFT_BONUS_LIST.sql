﻿CREATE TABLE [acsa].[SWIFT_BONUS_LIST] (
    [BONUS_LIST_ID]   INT           IDENTITY (1, 1) NOT NULL,
    [NAME_BONUS_LIST] VARCHAR (250) NULL,
    [CODE_ROUTE]      VARCHAR (50)  NULL,
    CONSTRAINT [PK__SWIFT_BO__DD154EB689F91C16] PRIMARY KEY CLUSTERED ([BONUS_LIST_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_BONUS_LIST_CODE_ROUTE]
    ON [acsa].[SWIFT_BONUS_LIST]([CODE_ROUTE] ASC)
    INCLUDE([BONUS_LIST_ID]);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_BONUS_LIST_CODE_ROUTE_NAME_BONUS_LIST]
    ON [acsa].[SWIFT_BONUS_LIST]([CODE_ROUTE] ASC, [NAME_BONUS_LIST] ASC)
    INCLUDE([BONUS_LIST_ID]);

