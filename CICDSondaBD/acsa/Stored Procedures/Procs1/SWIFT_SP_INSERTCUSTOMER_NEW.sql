﻿-- =============================================
-- Autor:				erick.morales
-- Fecha de Creacion: 	01-10-2015
-- Description:			Inserta los clientes de scouting de Sonda

--Modificacion 24-11-2015
		-- alberto.ruiz
		-- Se agregaron los siguientes parametros: @POS_SALE_NAME, @INVOICE_NAME, @INVOICE_ADDRESS, @NIT, @CONTACT_ID

--Modificacion 14-12-2015
		-- José Roberto
		-- Se agregaron los 2 nuevos campos [LATITUDE]-[LONGITUDE] para la correcta inserción en la tabla
		-- de los nuevos valors del GPS

-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_INSERTCUSTOMER_NEW]
	@CODE_CUSTOMER VARCHAR(50)
	,@NAME_CUSTOMER VARCHAR(50)
	,@CLASSIFICATION_CUSTOMER VARCHAR(50) = NULL
	,@PHONE_CUSTOMER VARCHAR(50) = NULL
	,@ADDRESS_CUSTOMER VARCHAR(MAX) = NULL
	,@CONTACT_CUSTOMER VARCHAR(50) = NULL
	,@CODE_ROUTE VARCHAR(50)
	,@SELLER_CODE VARCHAR(50) = NULL
	,@LAST_UPDATE VARCHAR(50) = NULL
	,@LAST_UPDATE_BY VARCHAR(50)
	,@HHID VARCHAR(50) = NULL
	,@SING VARCHAR(MAX) = NULL
	,@PHOTO VARCHAR(MAX) = NULL
	,@STATUS VARCHAR(20) = NULL
	,@NEW VARCHAR(10) = 1
	,@GPS VARCHAR(MAX) = '0,0'
	,@REFERENCE VARCHAR(150) = NULL
	,@ResultCode VARCHAR(50) = NULL OUTPUT
	,@POST_DATETIME datetime = NULL
	,@POS_SALE_NAME VARCHAR(150) = '...'
	,@INVOICE_NAME VARCHAR(150) = '...'
	,@INVOICE_ADDRESS VARCHAR(150) = '...'
	,@NIT VARCHAR(150) = '...'
	,@CONTACT_ID VARCHAR(150) = '...'
AS

DECLARE @ID INT
		,@NEW_ID INT

IF @HHID IS NOT NULL
BEGIN
	EXEC @NEW_ID = acsa.SWIFT_GET_NEW_SEQVAL_CUSTOMER
END

INSERT INTO [acsa].[SWIFT_CUSTOMERS_NEW](
	[CODE_CUSTOMER]
	,[NAME_CUSTOMER]
	,[CLASSIFICATION_CUSTOMER]
	,[PHONE_CUSTOMER]
	,[ADRESS_CUSTOMER]
	,[CONTACT_CUSTOMER]
	,[CODE_ROUTE]
	,[LAST_UPDATE]
	,[LAST_UPDATE_BY]
	,[SELLER_DEFAULT_CODE]
	,[SIGN]
	,[PHOTO]
	,[STATUS]
	,[NEW]
	,[GPS]
	,[CODE_CUSTOMER_HH]
	,[REFERENCE]
	,[POST_DATETIME]
	,[POS_SALE_NAME]
	,[INVOICE_NAME]
	,[INVOICE_ADDRESS]
	,[NIT]
	,[CONTACT_ID]
	,[LATITUDE]
	,[LONGITUDE]
)
VALUES (
    @NEW_ID
    ,@NAME_CUSTOMER
	,@CLASSIFICATION_CUSTOMER
    ,@PHONE_CUSTOMER
    ,@ADDRESS_CUSTOMER
    ,@CONTACT_CUSTOMER
    ,@CODE_ROUTE
    ,CURRENT_TIMESTAMP
    ,@LAST_UPDATE_BY
    ,@SELLER_CODE
	,@SING
	,@PHOTO
	,@STATUS
	,@NEW
	,@GPS
    ,@CODE_CUSTOMER
	,@REFERENCE
	,@POST_DATETIME
	,@POS_SALE_NAME
	,@INVOICE_NAME
	,@INVOICE_ADDRESS
	,@NIT
	,@CONTACT_ID
	,RTRIM(LTRIM(SUBSTRING(@GPS,1,CHARINDEX(',',@GPS) - 1)))
	,RTRIM(LTRIM(SUBSTRING(@GPS,CHARINDEX(',',@GPS) + 1,LEN(@GPS))))
)


INSERT INTO [acsa].[SWIFT_CUSTOMER_FREQUENCY_NEW]
	(
	CODE_CUSTOMER
	,LAST_UPDATED
	,LAST_UPDATED_BY
	,LAST_DATE_VISITED
	)
VALUES
	(
	@NEW_ID
	,CURRENT_TIMESTAMP
	,@LAST_UPDATE_BY
	,CURRENT_TIMESTAMP
	)

SET @ResultCode = @NEW_ID 


