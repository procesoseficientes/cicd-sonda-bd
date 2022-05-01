-- =============================================
-- Author:         diego.as
-- Create date:    15-02-2016
-- Description:    Cambia el STATUS del CERTIFICADO a 'ACTIVO','INACTIVO' o 'CANCELADO' 
--				   en la Tabla [acsa].[OP_WMS_CERTIFICATE_DEPOSIT_HEADER]

/*
Ejemplo de Ejecucion:

					EXEC [acsa].[OP_WMS_SP_SET_STATUS_CERTIFICATE_DEPOSIT_HEADER] 
					@ID_DEPOSIT_HEADER = 1
					,@STATUS = 'ACTIVO' 
					------------------------------------------------------------
					SELECT * FROM [acsa].[OP_WMS_CERTIFICATE_DEPOSIT_HEADER]
				
*/
-- =============================================

CREATE PROCEDURE [acsa].[OP_WMS_SP_SET_STATUS_CERTIFICATE_DEPOSIT_HEADER]
(
	@ID_DEPOSIT_HEADER INT
	,@STATUS VARCHAR(25)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		UPDATE [acsa].[OP_WMS_CERTIFICATE_DEPOSIT_HEADER] 
			SET STATUS = @STATUS
				,LAST_UPDATED = GETDATE()
		WHERE [CERTIFICATE_DEPOSIT_ID_HEADER] = @ID_DEPOSIT_HEADER
    END TRY
    BEGIN CATCH
		ROLLBACK
		DECLARE @ERROR VARCHAR(1000)= ERROR_MESSAGE()
		RAISERROR (@ERROR,16,1)
    END CATCH
END
