﻿CREATE TABLE [acsa].[SWIFT_COMPANY] (
    [COMPANY_ID]   INT          NOT NULL,
    [COMPANY_NAME] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([COMPANY_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_COMPANY_COMPANY_NAME]
    ON [acsa].[SWIFT_COMPANY]([COMPANY_NAME] ASC);
