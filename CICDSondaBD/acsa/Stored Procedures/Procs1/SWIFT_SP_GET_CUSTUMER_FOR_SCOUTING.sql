﻿-- =============================================
-- Autor:				joel.delcompare
-- Fecha de Creacion: 	11-09-2015
-- Description:			SP para obtener los clientes que se le puede hacer scouting por ruta


-- Modificado 11-09-2015
-- joel.delcompare
-- Por motivo de que se estaban tomando todos los clientes ahora en adelante se toman solo los clientes de ese vendedor en especifico

-- Modificado 11-11-2015
-- rudi.garcia
-- Se agregro que trajiera los clientes de las tareas generadas

-- Modificado 22-02-2016
-- alberto.ruiz
-- Se agrego el campo de limite de credito

-- Modificado 27-02-2016
-- rudi.garcia
-- Se agrego el campo dias de credito

-- Modificado 06-04-2016
-- hector.gonzalez
-- Se agrego el campo DISCOUNT

-- Modificacion 15-07-2016
-- alberto.ruiz
-- Se agrago campo de gps

-- Modificacion 25-Oct-16 @ A-Team Sprint 3
-- alberto.ruiz
-- Se agrego el replace en la direccion del cliente para quitar el caracter "

-- Modificacion 29-Nov-16 @ A-Team Sprint 5
-- rudi.garcia
-- Se agrego el campo RGA_CODE

-- Modificacion 12-Dec-16 @ A-Team Sprint 6
-- alberto.ruiz
-- Se agregaron los campos de la lista de descuento y lista de bonificacion

-- Modificacion 26-Dec-16 @ A-Team Sprint Balder
-- rodrigo.gomez
-- Se agregaron el campo de la lista de precios

-- Modificacion 08-Feb-17 @ A-Team Sprint Chatuluka
-- alberto.ruiz
-- Se agrego el campo de lista de venta por multiplo

-- Modificacion 4/20/2017 @ A-Team Sprint Hondo
-- diego.as
-- Se agregan las columnas LAST_PURCHASE y PREVIUS_BALANCE

-- Modificacion 03-May-17 @ A-Team Sprint Hondo
-- alberto.ruiz
-- Se coloco que obtenga las listas de precios de la tabla SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE y se ajusto como obtiene la lista de precios por defecto para que tome en cuenta la que puede tener configurada el usuario

-- Modificacion 29-May-17 @ A-Team Sprint Jibade
-- alberto.ruiz
-- Se agregaron campos de nit y nombre de facturacion

-- Modificacion 06-Jul-17 @ TeamOmikron Qalisar
-- eder.chamale
-- Tuning

-- Modificacion 01-Aug-17 @ Reborn-Team Sprint Bearbeitung
-- rudi.garcia
-- Se ajusto para que solo tome las listas de los clientes de la ruta y se cambio el filtra para que utilize el codigo ruta.

-- Modificacion 08-Aug-17 @ Nexus Team Sprint AgeOfEmpires
-- alberto.ruiz
-- Se agrego el where para las listas de bonificaciones,descuentos y venta por multiplo y se comentarion los joins a dichas tablas


-- Autor:	        hector.gonzalez
-- Fecha de Creacion: 	2017-08-22 @ Team REBORN - Sprint Bearbeitung
-- Description:	   Se modificaron tablas temporales para que tengan la ruta cliente y listas, se agregaron indices 

-- Modificacion			11/15/2018 @ G-Force Team Sprint 
-- Autor:				diego.as
-- Historia/Bug:		Product Backlog Item 25662: Precios Especiales en el movil
-- Descripcion:			11/15/2018 - Se agrega envio de lista de precios especiales


-- Modificacion			02/12/2019 @ G-Force Team Salamandra
-- Autor:				christian.hernandez
-- Historia/Bug:		Product Backlog Item 26937: Aplicación de MicroEncuestas a Clientes del Canal
-- Descripcion:			02/12/2019 - Se agrega campo CODE_CHANNEL

-- Modificacion 		6/20/2019 @ G-Force Team Sprint Dubai
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 29713: Agregar funcionalidad de Cobros en Preventa
-- Descripcion: 		6/20/2019 - Se agregan columnas GROUP_NUM y [OUTSTANDING_BALANCE]

-- Modificacion 		7/12/2019 @ G-Force Team Sprint Estocolmo
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 30461: Visualizacion de Ultima fecha y precio de compra
-- Descripcion: 		7/12/2019 - Se agrega subquery para obtener LAST_PURCHASE y LAST_PURCHASE_DATE desde la tabla SONDA_ITEM_HISTORY

