﻿CREATE TABLE [acsa].[SWIFT_LOG_INTERFACE] (
    [LOG_INTERFACE_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [ERP_TARGET]           VARCHAR (50)   NOT NULL,
    [OPERATION_TYPE]       VARCHAR (50)   NOT NULL,
    [OBJECT_NAME]          VARCHAR (250)  NOT NULL,
    [MESSAGE]              VARCHAR (1000) NOT NULL,
    [LOG_DATETIME]         DATETIME       NOT NULL,
    [DOC_ID]               INT            NULL,
    [ERP_REFERENCE]        VARCHAR (250)  NULL,
    [ERP_POSTING_ATTEMPTS] INT            NULL,
    CONSTRAINT [PK_SWIFT_LOG_INTERFACE] PRIMARY KEY CLUSTERED ([LOG_INTERFACE_ID] ASC)
);
