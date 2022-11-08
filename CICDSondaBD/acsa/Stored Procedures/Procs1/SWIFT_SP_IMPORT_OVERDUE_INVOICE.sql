-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	4/29/2018 @ G-FORCE TEAM - Sprint CASTOR
-- Description:			SP que importa las facturas vencidas de los clientes

-- Modificacion 10/26/2018 @ A-Team Sprint G-FORCE@LEON
-- diego.as
-- Se elimina condicion de fechas en el openquery para que ahora se puedan importar todas las facturas sin importar si esta vencida o no

-- Modificacion 		7/8/2019 @ G-Force Team Sprint ESTOCOLMO
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 30230: Visualizacion de Facturas Vencidas 
-- Descripcion: 		7/8/2019 - Se cambia tipo de datos de columnas INVOICE_ID, DOC_ENTRY a VARCHAR(250)
--						Se agregan columnas AMOUNT_TO_DATE, PENDING_AMOUNT para almacenar el historico del estado de la factura

/*
-- Ejemplo de Ejecucion:
      		EXEC [diprocom].[SWIFT_SP_IMPORT_OVERDUE_INVOICE]
*/
-- =============================================
ALTER PROCEDURE [DIPROCOM].[SWIFT_SP_IMPORT_OVERDUE_INVOICE]
AS
BEGIN
    --
    SET NOCOUNT ON;
    --
    DECLARE @QUERY VARCHAR(MAX);

    BEGIN TRY
        -- -------------------------------------------------------------
        -- Definimos la tabla temporal que almacenara los clientes
        -- -------------------------------------------------------------
        CREATE TABLE [#CUSTOMER]
        (
            [CUSTOMER_ID] INT IDENTITY(1, 1) PRIMARY KEY,
            [CODE_CUSTOMER] VARCHAR(250)
        );


        -- ------------------------------------------------------------
        -- Definimos tabla para almacenar las facturas
        -- ------------------------------------------------------------
        CREATE TABLE [#OVERDUE_INVOICE_BY_CUSTOMER]
        (
            [ID] INT IDENTITY(1, 1),
            [INVOICE_ID] VARCHAR(250) NOT NULL,
            [DOC_ENTRY] VARCHAR(250) NOT NULL,
            [CODE_CUSTOMER] VARCHAR(250) NOT NULL,
            [CREATED_DATE] DATETIME,
            [DUE_DATE] DATETIME,
            [TOTAL_AMOUNT] NUMERIC(18, 6),
            [PENDING_TO_PAID] NUMERIC(18, 6),
            PRIMARY KEY (
                            [ID],
                            [INVOICE_ID],
                            [DOC_ENTRY]
                        )
        );

        -- -------------------------------------------------------------
        -- Creamos un indice sobre la tabla
        -- -------------------------------------------------------------
        CREATE NONCLUSTERED INDEX [IDX_CUSTOMER_TO_PROCESS]
        ON [#CUSTOMER] (
                           [CUSTOMER_ID],
                           [CODE_CUSTOMER]
                       );

        -- INICIAMOS TRANSACCION
        BEGIN TRAN;

        -- -------------------------------------------------------------
        -- Limpiamos la tabla
        -- -------------------------------------------------------------
        TRUNCATE TABLE [diprocom].[SWIFT_OVERDUE_INVOICE_BY_CUSTOMER];

        -- -------------------------------------------------------------
        -- Obtenemos los clientes
        -- -------------------------------------------------------------
        INSERT INTO [#CUSTOMER]
        (
            [CODE_CUSTOMER]
        )
        SELECT [CODE_CUSTOMER]
        FROM [diprocom].[SWIFT_VIEW_ALL_COSTUMER];

        -- ------------------------------------------------------------
        -- Armamos y Ejecutamos la consulta
        -- ------------------------------------------------------------
        SELECT @QUERY
            = '
				INSERT INTO [#OVERDUE_INVOICE_BY_CUSTOMER]
					SELECT 
						IV.INVOICE_ID
						,IV.DOC_ENTRY
						,IV.CODE_CUSTOMER
						,IV.CREATED_DATE
						,IV.DUE_DATE
						,IV.TOTAL_AMOUNT
						,IV.PENDING_TO_PAID
					FROM (
						SELECT
							INV.numero as INVOICE_ID
							,INV.numero as DOC_ENTRY
							,INV.ctacte as CODE_CUSTOMER
							,INV.fecha as CREATED_DATE
							,INV.fecha_vencimiento as DUE_DATE
							,INV.monto_original as TOTAL_AMOUNT
							,INV.saldo as PENDING_TO_PAID
						FROM SWIFT_INTERFACES_ONLINE_A.diprocom.ERP_VIEW_INVOICE_PENDING_TO_PAY AS INV
						where GETDATE() > INV.fecha_vencimiento
						AND INV.monto_original > 0
				) AS IV
				INNER JOIN #CUSTOMER AS VC
				ON ([IV].CODE_CUSTOMER COLLATE DATABASE_DEFAULT = [VC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT)
					';
        EXECUTE (@QUERY);

        -- -------------------------------------------------------------------
        -- Insertamos en nuestra tabla que almacena toda la informacion
        -- -------------------------------------------------------------------
        INSERT INTO [diprocom].[SWIFT_OVERDUE_INVOICE_BY_CUSTOMER]
        (
            [INVOICE_ID],
            [DOC_ENTRY],
            [CODE_CUSTOMER],
            [CREATED_DATE],
            [DUE_DATE],
            [TOTAL_AMOUNT],
            [PENDING_TO_PAID],
            [IS_EXPIRED]
        )
        SELECT [OI].[INVOICE_ID],
               [OI].[DOC_ENTRY],
               [OI].[CODE_CUSTOMER],
               [OI].[CREATED_DATE],
               [OI].[DUE_DATE],
               [OI].[TOTAL_AMOUNT],
               [OI].[PENDING_TO_PAID],
               CASE
                   WHEN CAST(GETDATE() AS DATE) > [OI].[DUE_DATE] THEN
                       1
                   ELSE
                       0
               END
        FROM [#OVERDUE_INVOICE_BY_CUSTOMER] AS [OI]
        WHERE [OI].[ID] > 0;

        -- FINALIZAMOS TRANSACCION
        COMMIT;
    END TRY
    BEGIN CATCH
        --
        DECLARE @ERROR_MESSAGE VARCHAR(MAX);
        SET @ERROR_MESSAGE = ERROR_MESSAGE();

        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK;
        END;

        --
        EXEC [diprocom].[SONDA_SP_INSERT_SONDA_SERVER_ERROR_LOG] @CODE_ROUTE = '',                                  -- varchar(50)
                                                              @LOGIN = '',                                       -- varchar(50)
                                                              @SOURCE_ERROR = 'SWIFT_SP_IMPORT_OVERDUE_INVOICE', -- varchar(250)
                                                              @DOC_RESOLUTION = '',                              -- varchar(100)
                                                              @DOC_SERIE = '',                                   -- varchar(100)
                                                              @DOC_NUM = 0,                                      -- int
                                                              @MESSAGE_ERROR = @ERROR_MESSAGE,                   -- varchar(max)
                                                              @SEVERITY_CODE = 5000;                             -- int

    --


    END CATCH;

END;