/*
-- Ejemplo de Ejecucion:
        exec [acsa].[SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING] @CODE_ROUTE = 'RP-01'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING]
(@CODE_ROUTE VARCHAR(50))
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE @DEFAULT_PRICE_LIST VARCHAR(25);
    --
    CREATE TABLE [#CUSTOMER]
    (
        [CODE_CUSTOMER] VARCHAR(50),
        [NAME_CUSTOMER] VARCHAR(250),
        [TAX_ID_NUMBER] VARCHAR(50),
        [ADRESS_CUSTOMER] VARCHAR(250),
        [PHONE_CUSTOMER] VARCHAR(250),
        [CONTACT_CUSTOMER] VARCHAR(250),
        [CREDIT_LIMIT] NUMERIC(18, 6),
        [EXTRA_DAYS] INT,
        [DISCOUNT] NUMERIC(18, 6),
        [GPS] VARCHAR(250),
        [RGA_CODE] VARCHAR(150),
        [DISCOUNT_LIST_ID] INT,
        [BONUS_LIST_ID] INT,
        [PRICE_LIST_ID] VARCHAR(50),
        [SALES_BY_MULTIPLE_LIST_ID] INT,
        [PREVIUS_BALANCE] DECIMAL(18, 6),
        [LAST_PURCHASE] NUMERIC(18, 6),
        [INVOICE_NAME] VARCHAR(250),
        [SPECIAL_PRICE_LIST_ID] INT,
        [CODE_CHANNEL] VARCHAR(25),
        [GROUP_NUM] INT,
        [OUTSTANDING_BALANCE] NUMERIC(18, 6),
        [LAST_PURCHASE_DATE] DATE
    );

    CREATE CLUSTERED INDEX [IDX_#CUSTOMER_CODE_CUSTOMER]
    ON [#CUSTOMER] ([CODE_CUSTOMER]); --, [DISCOUNT_LIST_ID], [BONUS_LIST_ID], [SALES_BY_MULTIPLE_LIST_ID])

    --
    CREATE TABLE [#RESULT]
    (
        [CODE_CUSTOMER] VARCHAR(50),
        [NAME_CUSTOMER] VARCHAR(250),
        [TAX_ID_NUMBER] VARCHAR(50),
        [ADRESS_CUSTOMER] VARCHAR(250),
        [PHONE_CUSTOMER] VARCHAR(250),
        [CONTACT_CUSTOMER] VARCHAR(250),
        [CREDIT_LIMIT] NUMERIC(18, 6),
        [EXTRA_DAYS] INT,
        [DISCOUNT] NUMERIC(18, 6),
        [GPS] VARCHAR(250),
        [RGA_CODE] VARCHAR(150),
        [DISCOUNT_LIST_ID] INT,
        [BONUS_LIST_ID] INT,
        [PRICE_LIST_ID] VARCHAR(50),
        [SALES_BY_MULTIPLE_LIST_ID] INT,
        [PREVIUS_BALANCE] DECIMAL(18, 6),
        [LAST_PURCHASE] NUMERIC(18, 6),
        [INVOICE_NAME] VARCHAR(250),
        [SPECIAL_PRICE_LIST_ID] INT,
        [CODE_CHANNEL] VARCHAR(25),
        [GROUP_NUM] INT,
        [OUTSTANDING_BALANCE] NUMERIC(18, 6),
        [LAST_PURCHASE_DATE] DATE
    );
    CREATE INDEX [IDX_#RESULT_CODE_CUSTOMER] ON [#RESULT] ([CODE_CUSTOMER]);

    CREATE TABLE [#CHANNEL]
    (
        [CHANNEL_ID] VARCHAR(50),
        [CODE_CHANNEL] VARCHAR(50),
        [CODE_CUSTOMER] VARCHAR(50)
    );


    CREATE CLUSTERED INDEX [IDX_#CHANNEL_CHANNEL_ID]
    ON [#CHANNEL] ([CHANNEL_ID]);
    CREATE INDEX [IDX_#CHANNEL_CODE_CUSTOMER]
    ON [#CHANNEL] ([CODE_CUSTOMER])
    INCLUDE ([CHANNEL_ID]);
    --
    CREATE TABLE [#DISCOUNT_LIST]
    (
        [DISCOUNT_LIST_ID] INT,
        [CODE_ROUTE] VARCHAR(50),
        [CODE_CUSTOMER] VARCHAR(50)
    );

    CREATE CLUSTERED INDEX [IDX_#DISCOUNT_LIST_DISCOUNT_LIST_ID]
    ON [#DISCOUNT_LIST] ([DISCOUNT_LIST_ID]);

    CREATE NONCLUSTERED INDEX [IDX_#DISCOUNT_LIST_CODE_CUSTOMER]
    ON [#DISCOUNT_LIST] ([CODE_CUSTOMER])
    INCLUDE ([DISCOUNT_LIST_ID]);
    --
    CREATE TABLE [#BONUS_LIST]
    (
        [BONUS_LIST_ID] INT,
        [CODE_ROUTE] VARCHAR(50),
        [CODE_CUSTOMER] VARCHAR(50)
            UNIQUE (
                       [CODE_CUSTOMER],
                       [BONUS_LIST_ID]
                   )
    );
    CREATE CLUSTERED INDEX [IDX_#BONUS_LIST_BONUS_LIST_ID]
    ON [#BONUS_LIST] ([BONUS_LIST_ID]);

    CREATE NONCLUSTERED INDEX [IDX_#BONUS_LIST_CODE_CUSTOMER]
    ON [#BONUS_LIST] ([CODE_CUSTOMER])
    INCLUDE ([BONUS_LIST_ID]);

    --
    CREATE TABLE [#SKU_SALES_BY_MULTIPLE_LIST]
    (
        [SALES_BY_MULTIPLE_LIST_ID] INT,
        [CODE_ROUTE] VARCHAR(50),
        [CODE_CUSTOMER] VARCHAR(50)
            UNIQUE (
                       [CODE_CUSTOMER],
                       [SALES_BY_MULTIPLE_LIST_ID]
                   )
    );
    CREATE CLUSTERED INDEX [IDX_#SKU_SALES_BY_MULTIPLE_LIST_SALES_BY_MULTIPLE_LIST_ID]
    ON [#SKU_SALES_BY_MULTIPLE_LIST] ([SALES_BY_MULTIPLE_LIST_ID]);
    CREATE NONCLUSTERED INDEX [IDX_#SKU_SALES_BY_MULTIPLE_LIST_CODE_CUSTOMER]
    ON [#SKU_SALES_BY_MULTIPLE_LIST] ([CODE_CUSTOMER])
    INCLUDE ([SALES_BY_MULTIPLE_LIST_ID]);

    --
    CREATE TABLE [#SPECIAL_PRICE_LIST]
    (
        [SPECIAL_PRICE_LIST_ID] INT,
        [CODE_ROUTE] VARCHAR(50),
        [CODE_CUSTOMER] VARCHAR(50)
    );
    CREATE CLUSTERED INDEX [IDX_SPECIAL_PRICE_LIST_ID]
    ON [#SPECIAL_PRICE_LIST] ([SPECIAL_PRICE_LIST_ID]);
    CREATE NONCLUSTERED INDEX [IDX_SPECIAL_PRICE_LIST_CODE_CUSTOMER]
    ON [#SPECIAL_PRICE_LIST] ([CODE_CUSTOMER])
    INCLUDE ([SPECIAL_PRICE_LIST_ID]);

    -- ------------------------------------------------------------------------------------
    -- Obtiene la lista de precios por defecto de la ruta
    -- ------------------------------------------------------------------------------------
    /*SELECT @DEFAULT_PRICE_LIST = ISNULL([CODE_PRICE_LIST], [acsa].[SWIFT_FN_GET_PARAMETER] ('ERP_HARDCODE_VALUES','PRICE_LIST'))
  FROM [acsa].[USERS]
  WHERE [SELLER_ROUTE] = @CODE_ROUTE*/
    SELECT @DEFAULT_PRICE_LIST = '-1';

    -- ------------------------------------------------------------------------------------
    -- Obtiene las listas de descuentos asociadas a la ruta
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#DISCOUNT_LIST]
    SELECT [DL].[DISCOUNT_LIST_ID],
           [DL].[CODE_ROUTE],
           [DLBC].[CODE_CUSTOMER]
    FROM [acsa].[SWIFT_DISCOUNT_LIST] [DL]
        INNER JOIN [acsa].[SWIFT_DISCOUNT_LIST_BY_CUSTOMER] [DLBC]
            ON (
                   [DL].[DISCOUNT_LIST_ID] = [DLBC].[DISCOUNT_LIST_ID] 
                   AND [DLBC].[DISCOUNT_LIST_ID] > 0
               )
    WHERE [DL].[CODE_ROUTE] = @CODE_ROUTE;

    -- ------------------------------------------------------------------------------------
    -- Obtiene las listas de bonificaciones asociadas a la ruta
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#BONUS_LIST]
    SELECT [BL].[BONUS_LIST_ID],
           [BL].[CODE_ROUTE],
           [BLBC].[CODE_CUSTOMER]
    FROM [acsa].[SWIFT_BONUS_LIST] [BL]
        INNER JOIN [acsa].[SWIFT_BONUS_LIST_BY_CUSTOMER] [BLBC]
            ON ([BL].[BONUS_LIST_ID] = [BLBC].[BONUS_LIST_ID] )
    WHERE [BL].[CODE_ROUTE] = @CODE_ROUTE;

    -- ------------------------------------------------------------------------------------
    -- Obtiene las listas de venta minima
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#SKU_SALES_BY_MULTIPLE_LIST]
    SELECT [SM].[SALES_BY_MULTIPLE_LIST_ID],
           [SM].[CODE_ROUTE],
           [SLBC].[CODE_CUSTOMER]
    FROM [acsa].[SWIFT_SKU_SALES_BY_MULTIPLE_LIST] [SM]
        INNER JOIN [acsa].[SWIFT_SKU_SALES_BY_MULTIPLE_LIST_BY_CUSTOMER] [SLBC]
            ON ([SM].[SALES_BY_MULTIPLE_LIST_ID] = [SLBC].[SALES_BY_MULTIPLE_LIST_ID] )
    WHERE [SM].[CODE_ROUTE] = @CODE_ROUTE;

    -- ------------------------------------------------------------------------------------
    -- Obtiene las listas de precios especiales asociadas a la ruta
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#SPECIAL_PRICE_LIST]
    (
        [SPECIAL_PRICE_LIST_ID],
        [CODE_ROUTE],
        [CODE_CUSTOMER]
    )
    SELECT [SPL].[SPECIAL_PRICE_LIST_ID],
           [SPL].[CODE_ROUTE],
           [SPLBC].[CODE_CUSTOMER]
    FROM [acsa].[SWIFT_SPECIAL_PRICE_LIST] AS [SPL]
        INNER JOIN [acsa].[SWIFT_SPECIAL_PRICE_LIST_BY_CUSTOMER] AS [SPLBC]
            ON (
                   [SPLBC].[SPECIAL_PRICE_LIST_ID]  = [SPL].[SPECIAL_PRICE_LIST_ID]
                   AND [SPLBC].[SPECIAL_PRICE_LIST_ID] > 0
               )
    WHERE [SPL].[CODE_ROUTE] = @CODE_ROUTE;

    -- ------------------------------------------------------------------------------------
    -- Obtener Canales
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#CHANNEL]
    SELECT [SC].[CHANNEL_ID],
           [SC].[CODE_CHANNEL],
           [SCXC].[CODE_CUSTOMER]
   FROM [acsa].[SWIFT_CHANNEL] [SC]
        INNER JOIN [acsa].[SWIFT_CHANNEL_X_CUSTOMER] [SCXC]
            ON ([SCXC].[CHANNEL_ID] = [SC].[CHANNEL_ID]  );

    -- ------------------------------------------------------------------------------------
    -- Obtener Clientes Scounting
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#CUSTOMER]
    (
        [CODE_CUSTOMER],
        [NAME_CUSTOMER],
        [TAX_ID_NUMBER],
        [ADRESS_CUSTOMER],
        [PHONE_CUSTOMER],
        [CONTACT_CUSTOMER],
        [CREDIT_LIMIT],
        [EXTRA_DAYS],
        [DISCOUNT],
        [GPS],
        [RGA_CODE],
        [DISCOUNT_LIST_ID],
        [BONUS_LIST_ID],
        [PRICE_LIST_ID],
        [SALES_BY_MULTIPLE_LIST_ID],
        [PREVIUS_BALANCE],
        [LAST_PURCHASE],
        [INVOICE_NAME],
        [SPECIAL_PRICE_LIST_ID],
        [CODE_CHANNEL],
        [GROUP_NUM],
        [OUTSTANDING_BALANCE],
        [LAST_PURCHASE_DATE]
    )
    SELECT TOP 10 [C].[CODE_CUSTOMER],
           [dbo].[FUNC_REMOVE_SPECIAL_CHARS]([C].[NAME_CUSTOMER]) AS [NAME_CUSTOMER],
           [C].[TAX_ID_NUMBER],
           REPLACE([dbo].[FUNC_REMOVE_SPECIAL_CHARS](COALESCE([C].[ADRESS_CUSTOMER], '')), '"', '') AS [ADRESS_CUSTOMER],
           COALESCE([C].[PHONE_CUSTOMER], '') AS [PHONE_CUSTOMER],
           [dbo].[FUNC_REMOVE_SPECIAL_CHARS](COALESCE([C].[CONTACT_CUSTOMER], '')) AS [CONTACT_CUSTOMER],
           ISNULL([C].[CREDIT_LIMIT], 0.00) [CREDIT_LIMIT],
           ISNULL([C].[EXTRA_DAYS], 0) [EXTRA_DAYS],
           [C].[DISCOUNT] AS [DISCOUNT],
           ISNULL([C].[GPS], '0,0') [GPS],
           [C].[RGA_CODE],
           [DLC].[DISCOUNT_LIST_ID],
           [BLC].[BONUS_LIST_ID],
           ISNULL([PLC].[CODE_PRICE_LIST], @DEFAULT_PRICE_LIST),
           [SMC].[SALES_BY_MULTIPLE_LIST_ID],
           [C].[BALANCE] AS [PREVIUS_BALANCE],
           ISNULL(
           (
               SELECT TOP (1)
                      MAX([IH].[DOCUMENT_AMOUNT]) AS [DOCUMENT_AMOUNT]
               FROM [acsa].[SONDA_ITEM_HISTORY] AS [IH]
               WHERE [IH].[CODE_CUSTOMER] = [C].[CODE_CUSTOMER]
               GROUP BY [IH].[CODE_CUSTOMER]
               ORDER BY [IH].[CODE_CUSTOMER]
           ),
           0
                 ) AS [LAST_PURCHASE],
           [C].[INVOICE_NAME],
           [SPL].[SPECIAL_PRICE_LIST_ID],
           [CH].[CODE_CHANNEL],
           [C].[GROUP_NUM],
           (ISNULL([C].[CREDIT_LIMIT], 0) - ISNULL([C].[BALANCE], 0)) AS [OUTSTANDING_BALANCE],
           (
               SELECT TOP (1)
                      MAX(CAST([IH].[SALE_DATE] AS DATE)) AS [SALE_DATE]
               FROM [acsa].[SONDA_ITEM_HISTORY] AS [IH]
               WHERE [IH].[CODE_CUSTOMER] = [C].[CODE_CUSTOMER]
               GROUP BY [IH].[CODE_CUSTOMER]
               ORDER BY [IH].[CODE_CUSTOMER]
           ) AS [LAST_PURCHASE_DATE]
        FROM [acsa].[SWIFT_VIEW_ALL_COSTUMER] [C]
        INNER JOIN [acsa].[USERS] [U]
            ON ([C].[SELLER_DEFAULT_CODE] COLLATE DATABASE_DEFAULT = [U].[RELATED_SELLER] COLLATE DATABASE_DEFAULT)
        LEFT JOIN [#DISCOUNT_LIST] [DLC]
            ON (
                   [DLC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT = [C].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT
                   AND [DLC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT > ''
               )
        LEFT JOIN [#BONUS_LIST] [BLC]
            ON (
                   [BLC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT = [C].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT 
                   AND [BLC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT > ''
               )
        LEFT JOIN [#SKU_SALES_BY_MULTIPLE_LIST] [SMC]
            ON (
                   [SMC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT = [C].[CODE_CUSTOMER]COLLATE DATABASE_DEFAULT
                   AND [SMC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT > ''
               )
        LEFT JOIN [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE] [PLC]
            ON (
                   [PLC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT = [C].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT
                   AND [PLC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT  > ''
               )
        LEFT JOIN [#SPECIAL_PRICE_LIST] AS [SPL]
            ON (
                   [SPL].[CODE_CUSTOMER]COLLATE DATABASE_DEFAULT = [C].[CODE_CUSTOMER]COLLATE DATABASE_DEFAULT 
                   AND [SPL].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT > ''
               )
        LEFT JOIN [#CHANNEL] AS [CH]
            ON ([CH].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT = [C].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT)
    WHERE [U].[SELLER_ROUTE] = @CODE_ROUTE;

    --    LEFT JOIN @BONUS_LIST BL
    --      ON (
    --      [BLC].[BONUS_LIST_ID] = [BL].[BONUS_LIST_ID]
    --      )
    --    LEFT JOIN @SKU_SALES_BY_MULTIPLE_LIST SML
    --      ON (
    --      [SMC].[SALES_BY_MULTIPLE_LIST_ID] = [SML].[SALES_BY_MULTIPLE_LIST_ID]
    --      )
    --    LEFT JOIN @DISCOUNT_LIST [DL]
    --      ON (
    --      [DLC].[DISCOUNT_LIST_ID] = [DL].[DISCOUNT_LIST_ID]
    --      )

    --    AND (
    --    DLC.DISCOUNT_LIST_ID IS NULL
    --    OR DLC.DISCOUNT_LIST_ID IN (SELECT
    --        DISCOUNT_LIST_ID
    --      FROM @DISCOUNT_LIST D
    --      WHERE D.DISCOUNT_LIST_ID = DLC.DISCOUNT_LIST_ID)
    --    )
    --    AND (
    --    [BLC].BONUS_LIST_ID IS NULL
    --    OR [BLC].BONUS_LIST_ID IN (SELECT
    --        BONUS_LIST_ID
    --      FROM @BONUS_LIST B
    --      WHERE B.BONUS_LIST_ID = BLC.BONUS_LIST_ID)
    --    )
    --    AND (
    --    [SMC].SALES_BY_MULTIPLE_LIST_ID IS NULL
    --    OR [SMC].SALES_BY_MULTIPLE_LIST_ID IN (SELECT
    --        SALES_BY_MULTIPLE_LIST_ID
    --      FROM @SKU_SALES_BY_MULTIPLE_LIST S
    --      WHERE S.SALES_BY_MULTIPLE_LIST_ID = SMC.SALES_BY_MULTIPLE_LIST_ID)
    --    )

    -- ------------------------------------------------------------------------------------
    -- Obtener Clientes Tareas
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#CUSTOMER]
    (
        [CODE_CUSTOMER],
        [NAME_CUSTOMER],
        [TAX_ID_NUMBER],
        [ADRESS_CUSTOMER],
        [PHONE_CUSTOMER],
        [CONTACT_CUSTOMER],
        [CREDIT_LIMIT],
        [EXTRA_DAYS],
        [DISCOUNT],
        [GPS],
        [RGA_CODE],
        [DISCOUNT_LIST_ID],
        [BONUS_LIST_ID],
        [PRICE_LIST_ID],
        [SALES_BY_MULTIPLE_LIST_ID],
        [PREVIUS_BALANCE],
        [LAST_PURCHASE],
        [INVOICE_NAME],
        [SPECIAL_PRICE_LIST_ID],
        [CODE_CHANNEL],
        --[GROUP_NUM],
        [OUTSTANDING_BALANCE],
        [LAST_PURCHASE_DATE]
    )
    SELECT [VAC].[CODE_CUSTOMER],
           [dbo].[FUNC_REMOVE_SPECIAL_CHARS]([VAC].[NAME_CUSTOMER]) AS [NAME_CUSTOMER],
           [VAC].[TAX_ID_NUMBER],
           [dbo].[FUNC_REMOVE_SPECIAL_CHARS](COALESCE([VAC].[ADRESS_CUSTOMER], '')) AS [ADRESS_CUSTOMER],
           COALESCE([VAC].[PHONE_CUSTOMER], '') AS [PHONE_CUSTOMER],
           [dbo].[FUNC_REMOVE_SPECIAL_CHARS](COALESCE([VAC].[CONTACT_CUSTOMER], '')) AS [CONTACT_CUSTOMER],
           ISNULL([VAC].[CREDIT_LIMIT], 0.00) [CREDIT_LIMIT],
           ISNULL([VAC].[EXTRA_DAYS], 0) [EXTRA_DAYS],
           [VAC].[DISCOUNT] AS [DISCOUNT],
           ISNULL([VAC].[GPS], '0,0') [GPS],
           [VAC].[RGA_CODE],
           [DLC].[DISCOUNT_LIST_ID],
           [BLC].[BONUS_LIST_ID],
           ISNULL([PLC].[CODE_PRICE_LIST], @DEFAULT_PRICE_LIST),
           [SMC].[SALES_BY_MULTIPLE_LIST_ID],
           [VAC].[BALANCE] AS [PREVIUS_BALANCE],
           ISNULL(
           (
               SELECT TOP (1)
                      MAX([IH].[DOCUMENT_AMOUNT]) AS [DOCUMENT_AMOUNT]
               FROM [acsa].[SONDA_ITEM_HISTORY] AS [IH]
               WHERE [IH].[CODE_CUSTOMER] = [VAC].[CODE_CUSTOMER]
               GROUP BY [IH].[CODE_CUSTOMER]
               ORDER BY [IH].[CODE_CUSTOMER]
           ),
           0
                 ) AS [LAST_PURCHASE],
           [VAC].[INVOICE_NAME],
           [SPL].[SPECIAL_PRICE_LIST_ID],
           [CH].[CODE_CHANNEL],
           --[VAC].[GROUP_NUM],
           (ISNULL([VAC].[CREDIT_LIMIT], 0) - ISNULL([VAC].[BALANCE], 0)) AS [OUTSTANDING_BALANCE],
           (
               SELECT TOP (1)
                      MAX(CAST([IH].[SALE_DATE] AS DATE)) AS [SALE_DATE]
               FROM [acsa].[SONDA_ITEM_HISTORY] AS [IH]
               WHERE [IH].[CODE_CUSTOMER] = [VAC].[CODE_CUSTOMER]
               GROUP BY [IH].[CODE_CUSTOMER]
               ORDER BY [IH].[CODE_CUSTOMER]
           ) AS [LAST_PURCHASE_DATE]
        FROM [$(CICDSondaBD)].[acsa].[SWIFT_VIEW_ALL_COSTUMER] [VAC]
        INNER JOIN [acsa].[SONDA_ROUTE_PLAN] [RP]
            ON ([VAC].[CODE_CUSTOMER]COLLATE DATABASE_DEFAULT = [RP].[RELATED_CLIENT_CODE]COLLATE DATABASE_DEFAULT)
        LEFT JOIN [#DISCOUNT_LIST] [DLC]
            ON (
                   [DLC].[CODE_CUSTOMER] = [VAC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT
                   AND [DLC].[CODE_CUSTOMER] > ''
               )
        LEFT JOIN [#BONUS_LIST] [BLC]
            ON (
                   [BLC].[CODE_CUSTOMER] = [VAC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT
                   AND [BLC].[CODE_CUSTOMER] > ''
               )
        LEFT JOIN [#SKU_SALES_BY_MULTIPLE_LIST] [SMC]
            ON (
                   [SMC].[CODE_CUSTOMER] = [VAC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT
                   AND [SMC].[CODE_CUSTOMER] > ''
               )
        LEFT JOIN [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE] [PLC]
            ON (
                   [PLC].[CODE_CUSTOMER]  COLLATE DATABASE_DEFAULT = [VAC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT
                   AND [PLC].[CODE_CUSTOMER]COLLATE DATABASE_DEFAULT > ''
               )
        LEFT JOIN [#SPECIAL_PRICE_LIST] AS [SPL]
            ON (
                   [SPL].[CODE_CUSTOMER] = [VAC].[CODE_CUSTOMER]COLLATE DATABASE_DEFAULT
                   AND [SPL].[CODE_CUSTOMER] > ''
               )
        LEFT JOIN [#CHANNEL] AS [CH]
            ON ([CH].[CODE_CUSTOMER] = [VAC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT)
    WHERE [RP].[CODE_ROUTE] = @CODE_ROUTE;

    --    LEFT JOIN @BONUS_LIST BL
    --      ON (
    --      [BLC].[BONUS_LIST_ID] = [BL].[BONUS_LIST_ID]
    --      )
    --    LEFT JOIN @SKU_SALES_BY_MULTIPLE_LIST SML
    --      ON (
    --      [SMC].[SALES_BY_MULTIPLE_LIST_ID] = [SML].[SALES_BY_MULTIPLE_LIST_ID]
    --      )
    --    LEFT JOIN @DISCOUNT_LIST [DL]
    --      ON (
    --      [DLC].[DISCOUNT_LIST_ID] = [DL].[DISCOUNT_LIST_ID]
    --      )

    --    AND (
    --    DLC.DISCOUNT_LIST_ID IS NULL
    --    OR DLC.DISCOUNT_LIST_ID IN (SELECT
    --        DISCOUNT_LIST_ID
    --      FROM @DISCOUNT_LIST D
    --      WHERE D.DISCOUNT_LIST_ID = DLC.DISCOUNT_LIST_ID)
    --    )
    --    AND (
    --    [BLC].BONUS_LIST_ID IS NULL
    --    OR [BLC].BONUS_LIST_ID IN (SELECT
    --        BONUS_LIST_ID
    --      FROM @BONUS_LIST B
    --      WHERE B.BONUS_LIST_ID = BLC.BONUS_LIST_ID)
    --    )
    --    AND (
    --    [SMC].SALES_BY_MULTIPLE_LIST_ID IS NULL
    --    OR [SMC].SALES_BY_MULTIPLE_LIST_ID IN (SELECT
    --        SALES_BY_MULTIPLE_LIST_ID
    --      FROM @SKU_SALES_BY_MULTIPLE_LIST S
    --      WHERE S.SALES_BY_MULTIPLE_LIST_ID = SMC.SALES_BY_MULTIPLE_LIST_ID)
    --    )

    -- ------------------------------------------------------------------------------------
    -- Agrego todos los clientes que no estan en algun acuerdo comercial
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#RESULT]
    (
        [CODE_CUSTOMER],
        [NAME_CUSTOMER],
        [TAX_ID_NUMBER],
        [ADRESS_CUSTOMER],
        [PHONE_CUSTOMER],
        [CONTACT_CUSTOMER],
        [CREDIT_LIMIT],
        [EXTRA_DAYS],
        [DISCOUNT],
        [GPS],
        [RGA_CODE],
        [DISCOUNT_LIST_ID],
        [BONUS_LIST_ID],
        [PRICE_LIST_ID],
        [SALES_BY_MULTIPLE_LIST_ID],
        [PREVIUS_BALANCE],
        [LAST_PURCHASE],
        [INVOICE_NAME],
        [SPECIAL_PRICE_LIST_ID],
        [CODE_CHANNEL],
        [GROUP_NUM],
        [OUTSTANDING_BALANCE],
        [LAST_PURCHASE_DATE]
    )
    SELECT [C].[CODE_CUSTOMER],
           [C].[NAME_CUSTOMER],
           [C].[TAX_ID_NUMBER],
           [C].[ADRESS_CUSTOMER],
           [C].[PHONE_CUSTOMER],
           [C].[CONTACT_CUSTOMER],
           [C].[CREDIT_LIMIT],
           [C].[EXTRA_DAYS],
           [C].[DISCOUNT],
           [C].[GPS],
           [C].[RGA_CODE],
           [C].[DISCOUNT_LIST_ID],
           [C].[BONUS_LIST_ID],
           [C].[PRICE_LIST_ID],
           [C].[SALES_BY_MULTIPLE_LIST_ID],
           [C].[PREVIUS_BALANCE],
           [C].[LAST_PURCHASE],
           [C].[INVOICE_NAME],
           [C].[SPECIAL_PRICE_LIST_ID],
           [C].[CODE_CHANNEL],
           [C].[GROUP_NUM],
           [C].[OUTSTANDING_BALANCE],
           [C].[LAST_PURCHASE_DATE]
    FROM [#CUSTOMER] [C]
    WHERE [C].[DISCOUNT_LIST_ID] IS NULL
          AND [C].[BONUS_LIST_ID] IS NULL
          AND [C].[SALES_BY_MULTIPLE_LIST_ID] IS NULL
          AND [C].[SPECIAL_PRICE_LIST_ID] IS NULL;

    -- ------------------------------------------------------------------------------------
    -- Elimina los clientes sin acuerdo comercial
    -- ------------------------------------------------------------------------------------
    DELETE [C]
    FROM [#CUSTOMER] [C]
        INNER JOIN [#RESULT] [R]
            ON ([R].[CODE_CUSTOMER] = [C].[CODE_CUSTOMER]);

    -- ------------------------------------------------------------------------------------
    -- Agrego los clientes que tienen acuerdo comercial y que generaron listas para la ruta solicitada
    -- ------------------------------------------------------------------------------------
    INSERT INTO [#RESULT]
    (
        [CODE_CUSTOMER],
        [NAME_CUSTOMER],
        [TAX_ID_NUMBER],
        [ADRESS_CUSTOMER],
        [PHONE_CUSTOMER],
        [CONTACT_CUSTOMER],
        [CREDIT_LIMIT],
        [EXTRA_DAYS],
        [DISCOUNT],
        [GPS],
        [RGA_CODE],
        [DISCOUNT_LIST_ID],
        [BONUS_LIST_ID],
        [PRICE_LIST_ID],
        [SALES_BY_MULTIPLE_LIST_ID],
        [PREVIUS_BALANCE],
        [LAST_PURCHASE],
        [INVOICE_NAME],
        [SPECIAL_PRICE_LIST_ID],
        [CODE_CHANNEL],
        [GROUP_NUM],
        [OUTSTANDING_BALANCE],
        [LAST_PURCHASE_DATE]
    )
    SELECT DISTINCT
           [C].[CODE_CUSTOMER],
           [C].[NAME_CUSTOMER],
           [C].[TAX_ID_NUMBER],
           [C].[ADRESS_CUSTOMER],
           [C].[PHONE_CUSTOMER],
           [C].[CONTACT_CUSTOMER],
           [C].[CREDIT_LIMIT],
           [C].[EXTRA_DAYS],
           [C].[DISCOUNT],
           [C].[GPS],
           [C].[RGA_CODE],
           [C].[DISCOUNT_LIST_ID],
           [C].[BONUS_LIST_ID],
           [C].[PRICE_LIST_ID],
           [C].[SALES_BY_MULTIPLE_LIST_ID],
           [C].[PREVIUS_BALANCE],
           [C].[LAST_PURCHASE],
           [C].[INVOICE_NAME],
           [C].[SPECIAL_PRICE_LIST_ID],
           [C].[CODE_CHANNEL],
           [C].[GROUP_NUM],
           [C].[OUTSTANDING_BALANCE],
           [C].[LAST_PURCHASE_DATE]
    FROM [#CUSTOMER] [C]
        LEFT JOIN [#DISCOUNT_LIST] [DL]
            ON (ISNULL([DL].[DISCOUNT_LIST_ID], 0) = [C].[DISCOUNT_LIST_ID])
        LEFT JOIN [#BONUS_LIST] [BL]
            ON (ISNULL([BL].[BONUS_LIST_ID], 0) = [C].[BONUS_LIST_ID])
        LEFT JOIN [#SKU_SALES_BY_MULTIPLE_LIST] [SM]
            ON (ISNULL([SM].[SALES_BY_MULTIPLE_LIST_ID], 0) = [C].[SALES_BY_MULTIPLE_LIST_ID])
        LEFT JOIN [#SPECIAL_PRICE_LIST] AS [SPL]
            ON (ISNULL([SPL].[SPECIAL_PRICE_LIST_ID], 0) = [C].[SPECIAL_PRICE_LIST_ID]);

    -- ------------------------------------------------------------------------------------
    -- Muestra el resultado final
    -- ------------------------------------------------------------------------------------
    SELECT DISTINCT
           [R].[CODE_CUSTOMER],
           [R].[NAME_CUSTOMER],
           [R].[TAX_ID_NUMBER],
           [R].[ADRESS_CUSTOMER],
           [R].[PHONE_CUSTOMER],
           [R].[CONTACT_CUSTOMER],
           [R].[CREDIT_LIMIT],
           [R].[EXTRA_DAYS],
           [R].[DISCOUNT],
           [R].[GPS],
           [R].[RGA_CODE],
           [R].[DISCOUNT_LIST_ID],
           [R].[BONUS_LIST_ID],
           [R].[PRICE_LIST_ID],
           [R].[SALES_BY_MULTIPLE_LIST_ID],
           [R].[PREVIUS_BALANCE],
           [R].[LAST_PURCHASE],
           [R].[INVOICE_NAME],
           [R].[SPECIAL_PRICE_LIST_ID],
           [R].[CODE_CHANNEL],
           [R].[GROUP_NUM],
           [R].[OUTSTANDING_BALANCE],
           [R].[LAST_PURCHASE_DATE]
    FROM [#RESULT] [R];
END;
