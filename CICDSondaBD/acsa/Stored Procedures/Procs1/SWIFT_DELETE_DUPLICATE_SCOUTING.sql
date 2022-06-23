-- =============================================
--  Autor:		
-- Fecha de Creacion: 	
-- Description:		

/*
-- Ejemplo de Ejecucion:
		USE $(CICDSondaBD)
		GO

		EXEC  ACSA.SWIFT_DELETE_DUPLICATE_SCOUTING
*/

-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_DELETE_DUPLICATE_SCOUTING]
	AS
	BEGIN

	DECLARE @CODE_CUSTOMER VARCHAR(100)
	,@CS INT

	SELECT CODE_CUSTOMER, COUNT(*) [TOTAL]
		INTO #DD
		FROM ACSA.SWIFT_CUSTOMERS_NEW WITH (NOLOCK)
		WHERE POST_DATETIME>= format (GETDATE()-5,'yyyyMMdd')
		GROUP BY CODE_CUSTOMER
		HAVING COUNT(*)>1


	WHILE EXISTS(SELECT TOP 1 1 FROM #DD)
	BEGIN
		-- ------------------------------------------------------------------------------------
		-- Obtiene el registro de cliente a eliminar
		-- ------------------------------------------------------------------------------------
		SELECT TOP 1
			@CODE_CUSTOMER= DD.CODE_CUSTOMER
		FROM #DD DD
		
		SELECT @CS = MIN (CUSTOMER)
		FROM acsa.SWIFT_CUSTOMERS_NEW
		WHERE CODE_CUSTOMER = @CODE_CUSTOMER

		-- ------------------------------------------------------------------------------------
		-- Elimina el cliente 
		-- ------------------------------------------------------------------------------------

		DELETE FROM acsa.SWIFT_CUSTOMERS_NEW
		WHERE CODE_CUSTOMER=@CODE_CUSTOMER
		AND CUSTOMER NOT IN (@CS)
		
		-- ------------------------------------------------------------------------------------
		-- Inserta en el log
		-- ------------------------------------------------------------------------------------
		
		INSERT INTO [acsa].[SWIFT_CUSTOMERS_NEW_DUP_LOG] VALUES (@CODE_CUSTOMER, GETDATE())
		
		-- ------------------------------------------------------------------------------------
		-- Elimina el cliente de la temporal
		-- ------------------------------------------------------------------------------------
		DELETE FROM #DD WHERE CODE_CUSTOMER = @CODE_CUSTOMER
	END

END
