CREATE TABLE [acsa].[OP_WMS_WAREHOUSES] (
    [WAREHOUSE_ID]               VARCHAR (25)  NOT NULL,
    [NAME]                       VARCHAR (50)  NOT NULL,
    [COMMENTS]                   VARCHAR (150) NULL,
    [ERP_WAREHOUSE]              VARCHAR (50)  NULL,
    [ALLOW_PICKING]              NUMERIC (18)  NULL,
    [DEFAULT_RECEPTION_LOCATION] VARCHAR (25)  NULL,
    [SHUNT_NAME]                 VARCHAR (25)  NULL,
    [WAREHOUSE_WEATHER]          VARCHAR (50)  NULL,
    [WAREHOUSE_STATUS]           INT           NULL,
    [IS_3PL_WAREHUESE]           INT           NULL,
    [WAHREHOUSE_ADDRESS]         VARCHAR (250) NULL,
    [GPS_URL]                    VARCHAR (100) NULL,
    [DISTRIBUTION_CENTER_ID]     VARCHAR (50)  NOT NULL
);

