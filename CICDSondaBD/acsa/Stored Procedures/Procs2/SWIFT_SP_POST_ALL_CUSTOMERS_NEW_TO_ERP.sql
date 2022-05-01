/*=======================================================
-- Author:         alejandro.ochoa
-- Create date:    25-10-2017
-- Description:    Inserta Todos los Scouting en DB de Interfaz Intermedia para envio a AX
				   

-- EJEMPLO DE EJECUCION: 
		EXEC [acsa].[SWIFT_SP_POST_ALL_CUSTOMERS_NEW_TO_ERP]

=========================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_POST_ALL_CUSTOMERS_NEW_TO_ERP]
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @CODE_CUSTOMER VARCHAR(50)
	DECLARE @PriceList VARCHAR(50) = [acsa].[SWIFT_FN_GET_PARAMETER]('ERP_HARDCODE_VALUES','PRICE_LIST')
	
	SELECT
		scn.CODE_CUSTOMER
	INTO #NewClients
	FROM [acsa].SWIFT_CUSTOMERS_NEW scn
	WHERE ISNULL(scn.IS_POSTED_ERP,-1) = -1

	--AND scn.[STATUS] = 'ACCEPTED' --Se comenta para que todos los Scouting viajen a AX
	
	WHILE EXISTS(SELECT TOP 1 1 FROM #NewClients)
	BEGIN
		
		SELECT 
			@CODE_CUSTOMER = CODE_CUSTOMER
		FROM #NewClients


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
			
			UPDATE [acsa].SWIFT_CUSTOMERS_NEW
				SET IS_POSTED_ERP = 1, 
					POSTED_RESPONSE = 'Proceso Exitoso',
					POSTED_ERP=GETDATE()
				WHERE CODE_CUSTOMER = @CODE_CUSTOMER
		END TRY
		BEGIN CATCH
			ROLLBACK
			UPDATE [acsa].SWIFT_CUSTOMERS_NEW
				SET POSTED_RESPONSE = ERROR_MESSAGE(),
					POSTED_ERP=GETDATE(),
					ATTEMPTED_WITH_ERROR = ISNULL(ATTEMPTED_WITH_ERROR,0)+1
				WHERE CODE_CUSTOMER = @CODE_CUSTOMER
		END CATCH

		DELETE FROM #NewClients WHERE CODE_CUSTOMER = @CODE_CUSTOMER
	END;  

END





