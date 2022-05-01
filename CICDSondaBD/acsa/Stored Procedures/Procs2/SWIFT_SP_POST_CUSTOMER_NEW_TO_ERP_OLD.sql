/*=======================================================
-- Author:         alejandro.ochoa
-- Create date:    17-08-2016
-- Description:    Inserta los clientes en DB de Interfaz para AX
				   

-- EJEMPLO DE EJECUCION: 
		EXEC [acsa].[SWIFT_SP_POST_CUSTOMER_NEW_TO_ERP]

=========================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_POST_CUSTOMER_NEW_TO_ERP_OLD]
AS
BEGIN

	SET NOCOUNT ON
	
	DECLARE @CODE_CUSTOMER VARCHAR(50)
	DECLARE @PriceList VARCHAR(50) = [acsa].[SWIFT_FN_GET_PARAMETER]('ERP_HARDCODE_VALUES','PRICE_LIST')
	--DECLARE Customer_Cursor CURSOR FOR  
		SELECT
			scn.CODE_CUSTOMER
		INTO #NewClients
		FROM [acsa].SWIFT_CUSTOMERS_NEW scn
		WHERE scn.IS_POSTED_ERP = -1
		--AND scn.[STATUS] = 'ACCEPTED'  
	

	--OPEN Customer_Cursor;
		
	--FETCH NEXT FROM Customer_Cursor
	--INTO @Code_Customer 
		
	--WHILE @@FETCH_STATUS = 0  
	WHILE EXISTS(SELECT TOP 1 1 FROM #NewClients)
	BEGIN
		
		SELECT 
			@CODE_CUSTOMER = CODE_CUSTOMER
		FROM #NewClients


		BEGIN TRY
			INSERT INTO ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_cliente_potencial]
			SELECT
				'ACSA' as Empresa
				,(CASE WHEN scn.NIT='...' or scn.NIT IS NULL THEN 'C.F.' ELSE scn.NIT END) as NIT
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
			--PRINT 'INSERTO CLIENTE: '+@CODE_CUSTOMER
			UPDATE [acsa].SWIFT_CUSTOMERS_NEW
				SET IS_POSTED_ERP = 1, 
					POSTED_RESPONSE = 'Proceso Exitoso',
					POSTED_ERP=GETDATE()
				WHERE CODE_CUSTOMER = @CODE_CUSTOMER
			--PRINT 'ACTUALIZO CLIENTE: '+@CODE_CUSTOMER
		END TRY
		BEGIN CATCH
			ROLLBACK
			UPDATE [acsa].SWIFT_CUSTOMERS_NEW
				SET POSTED_RESPONSE = ERROR_MESSAGE(),
					POSTED_ERP=GETDATE(),
					ATTEMPTED_WITH_ERROR = ISNULL(ATTEMPTED_WITH_ERROR,0)+1
				WHERE CODE_CUSTOMER = @CODE_CUSTOMER
			--PRINT 'ERROR CON CLIENTE: '+@CODE_CUSTOMER
		END CATCH

		DELETE FROM #NewClients WHERE CODE_CUSTOMER = @CODE_CUSTOMER
		--FETCH NEXT FROM Customer_Cursor;  
	END;  
	--CLOSE Customer_Cursor;  
	--DEALLOCATE Customer_Cursor;


END


