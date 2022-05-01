﻿-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	7/20/2018 @ A-TEAM Sprint G-Force@Gato  
-- Description:			SP que obtiene los primeros 5 documentos de pago

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_TOP5_PAYMENT_HEADER]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_TOP5_PAYMENT_HEADER]
AS
	BEGIN
		SET NOCOUNT ON;
	--
		DECLARE
			@SHIPPING_ATTEMPTS VARCHAR(100)
			,@CASH_ACCOUNT_IN_ERP VARCHAR(100)
			,@CHECK_ACCOUNT_IN_ERP VARCHAR(100)
			,@DEPOSIT_ACCOUNT_IN_ERP VARCHAR(100);

		SELECT
			@SHIPPING_ATTEMPTS = [acsa].[SWIFT_FN_GET_PARAMETER]('PAYMENT' ,
																'SHIPPING_ATTEMPTS')
			,@CASH_ACCOUNT_IN_ERP = [acsa].[SWIFT_FN_GET_PARAMETER]('PAYMENT' ,
																'CASH_ACCOUNT_IN_ERP')
			,@CHECK_ACCOUNT_IN_ERP = [acsa].[SWIFT_FN_GET_PARAMETER]('PAYMENT' ,
																'CHECK_ACCOUNT_IN_ERP')
			,@DEPOSIT_ACCOUNT_IN_ERP = [acsa].[SWIFT_FN_GET_PARAMETER]('PAYMENT' ,
																'DEPOSIT_ACCOUNT_IN_ERP');

		SELECT TOP 5
			[OIPH].[ID]
			,[OIPH].[CODE_CUSTOMER]
			,[OIPH].[DOC_SERIE]
			,[OIPH].[DOC_NUM]
			,[OIPH].[CREATED_DATE]
			,[OIPH].[POSTED_DATE]
			,[OIPH].[CODE_ROUTE]
			,[OIPH].[LOGIN_ID]
			,[OIPH].[PAYMENT_AMOUNT]
			,[OIPH].[COMMENT]
			,[OIPH].[IS_POSTED_ERP]
			,[OIPH].[POSTED_DATETIME_ERP]
			,[OIPH].[POSTING_RESPONSE]
			,[OIPH].[ATTEMPTED_WITH_ERROR]
			,[OIPH].[ERP_REFERENCE]
			,'C' AS DOC_TYPE
			,@CASH_ACCOUNT_IN_ERP AS CASH_ACCOUNT_IN_ERP
			,@CHECK_ACCOUNT_IN_ERP AS CHECK_ACCOUNT_IN_ERP
			,@DEPOSIT_ACCOUNT_IN_ERP AS DEPOSIT_ACCOUNT_IN_ERP
			,([OIPH].[DOC_SERIE] + '-' + CAST([OIPH].[DOC_NUM] AS VARCHAR(250))) AS U_N_RECIBO
		FROM
			[acsa].[SONDA_OVERDUE_INVOICE_PAYMENT_HEADER] AS [OIPH]
		WHERE
			([OIPH].[IS_POSTED_ERP] <> 1)
			AND ([OIPH].[ATTEMPTED_WITH_ERROR] < CAST(@SHIPPING_ATTEMPTS AS INT))
		ORDER BY [OIPH].[CREATED_DATE] ASC
		
	END;
