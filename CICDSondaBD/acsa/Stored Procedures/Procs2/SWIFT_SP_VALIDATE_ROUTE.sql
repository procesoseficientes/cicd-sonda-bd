-- =============================================
-- Autor:				JOSE ROBERTO
-- Fecha de Creacion: 	07-12-2015
-- Description:			Valida que cuando el evento sea venta  que el usuario de PREVENTA
--						tenga asociado ORDEN DE VENTA, RESOLUCION y BODEGA.

-- -----------------
-- Modificacion			10-06-2016
--						hector.gonzalez
--						Se agrego validacion de existencia de sequencias de documentos de toma de inventario

-- -----------------
-- Modificacion			10-10-2016
--						diego.as
--						Se agrego validacion de existencia de sequencias de documentos de Cobro de Factura

-- -----------------
--Modificacion 11-04-2016 Sprint 4- TeamA
--            rudi.garcia
--            Se agrego la validacion de ver si vendedor tiene un portafolio asignado y ver si tiene productos.

-- -----------------
-- Modificacion 12-Jan-17 @ A-Team Sprint Adeben
-- alberto.ruiz
-- Se agrego validacion si la ruta tiene la regla para asignar un acuerdo comercial a los clientes nuevos y si esta activa si tiene que tener un acuerdo comercial asignado a la ruta

-- -----------------
-- Modificacion 28-Feb-17 @ A-Team Sprint Donkor
-- alberto.ruiz
-- Se ajusto para que cuando valida la lista de precios por defecto no sea un bit

-- -----------------
-- Modificacion 23-Mar-17 @ A-Team Sprint Fenyang
-- alberto.ruiz
-- Se agrega validacion de parametros de etiqueta

-- -----------------
-- Modificacion 26-Aug-17 @ Reborn-Team Sprint Bearbeitung
-- hector.gonzalez
-- Se agrega validacion de Historico de Promociones

-- -----------------
-- Modificacion 5/13/2018 @ G-Force - Team Sprint Castor
-- diego.as
-- se agrega validacion de secuencia de documentos para cobro de facturas de credito vencidas. 

-- -----------------
-- Modificacion			12/4/2018 @ G-Force Team Sprint 
-- Autor:				diego.as
-- Historia/Bug:		Product Backlog Item 23773: Micro Encuestas en Preventa
-- Descripcion:			12/4/2018 - Se agrega validacion de secuencia de documentos para proceso de microencuestas si la ruta tiene asigana por lo menos una microencuesta

-- -----------------
-- MODIFICACIÓN:		06/11/2019 @ G-FORCE TEAM-A SPRINT 
-- AUTOR:				DENIS VILLAGRÁN
-- HISTORIA/BUG:		PRODUCT BACKLOG ITEM 33222: PARAMETRIZACIÓN PARA UTILIZACIÓN FEL Y VISUALIZACIÓN DE SECUENCIA DE DOCUMENTOS DE CONTINGENCIA
-- DESCRIPCIÓN:			06/11/2019 - SE AGREGA VALIDACIÓN

-- -----------------
-- Modificación:		15/11/2019 @ G-Gorce Team-A sprint 
-- Autor:				Denis Villagrán
-- Historia/bug:		Product Backlog Item 33222: Parametrización para utilización fel y visualización de secuencia de documentos de contingencia
-- Descripción:			15/11/2019 - Se cambia nombre de los documentos de contingencia en una validación ya que se modificó en la aplicación.
--                                   Está en el select con el siguiente encabezado -- Valida la secuencia de documentos disponible para FEL

-- -----------------
-- Modificacion 		12/2/2019 @ G-Force Team Sprint OSLO
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 33218: Configuración de Frases y Escenarios
-- Descripcion: 		12/2/2019 - Se agrega validacion para Frases y Escenarios FEL en rutas de venta directa, SI Y SOLO SI la ruta utiliza FEL

