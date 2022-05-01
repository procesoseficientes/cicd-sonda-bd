﻿CREATE PROC [acsa].[SWIFT_INSERT_SELLER_BY_SKU]
@SKU_CODE NVARCHAR(40),
@SELLER_CODE NVARCHAR(40),
@LAST_UPDATE_BY NVARCHAR(30)
AS
--DECLARE @SELLER_CODE VARCHAR(150)
--DECLARE @SKU_CODE VARCHAR(150)
--SET @SELLER_CODE = '7'
--SET @SKU_CODE = '12233791'

IF @SKU_CODE  NOT IN(SELECT CODE_SKU FROM [acsa].SWIFT_SELLER_BY_SKU WHERE CODE_SELLER = @SELLER_CODE)
BEGIN
	INSERT INTO [acsa].SWIFT_SELLER_BY_SKU
	(CODE_SKU, CODE_SELLER, LAST_UPDATE, LAST_UPDATE_BY)
	VALUES (
	@SKU_CODE,
	@SELLER_CODE,
	GETDATE(),
	@LAST_UPDATE_BY)
END
--IF @SKU_CODE IN(SELECT CODE_SKU FROM [acsa].SWIFT_SELLER_BY_SKU WHERE CODE_SELLER = @SELLER_CODE)
--BEGIN
--	PRINT 'UPDATE'
--END

