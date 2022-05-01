/*=======================================================
-- Author:         alejandro.ochoa
-- Create date:    03-08-2017
-- Description:    Actualiza la informacion de GPS en la base intermedia de AX
				   

-- EJEMPLO DE EJECUCION: 
		EXEC [acsa].[SWIFT_SP_UPDATE_CUSTOMER_GPS_INFO]
=========================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_UPDATE_CUSTOMER_GPS_INFO] 
AS
BEGIN
	--
	SET NOCOUNT ON

	DECLARE @CODE_CUSTOMER VARCHAR(50)
	,@CODE_ROUTE VARCHAR(50)
	,@LONGITUDE VARCHAR(50)
	,@LATITUDE VARCHAR(50)
	,@CUSTOMERCHANGE VARCHAR(50)

	SELECT 
		[CUSTOMER],[POSTED_DATETIME] 
		INTO #CHANGES 
	FROM [acsa].[SWIFT_CUSTOMER_CHANGE]
	WHERE [STATUS]='ACCEPTED' AND ISNULL([IS_POSTED_ERP],0)=0

	WHILE EXISTS (SELECT TOP 1 1 FROM #CHANGES)
	BEGIN

		SELECT TOP 1
			@CUSTOMERCHANGE = [CUSTOMER]
		FROM #CHANGES
		ORDER BY [POSTED_DATETIME] ASC;
		--
		SELECT 
			@CODE_CUSTOMER = CODE_CUSTOMER
			,@CODE_ROUTE = [CODE_ROUTE]
			,@LATITUDE = ISNULL(SUBSTRING([GPS],1,CHARINDEX(',',[GPS],1)-1),'0')
			,@LONGITUDE = ISNULL(SUBSTRING([GPS],CHARINDEX(',',[GPS],1)+1,LEN([GPS])),'0')
		FROM [acsa].[SWIFT_CUSTOMER_CHANGE]
		WHERE [CUSTOMER] = @CUSTOMERCHANGE

		BEGIN TRY 
						
			DELETE FROM [ACSASERVER].[SONDA_ACSA_PRUEBAS].dbo.[mov_cliente_georeferencia]
			WHERE [ctacte] = @CODE_CUSTOMER 
			
			INSERT INTO [ACSASERVER].[SONDA_ACSA_PRUEBAS].dbo.[mov_cliente_georeferencia]
					(
						[empresa]
						,[ctacte]
						,[latitud]
						,[longitud]
						,[tipo_ctacte]
						,[usuario_grabo]
						,[fecha_grabo]
					)
			VALUES
					(
						'ACSA'  -- empresa - varchar(25)
						,@CODE_CUSTOMER  -- ctacte - varchar(45)
						,@LATITUDE  -- latitud - varchar(45)
						,@LONGITUDE  -- longitud - varchar(45)
						,'CLIENTE'  -- tipo_ctacte - varchar(10)
						,@CODE_ROUTE  -- usuario_grabo - varchar(25)
						,GETDATE()  -- fecha_grabo - datetime
					)

			UPDATE [acsa].[SWIFT_CUSTOMER_CHANGE]
			SET ATTEMPTED_WITH_ERROR = 0
				,IS_POSTED_ERP = 1
				,POSTED_ERP = GETDATE()
				,POSTED_RESPONSE = 'Proceso Exitoso'
			WHERE CUSTOMER = @CUSTOMERCHANGE 
		END TRY
		BEGIN CATCH
			UPDATE [acsa].[SWIFT_CUSTOMER_CHANGE]
			SET ATTEMPTED_WITH_ERROR = ISNULL(ATTEMPTED_WITH_ERROR,0)+1
				,IS_POSTED_ERP = 0
				,POSTED_ERP = GETDATE()
				,POSTED_RESPONSE = ERROR_MESSAGE()
			WHERE CUSTOMER = @CUSTOMERCHANGE 
		END CATCH
		--
		DELETE FROM #CHANGES WHERE [CUSTOMER] = @CUSTOMERCHANGE;

	END;
--
END





