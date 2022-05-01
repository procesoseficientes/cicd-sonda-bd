-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	7/20/2018 @ A-TEAM Sprint G-Force@Gato 
-- Description:			SP que obtiene los registros del detalle de tipos de pago de un documento de pago

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_DETAIL_OF_PAYMENT_TYPE]
				@PAYMENT_HEADER_ID = 20
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_DETAIL_OF_PAYMENT_TYPE]
	(
		@PAYMENT_HEADER_ID INT
	)
AS
	BEGIN
		SET NOCOUNT ON;
	--
		SELECT
			[OIPTD].[PAYMENT_TYPE_ID]
			,[OIPTD].[PAYMENT_HEADER_ID]
			,[OIPTD].[PAYMENT_TYPE]
			,[OIPTD].[DOCUMENT_NUMBER]
			,[OIPTD].[BANK_ACCOUNT]
			,[OIPTD].[BANK_NAME]
			,[OIPTD].[AMOUNT]
			,(
				SELECT TOP 1
					[C].[MPC01]
				FROM
					[acsa].[SWIFT_CLASSIFICATION] AS [C]
				WHERE
					[C].[NAME_CLASSIFICATION] = [OIPTD].[BANK_NAME]
				) [BANK_CODE]
		FROM
			[acsa].[SONDA_PAYMENT_TYPE_DETAIL_FOR_OVERDUE_INVOICE_PAYMENT] AS [OIPTD]
		WHERE
			[OIPTD].[PAYMENT_HEADER_ID] = @PAYMENT_HEADER_ID;
	END;
