-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	21-Nov-16 @ A-TEAM Sprint 5 
-- Description:			SP que administra el proceso de generar las bonificaciones por multiplo para los clientes que esten en ambas casos de los acuerdos comerciales

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GENERATE_BONUS_MULTIPLE_FOR_DUPLICATE_CUSTOMER]
					@CODE_ROUTE = 'RUDI@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GENERATE_BONUS_MULTIPLE_FOR_DUPLICATE_CUSTOMER](
	@CODE_ROUTE VARCHAR(250)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE
		@DESCRIPTION VARCHAR(250)
		,@SP NVARCHAR(500)
		,@ORDER INT
	--
	DECLARE @PROC TABLE (
		[DESCRIPTION] VARCHAR(250)
		,[SP] VARCHAR(250)
		,[ORDER] INT
	)

	-- ------------------------------------------------------------------------------------
	-- Obtiene los clientes por ruta
	-- ------------------------------------------------------------------------------------
	INSERT INTO @PROC
			(
				[DESCRIPTION]
				,[SP]
				,[ORDER]
			)
	SELECT
		[BP].[DESCRIPTION]
		,[BP].[SP_SWIFT_EXPRESS_BY_MULTIPLE]
		,[ORDER]
	FROM [acsa].[SWIFT_BONUS_PRIORITY] [BP]
	WHERE [ACTIVE_SWIFT_INTERFACE_ONLINE] = 1
	ORDER BY [ORDER];

	-- ------------------------------------------------------------------------------------
	-- Recorre cada registro y lo manda a ejecutar
	-- ------------------------------------------------------------------------------------
	PRINT 'Inicia ciclo'
	--
	WHILE EXISTS(SELECT TOP 1 1 FROM @PROC)
	BEGIN
		-- ------------------------------------------------------------------------------------
		-- Obtiene el SP por ejecutar
		-- ------------------------------------------------------------------------------------
		SELECT TOP 1
			@DESCRIPTION = [DESCRIPTION]
			,@SP = SP
			,@ORDER = [ORDER]
		FROM @PROC
		ORDER BY [ORDER]
		--
		PRINT '@DESCRIPTION: ' + @DESCRIPTION
		PRINT '@SP: ' + @SP

		-- ------------------------------------------------------------------------------------
		-- Ejecuta el SP
		-- ------------------------------------------------------------------------------------
		SET @SP = @SP + ' @CODE_ROUTE = ' + CAST(@CODE_ROUTE AS VARCHAR) + ' , @ORDER = ' + CAST(@ORDER AS VARCHAR)
		--
		PRINT '@SP: ' + @SP
		--
		EXEC(@SP)
		--
		PRINT 'Ejecucion exitosa'

		-- ------------------------------------------------------------------------------------
		-- Elimina el cliente actual por ruta
		-- ------------------------------------------------------------------------------------
		DELETE FROM @PROC WHERE [ORDER] = @ORDER AND [DESCRIPTION] = @DESCRIPTION
		--
		PRINT 'Elimina registro'
	END
	--
	PRINT 'Termina ciclo'
END


