﻿CREATE TABLE [acsa].[SONDA_SALES_ORDER_HEADER] (
    [SALES_ORDER_ID]             INT             IDENTITY (1, 1) NOT NULL,
    [TERMS]                      VARCHAR (15)    NULL,
    [POSTED_DATETIME]            DATETIME        NULL,
    [CLIENT_ID]                  VARCHAR (50)    NULL,
    [POS_TERMINAL]               VARCHAR (25)    NULL,
    [GPS_URL]                    VARCHAR (150)   NULL,
    [TOTAL_AMOUNT]               NUMERIC (18, 6) NULL,
    [STATUS]                     INT             NULL,
    [POSTED_BY]                  VARCHAR (25)    NULL,
    [IMAGE_1]                    VARCHAR (MAX)   NULL,
    [IMAGE_2]                    VARCHAR (MAX)   NULL,
    [IMAGE_3]                    VARCHAR (MAX)   NULL,
    [IMAGE_4_G]                    VARCHAR (MAX)   NULL,
    [DEVICE_BATTERY_FACTOR]      INT             CONSTRAINT [DF_SONDA_SALES_ORDER_HEADER_DEVICE_BATTERY_FACTOR] DEFAULT ((0)) NULL,
    [VOID_DATETIME]              DATETIME        NULL,
    [VOID_REASON]                VARCHAR (25)    NULL,
    [VOID_NOTES]                 VARCHAR (MAX)   NULL,
    [VOIDED]                     INT             NULL,
    [CLOSED_ROUTE_DATETIME]      DATETIME        NULL,
    [IS_ACTIVE_ROUTE]            INT             CONSTRAINT [DF_SONDA_SALES_ORDER_HEADER_IS_ACTIVE_ROUTE] DEFAULT ((1)) NULL,
    [GPS_EXPECTED]               VARCHAR (MAX)   NULL,
    [DELIVERY_DATE]              DATETIME        NULL,
    [SALES_ORDER_ID_HH]          INT             NULL,
    [ATTEMPTED_WITH_ERROR]       INT             CONSTRAINT [DF_SONDA_SALES_ORDER_HEADER_ATTEMPTED_WITH_ERROR] DEFAULT ((0)) NULL,
    [IS_POSTED_ERP]              INT             NULL,
    [POSTED_ERP]                 DATETIME        CONSTRAINT [DF_SONDA_SALES_ORDER_HEADER_POSTED_ERP] DEFAULT ((0)) NULL,
    [POSTED_RESPONSE]            VARCHAR (4000)  NULL,
    [IS_PARENT]                  INT             NULL,
    [REFERENCE_ID]               VARCHAR (150)   NULL,
    [WAREHOUSE]                  VARCHAR (50)    NULL,
    [TIMES_PRINTED]              INT             CONSTRAINT [DF_SONDA_SALES_ORDER_HEADER_TIMES_PRINTED] DEFAULT ((0)) NULL,
    [DOC_SERIE]                  VARCHAR (100)   NULL,
    [DOC_NUM]                    INT             NULL,
    [IS_VOID]                    INT             CONSTRAINT [DF_SONDA_SALES_ORDER_HEADER_IS_VOID] DEFAULT ((0)) NULL,
    [SALES_ORDER_TYPE]           VARCHAR (250)   NULL,
    [DISCOUNT]                   NUMERIC (18, 6) CONSTRAINT [DF__SONDA_SAL__DISCO__6541F3FA] DEFAULT ((0)) NULL,
    [IS_DRAFT]                   INT             CONSTRAINT [DF__SONDA_SAL__IS_DR__66361833] DEFAULT ((0)) NULL,
    [ASSIGNED_BY]                VARCHAR (50)    CONSTRAINT [DF__SONDA_SAL__ASSIG__672A3C6C] DEFAULT ('HH') NULL,
    [TASK_ID]                    INT             NULL,
    [COMMENT]                    VARCHAR (250)   NULL,
    [ERP_REFERENCE]              VARCHAR (256)   NULL,
    [PAYMENT_TIMES_PRINTED]      INT             NULL,
    [PAID_TO_DATE]               NUMERIC (18, 6) CONSTRAINT [DF__SONDA_SAL__PAID___681E60A5] DEFAULT ((0.00)) NULL,
    [TO_BILL]                    INT             CONSTRAINT [DF__SONDA_SAL__TO_BI__691284DE] DEFAULT ((0)) NULL,
    [HAVE_PICKING]               INT             CONSTRAINT [DF__SONDA_SAL__HAVE___6A06A917] DEFAULT ((0)) NULL,
    [AUTHORIZED]                 INT             CONSTRAINT [DF__SONDA_SAL__AUTHO__6AFACD50] DEFAULT ((1)) NOT NULL,
    [AUTHORIZED_BY]              VARCHAR (50)    NULL,
    [AUTHORIZED_DATE]            DATETIME        NULL,
    [DISCOUNT_BY_GENERAL_AMOUNT] NUMERIC (18, 6) CONSTRAINT [DF__SONDA_SAL__DISCO__6BEEF189] DEFAULT ((0)) NULL,
    [IS_READY_TO_SEND]           INT             CONSTRAINT [DF__SONDA_SAL__IS_RE__6CE315C2] DEFAULT ((0)) NULL,
    [IS_SENDING]                 INT             CONSTRAINT [DF__SONDA_SAL__IS_SE__6DD739FB] DEFAULT ((0)) NULL,
    [LAST_UPDATE_IS_SENDING]     DATETIME        NULL,
    [SERVER_POSTED_DATETIME]     DATETIME        CONSTRAINT [DF__SONDA_SAL__SERVE__6ECB5E34] DEFAULT (getdate()) NOT NULL,
    [DEVICE_NETWORK_TYPE]        VARCHAR (15)    NULL,
    [IS_POSTED_OFFLINE]          INT             CONSTRAINT [DF__SONDA_SAL__IS_PO__6FBF826D] DEFAULT ((0)) NOT NULL,
    [GOAL_HEADER_ID]             INT             NULL,
    [TOTAL_AMOUNT_DISPLAY]       NUMERIC (18, 6) CONSTRAINT [DF_SondaSalesOrderHeader_totalAmountDisplay] DEFAULT ((0)) NULL,
    [PURCHASE_ORDER_NUMBER]      VARCHAR (100)   NULL,
    CONSTRAINT [PK_SONDA_SALES_ORDER_HEADER] PRIMARY KEY CLUSTERED ([SALES_ORDER_ID] ASC),
    CONSTRAINT [FK_SONDA_SALES_ORDER_HEADER_SWIFT_TASKS] FOREIGN KEY ([TASK_ID]) REFERENCES [acsa].[SWIFT_TASKS] ([TASK_ID])
);


