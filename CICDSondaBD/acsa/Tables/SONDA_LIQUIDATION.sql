﻿CREATE TABLE [acsa].[SONDA_LIQUIDATION] (
    [LIQUIDATION_ID]      BIGINT        NOT NULL,
    [CODE_ROUTE]          VARCHAR (50)  NOT NULL,
    [LOGIN]               VARCHAR (50)  NOT NULL,
    [LIQUIDATION_DATE]    DATETIME      NOT NULL,
    [LAST_UPDATE]         DATETIME      NOT NULL,
    [LAST_UPDATE_BY]      VARCHAR (50)  NOT NULL,
    [LIQUIDATION_STATUS]  VARCHAR (10)  NULL,
    [STATUS]              VARCHAR (10)  NOT NULL,
    [TYPE_ROUTE]          VARCHAR (10)  NULL,
    [LIQUIDATION_COMMENT] VARCHAR (250) NULL,
    PRIMARY KEY CLUSTERED ([LIQUIDATION_ID] ASC)
);

