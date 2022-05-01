-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	27-Jan-17 @ A-TEAM Sprint Bankole 
-- Description:			SP que crea tarea de venta

-- Modificacion 5/3/2018 @ G-Force - Team Sprint Castor
-- diego.as
-- Se agrega obtencion de facturas vencidas y condiciones de pago del cliente


-- Modificacion 		26-9-2019 @ G-Force Team Sprint Kansas
-- Autor: 				fernando.monroy
-- Historia/Bug:		Product Backlog Item 32317: Visualizacion de la Estadistica de Venta del cliente
-- Descripcion: 		Se agrega obtencion de estadistica de cliente

-- Modificacion 		26-9-2019 @ G-Force Team Sprint Londres
-- Autor: 				denis.villagran
-- Historia/Bug:		Product Backlog Item 32780: Creación de Tareas por cada Gestion
-- Descripcion: 		Se agrega subquery para obtener la secuencia de la tarea.
/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SONDA_SP_CREATE_TASK_OUTSIDE_OF_ROUTE_PLAN]
					@CODE_ROUTE = '4'
					,@CODE_CUSTOMER = '1915'
					,@TASK_TYPE = 'SALES'
				--
				SELECT * FROM [acsa].[SWIFT_TASKS] ORDER BY 1 DESC
				--
				SELECT TOP 5 * FROM [acsa].[SONDA_ROUTE_PLAN] ORDER BY 1 DESC
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_CREATE_TASK_OUTSIDE_OF_ROUTE_PLAN]
(
    @CODE_ROUTE VARCHAR(50),
    @CODE_CUSTOMER VARCHAR(50),
    @TASK_TYPE VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE @TASK_ID INT,
            @CODE_FREQUENCY VARCHAR(50) = '';

	SELECT 
	@TASK_ID = ISNULL(TASK_ID,0)
	FROM [acsa].[SONDA_ROUTE_PLAN]
	WHERE [RELATED_CLIENT_CODE] = @CODE_CUSTOMER COLLATE DATABASE_DEFAULT
		AND [CODE_ROUTE] = @CODE_ROUTE
		AND [TASK_TYPE] = @TASK_TYPE

	IF (@TASK_ID = 0) 

    -- ------------------------------------------------------------------------------------
    -- Obtiene un codigo de frecuencia de la ruta ya que es necesario para la tabla SONDA_ROUTE_PLAN
    -- ------------------------------------------------------------------------------------
    SELECT TOP 1
           @CODE_FREQUENCY = [F].[CODE_FREQUENCY]
    FROM [acsa].[SWIFT_FREQUENCY] AS [F]
    WHERE [F].[CODE_ROUTE] = @CODE_ROUTE COLLATE DATABASE_DEFAULT;

    -- -----------------------------------------------------------------
    -- Inserta en la tabla SWIFT_TASKS
    -- -----------------------------------------------------------------
    INSERT INTO [acsa].[SWIFT_TASKS]
    (
        [TASK_TYPE],
        [TASK_DATE],
        [SCHEDULE_FOR],
        [CREATED_STAMP],
        [ASSIGEND_TO],
        [ASSIGNED_BY],
        [ASSIGNED_STAMP],
        [CANCELED_STAMP],
        [CANCELED_BY],
        [ACCEPTED_STAMP],
        [COMPLETED_STAMP],
        [RELATED_PROVIDER_CODE],
        [RELATED_PROVIDER_NAME],
        [EXPECTED_GPS],
        [POSTED_GPS],
        [TASK_STATUS],
        [TASK_COMMENTS],
        [TASK_SEQ],
        [REFERENCE],
        [SAP_REFERENCE],
        [COSTUMER_CODE],
        [COSTUMER_NAME],
        [RECEPTION_NUMBER],
        [PICKING_NUMBER],
        [COUNT_ID],
        [ACTION],
        [SCANNING_STATUS],
        [ALLOW_STORAGE_ON_DIFF],
        [CUSTOMER_PHONE],
        [TASK_ADDRESS],
        [VISIT_HOUR],
        [ROUTE_IS_COMPLETED],
        [EMAIL_TO_CONFIRM],
        [IN_PLAN_ROUTE],
        [CREATE_BY],
        [CODE_ROUTE]
    )
    SELECT @TASK_TYPE,
           GETDATE(),
           GETDATE(),
           GETDATE(),
           [U].[LOGIN],
           'Proceso diario',
           GETDATE(),
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           [C].[GPS],
           NULL,
           'ASSIGNED',
           'Tarea generada para cliente ' + ISNULL([C].[NAME_CUSTOMER], '...'),
           (
               SELECT COUNT([RP].[TASK_SEQ]) + 1
               FROM [acsa].[SONDA_ROUTE_PLAN] [RP]
               WHERE [RP].[CODE_ROUTE] = @CODE_ROUTE
                     AND [RP].[TASK_TYPE] = @TASK_TYPE
                     AND [RP].[SCHEDULE_FOR] = GETDATE()
           ),
           NULL,
           NULL,
           [C].[CODE_CUSTOMER],
           ISNULL([C].[NAME_CUSTOMER], '...'),
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           1,
           [C].[PHONE_CUSTOMER],
           ISNULL([C].[ADRESS_CUSTOMER], ''),
           NULL,
           NULL,
           NULL,
           0,
           'BY_USER',
           @CODE_ROUTE
    FROM [acsa].[USERS] AS [U]
        INNER JOIN [acsa].[SWIFT_VIEW_ALL_COSTUMER] AS [C]
            ON ([C].[SELLER_DEFAULT_CODE] COLLATE DATABASE_DEFAULT = [U].[RELATED_SELLER] COLLATE DATABASE_DEFAULT)
    WHERE [U].[SELLER_ROUTE] = @CODE_ROUTE
          AND [C].[CODE_CUSTOMER] = @CODE_CUSTOMER;
    --
    SET @TASK_ID = SCOPE_IDENTITY();

    -- -----------------------------------------------------------------
    -- Inserta en la tabla SONDA_ROUTE_PLAN
    -- -----------------------------------------------------------------
    INSERT INTO [acsa].[SONDA_ROUTE_PLAN]
    (
        [TASK_ID],
        [CODE_FREQUENCY],
        [SCHEDULE_FOR],
        [ASSIGNED_BY],
        [DOC_PARENT],
        [EXPECTED_GPS],
        [TASK_COMMENTS],
        [TASK_SEQ],
        [TASK_ADDRESS],
        [RELATED_CLIENT_PHONE_1],
        [EMAIL_TO_CONFIRM],
        [RELATED_CLIENT_CODE],
        [RELATED_CLIENT_NAME],
        [TASK_PRIORITY],
        [TASK_STATUS],
        [SYNCED],
        [NO_PICKEDUP],
        [NO_VISIT_REASON],
        [IS_OFFLINE],
        [DOC_NUM],
        [TASK_TYPE],
        [TASK_DATE],
        [CREATED_STAMP],
        [ASSIGEND_TO],
        [CODE_ROUTE],
        [IN_PLAN_ROUTE],
        [CREATE_BY]
    )
    SELECT [T].[TASK_ID],
           @CODE_FREQUENCY,
           [T].[TASK_DATE],
           [T].[ASSIGNED_BY],
           0,
           [T].[EXPECTED_GPS],
           ISNULL([T].[TASK_COMMENTS], '...'),
           [T].[TASK_SEQ],
           [T].[TASK_ADDRESS],
           [T].[CUSTOMER_PHONE],
           '',
           [T].[COSTUMER_CODE],
           ISNULL([T].[COSTUMER_NAME], '...'),
           1,
           [T].[TASK_STATUS],
           1,
           NULL,
           NULL,
           1,
           NULL,
           [T].[TASK_TYPE],
           [T].[TASK_DATE],
           [CREATED_STAMP],
           [T].[ASSIGEND_TO],
           @CODE_ROUTE,
           1,
           'BY_USER'
    FROM [acsa].[SWIFT_TASKS] AS [T]
    WHERE [T].[TASK_ID] = @TASK_ID;

    -- ------------------------------------------------------------------------------------
    -- Muestra la tarea nueva
    -- ------------------------------------------------------------------------------------
    SELECT [TASK_ID],
           [CODE_FREQUENCY],
           [SCHEDULE_FOR],
           [ASSIGNED_BY],
           [DOC_PARENT],
           [EXPECTED_GPS],
           [TASK_COMMENTS],
           [TASK_SEQ],
           [TASK_ADDRESS],
           [RELATED_CLIENT_PHONE_1],
           [EMAIL_TO_CONFIRM],
           [RELATED_CLIENT_CODE],
           [RELATED_CLIENT_NAME],
           [TASK_PRIORITY],
           [TASK_STATUS],
           [SYNCED],
           [NO_PICKEDUP],
           [NO_VISIT_REASON],
           [IS_OFFLINE],
           [DOC_NUM],
           [TASK_TYPE],
           [TASK_DATE],
           [CREATED_STAMP],
           [ASSIGEND_TO],
           [C].[CODE_ROUTE],
           [TARGET_DOC],
           [IN_PLAN_ROUTE],
           [CREATE_BY],
           [C].[TAX_ID_NUMBER] [NIT],
           (
               SELECT TOP 1
                      [CODE_PRICE_LIST]
               FROM [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE]
               WHERE [CODE_CUSTOMER] = @CODE_CUSTOMER
                     AND [CODE_ROUTE] = @CODE_ROUTE
           ) AS [CODE_PRICE_LIST]
    FROM [acsa].[SONDA_ROUTE_PLAN] AS [RP]
        INNER JOIN [acsa].[SWIFT_VIEW_ALL_COSTUMER] AS [C]
            ON [C].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT = [RP].[RELATED_CLIENT_CODE] COLLATE DATABASE_DEFAULT
    WHERE [TASK_ID] = @TASK_ID;

    -- ------------------------------------------------------------------------------------
    -- Muestra la lista de precios para el cliente de la nueva tarea
    -- ------------------------------------------------------------------------------------
    SELECT [PLS].[CODE_PRICE_LIST],
           [PLS].[CODE_SKU],
           [PLS].[CODE_PACK_UNIT],
           [PLS].[PRIORITY],
           [PLS].[LOW_LIMIT],
           [PLS].[HIGH_LIMIT],
           [PLS].[PRICE]
    FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE_FOR_ROUTE] AS [PLS]
    WHERE [PLS].[CODE_ROUTE] = @CODE_ROUTE
          AND [PLS].[CODE_PRICE_LIST] =
          (
              SELECT TOP 1
                     [CODE_PRICE_LIST]
              FROM [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER_FOR_ROUTE]
              WHERE [CODE_CUSTOMER] = @CODE_CUSTOMER
                    AND [CODE_ROUTE] = @CODE_ROUTE
          )
          AND [PLS].[CODE_SKU] IN
              (
                  SELECT [SKU]
                  FROM [acsa].[SONDA_POS_SKUS]
                  WHERE [ROUTE_ID] =
                  (
                      SELECT TOP 1
                             [U].[DEFAULT_WAREHOUSE]
                      FROM [acsa].[USERS] AS [U]
                      WHERE [U].[SELLER_ROUTE] = @CODE_ROUTE
                  )
              );

    -- ------------------------------------------------------------------------------------
    -- Muestra las consignaciones activas para el cliente de la nueva tarea
    -- ------------------------------------------------------------------------------------
    SELECT [CONSIGNMENT_ID],
           [CUSTOMER_ID],
           [DATE_CREATE],
           [DATE_UPDATE],
           [STATUS],
           [POSTED_BY],
           [IS_POSTED],
           [POS_TERMINAL],
           [GPS_URL],
           [DOC_DATE],
           [CLOSED_ROUTE_DATETIME],
           [IS_ACTIVE_ROUTE],
           [DUE_DATE],
           [CONSIGNMENT_ID] [CONSIGNMENT_BO_NUM],
           [TOTAL_AMOUNT],
           [DOC_SERIE],
           [DOC_NUM],
           [IMG],
           [IS_CLOSED],
           NULL [IS_RECONSIGN],
           [REASON],
           NULL [IN_ROUTE]
    FROM [acsa].[SWIFT_CONSIGNMENT_HEADER]
    WHERE [STATUS] = 'ACTIVE'
          AND [CUSTOMER_ID] = @CODE_CUSTOMER;

    -- ------------------------------------------------------------------------------------
    -- Muestra el detalle de las consignaciones activas para el cliente de la nueva tarea
    -- ------------------------------------------------------------------------------------
    SELECT [CD].[CONSIGNMENT_ID],
           [CD].[SKU],
           [CD].[LINE_NUM],
           [CD].[QTY],
           [CD].[PRICE],
           [CD].[DISCOUNT],
           [CD].[TOTAL_LINE],
           [CD].[POSTED_DATETIME],
           [CD].[PAYMENT_ID],
           [CD].[HANDLE_SERIAL],
           [CD].[SERIAL_NUMBER]
    FROM [acsa].[SWIFT_CONSIGNMENT_DETAIL] AS [CD]
        INNER JOIN [acsa].[SWIFT_CONSIGNMENT_HEADER] AS [CH]
            ON [CD].[CONSIGNMENT_ID] = [CH].[CONSIGNMENT_ID]
    WHERE [STATUS] = 'ACTIVE'
          AND [CUSTOMER_ID] = @CODE_CUSTOMER;

    -- -------------------------------------------------------------------------------------------------------------
    -- Obtiene las facturas vencidas para el cliente
    -- -------------------------------------------------------------------------------------------------------------
    EXEC [acsa].[SONDA_SP_GET_OVERDUE_INVOICE_BY_CUSTOMER] @CODE_ROUTE = @CODE_ROUTE,       -- varchar(50)
                                                            @CODE_CUSTOMER = @CODE_CUSTOMER; -- varchar(250)

    -- -------------------------------------------------------------------------------------------------------------
    -- Obtiene las condiciones de pago e informacion de limite de credito del cliente
    -- -------------------------------------------------------------------------------------------------------------
    EXEC [acsa].[SONDA_SP_GET_CUSTOMER_ACCOUNTING_INFORMATION] @CODE_ROUTE = @CODE_ROUTE,       -- varchar(50)
                                                                @CODE_CUSTOMER = @CODE_CUSTOMER; -- varchar(250)

    -- -----------------------------------------------------
    -- Obtiene la estadistica de ventas del cliente
    -- -----------------------------------------------------

    EXEC [acsa].[SONDA_SP_STATISTIC_SALES_BY_CUSTOMER_OUT_OF_ROUTE_PLAN] @CODE_ROUTE = @CODE_ROUTE,   -- varchar(50)
                                                                          @CLIENT_ID = @CODE_CUSTOMER; -- varchar(150)

END;
