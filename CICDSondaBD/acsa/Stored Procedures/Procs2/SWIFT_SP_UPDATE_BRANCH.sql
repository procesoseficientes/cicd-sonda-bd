CREATE PROC [acsa].[SWIFT_SP_UPDATE_BRANCH]
@BRANCH_PK INT,
@BRANCH_CODE VARCHAR(50),
@CUSTOMER_CODE VARCHAR(50),
@BRANCH_PDE VARCHAR(50),
@BRANCH_NAME VARCHAR(150),
@BRANCH_ADDRESS VARCHAR(350),
@GEO_ROUTE VARCHAR(50),
@GPS_LAT_LON VARCHAR(150),
@PHONE VARCHAR(25),
@DELIVERY_EMAIL VARCHAR(200),
@RECOLLECT_EMAIL VARCHAR(200),
@STATUS VARCHAR(20),
@CONTACT_NAME VARCHAR(150),
@IS_DEFAULT INT,
@LAST_UPDATED_BY VARCHAR(25)
AS
UPDATE acsa.SWIFT_BRANCHES SET 
	CUSTOMER_CODE		= @CUSTOMER_CODE,
	BRANCH_PDE			= @BRANCH_PDE,
	BRANCH_NAME			= @BRANCH_NAME,
	BRANCH_ADDRESS		= @BRANCH_ADDRESS,
	GEO_ROUTE			= @GEO_ROUTE,
	GPS_LAT_LON			= @GPS_LAT_LON,
	PHONE				= @PHONE,
	DELIVERY_EMAIL		= @DELIVERY_EMAIL,
	RECOLLECT_EMAIL		= @RECOLLECT_EMAIL,
	[STATUS]			= @STATUS,
	CONTACT_NAME		= @CONTACT_NAME,
	IS_DEFAULT			= @IS_DEFAULT,
	LAST_UPDATED		= GETDATE(),
	LAST_UPDATED_BY		= @LAST_UPDATED_BY
WHERE
	BRANCH_PK = @BRANCH_PK
