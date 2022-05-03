﻿CREATE TABLE [acsa].[SWIFT_TASK_BY_POLYGON] (
    [POLYGON_ID] INT          NOT NULL,
    [TASK_TYPE]  VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([POLYGON_ID] ASC, [TASK_TYPE] ASC),
    CONSTRAINT [FK__SWIFT_TAS__POLYG__08411774] FOREIGN KEY ([POLYGON_ID]) REFERENCES [acsa].[SWIFT_POLYGON] ([POLYGON_ID])
);