GO
CREATE NONCLUSTERED INDEX [IDX_SALES_ORDER_TASK_ID]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([TASK_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_SONDA_SALES_ORDER_HEADER_SERVER_POSTED_DATETIME]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([SALES_ORDER_ID] ASC)
    INCLUDE([SERVER_POSTED_DATETIME]);


GO
CREATE NONCLUSTERED INDEX [IDX_SONDA_SALES_ORDER_HEADER_TO]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([CLIENT_ID] ASC)
    INCLUDE([TOTAL_AMOUNT], [POSTED_DATETIME]);


GO
CREATE NONCLUSTERED INDEX [IN_SONDA_SALES_ORDER_HEADER_DEMAND_DISPATCH]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([IS_VOID] ASC, [IS_DRAFT] ASC, [HAVE_PICKING] ASC, [POSTED_DATETIME] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SONDA_SALES_ORDER_HEADER_DOC_SERIE_NUM]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([DOC_SERIE] ASC, [DOC_NUM] ASC)
    INCLUDE([SERVER_POSTED_DATETIME], [IS_READY_TO_SEND]);


GO
CREATE NONCLUSTERED INDEX [IN_SONDA_SALES_ORDER_HEADER_IS_ACTIVE_ROUTE_IS_POSTED_ERP_DOC_SERIE_NUM]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([IS_ACTIVE_ROUTE] ASC, [IS_POSTED_ERP] ASC, [DOC_SERIE] ASC, [DOC_NUM] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SONDA_SALES_ORDER_HEADER_IS_ACTIVE_ROUTE_POS_TERMINAL_DOC_SERIE_NUM]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([IS_ACTIVE_ROUTE] ASC, [POS_TERMINAL] ASC, [DOC_SERIE] ASC, [DOC_NUM] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SONDA_SALES_ORDER_HEADER_POS_TERMINAL_CLIENT_ID_DOC_SERIE_NUM]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([POS_TERMINAL] ASC, [CLIENT_ID] ASC, [DOC_SERIE] ASC, [DOC_NUM] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SONDA_SALES_ORDER_HEADER_WAREHOUSE]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([WAREHOUSE] ASC);


GO
CREATE NONCLUSTERED INDEX [IN_SONDA_SALES_ORDER_POS_TERMINAL]
    ON [acsa].[SONDA_SALES_ORDER_HEADER]([POS_TERMINAL] ASC)
    INCLUDE([IS_ACTIVE_ROUTE], [IS_READY_TO_SEND]);

