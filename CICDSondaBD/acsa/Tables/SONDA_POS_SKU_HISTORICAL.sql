﻿CREATE TABLE [acsa].[SONDA_POS_SKU_HISTORICAL] (
    [SKU_HISTORICAL_ID] BIGINT          IDENTITY (1, 1) NOT NULL,
    [CODE_SKU]          VARCHAR (50)    NULL,
    [DESCRIPTION_SKU]   VARCHAR (150)   NULL,
    [SKU_PRICE]         MONEY           NULL,
    [REQUERIES_SERIE]   INT             DEFAULT ((0)) NULL,
    [IS_KIT]            INT             DEFAULT ((0)) NULL,
    [ON_HAND]           NUMERIC (18, 2) NULL,
    [CODE_WAREHOUSE]    VARCHAR (25)    NOT NULL,
    [IS_PARENT]         INT             NULL,
    [PARENT_SKU]        VARCHAR (50)    NOT NULL,
    [EXPOSURE]          INT             NULL,
    [PRIORITY]          INT             NULL,
    [QTY_RELATED]       INT             NULL,
    [CODE_FAMILY_SKU]   VARCHAR (50)    NULL,
    [SALES_PACK_UNIT]   VARCHAR (25)    NULL,
    [INITIAL_QTY]       NUMERIC (18, 2) NULL,
    [TRANSFER_DATETIME] DATETIME        NOT NULL,
    [LIQUIDATION_ID]    BIGINT          NOT NULL,
    PRIMARY KEY CLUSTERED ([SKU_HISTORICAL_ID] ASC)
);

