-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	12/16/2019 @ G-Force - TEAM Sprint 
-- Historia/Bug:		IMPLEMENTACION AUTOVENTA SARITA GT
-- Descripcion: 		12/16/2019 - SP que establece el estado de la publicacion del documento en el ERP (Microsoft Business Central 365)

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SWIFT_SP_SET_ERP_POSTING_STATUS_ON_INVOICE]
  
*/
-- =============================================

CREATE PROCEDURE [acsa].[SWIFT_SP_SET_ERP_POSTING_STATUS_ON_INVOICE]
(
    @INVOICE_ID INT,
    @POSTING_STATUS INT,
    @POSTING_RESPONSE VARCHAR(250),
    @ERP_REFERENCE VARCHAR(250) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @INVOICE_NUM INT,
            @CDF_SERIE VARCHAR(250),
            @CDF_RESOLUCION VARCHAR(250),
            @IS_CREDIT_NOTE INT;

    -- ---------------------------------------------------------------
    -- Se obtienen los datos de la factura a procesar
    -- ---------------------------------------------------------------
    SELECT @INVOICE_NUM = [IH].[INVOICE_ID],
           @CDF_SERIE = [IH].[CDF_SERIE],
           @CDF_RESOLUCION = [IH].[CDF_RESOLUCION],
           @IS_CREDIT_NOTE = [IH].[IS_CREDIT_NOTE]
    FROM [acsa].[SONDA_POS_INVOICE_HEADER] AS [IH]
    WHERE [IH].[ID] = @INVOICE_ID;


    -- ---------------------------------------------------------------
    -- Se procesa la factura en base al resultado de posteo
    -- ---------------------------------------------------------------
    IF (@POSTING_STATUS = 1)
    BEGIN
        EXEC [acsa].[SWIFT_SP_MARK_INVOICE_AS_SEND_TO_ERP] @INVOICE_ID = @INVOICE_NUM,           -- int
                                                            @CDF_SERIE = @CDF_SERIE,              -- varchar(50)
                                                            @CDF_RESOLUCION = @CDF_RESOLUCION,    -- nvarchar(50)
                                                            @IS_CREDIT_NOTE = @IS_CREDIT_NOTE,    -- int
                                                            @POSTED_RESPONSE = @POSTING_RESPONSE, -- varchar(150)
                                                            @ERP_REFERENCE = @ERP_REFERENCE;      -- varchar(256)

    END;
    ELSE
    BEGIN
        EXEC [acsa].[SWIFT_SP_MARK_INVOICE_AS_FAILED_TO_ERP] @INVOICE_ID = @INVOICE_NUM,           -- int
                                                              @CDF_SERIE = @CDF_SERIE,              -- varchar(50)
                                                              @CDF_RESOLUCION = @CDF_RESOLUCION,    -- nvarchar(50)
                                                              @IS_CREDIT_NOTE = @IS_CREDIT_NOTE,    -- int
                                                              @POSTED_RESPONSE = @POSTING_RESPONSE; -- varchar(150)
    END;

END;
