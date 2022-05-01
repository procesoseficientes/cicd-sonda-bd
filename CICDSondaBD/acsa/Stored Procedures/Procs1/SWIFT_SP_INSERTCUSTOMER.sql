﻿CREATE PROC [acsa].[SWIFT_SP_INSERTCUSTOMER]
@CODE_CUSTOMER VARCHAR(50),
@NAME_CUSTOMER VARCHAR(50),
@CLASSIFICATION_CUSTOMER VARCHAR(50) = NULL,
@PHONE_CUSTOMER VARCHAR(50) = NULL,
@ADDRESS_CUSTOMER VARCHAR(MAX) = NULL,
@CONTACT_CUSTOMER VARCHAR(50) = NULL,
@CODE_ROUTE VARCHAR(50),
@SELLER_CODE VARCHAR(50) = NULL,
@LAST_UPDATE VARCHAR(50) = NULL,
@LAST_UPDATE_BY VARCHAR(50),
@HHID VARCHAR(50) = NULL,
@ResultCode VARCHAR(50) = NULL OUTPUT
AS

DECLARE @ID INT

IF @HHID IS NOT NULL
BEGIN
	--DECLARE @return_value int,
 --         @pID numeric(18, 0)
	--EXEC @return_value = [acsa].[SWIFT_SP_GET_NEXT_SEQUENCE] @SEQUENCE_NAME = N'CUSTOMER',
 --                                                             @pRESULT = @ResultCode OUTPUT

	EXEC @CODE_CUSTOMER = acsa.SWIFT_GET_NEW_SEQVAL_CUSTOMER
END

INSERT INTO [acsa].[SWIFT_CUSTOMERS]
           ([CODE_CUSTOMER]
           ,[NAME_CUSTOMER]
		   ,[CLASSIFICATION_CUSTOMER]
           ,[PHONE_CUSTOMER]
           ,[ADRESS_CUSTOMER]
           ,[CONTACT_CUSTOMER]
           ,[CODE_ROUTE]
           ,[LAST_UPDATE]
           ,[LAST_UPDATE_BY]
           ,[SELLER_DEFAULT_CODE])
     VALUES
           (@CODE_CUSTOMER
           ,@NAME_CUSTOMER
		   ,@CLASSIFICATION_CUSTOMER
           ,@PHONE_CUSTOMER
           ,@ADDRESS_CUSTOMER
           ,@NAME_CUSTOMER
           ,@CODE_ROUTE
           ,CURRENT_TIMESTAMP
           ,@LAST_UPDATE_BY
           ,@SELLER_CODE)


INSERT INTO SWIFT_CUSTOMER_FREQUENCY(CODE_CUSTOMER, LAST_UPDATED, LAST_UPDATED_BY, LAST_DATE_VISITED)
VALUES(@CODE_CUSTOMER, CURRENT_TIMESTAMP, @LAST_UPDATE_BY, CURRENT_TIMESTAMP)

SET @ResultCode = @CODE_CUSTOMER

