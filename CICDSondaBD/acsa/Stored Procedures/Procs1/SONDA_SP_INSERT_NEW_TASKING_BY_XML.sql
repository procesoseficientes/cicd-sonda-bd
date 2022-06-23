-- =============================================================================
-- AUTHOR:		denis.villagrán
-- CREATE DATE:	2019-10-24 14:41:22
-- DATABASE:	$(CICDSondaBD)
-- DESCRIPTION:	SP que inserta tareas a la tabla SWIFT_TASK a partir de un xml
-- =============================================================================
/*
-- =============================================================================
-- Ejemplo de ejecución
EXEC [acsa].[SONDA_SP_INSERT_NEW_TASKING_BY_XML] @XML = '<?xml version=''1.0''?>
<Data>
    <tasking>
        <taskId>4</taskId>
        <taskType>SALE</taskType>
        <taskDate>10/24/2019 1:01:13 PM</taskDate>
        <scheudleFor>10/24/2019 1:01:13 PM</scheudleFor>
        <createdStamp>10/24/2019 1:01:13 PM</createdStamp>
        <assignedTo>adolfo@acsa</assignedTo>
        <assignedBy>Proceso diario</assignedBy>
        <acceptedStamp>10/24/2019 1:01:13 PM</acceptedStamp>
        <completedStamp>10/24/2019 1:01:13 PM</completedStamp>
        <expectedGps>14.712527,-90.4011317</expectedGps>
        <postedGps>null</postedGps>
        <taskComments>Nueva tarea generada para el cliente TIENDA ERICK</taskComments>
        <taskSeq>7</taskSeq>
        <taskAddress>LOTE 6  MANZANA B  COLONIA PIEDRAS VERDES</taskAddress>
        <relatedClientCode>SO-151109</relatedClientCode>
        <relatedClientName>TIENDA ERICK</relatedClientName>
        <taskStatus>ASSIGNED</taskStatus>
        <taskBoId>4</taskBoId>
        <isPosted>0</isPosted>
        <completedSuccessfully>0</completedSuccessfully>
        <reason>null</reason>
        <rgaCode>null</rgaCode>
        <nit>CF</nit>
        <phoneCustomer>null</phoneCustomer>
        <codePriceList>1</codePriceList>
        <inPlanRoute>0</inPlanRoute>
    </tasking>
    <dbuser>UDIPROCOM</dbuser>
    <dbuserpass>DIPROCOMServer1237710</dbuserpass>
    <routeid>46</routeid>
    <loginId>adolfo@acsa</loginId>
    <deviceId>c854a333aa2973b7</deviceId>
    <networkType>WiFi</networkType>
</Data>'
====================================
*/
CREATE PROCEDURE [acsa].[SONDA_SP_INSERT_NEW_TASKING_BY_XML]
(
    @XML XML,
    @JSON VARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    --
    DECLARE @LOGIN_ID VARCHAR(50),
            @CODE_ROUTE VARCHAR(50),
            @DEVICE_NETWORK_TYPE VARCHAR(10),
            @TASK_TYPE VARCHAR(10),
            @DEVICE_ID VARCHAR(50);

    DECLARE @TASK TABLE
    (
        [TASK_ID] [INT] IDENTITY(1, 1) NOT NULL,
        [TASK_TYPE] [VARCHAR](15) NULL,
        [TASK_DATE] [DATE] NULL,
        [SCHEDULE_FOR] [DATE] NULL,
        [CREATED_STAMP] [DATETIME] NULL,
        [ASSIGEND_TO] [VARCHAR](25) NULL,
        [ASSIGNED_BY] [VARCHAR](25) NULL,
        [ACCEPTED_STAMP] [DATETIME] NULL,
        [COMPLETED_STAMP] [DATETIME] NULL,
        [EXPECTED_GPS] [VARCHAR](100) NULL,
        [POSTED_GPS] [VARCHAR](100) NULL,
        [TASK_STATUS] [VARCHAR](10) NULL,
        [TASK_COMMENTS] [VARCHAR](150) NULL,
        [TASK_SEQ] [INT] NULL,
        [CUSTOMER_CODE] [VARCHAR](25) NULL,
        [CUSTOMER_NAME] [VARCHAR](250) NULL,
        [CUSTOMER_PHONE] [VARCHAR](50) NULL,
        [TASK_ADDRESS] [VARCHAR](250) NULL,
        [REASON] [VARCHAR](250) NULL,
        [COMPLETED_SUCCESSFULLY] [INT] NULL, --[NUMERIC](18, 0) NULL,
        [TASK_ID_HH] [INT] NULL,
        [CREATE_BY] [VARCHAR](250) NULL,
        [DEVICE_NETWORK_TYPE] [VARCHAR](15) NULL,
        [IS_POSTED_OFFLINE] [INT] NOT NULL,
        [CODE_ROUTE] [VARCHAR](50) NULL,
        [IN_PLAN_ROUTE] [INT] NULL
    );
    BEGIN TRAN;
    BEGIN TRY

        -- ------------------------------------------------------------------------------- --
        -- Obtiene el LOGIN_ID, el CODE_ROUTE y el DEVICE_ID                               --
        -- ------------------------------------------------------------------------------- --
        SELECT @LOGIN_ID = [x].[Rec].[query]('./loginId').[value]('.', 'varchar(50)'),
               @CODE_ROUTE = [x].[Rec].[query]('./routeid').[value]('.', 'varchar(50)'),
               @DEVICE_NETWORK_TYPE = [x].[Rec].[query]('./networkType').[value]('.', 'varchar(10)'),
               @TASK_TYPE = 'SALE',
               @DEVICE_ID = [x].[Rec].[query]('./deviceId').[value]('.', 'varchar(50)')
        FROM @XML.[nodes]('Data') AS [x]([Rec]);

        -- ------------------------------------------------------------------------------------- --
        -- Se valida el identificador del dispositivo que mando a ejecutar al procedimiento      --
        -- ------------------------------------------------------------------------------------- --
        EXEC [acsa].[SONDA_SP_VALIDATE_DEVICE_ID_OF_USER_FOR_TRANSACTION] @CODE_ROUTE = @CODE_ROUTE,
                                                                           @DEVICE_ID = @DEVICE_ID;

        -- ----------------------------------------------------------------- --
        -- Obtiene las tareas                                                --
        -- ----------------------------------------------------------------- --
        INSERT INTO @TASK
        (
            [TASK_TYPE],
            [TASK_DATE],
            [SCHEDULE_FOR],
            [CREATED_STAMP],
            [ASSIGEND_TO],
            [ASSIGNED_BY],
            [ACCEPTED_STAMP],
            [COMPLETED_STAMP],
            [EXPECTED_GPS],
            [POSTED_GPS],
            [TASK_STATUS],
            [TASK_COMMENTS],
            [TASK_SEQ],
            [CUSTOMER_CODE],
            [CUSTOMER_NAME],
            [CUSTOMER_PHONE],
            [TASK_ADDRESS],
            [REASON],
            [TASK_ID_HH],
            [CREATE_BY],
            [COMPLETED_SUCCESSFULLY],
            [DEVICE_NETWORK_TYPE],
            [IS_POSTED_OFFLINE],
            [CODE_ROUTE],
            [IN_PLAN_ROUTE]
        )
        SELECT @TASK_TYPE,
               CASE
                   WHEN ([x].[Rec].[query]('./taskDate').[value]('.', 'varchar(100)') = 'null') THEN
                       NULL
                   WHEN ([x].[Rec].[query]('./taskDate').[value]('.', 'varchar(100)') <> 'null') THEN
                       CONVERT(DATETIME, [x].[Rec].[query]('./taskDate').[value]('.', 'date'))
               END,
               CASE
                   WHEN ([x].[Rec].[query]('./scheduleFor').[value]('.', 'varchar(100)') = 'null') THEN
                       NULL
                   WHEN ([x].[Rec].[query]('./scheduleFor').[value]('.', 'varchar(100)') <> 'null') THEN
                       CONVERT(DATETIME, [x].[Rec].[query]('./scheduleFor').[value]('.', 'date'))
               END,
               CASE
                   WHEN ([x].[Rec].[query]('./createdStamp').[value]('.', 'varchar(100)') = 'null') THEN
                       NULL
                   WHEN ([x].[Rec].[query]('./createdStamp').[value]('.', 'varchar(100)') <> 'null') THEN
                       CONVERT(DATETIME, [x].[Rec].[query]('./createdStamp').[value]('.', 'datetime'))
               END,
               [x].[Rec].[query]('./assignedTo').[value]('.', 'varchar(25)'),
               [x].[Rec].[query]('./assignedTo').[value]('.', 'varchar(25)'),
               CASE
                   WHEN ([x].[Rec].[query]('./acceptedStamp').[value]('.', 'varchar(100)') = 'null') THEN
                       NULL
                   WHEN ([x].[Rec].[query]('./acceptedStamp').[value]('.', 'varchar(100)') <> 'null') THEN
                       CONVERT(DATETIME, [x].[Rec].[query]('./acceptedStamp').[value]('.', 'datetime'))
               END,
               CASE
                   WHEN ([x].[Rec].[query]('./completedStamp').[value]('.', 'varchar(100)') = 'null') THEN
                       NULL
                   WHEN ([x].[Rec].[query]('./completedStamp').[value]('.', 'varchar(100)') <> 'null') THEN
                       CONVERT(DATETIME, [x].[Rec].[query]('./completedStamp').[value]('.', 'datetime'))
               END,
               [x].[Rec].[query]('./expectedGps').[value]('.', 'varchar(100)'),
               CASE
                   WHEN ([x].[Rec].[query]('./postedGps').[value]('.', 'varchar(100)') = 'null') THEN
                       ''
                   WHEN ([x].[Rec].[query]('./postedGps').[value]('.', 'varchar(100)') <> 'null') THEN
                       [x].[Rec].[query]('./postedGps').[value]('.', 'varchar(100)')
               END,
               [x].[Rec].[query]('./taskStatus').[value]('.', 'varchar(10)'),
               [x].[Rec].[query]('./taskComments').[value]('.', 'varchar(150)'),
               [x].[Rec].[query]('./taskSeq').[value]('.', 'int'),
               [x].[Rec].[query]('./relatedClientCode').[value]('.', 'varchar(25)'),
               [x].[Rec].[query]('./relatedClientName').[value]('.', 'varchar(250)'),
               [x].[Rec].[query]('./phoneCustomer').[value]('.', 'varchar(50)'),
               [x].[Rec].[query]('./taskAddress').[value]('.', 'varchar(250)'),
               CASE
                   WHEN ([x].[Rec].[query]('./reason').[value]('.', 'varchar(250)') = 'null') THEN
                       ''
                   WHEN ([x].[Rec].[query]('./reason').[value]('.', 'varchar(250)') <> 'null') THEN
                       [x].[Rec].[query]('./reason').[value]('.', 'varchar(250)')
               END,
               [x].[Rec].[query]('./taskId').[value]('.', 'int'),
               'BY_USER',
               CASE
                   WHEN ([x].[Rec].[query]('./completedSuccessfully').[value]('.', 'varchar(100)') = 'null') THEN
                       0
                   WHEN ([x].[Rec].[query]('./completedSuccessfully').[value]('.', 'varchar(100)') <> 'null') THEN
                       [x].[Rec].[query]('./completedSuccessfully').[value]('.', 'int')
               END,
               @DEVICE_NETWORK_TYPE,
               0,
               @CODE_ROUTE,
               [x].[Rec].[query]('./inPlanRoute').[value]('.', 'int')
        FROM @XML.[nodes]('Data/tasking') AS [x]([Rec]);

        -- ------------------------------------------- --
        -- Inserta en la tabla SWIFT_TASKS             --
        -- ------------------------------------------- --
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
            [CODE_ROUTE],
            [DEVICE_NETWORK_TYPE],
            [TASK_ID_HH]
        )
        SELECT @TASK_TYPE,
               [T].[TASK_DATE],
               [T].[SCHEDULE_FOR],
               [T].[CREATED_STAMP],
               [T].[ASSIGEND_TO],
               [T].[ASSIGNED_BY],
               GETDATE(),
               NULL,
               NULL,
               [T].[ACCEPTED_STAMP],
               [T].[COMPLETED_STAMP],
               NULL,
               NULL,
               [T].[EXPECTED_GPS],
               [T].[POSTED_GPS],
               [T].[TASK_STATUS],
               [T].[TASK_COMMENTS],
               [T].[TASK_SEQ],
               NULL,
               NULL,
               [T].[CUSTOMER_CODE],
               [T].[CUSTOMER_NAME],
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               1,
               [T].[CUSTOMER_PHONE],
               [T].[TASK_ADDRESS],
               NULL,
               NULL,
               NULL,
               [T].[IN_PLAN_ROUTE],
               [T].[CREATE_BY],
               [T].[CODE_ROUTE],
               [T].[DEVICE_NETWORK_TYPE],
               [T].[TASK_ID_HH]
        FROM @TASK AS [T];

        COMMIT;
        -- ---------------------- --
        -- Muestra la tarea nueva --
        -- ---------------------- --
        SELECT [ST].[TASK_ID],
               [ST].[TASK_ID_HH]
        FROM @TASK AS [TS]
            INNER JOIN [acsa].[SWIFT_TASKS] [ST]
                ON [ST].[CREATED_STAMP] = [TS].[CREATED_STAMP]
                   AND [ST].[COSTUMER_CODE] = [TS].[CUSTOMER_CODE]
                   AND [ST].[CODE_ROUTE] = [TS].[CODE_ROUTE];
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK;
        END;
        DECLARE @ERROR VARCHAR(1000) = ERROR_MESSAGE();
        PRINT 'CATCH: ' + @ERROR;
        RAISERROR(@ERROR, 16, 1);
    END CATCH;
END;