/*
-- Ejemplo de Ejecucion:				
				--
				exec [acsa].[SWIFT_SP_VALIDATE_ROUTE] @CODE_ROUTE = 'R011'
				exec [acsa].[SWIFT_SP_VALIDATE_ROUTE] @CODE_ROUTE = 'JOSE@acsa'
				exec [acsa].[SWIFT_SP_VALIDATE_ROUTE] @CODE_ROUTE = 'JOEL@acsa'
				exec [acsa].[SWIFT_SP_VALIDATE_ROUTE] @CODE_ROUTE = 'ALBERTO@acsa'
				exec [acsa].[SWIFT_SP_VALIDATE_ROUTE] @CODE_ROUTE = 'RUDI@acsa'				
				exec [acsa].[SWIFT_SP_VALIDATE_ROUTE] @CODE_ROUTE = '001'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_VALIDATE_ROUTE] @CODE_ROUTE VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE @USER VARCHAR(50),
            @PResult VARCHAR(250) = '',
            @RESULT VARCHAR(2000) = '',
            @PDOC BIT = 0,
            @PWH BIT = 0,
            @SALE_QTY INT = 0,
            @PRESALE_QTY INT = 0,
            @EXIST_PRICE_LIST_DEFAULT VARCHAR(50) = NULL,
            @TAKE_INVENTORY_QTY INT = 0,
            @HAVE_INVENTORY_DOCS BIT = 0,
            @PAYMENT_RULE_ACTIVE INT = 0,
            @SELLER_CODE VARCHAR(50),
            @CODE_PORTFOLIO VARCHAR(25) = NULL,
            @QTY_SKU_PORTFOLIO INT = 0,
            @HAS_TRADE_AGREEMENT INT = 0,
            @EXISTS_LABEL_GROUP INT = 0,
            @HAVE_DOCUMENT_SEQUENCE_OF_HISTORY_PROMO INT = 0,
            @QTY_SURVEY INT = 0,
            @OPERATOR_TYPE VARCHAR(50) = '',
            @ROUTE_WILL_USE_FEL VARCHAR(10) = '',
            @CURRENT_ONLINE_INVOICE_SEQUENCE INT = 0,
            @LAST_ALLOWED_ONLINE_INVOICE_SEQUENCE INT = 0;

    -- -----------------------------------------------
    -- Obtiene tareas y cantidad por tipo
    -- -----------------------------------------------
    SELECT [T].[TASK_TYPE],
           COUNT([T].[TASK_TYPE]) AS [QTY]
    INTO [#TASK]
    FROM [acsa].[SWIFT_TASKS] [T]
        INNER JOIN [acsa].[USERS] [U]
            ON ([T].[ASSIGEND_TO] = [U].[LOGIN])
    WHERE [U].[SELLER_ROUTE] = @CODE_ROUTE
          AND [T].[TASK_DATE] = CONVERT(DATE, GETDATE())
    GROUP BY [T].[TASK_TYPE];
    --
    SELECT @SALE_QTY = [QTY]
    FROM [#TASK] [T]
    WHERE [T].[TASK_TYPE] = 'SALE';
    --
    SELECT @PRESALE_QTY = [QTY]
    FROM [#TASK] [T]
    WHERE [T].[TASK_TYPE] = 'PRESALE';
    --
    SELECT @TAKE_INVENTORY_QTY = [QTY]
    FROM [#TASK] [T]
    WHERE [T].[TASK_TYPE] = 'TAKE_INVENTORY';

    SELECT @QTY_SURVEY = COUNT(*)
    FROM [acsa].[SWIFT_ASIGNED_QUIZ]
    WHERE [ROUTE_CODE] = @CODE_ROUTE;

	print '1'

    -- -----------------------------------------------
    -- Se obtiene el codigo de vendedor de la bodega
    -- -----------------------------------------------
    SELECT TOP (1)
           @SELLER_CODE = [U].[RELATED_SELLER]
    FROM [acsa].[USERS] [U]
    WHERE [U].[SELLER_ROUTE] = @CODE_ROUTE;

    -- -----------------------------------------------
    -- Obtenemos si vendedor tiene asociado un potafolios
    -- -----------------------------------------------
    SELECT TOP (1)
           @CODE_PORTFOLIO = [PS].[CODE_PORTFOLIO]
    FROM [acsa].[SWIFT_PORTFOLIO_BY_SELLER] [PS]
    WHERE [PS].[CODE_SELLER] = @SELLER_CODE;

    -- -----------------------------------------------
    -- Validamos si el vendedor tiene un portafolios asociado
    -- -----------------------------------------------
    IF (@CODE_PORTFOLIO IS NOT NULL)
    BEGIN
        SELECT @QTY_SKU_PORTFOLIO = COUNT([PS].[CODE_SKU])
        FROM [acsa].[SWIFT_PORTFOLIO_BY_SKU] [PS]
        WHERE [PS].[CODE_PORTFOLIO] = @CODE_PORTFOLIO;
        --
        IF (@QTY_SKU_PORTFOLIO = 0)
        BEGIN
            SET @RESULT = 'El portafolio de productos asociado al vendedor no tiene productos.';
        END;
    END;


	print '2'
    -- -----------------------------------------------
    -- Se obtiene el usuario de la ruta y el tipo de usuario
    -- -----------------------------------------------
    SELECT @USER = [LOGIN],
           @OPERATOR_TYPE = [USER_TYPE]
    FROM [acsa].[USERS]
    WHERE [SELLER_ROUTE] = @CODE_ROUTE;

    -- -----------------------------------------------
    -- Obtiene regla que indica si utilizará FEL
    -- -----------------------------------------------
    SELECT @ROUTE_WILL_USE_FEL = [E].[ENABLED]
    FROM [acsa].[SWIFT_EVENT] [E]
        INNER JOIN [acsa].[SWIFT_RULE_X_EVENT] [RE]
            ON ([RE].[EVENT_ID] = [E].[EVENT_ID])
        INNER JOIN [acsa].[SWIFT_RULE] [R]
            ON ([R].[RULE_ID] = [RE].[RULE_ID])
        INNER JOIN [acsa].[SWIFT_RULE_X_ROUTE] [RR]
            ON ([R].[RULE_ID] = [RR].[RULE_ID])
    WHERE [RR].[CODE_ROUTE] = @CODE_ROUTE
          AND [E].[TYPE] = 'RutaUsaFacturacionEnLinea'
    ORDER BY [R].[CODE],
             [RE].[EVENT_ORDER];

    -- -----------------------------------------------
    -- Valida la secuencia de documentos disponible para FEL
    -- -----------------------------------------------
    SELECT @LAST_ALLOWED_ONLINE_INVOICE_SEQUENCE = [DOC_TO],
           @CURRENT_ONLINE_INVOICE_SEQUENCE = [CURRENT_DOC]
    FROM [acsa].[SWIFT_DOCUMENT_SEQUENCE]
    WHERE [ASSIGNED_TO] = @CODE_ROUTE
          AND [DOC_TYPE] = 'CONTINGENCY_DOCUMENT';

	print '3'
    -- -----------------------------------------------
    -- Valida si tiene tareas de venta
    -- -----------------------------------------------
    IF (@SALE_QTY > 0)
    BEGIN
        SELECT @PDOC = [acsa].[SWIFT_FUNC_VALIDATE_DOCUMENT_SALE](@CODE_ROUTE);
        --
        IF (@PDOC = 0)
        BEGIN
            SET @RESULT = 'Ruta No Tiene Resolución de Factura por Tareas de Venta Directa';
        END;

        SELECT @PWH = [acsa].[SWIFT_FUNC_VALIDATE_ROUTE_WH_SALE](@CODE_ROUTE);
        --
        IF (@PWH = 0)
        BEGIN
            IF (@RESULT != '')
            BEGIN
                SET @RESULT = @RESULT + ', Ruta No Tiene Bodega Asignada de Venta Directa';
            END;
            ELSE
            BEGIN
                SET @RESULT = ' Ruta No Tiene Bodega Asignada de Venta Directa';
            END;
        END;
    END;

	print '4'

    -- -----------------------------------------------
    -- Valida si tiene tareas de preventa
    -- -----------------------------------------------
    IF (@PRESALE_QTY > 0)
    BEGIN
        SELECT @PDOC = [acsa].[SWIFT_FUNC_VALIDATE_DOCUMENT_PRESALE](@CODE_ROUTE);
        --
        IF (@PDOC = 0)
        BEGIN
            IF (@RESULT != '')
            BEGIN
                SET @RESULT = @RESULT + ', Ruta No Tiene Documentos de Ordenes de Venta';
            END;
            ELSE
            BEGIN
                SET @RESULT = 'Ruta No Tiene Documentos de Ordenes de Venta';
            END;
        END;
        SELECT @PWH = [acsa].[SWIFT_FUNC_VALIDATE_ROUTE_WH_PRESALE](@CODE_ROUTE);
        --
        IF (@PWH = 0)
        BEGIN
            IF (@RESULT != '')
            BEGIN
                SET @RESULT = @RESULT + ', Ruta No Tiene Bodega Asignada de Preventa';
            END;
            ELSE
            BEGIN
                SET @RESULT = 'Ruta No Tiene Bodega Asignada de Preventa';
            END;
        END;
    END;

	print '5'

    -- -----------------------------------------------
    -- Valida si tiene tareas de Toma de Inventario
    -- -----------------------------------------------
    IF (@TAKE_INVENTORY_QTY > 0)
    BEGIN
        SELECT @HAVE_INVENTORY_DOCS = [acsa].[SWIFT_FUNC_VALIDATE_DOCUMENT_TAKE_INVENTORY](@CODE_ROUTE);
        --
        IF (@HAVE_INVENTORY_DOCS = 0)
        BEGIN
            IF (@RESULT != '')
            BEGIN
                SET @RESULT = @RESULT + ', Ruta No Tiene Documentos de Toma de Inventario';
            END;
            ELSE
            BEGIN
                SET @RESULT = 'Ruta No Tiene Documentos de Toma de Inventario';
            END;
        END;
    END;

	print '6'
    -- -----------------------------------------------
    -- Obtiene Eventos por tipo
    -- -----------------------------------------------
    SELECT [E].[TYPE_ACTION],
           COUNT([E].[TYPE_ACTION]) AS [QTY]
    INTO [#EVENT]
    FROM [acsa].[SWIFT_EVENT] [E]
        INNER JOIN [acsa].[SWIFT_RULE_X_EVENT] [RE]
            ON ([E].[EVENT_ID] = [RE].[EVENT_ID])
        INNER JOIN [acsa].[SWIFT_RULE_X_ROUTE] [RR]
            ON ([RE].[RULE_ID] = [RR].[RULE_ID])
    WHERE [RR].[CODE_ROUTE] = @CODE_ROUTE
          AND [E].[TYPE] = 'agregarCliente'
          AND [E].[ENABLED] = 'Si'
    GROUP BY [E].[TYPE_ACTION];
    --
    SELECT @SALE_QTY = [QTY]
    FROM [#EVENT] [T]
    WHERE [T].[TYPE_ACTION] = 'VentaDirecta';
    --
    SELECT @PRESALE_QTY = [QTY]
    FROM [#EVENT] [T]
    WHERE [T].[TYPE_ACTION] = 'Preventa';


	print '7'

    -- -----------------------------------------------
    -- Valida si Tiene  Eventos de Venta
    -- -----------------------------------------------
    IF (@SALE_QTY > 0) --OR CONTAINS(@RESULT,'Ruta No Tiene Resolución de Factura')= 1)

    BEGIN
        SELECT @PDOC = [acsa].[SWIFT_FUNC_VALIDATE_DOCUMENT_SALE](@CODE_ROUTE);
        --
        IF (@PDOC = 0)
        BEGIN
            IF (@RESULT != '')
            BEGIN
                SET @RESULT = @RESULT + ', Ruta No Tiene Resolución de Factura por Tareas de Venta Directa';
            END;
            ELSE
            BEGIN
                SET @RESULT = 'Ruta No Tiene Resolución de Factura por Tareas de Venta Directa';
            END;
        END;
    END;
    SELECT @PWH = [acsa].[SWIFT_FUNC_VALIDATE_ROUTE_WH_SALE](@CODE_ROUTE);
    --
    IF (@PWH = 0)
    BEGIN
        IF (@RESULT != '')
        BEGIN
            SET @RESULT = @RESULT + ', Ruta No Tiene Bodega Asignada de Venta Directa';
        END;
        ELSE
        BEGIN
            SET @RESULT = 'Ruta No Tiene Bodega Asignada de Venta Directa';
        END;
    END;


	print '8'
    -- -----------------------------------------------
    -- Valida si tiene eventos de preventa
    -- -----------------------------------------------
    IF (@PRESALE_QTY > 0)
    BEGIN
        SELECT @PDOC = [acsa].[SWIFT_FUNC_VALIDATE_DOCUMENT_PRESALE](@CODE_ROUTE);
        --
        IF (@PDOC = 0)
        BEGIN
            IF (@RESULT != '')
            BEGIN
                SET @RESULT = @RESULT + ', Ruta No Tiene Documentos de Ordenes de Venta';
            END;
            ELSE
            BEGIN
                SET @RESULT = 'Ruta No Tiene Documentos de Ordenes de Venta';
            END;
        END;
        SELECT @PWH = [acsa].[SWIFT_FUNC_VALIDATE_ROUTE_WH_PRESALE](@CODE_ROUTE);
        --
        IF (@PWH = 0)
        BEGIN
            IF (@RESULT != '')
            BEGIN
                SET @RESULT = @RESULT + ', Ruta No Tiene Bodega Asignada de Preventa';
            END;
            ELSE
            BEGIN
                SET @RESULT = 'Ruta No Tiene Bodega Asignada de Preventa';
            END;
        END;
    END;


	print '9'

    -- -----------------------------------------------
    -- Valida si tiene Lista de Precios por Default
    -- -----------------------------------------------
    SELECT @EXIST_PRICE_LIST_DEFAULT = [acsa].[SWIFT_FN_GET_PRICE_LIST](NULL);

    IF (@EXIST_PRICE_LIST_DEFAULT IS NULL)
    BEGIN
        IF (@RESULT = '')
        BEGIN
            SET @RESULT = 'Ruta No Tiene Lista De Precios Default Asignada';
        END;
        ELSE
        BEGIN
            SET @RESULT = @RESULT + 'Ruta No Tiene Lista De Precios Default Asignada';
        END;
    END;


	print '10'
    -- ----------------------------------------------------------------------------------------
    -- Valida si tiene activa la regla de cobro de factura Y SI TIENE DOCUMENTOS PARA LA MISMA
    -- ----------------------------------------------------------------------------------------
    SELECT TOP (1)
           @PAYMENT_RULE_ACTIVE = 1
    FROM [acsa].[SWIFT_EVENT] AS [E]
        INNER JOIN [acsa].[SWIFT_RULE_X_EVENT] AS [RE]
            ON ([RE].[EVENT_ID] = [E].[EVENT_ID])
        INNER JOIN [acsa].[SWIFT_RULE] AS [R]
            ON ([R].[RULE_ID] = [RE].[RULE_ID])
        INNER JOIN [acsa].[SWIFT_RULE_X_ROUTE] AS [RR]
            ON ([RR].[RULE_ID] = [R].[RULE_ID])
    WHERE [RR].[CODE_ROUTE] = @CODE_ROUTE
          AND [E].[TYPE] = 'CobrarOrdenDeVenta'
          AND
          (
              [E].[ENABLED] = 'SI'
              OR [E].[ENABLED] = 'Si'
          );
    --
    IF (@PAYMENT_RULE_ACTIVE = 1)
    BEGIN
        DECLARE @HAVE_SEQUENCE INT = 0;
        --
        SELECT @HAVE_SEQUENCE = 1
        FROM [acsa].[SWIFT_DOCUMENT_SEQUENCE] AS [DS]
        WHERE [DS].[ASSIGNED_TO] = @CODE_ROUTE
              AND [DOC_TYPE] = 'PAYMENT'
              AND ([DS].[CURRENT_DOC] + 1) >= [DS].[DOC_FROM]
              AND ([DS].[CURRENT_DOC] + 1) <= [DS].[DOC_TO];
        --
        IF (@HAVE_SEQUENCE = 0)
        BEGIN
            IF (@RESULT = '')
            BEGIN
                SET @RESULT = 'Ruta No Tiene Documentos para Cobro de Factura';
            END;
            ELSE
            BEGIN
                SET @RESULT = @RESULT + 'Ruta No Tiene Documentos para Cobro de Factura';
            END;
        END;
    END;

	print '11'

    -- ------------------------------------------------------------------------------------
    -- Valida si debe de tener asignado un acuerdo comercial
    -- ------------------------------------------------------------------------------------
    SELECT @HAS_TRADE_AGREEMENT = [acsa].[SWIFT_FN_VALIDATE_TRADE_AGREEMENT_BY_ROUTE](@CODE_ROUTE);
    --
    IF (@HAS_TRADE_AGREEMENT = 0)
    BEGIN
        IF (@RESULT = '')
        BEGIN
            SET @RESULT = 'Ruta No Tiene Acuerdo Comercial Para Clientes Nuevos';
        END;
        ELSE
        BEGIN
            SET @RESULT = @RESULT + 'Ruta No Tiene Acuerdo Comercial Para Clientes Nuevos';
        END;
    END;



	print '12'
    -- ------------------------------------------------------------------------------------
    -- Valida si existen los parametros de etiqutas
    -- ------------------------------------------------------------------------------------
    SELECT @EXISTS_LABEL_GROUP = [acsa].[SWIFT_FN_VALIDATE_EXISTX_GROUP_IN_PARAMETER]('LABEL');
    --
    IF (@EXISTS_LABEL_GROUP = 0)
    BEGIN
        IF (@RESULT = '')
        BEGIN
            SET @RESULT = 'No estan configurados los parametros de etiquetas';
        END;
        ELSE
        BEGIN
            SET @RESULT = @RESULT + 'No estan configurados los parametros de etiquetas';
        END;
    END;


	print '13'
    -- ------------------------------------------------------------------------------------
    -- Valida si la ruta tiene secuencia de documentos de HISTORY_PROMO
    -- ------------------------------------------------------------------------------------
    SELECT @HAVE_DOCUMENT_SEQUENCE_OF_HISTORY_PROMO
        = [acsa].[SWIFT_FN_VALIDATE_IF_ROUTE_HAVE_DOCUMENT_SEQUENCE_OF_HISTORY_PROMO](@CODE_ROUTE);
    --
    IF (@HAVE_DOCUMENT_SEQUENCE_OF_HISTORY_PROMO = 0)
    BEGIN
        IF (@RESULT = '')
        BEGIN
            SET @RESULT = 'Ruta no tiene Secuencia de Documentos de Historial de Promociones';
        END;
        ELSE
        BEGIN
            SET @RESULT = @RESULT + 'Ruta no tiene Secuencia de Documentos de Historial de Promociones';
        END;
    END;


	print '14'
    -- ----------------------------------------------------------------------------------------------------------------
    -- Valida si la ruta tiene la regla de FacturarAunConFacturasVencidas para que exista una secuencia de documentos
    -- ----------------------------------------------------------------------------------------------------------------
    DECLARE @RULE_EXISTS INT = 0,
            @RULE_ENABLED INT = 0,
            @SEQUENCE_EXISTS INT = 0;

    SELECT @RULE_EXISTS = 1,
           @RULE_ENABLED = 1
    FROM [acsa].[SWIFT_EVENT] AS [E]
        INNER JOIN [acsa].[SWIFT_RULE_X_EVENT] AS [RE]
            ON ([RE].[EVENT_ID] = [E].[EVENT_ID])
        INNER JOIN [acsa].[SWIFT_RULE_X_ROUTE] AS [RR]
            ON ([RR].[RULE_ID] = [RE].[RULE_ID])
    WHERE [RR].[CODE_ROUTE] = @CODE_ROUTE
          AND [E].[TYPE] = 'FacturarAunConFacturasVencidas'
          AND [E].[ENABLED] = 'SI';

    IF (@RULE_EXISTS = 1 AND @RULE_ENABLED = 1)
    BEGIN
        SELECT @SEQUENCE_EXISTS = 1
        FROM [acsa].[SWIFT_DOCUMENT_SEQUENCE]
        WHERE [DOC_TYPE] = 'CREDIT_INVOICE_PAYMENT'
              AND [ASSIGNED_TO] = @CODE_ROUTE;

        IF (@SEQUENCE_EXISTS = 0)
        BEGIN
            IF (@RESULT = '')
            BEGIN
                SET @RESULT = 'Ruta no tiene Secuencia de Documentos de Pagos de Facturas Vencidas';
            END;
            ELSE
            BEGIN
                SET @RESULT = @RESULT + 'Ruta no tiene Secuencia de Documentos de Pagos de Facturas Vencidas';
            END;
        END;
    END;


	print '15'
    -- -------------------------------------------------------------------------------------------------
    -- Valida si tiene micro encuestas asignadas y si las hay, valida que tenga secuencia de documentos
    -- -------------------------------------------------------------------------------------------------

    IF (@QTY_SURVEY > 0)
    BEGIN
        DECLARE @MICROSURVEY_SEQUECE_EXISTS INT = 0;

        SELECT @MICROSURVEY_SEQUECE_EXISTS = COUNT(*)
        FROM [acsa].[SWIFT_DOCUMENT_SEQUENCE] AS [DS]
        WHERE [DS].[ASSIGNED_TO] = @CODE_ROUTE;

        IF (@MICROSURVEY_SEQUECE_EXISTS = 0)
        BEGIN
            IF (@RESULT = '')
            BEGIN
                SET @RESULT = 'Ruta no tiene Secuencia de Documentos para Microencuestas';
            END;
            ELSE
            BEGIN
                SET @RESULT = @RESULT + ' Ruta no tiene Secuencia de Documentos para Microencuestas';
            END;
        END;

    END;



	print '16'
    -- -----------------------------------------------------------------------------------------------
    -- Valida si el tipo del usuario es de venta, que use FEL y que exista secuencia de documentos con  
    -- disponibilidad                                                                                   
    -- -----------------------------------------------------------------------------------------------
    IF (@OPERATOR_TYPE = 'VEN')
    BEGIN
        IF (@ROUTE_WILL_USE_FEL = 'SI')
        BEGIN
            IF (@CURRENT_ONLINE_INVOICE_SEQUENCE = @LAST_ALLOWED_ONLINE_INVOICE_SEQUENCE)
            BEGIN
                IF (@RESULT = '')
                BEGIN
                    SET @RESULT
                        = 'Ruta no tiene Secuencia de Documentos de Contingencia para Facturación Electrónica en Línea.';
                END;
                ELSE
                BEGIN
                    SET @RESULT
                        = @RESULT
                          + ' Ruta no tiene Secuencia de Documentos de Contingencia para Facturación Electrónica en Línea.';
                END;
            END;

            -- ---------------------------------------------------------------
            -- Se verifica que tenga Frases y Escenarios Configurados
            -- ---------------------------------------------------------------
            DECLARE @SONDA_PHRASES_AND_SCENARIOS_FEL TABLE
            (
                [ID] [INT],
                [FEL_DOCUMENT_TYPE] [VARCHAR](250),
                [PHRASE_CODE] [INT],
                [SCENARIO_CODE] [INT],
                [DESCRIPTION] [VARCHAR](250),
                [TEXT_TO_SHOW] [VARCHAR](250)
            );

            -- ---------------------------------------------------------------
            -- Se obtienen las frases y escenarios de la ruta
            -- ---------------------------------------------------------------
            INSERT INTO @SONDA_PHRASES_AND_SCENARIOS_FEL
            EXEC [acsa].[SONDA_SP_GET_PHRASES_AND_SCENARIOS_FEL_BY_ROUTE] @CODE_ROUTE = @CODE_ROUTE; -- varchar(50)

            IF NOT EXISTS (SELECT 1 FROM @SONDA_PHRASES_AND_SCENARIOS_FEL)
            BEGIN
                IF (@RESULT = '')
                BEGIN
                    SET @RESULT
                        = 'La ruta no cuenta con configuracion de Frases y Escenarios FEL, comuniquese con su Administrador.';
                END;
                ELSE
                BEGIN
                    SET @RESULT
                        = @RESULT
                          + ' La ruta no cuenta con configuracion de Frases y Escenarios FEL, comuniquese con su Administrador.';
                END;
            END;
        END;
    END;


	print '17'
    -- ------------------------------------------------------------------------------------
    -- Valida si hay algun resultado sino se manda Exito
    -- ------------------------------------------------------------------------------------
    IF (@RESULT = '')
    BEGIN
        SET @RESULT = 'Exito'; --'Validación Exitosa'
    END;
    --
    SELECT @RESULT AS [RESULT];
END;
