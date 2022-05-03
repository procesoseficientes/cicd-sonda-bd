﻿CREATE PROC [acsa].[SWIFT_SP_UPDATE_PORTFOLIO]
	@CODE_PORTFOLIO VARCHAR(25)
	, @NAME_PORTFOLIO VARCHAR(50)
	, @COMMENT VARCHAR(250)
	, @LAST_UPDATE_BY VARCHAR(50)
	, @pResult VARCHAR(250) OUTPUT
AS
BEGIN
	
	BEGIN TRAN t1
		BEGIN
			UPDATE acsa.SWIFT_PORTFOLIO SET				
				NAME_PORTFOLIO = @NAME_PORTFOLIO
				, COMMENT = @COMMENT
				, LAST_UPDATE = GETDATE()
				, LAST_UPDATE_BY = @LAST_UPDATE_BY
			WHERE CODE_PORTFOLIO = @CODE_PORTFOLIO			
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



