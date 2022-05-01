﻿CREATE TABLE [acsa].[SWIFT_FREQUENCY] (
    [ID_FREQUENCY]      INT           IDENTITY (1, 1) NOT NULL,
    [CODE_FREQUENCY]    VARCHAR (50)  NOT NULL,
    [SUNDAY]            INT           NOT NULL,
    [MONDAY]            INT           NOT NULL,
    [TUESDAY]           INT           NOT NULL,
    [WEDNESDAY]         INT           NOT NULL,
    [THURSDAY]          INT           NOT NULL,
    [FRIDAY]            INT           NOT NULL,
    [SATURDAY]          INT           NOT NULL,
    [FREQUENCY_WEEKS]   INT           NOT NULL,
    [LAST_WEEK_VISITED] DATE          NOT NULL,
    [LAST_UPDATED]      DATETIME      NOT NULL,
    [LAST_UPDATED_BY]   NVARCHAR (25) NULL,
    [CODE_ROUTE]        VARCHAR (50)  NOT NULL,
    [TYPE_TASK]         VARCHAR (20)  NOT NULL,
    [REFERENCE_SOURCE]  VARCHAR (150) CONSTRAINT [DF_SWIFT_FREQUENCY_REFERENCE_SOURCE] DEFAULT ('BO') NULL,
    [POLYGON_ID]        INT           NULL,
    [IS_BY_POLIGON]     INT           CONSTRAINT [DF__SWIFT_FRE__IS_BY__1D5142F3] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_SWIFT_FREQUENCY] PRIMARY KEY CLUSTERED ([ID_FREQUENCY] ASC),
    CONSTRAINT [FK__SWIFT_FRE__POLYG__53CD4F35] FOREIGN KEY ([POLYGON_ID]) REFERENCES [acsa].[SWIFT_POLYGON] ([POLYGON_ID]),
    CONSTRAINT [UQ__SWIFT_FR__6D1828CAA4AAFD14] UNIQUE NONCLUSTERED ([CODE_FREQUENCY] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_FREQUENCY_CODE_FREQUENCY]
    ON [acsa].[SWIFT_FREQUENCY]([CODE_FREQUENCY] ASC)
    INCLUDE([SUNDAY], [MONDAY], [TUESDAY], [WEDNESDAY], [THURSDAY], [LAST_WEEK_VISITED], [LAST_UPDATED], [LAST_UPDATED_BY], [CODE_ROUTE], [TYPE_TASK], [POLYGON_ID], [FRIDAY], [SATURDAY], [FREQUENCY_WEEKS]);


GO
CREATE NONCLUSTERED INDEX [IN_SWIFT_FREQUENCY_POLYGON_ID]
    ON [acsa].[SWIFT_FREQUENCY]([POLYGON_ID] ASC)
    INCLUDE([SUNDAY], [MONDAY], [TUESDAY], [WEDNESDAY], [THURSDAY], [FREQUENCY_WEEKS], [LAST_WEEK_VISITED], [LAST_UPDATED], [LAST_UPDATED_BY], [CODE_ROUTE], [TYPE_TASK], [CODE_FREQUENCY], [ID_FREQUENCY], [FRIDAY], [SATURDAY]);

