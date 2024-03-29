﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	29-Sep-16 @ A-TEAM Sprint 2
-- Description:			Obtine los clientes del poligono de un dia y tipo especifico

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_CUSTOMER_IN_POLYGON_BY_SELLER]
					@POLYGON_ID = 67
					,@TYPE_TASK = 'PRESALE'
					,@FREQUENCY_WEEKS = 1
					,@DAY = 1
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CUSTOMER_IN_POLYGON_BY_SELLER] (
	@POLYGON_ID INT
	,@TYPE_TASK VARCHAR(50)
	,@FREQUENCY_WEEKS INT
	,@DAY INT
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @QUERY NVARCHAR(1000) = N''
	--
	SELECT @QUERY = 'SELECT DISTINCT
			[C].[CODE_CUSTOMER]
			,[C].[NAME_CUSTOMER]
			,[C].[ADRESS_CUSTOMER]
			,[SC].[CODE_CHANNEL]
			,[SC].[NAME_CHANNEL]
		FROM [acsa].[SWIFT_POLYGON_BY_ROUTE] [PBR]
		INNER JOIN [acsa].[SWIFT_ROUTES] [R] ON (
			[R].[ROUTE] = [PBR].[ROUTE]
		)
		INNER JOIN [acsa].[SWIFT_FREQUENCY] [F] ON (
			[F].[CODE_ROUTE] = [R].[CODE_ROUTE]
		)
		INNER JOIN [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] [FXC] ON (
			[FXC].[ID_FREQUENCY] = [F].[ID_FREQUENCY]
		)
		INNER JOIN [acsa].[SWIFT_VIEW_ALL_COSTUMER] C ON (
			[C].[CODE_CUSTOMER] = [FXC].[CODE_CUSTOMER]
		)
		LEFT JOIN [acsa].[SWIFT_CHANNEL_X_CUSTOMER] CXC ON (
			[CXC].[CODE_CUSTOMER] = [C].[CODE_CUSTOMER]
		)
		LEFT JOIN [acsa].[SWIFT_CHANNEL] SC ON (
			[SC].[CHANNEL_ID] = [CXC].[CHANNEL_ID]
		)
		WHERE [PBR].[POLYGON_ID] = ' + CAST(@POLYGON_ID AS VARCHAR)
			+ ' AND [F].[TYPE_TASK] = ''' + @TYPE_TASK + ''''
			+ ' AND [F].[FREQUENCY_WEEKS] = ' + CAST(@FREQUENCY_WEEKS AS VARCHAR)
			+ CASE CAST(@DAY AS VARCHAR)
				WHEN '1' THEN ' AND [F].[SUNDAY] = 1'
				WHEN '2' THEN ' AND [F].[MONDAY] = 1'
				WHEN '3' THEN ' AND [F].[TUESDAY] = 1'
				WHEN '4' THEN ' AND [F].[WEDNESDAY] = 1'
				WHEN '5' THEN ' AND [F].[THURSDAY] = 1'
				WHEN '6' THEN ' AND [F].[FRIDAY] = 1'
				WHEN '7' THEN ' AND [F].[SATURDAY] = 1'
			END
	--
	PRINT '@QUERY: ' + @QUERY
	--
	EXEC(@QUERY);
END

