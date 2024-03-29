﻿CREATE TABLE [acsa].[SWIFT_TAGS_BY_SERIE] (
    [SKU]           VARCHAR (50)  NOT NULL,
    [SERIAL_NUMBER] VARCHAR (150) NOT NULL,
    [TAG_COLOR]     VARCHAR (8)   NOT NULL,
    CONSTRAINT [PK_SWIFT_TAGS_BY_SERIE] PRIMARY KEY CLUSTERED ([SKU] ASC, [SERIAL_NUMBER] ASC, [TAG_COLOR] ASC),
    CONSTRAINT [FK_SWIFT_TAGS_BY_SERIE_SWIFT_TAGS] FOREIGN KEY ([TAG_COLOR]) REFERENCES [acsa].[SWIFT_TAGS] ([TAG_COLOR])
);

