﻿-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	06-10-2016 @ A-TEAM Sprint 2
-- Description:			SP que almacena el Encabezado de los 
-- 						Documentos de Devolucion de Inventario

/*
-- Ejemplo de Ejecucion:
		--
		EXEC [acsa].SONDA_SP_INSERT_DEVOLUTION_HEADER
			@CODE_CUSTOMER = 'BO-2091'
			,@DOC_SERIE = ''
			,@DOC_NUM = 1
			,@CODE_ROUTE = 'RUDI@acsa'
			,@GPS_URL = '0,0'
			,@POSTED_BY = 'RUDI@acsa'
			,@LAST_UPDATE_BY = 'RUDI@acsa'
			,@TOTAL_AMOUNT = 10000
			,@IMG_1 = ''
			,@IMG_2 = ''
			,@IMG_3 = ''
			-- 
			SELECT * FROM [acsa].SONDA_DEVOLUTION_INVENTORY_HEADER
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_INSERT_DEVOLUTION_HEADER]
(
	@CODE_CUSTOMER VARCHAR(250)
	,@DOC_SERIE VARCHAR(250)
	,@DOC_NUM INT
	,@CODE_ROUTE VARCHAR(50)
	,@GPS_URL VARCHAR(250)
	,@POSTED_BY VARCHAR(250)
	,@LAST_UPDATE_BY VARCHAR(250)
	,@TOTAL_AMOUNT NUMERIC(18,6)
	,@IMG_1 VARCHAR(MAX)
	,@IMG_2 VARCHAR(MAX)
	,@IMG_3 VARCHAR(MAX)
) AS
BEGIN
	--
	DECLARE @DEVOLUTION_ID INT = NULL
	--
	BEGIN TRY
		INSERT INTO [acsa].[SONDA_DEVOLUTION_INVENTORY_HEADER](
			[CODE_CUSTOMER]
			,[DOC_SERIE]
			,[DOC_NUM]
			,[CODE_ROUTE]
			,[GPS_URL]
			,[POSTED_DATETIME]
			,[POSTED_BY]
			,[LAST_UPDATE]
			,[LAST_UPDATE_BY] 
			,[TOTAL_AMOUNT] 
			,[IS_POSTED] 
			,[IMG_1]
			,[IMG_2]
			,[IMG_3]
		)
		VALUES (
			@CODE_CUSTOMER
			,@DOC_SERIE
			,@DOC_NUM
			,@CODE_ROUTE
			,@GPS_URL
			,GETDATE()
			,@POSTED_BY
			,GETDATE()
			,@LAST_UPDATE_BY
			,@TOTAL_AMOUNT
			,1
			,@IMG_1
			,@IMG_2
			,@IMG_3
		)
		--
		SET @DEVOLUTION_ID = SCOPE_IDENTITY()
		--
		UPDATE [acsa].SWIFT_DOCUMENT_SEQUENCE SET CURRENT_DOC = @DOC_NUM WHERE SERIE = @DOC_SERIE AND ASSIGNED_TO = @CODE_ROUTE
		--
		SELECT @DEVOLUTION_ID AS DEVOLUTION_ID
		--
	END TRY
	BEGIN CATCH
		DECLARE @ERROR VARCHAR(MAX)
		SET @ERROR = ERROR_MESSAGE()
		RAISERROR(@ERROR,16,1)
	END CATCH
END

