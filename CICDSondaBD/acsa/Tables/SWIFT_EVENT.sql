﻿CREATE TABLE [acsa].[SWIFT_EVENT] (
    [EVENT_ID]    INT           NOT NULL,
    [NAME_EVENT]  VARCHAR (150) NULL,
    [TYPE]        VARCHAR (150) NULL,
    [FILTERS]     VARCHAR (150) NULL,
    [ACTION]      VARCHAR (150) NULL,
    [NAME_ACTION] VARCHAR (150) NULL,
    [TYPE_ACTION] VARCHAR (150) NULL,
    [ENABLED]     VARCHAR (150) NULL,
    CONSTRAINT [PK_SWIFT_EVENT] PRIMARY KEY CLUSTERED ([EVENT_ID] ASC)
);

