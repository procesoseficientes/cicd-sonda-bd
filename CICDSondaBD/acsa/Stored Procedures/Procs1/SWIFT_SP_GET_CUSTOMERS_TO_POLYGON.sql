﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	22-01-2016
-- Description:			Obtiene los clientes de una ruta de scouting en base a la frecuencia y dias de visita

-- Modificacion 15-02-2016
				-- alberto.ruiz
				-- Se cambia la condicion de los dias de AND por OR

/*
-- Ejemplo de Ejecucion:
				-- 
				EXEC [acsa].[SWIFT_SP_GET_CUSTOMERS_TO_POLYGON]
					@CODE_ROUTE = 'Oper5@arium'
					,@FREQUENCY = 0
					,@SUNDAY = 0
					,@MONDAY = 0
					,@TUESDAY = 1
					,@WEDNESDAY = 1
					,@THURSDAY = 0
					,@FRIDAY = 0
					,@SATURDAY = 0
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CUSTOMERS_TO_POLYGON]
	@CODE_ROUTE VARCHAR(50)
	,@FREQUENCY INT = 1
	,@SUNDAY INT = 0
	,@MONDAY INT = 0
	,@TUESDAY INT = 0
	,@WEDNESDAY INT = 0
	,@THURSDAY INT = 0
	,@FRIDAY INT = 0
	,@SATURDAY INT = 0
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE 
		@SQL NVARCHAR(2000) = ''
		,@HAVE_DAY INT = 0
	--
	SELECT @HAVE_DAY = CASE WHEN 
			@SUNDAY = 1
			OR @MONDAY = 1
			OR @TUESDAY = 1
			OR @WEDNESDAY = 1
			OR @THURSDAY = 1
			OR @FRIDAY = 1
			OR @SATURDAY = 1
		THEN 1 ELSE 0 END

	SELECT @SQL = '
		SELECT TOP 5000
			C.[CODE_CUSTOMER]
			,C.[NAME_CUSTOMER]
			,C.[LONGITUDE]
			,C.[LATITUDE]
		FROM [acsa].[SWIFT_VIEW_LATLNG_X_CUSTOMER] C
		WHERE C.[SCOUTING_ROUTE] = ''' + @CODE_ROUTE + ''''
		+ CASE WHEN @FREQUENCY > 0 THEN ' AND C.FREQUENCY = ''' + CAST(@FREQUENCY AS VARCHAR) + '''' ELSE '' END
		+ CASE WHEN @HAVE_DAY = 1 THEN ' AND (' ELSE '' END
		+ CASE WHEN @SUNDAY = 1 THEN 'C.SUNDAY = 1' ELSE '' END
		+ CASE WHEN @MONDAY = 1 AND @SUNDAY = 1 THEN ' OR' ELSE '' END
		+ CASE WHEN @MONDAY = 1 THEN ' C.MONDAY = 1' ELSE '' END
		+ CASE WHEN @TUESDAY = 1 AND (@SUNDAY = 1 OR @MONDAY = 1) THEN ' OR' ELSE '' END
		+ CASE WHEN @TUESDAY = 1 THEN ' C.TUESDAY = 1' ELSE '' END
		+ CASE WHEN @WEDNESDAY = 1 AND (@SUNDAY = 1 OR @MONDAY = 1 OR @TUESDAY = 1) THEN ' OR' ELSE '' END
		+ CASE WHEN @WEDNESDAY = 1 THEN ' C.WEDNESDAY = 1' ELSE '' END
		+ CASE WHEN @THURSDAY = 1 AND (@SUNDAY = 1 OR @MONDAY = 1 OR @TUESDAY = 1 OR @WEDNESDAY = 1) THEN ' OR' ELSE '' END
		+ CASE WHEN @THURSDAY = 1 THEN ' C.THURSDAY = 1' ELSE '' END
		+ CASE WHEN @FRIDAY = 1 AND (@SUNDAY = 1 OR @MONDAY = 1 OR @TUESDAY = 1 OR @WEDNESDAY = 1 OR @THURSDAY = 1) THEN ' OR' ELSE '' END
		+ CASE WHEN @FRIDAY = 1 THEN ' C.FRIDAY = 1' ELSE '' END
		+ CASE WHEN @SATURDAY = 1 AND (@SUNDAY = 1 OR @MONDAY = 1 OR @TUESDAY = 1 OR @WEDNESDAY = 1 OR @THURSDAY = 1 OR @FRIDAY = 1) THEN ' OR' ELSE '' END
		+ CASE WHEN @SATURDAY = 1 THEN ' C.SATURDAY = 1' ELSE '' END
		+ CASE WHEN @HAVE_DAY = 1 THEN ')' ELSE '' END
	--
	PRINT '@CODE_ROUTE: ' + CAST(@CODE_ROUTE AS VARCHAR)
	PRINT '@FREQUENCY: ' + CAST(@FREQUENCY AS VARCHAR)
	PRINT '@SUNDAY: ' + CAST(@SUNDAY AS VARCHAR)
	PRINT '@MONDAY: ' + CAST(@MONDAY AS VARCHAR)
	PRINT '@TUESDAY: ' + CAST(@TUESDAY AS VARCHAR)
	PRINT '@WEDNESDAY: ' + CAST(@WEDNESDAY AS VARCHAR)
	PRINT '@THURSDAY: ' + CAST(@THURSDAY AS VARCHAR)
	PRINT '@FRIDAY: ' + CAST(@FRIDAY AS VARCHAR)
	PRINT '@SATURDAY: ' + CAST(@SATURDAY AS VARCHAR)
	PRINT '@SQL: ' + @SQL
	--
	EXEC SP_EXECUTESQL @SQL
END

