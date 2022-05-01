﻿CREATE TABLE [acsa].[SWIFT_POLYGON] (
    [POLYGON_ID]           INT           IDENTITY (1, 1) NOT NULL,
    [POLYGON_NAME]         VARCHAR (250) NOT NULL,
    [POLYGON_DESCRIPTION]  VARCHAR (250) NOT NULL,
    [COMMENT]              VARCHAR (250) NULL,
    [LAST_UPDATE_BY]       VARCHAR (50)  NOT NULL,
    [LAST_UPDATE_DATETIME] DATETIME      NOT NULL,
    [POLYGON_ID_PARENT]    INT           NULL,
    [POLYGON_TYPE]         VARCHAR (250) NOT NULL,
    [SUB_TYPE]             VARCHAR (250) NULL,
    [OPTIMIZE]             INT           CONSTRAINT [DF__SWIFT_POL__OPTIM__60132A89] DEFAULT ((0)) NULL,
    [TYPE_TASK]            VARCHAR (20)  NULL,
    [CODE_WAREHOUSE]       VARCHAR (50)  NULL,
    [LAST_OPTIMIZATION]    DATETIME      NULL,
    [AVAILABLE]            INT           CONSTRAINT [DF__SWIFT_POL__AVAIL__61074EC2] DEFAULT ((0)) NULL,
    [IS_MULTISELLER]       INT           CONSTRAINT [DF__SWIFT_POL__IS_MU__61FB72FB] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__SWIFT_PO__F951E03788D9097D] PRIMARY KEY CLUSTERED ([POLYGON_ID] ASC),
    CONSTRAINT [FK__SWIFT_POL__POLYG__5986288B] FOREIGN KEY ([POLYGON_ID_PARENT]) REFERENCES [acsa].[SWIFT_POLYGON] ([POLYGON_ID]),
    CONSTRAINT [UC_SWIFT_POLYGON] UNIQUE NONCLUSTERED ([POLYGON_NAME] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_POLYGON_POLYGON_ID_PARENT]
    ON [acsa].[SWIFT_POLYGON]([POLYGON_ID_PARENT] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_POLYGON_POLYGON_NAME]
    ON [acsa].[SWIFT_POLYGON]([POLYGON_NAME] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_POLYGON_POLYGON_POLYGON_ID_PARENT_SUB_TYPE]
    ON [acsa].[SWIFT_POLYGON]([POLYGON_ID_PARENT] ASC, [SUB_TYPE] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_POLYGON_POLYGON_POLYGON_TYPE]
    ON [acsa].[SWIFT_POLYGON]([POLYGON_TYPE] ASC);

