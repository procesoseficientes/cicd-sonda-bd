﻿CREATE TABLE [acsa].[SWIFT_SERIALIZE_HEADER] (
    [SERIALIZE_HEADER]  INT           IDENTITY (1, 1) NOT NULL,
    [RECEPTION_HEADER]  INT           NULL,
    [TYPE_RECEPTION]    VARCHAR (50)  NULL,
    [CODE_PROVIDER]     VARCHAR (50)  NULL,
    [CODE_USER]         VARCHAR (50)  NULL,
    [REFERENCE]         VARCHAR (50)  NULL,
    [DOC_SAP_RECEPTION] VARCHAR (150) NULL,
    [STATUS]            VARCHAR (20)  NULL,
    [COMMENTS]          VARCHAR (MAX) NULL,
    [LAST_UPDATE]       DATETIME      NULL,
    [LAST_UPDATE_BY]    VARCHAR (50)  NULL,
    [SCHEDULE_FOR]      DATE          NULL,
    [SEQ]               INT           NULL
);

