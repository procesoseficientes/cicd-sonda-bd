﻿CREATE PROC [acsa].[SWIFT_SP_INSERT_PRICE_LIST_BY_CUSTOMER]
	@CODE_PRICE_LIST VARCHAR(25)	
	, @CODE_CUSTOMER VARCHAR(50)
	, @pResult VARCHAR(250) OUTPUT
AS
BEGIN TRY
BEGIN
	BEGIN TRAN t1
		BEGIN
			DELETE acsa.SWIFT_PRICE_LIST_BY_CUSTOMER
			WHERE CODE_CUSTOMER = @CODE_CUSTOMER;
		
			INSERT INTO acsa.SWIFT_PRICE_LIST_BY_CUSTOMER(
				CODE_PRICE_LIST
				, CODE_CUSTOMER
			)
			VALUES(
				@CODE_PRICE_LIST
				, @CODE_CUSTOMER
			);
		END
	
	
	IF @@error = 0 BEGIN
		SELECT @pResult = 'OK'
		COMMIT TRAN t1
	END		
	ELSE BEGIN
		ROLLBACK TRAN t1
		SELECT	@pResult	= ERROR_MESSAGE()
	END
END
END TRY
BEGIN CATCH
     ROLLBACK TRAN t1
	 SELECT  -1 as Resultado , ERROR_MESSAGE() Mensaje ,  @@ERROR Codigo 
END CATCH



