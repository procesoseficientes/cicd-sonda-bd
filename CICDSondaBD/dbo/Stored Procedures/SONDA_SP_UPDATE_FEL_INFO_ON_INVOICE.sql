-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	12/5/2019 @ G-Force - TEAM Sprint 
-- Historia/Bug:		
-- Descripcion: 		12/5/2019 - SP que actualiza los datos de FEL en una factura marcada como documento de contingencia

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_UPDATE_FEL_INFO_ON_INVOICE]
    @CODE_ROUTE =,
    @ELECTRONIC_SIGNATURE =,
    @DOCUMENT_SERIES =,
    @DOCUMENT_NUMBER =,
    @DOCUMENT_URL =,
    @SHIPMENT =,
    @VALIDATION_RESULT =,
    @SHIPMENT_DATETIME =,
    @SHIPMENT_RESPONSE =,
    @CONTINGENCY_DOC_SERIE =,
    @CONTINGENCY_DOC_NUM =
*/
-- =============================================
CREATE PROCEDURE [SONDA_SP_UPDATE_FEL_INFO_ON_INVOICE]
(
    @CODE_ROUTE VARCHAR(50),
    -- --------------------------------
    @ELECTRONIC_SIGNATURE VARCHAR(250) = NULL,
    @DOCUMENT_SERIES VARCHAR(250) = NULL,
    @DOCUMENT_NUMBER BIGINT = NULL,
    @DOCUMENT_URL VARCHAR(250) = NULL,
    @SHIPMENT INT,
    @VALIDATION_RESULT BIT,
    @SHIPMENT_DATETIME DATETIME,
    @SHIPMENT_RESPONSE VARCHAR(250) = NULL,
    @CONTINGENCY_DOC_SERIE VARCHAR(250),
    @CONTINGENCY_DOC_NUM BIGINT,
    @FROM_CONTINGENCY_SUBPROCESS INT = 0
)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY
        -- ---------------------------------------------------------------
        -- ACTUALIZA EL DOCUMENTO CON LOS DATOS DE FACTURA ELECTRONICA EN LINEA
        -- ---------------------------------------------------------------
        UPDATE [acsa].[SONDA_POS_INVOICE_HEADER]
        SET [ELECTRONIC_SIGNATURE] = @ELECTRONIC_SIGNATURE,
            [DOCUMENT_SERIES] = @DOCUMENT_SERIES,
            [DOCUMENT_NUMBER] = @DOCUMENT_NUMBER,
            [DOCUMENT_URL] = @DOCUMENT_URL,
            [SHIPMENT] = @SHIPMENT,
            [VALIDATION_RESULT] = @VALIDATION_RESULT,
            [SHIPMENT_DATETIME] = @SHIPMENT_DATETIME,
            [SHIPMENT_RESPONSE] = @SHIPMENT_RESPONSE
        WHERE [POS_TERMINAL] = @CODE_ROUTE
              AND [CONTINGENCY_DOC_SERIE] = @CONTINGENCY_DOC_SERIE
              AND [CONTINGENCY_DOC_NUM] = @CONTINGENCY_DOC_NUM;

        -- ------------------------------------------------------------------------
        -- SI VIENE DEL PROCESO AUTOMATICO DE FIRMA DE DOCUMENTOS DE CONTINGENCIA
        -- VERIFICAR SI EL PROCESO ES FALLIDO (SHIPMENT = 2) Y SI LO ES, ACTUALIZAR
        -- LOS INTENTOS DE ENVIO
        -- ------------------------------------------------------------------------
        IF (@FROM_CONTINGENCY_SUBPROCESS = 1 AND @SHIPMENT = 2)
        BEGIN
            UPDATE [acsa].[SONDA_POS_INVOICE_HEADER]
            SET [FEL_CONTINGENCY_DOCUMENT_SHIPMENT_ATTEMPTS] = ISNULL([FEL_CONTINGENCY_DOCUMENT_SHIPMENT_ATTEMPTS], 0)
                                                               + 1
            WHERE [POS_TERMINAL] = @CODE_ROUTE
                  AND [CONTINGENCY_DOC_SERIE] = @CONTINGENCY_DOC_SERIE
                  AND [CONTINGENCY_DOC_NUM] = @CONTINGENCY_DOC_NUM;
        END;

        -- ---------------------------------------------------------------
        -- DEVUELVE EL RESULTADO COMO FALLIDO
        -- ---------------------------------------------------------------
        SELECT 1 AS [Resultado],
               'PROCESO EXITOSO' AS [Mensaje],
               0 [DbCode];

    END TRY
    BEGIN CATCH

        -- ---------------------------------------------------------------
        -- DEVUELVE EL RESULTADO COMO FALLIDO
        -- ---------------------------------------------------------------
        SELECT -1 AS [Resultado],
               ERROR_MESSAGE() AS [Mensaje],
               @@ERROR [DbCode];

    END CATCH;
END;