﻿CREATE TABLE [acsa].[SWIFT_VEHICLE_X_USER] (
    [VEHICLE] INT          NOT NULL,
    [LOGIN]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_VEHICLE_X_USER] PRIMARY KEY CLUSTERED ([VEHICLE] ASC, [LOGIN] ASC),
    CONSTRAINT [FK_VEHICLE_X_USER_VEHICLE] FOREIGN KEY ([VEHICLE]) REFERENCES [acsa].[SWIFT_VEHICLES] ([VEHICLE])
);

