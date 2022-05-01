/*=======================================================
-- Author:         alejandro.ochoa
-- Create date:    17-08-2016
-- Description:    Inserta los clientes en DB de Interfaz para AX
				   

-- EJEMPLO DE EJECUCION: 
	EXEC [acsa].[SWIFT_SP_POST_CUSTOMER_NEW_TO_ERP] @CODE_CUSTOMER ='CL-000000'

=========================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_POST_CUSTOMER_NEW_TO_ERP] (@CODE_CUSTOMER VARCHAR(50))
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @PriceList VARCHAR(50) = [acsa].[SWIFT_FN_GET_PARAMETER]('ERP_HARDCODE_VALUES','PRICE_LIST')
	
	BEGIN TRY
		INSERT INTO ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_cliente_potencial]
		SELECT
			'ACSA' as Empresa
			,(CASE WHEN ISNULL(scn.NIT,'...') = '...' THEN 'C.F.' ELSE scn.NIT END) as NIT
			,scn.NAME_CUSTOMER
			,scn.ADRESS_CUSTOMER
			,scn.PHONE_CUSTOMER
			,scn.CODE_ROUTE
			,scn.CONTACT_CUSTOMER
			,scn.REFERENCE
			,scn.LAST_UPDATE
			,@PriceList
			,scn.CODE_CUSTOMER
		FROM [acsa].SWIFT_CUSTOMERS_NEW scn
		WHERE scn.CODE_CUSTOMER = @CODE_CUSTOMER
			AND ISNULL([scn].[IS_POSTED_ERP],-1) = -1
		
		EXEC [acsa].[SWIFT_SP_STATUS_SEND_CUSTOMER_TO_SAP] 
			@CODE_CUSTOMER = @CODE_CUSTOMER,
			@POSTED_RESPONSE = 'Proceso Exitoso',
			@CODE_CUSTOMER_BO = @CODE_CUSTOMER

	END TRY
	BEGIN CATCH

		EXEC [acsa].[SWIFT_SP_CUSTOMER_ERROR_TO_SEND_SAP] @CODE_CUSTOMER = @CODE_CUSTOMER , -- varchar(50)
			@POSTED_RESPONSE = ERROR_MESSAGE	

		DELETE FROM ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_cliente_potencial]
		WHERE cod_cliente = @CODE_CUSTOMER;

		

	END CATCH

END

