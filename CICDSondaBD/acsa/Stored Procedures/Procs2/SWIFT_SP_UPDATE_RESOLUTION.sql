-- Modificacion 		11/30/2019 @ G-Force Team Sprint Oslo
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 33218: Configuración de Frases y Escenarios
-- Descripcion: 		11/30/2019 - Se agregan columnas para indicar el TIPO DE DOCUMENTO FEL al que haran referencia las facturas generadas con la resolucion, asi como el CODIGO DE ESTABLECIMIENTO que de igual forma
--						se enviara en las facturas.
-- ==============================================================================================================================================
CREATE PROC [acsa].[SWIFT_SP_UPDATE_RESOLUTION]
    @AUTH_ID VARCHAR(50),
    @SERIE VARCHAR(100),
    @ASSIGNED_BY VARCHAR(100),
    @ASSIGNED_TO VARCHAR(100),
    @pResult VARCHAR(250) OUTPUT,
    @FEL_DOCUMENT_TYPE INT = NULL,
    @FEL_STABLISHMENT_CODE INT = NULL
AS
BEGIN

    BEGIN TRAN [t1];
    BEGIN
        UPDATE [acsa].[SONDA_POS_RES_SAT]
        SET [AUTH_ASSIGNED_DATETIME] = GETDATE(),
            [AUTH_ASSIGNED_BY] = @ASSIGNED_BY,
            [AUTH_ASSIGNED_TO] = @ASSIGNED_TO,
            [FEL_DOCUMENT_TYPE_CLASSIFICATION_ID] = @FEL_DOCUMENT_TYPE,
            [FEL_DOCUMENT_TYPE] =
            (
                SELECT TOP (1)
                       [VALUE_TEXT_CLASSIFICATION]
                FROM [acsa].[SWIFT_CLASSIFICATION]
                WHERE [CLASSIFICATION] = @FEL_DOCUMENT_TYPE
                ORDER BY [CLASSIFICATION]
            ),
            [FEL_STABLISHMENT_CODE_CLASSIFICATION_ID] = @FEL_STABLISHMENT_CODE,
            [FEL_STABLISHMENT_CODE] =
            (
                SELECT TOP (1)
                       [VALUE_TEXT_CLASSIFICATION]
                FROM [acsa].[SWIFT_CLASSIFICATION]
                WHERE [CLASSIFICATION] = @FEL_STABLISHMENT_CODE
                ORDER BY [CLASSIFICATION]
            )
        WHERE [AUTH_ID] = @AUTH_ID
              AND [AUTH_SERIE] = @SERIE;
    END;
    IF @@error = 0
    BEGIN
        SELECT @pResult = 'OK';
        COMMIT TRAN [t1];
    END;
    ELSE
    BEGIN
        ROLLBACK TRAN [t1];
        SELECT @pResult = ERROR_MESSAGE();
    END;
END;
