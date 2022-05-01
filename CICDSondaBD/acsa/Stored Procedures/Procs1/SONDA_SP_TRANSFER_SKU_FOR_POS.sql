-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	21-Oct-16 @ A-Team Sprint 3
-- Description:			SP que genera la transferencia de inventario para sondaPOS

-- Modificacion 27-Jan-17 @ A-Team Sprint Bankole
					-- alberto.ruiz
					-- Se agrega parametro para realizar la transferencia en linea o al inicio de ruta

/*
-- Ejemplo de Ejecucion:
				-- 
				EXEC [acsa].[SONDA_SP_TRANSFER_SKU_FOR_POS]
					@CODE_ROUTE = 'RUDI@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_TRANSFER_SKU_FOR_POS] (
	@CODE_ROUTE VARCHAR(250)
	,@IS_ONLINE INT = 0
	,@TRANSFER_ID INT = NULL
)AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE 
		@pRESULT VARCHAR(MAX)
		,@LOGIN VARCHAR(50)

	-- ------------------------------------------------------------------------------------
	-- Obtiene el usuario
	-- ------------------------------------------------------------------------------------
	SELECT TOP 1 @LOGIN = [u].[LOGIN]
	FROM [acsa].[USERS] [u]
	WHERE [u].[SELLER_ROUTE] = @CODE_ROUTE

	-- ------------------------------------------------------------------------------------
	-- Limpia los bonificaciones para la ruta
	-- ------------------------------------------------------------------------------------	
	EXEC [acsa].[SONDA_TRANSFER_SKU]
		@Login = @LOGIN
		,@Route = @CODE_ROUTE
		,@pRESULT = @pRESULT OUTPUT
		,@IS_ONLINE = @IS_ONLINE
		,@TRANSFER_ID = @TRANSFER_ID

	-- ------------------------------------------------------------------------------------
	-- Valida si hubo error
	-- ------------------------------------------------------------------------------------
	IF @pRESULT != 'OK'
	BEGIN  
    	RAISERROR(@pRESULT,16,1)
    END
	ELSE
	BEGIN
		SELECT 'Exito' [RESULT]
	END
END



