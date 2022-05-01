-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	7/5/2018 @ G-FORCE-TEAM Sprint Faisan  
-- Description:			SP que obtiene los registros de la estadistica de preventa del usuario en base a la meta del equipo

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SONDA_SP_GET_SALE_STATISTIC_BY_SELLER]
				@CODE_ROUTE = '46'
*/
-- =============================================
CREATE PROCEDURE [dbo].[SONDA_SP_GET_SALE_STATISTIC_BY_SELLER]
	(
		@CODE_ROUTE VARCHAR(50)
	)
AS
	BEGIN
		SET NOCOUNT ON;
	--
		DECLARE
			@SELLER_TYPE VARCHAR(50)
			,@HAS_ACTIVE_GOAL INT = 0
			,@GOAL_HEADER_ID INT = -1
			,@GOAL_DETAIL_COUNT INT;

	-- --------------------------------------------------------------------------------------------------------------------------------------------
	-- Se obtiene el tipo del vendedor PRE = Pre-Venta / VEN
	-- --------------------------------------------------------------------------------------------------------------------------------------------
		SELECT TOP 1
			@SELLER_TYPE = [U].[USER_TYPE]
		FROM
			[acsa].[USERS] AS [U]
		WHERE
			[U].[SELLER_ROUTE] = @CODE_ROUTE;

	-- --------------------------------------------------------------------------------------------------------------------------------------------
	-- Se verifica si tiene alguna meta activa
	-- --------------------------------------------------------------------------------------------------------------------------------------------
		SELECT
			@HAS_ACTIVE_GOAL = COUNT(*)
		FROM
			[acsa].[SWIFT_STATISTICS_GOALS_BY_SALES] [S]
		WHERE
			[S].[CODE_ROUTE] = @CODE_ROUTE
			AND [S].[LAST_CREATED] = 1
			AND [S].[SALE_TYPE] = @SELLER_TYPE;

		IF (@HAS_ACTIVE_GOAL > 0)
		BEGIN
			print '1'
	--	--------------------------------------------------------------------------------------------------------------------------------------------
	-- Se obtiene la estadistica del vendedor
	-- --------------------------------------------------------------------------------------------------------------------------------------------
			SELECT
				s.[GOAL_HEADER_ID]
				,(
					SELECT TOP 1
						[T].[NAME_TEAM]
					FROM
						[acsa].[SWIFT_TEAM] AS [T]
					WHERE
						[T].[TEAM_ID] = S.[TEAM_ID]
					) AS [TEAM_NAME]
				,(
					SELECT TOP 1
						[GH].[GOAL_NAME]
					FROM
						[acsa].[SWIFT_GOAL_HEADER] AS [GH]
					WHERE
						[GH].[GOAL_HEADER_ID] = S.[GOAL_HEADER_ID]
					) AS [GOAL_NAME]
				,(CAST([RANKING] AS VARCHAR) + ' / '
					+ (CAST((
								SELECT
									COUNT(*)
								FROM
									[acsa].[SWIFT_USER_BY_TEAM] AS [T]
								WHERE
									[T].[TEAM_ID] = [S].[TEAM_ID]
							) AS VARCHAR))) AS [RANKING]
				,(
					SELECT TOP 1
						[GD].[GOAL_BY_SELLER]
					FROM
						[acsa].[SWIFT_GOAL_DETAIL] AS [GD]
					WHERE
						[GD].[SELLER_ID] = [S].[USER_ID]
						AND [GD].[GOAL_HEADER_ID] = [S].[GOAL_HEADER_ID]
					) AS [GOAL_AMOUNT]
				,[ACCUMULATED_BY_PERIOD] AS [ACCUMULATED_AMOUNT]
				,[PERCENTAGE_OF_GENERAL_GOAL] AS [GOAL_PERCENTAGE_COVERED]
				,[REMAINING_DAYS]
				,[DAILY_GOAL] AS [GOAL_AMOUNT_OF_DAY]
			FROM
				[acsa].[SWIFT_STATISTICS_GOALS_BY_SALES] AS [S]
				INNER JOIN [acsa].[SWIFT_GOAL_HEADER] AS [GH]
					ON	[GH].[GOAL_HEADER_ID] = [S].[GOAL_HEADER_ID]
			WHERE
				[S].[CODE_ROUTE] = @CODE_ROUTE
				AND [S].[LAST_CREATED] = 1
				AND [S].[SALE_TYPE] = @SELLER_TYPE
				AND [GH].[STATUS] = 'IN_PROGRESS';
		END;
		ELSE
		BEGIN
			DECLARE
				@GOAL_AMOUNT_OF_SELLER NUMERIC(18 ,6)
				,@DAILY_GOAL_OF_SELLER NUMERIC(18 ,6);
				print '2'
			-- -------------------------------------------------------------------------------------------------------------------------------
			-- Se obtiene el ID de la meta que esta por iniciar en el dia actual
			-- -------------------------------------------------------------------------------------------------------------------------------
			SELECT TOP 1
				@GOAL_HEADER_ID = [GD].[GOAL_HEADER_ID]
				,@GOAL_AMOUNT_OF_SELLER = [GD].[GOAL_BY_SELLER]
				,@DAILY_GOAL_OF_SELLER = [GD].[DAILY_GOAL_BY_SELLER]
			FROM
				[acsa].[SWIFT_GOAL_DETAIL] AS [GD]
			INNER JOIN [acsa].[SWIFT_GOAL_HEADER] AS [GH]
			ON	[GH].[GOAL_HEADER_ID] = [GD].[GOAL_HEADER_ID]
			INNER JOIN [acsa].[USERS] AS [U]
			ON	[U].[CORRELATIVE] = [GD].[SELLER_ID]
			WHERE
				[U].[SELLER_ROUTE] = @CODE_ROUTE
				AND [GH].[STATUS] = 'IN_PROGRESS'
				AND [GH].[SALE_TYPE] = @SELLER_TYPE;

			IF (@GOAL_HEADER_ID > 0) BEGIN
				-- -------------------------------------------------------------------------------------------------------------------------------
				-- Se obtiene la cantidad de operadores involucrados en el cumplimiento de la meta
				-- -------------------------------------------------------------------------------------------------------------------------------
				SELECT
					@GOAL_DETAIL_COUNT = COUNT(*)
				FROM
					[acsa].[SWIFT_GOAL_DETAIL]
				WHERE
					[GOAL_HEADER_ID] = @GOAL_HEADER_ID;

				-- -------------------------------------------------------------------------------------------------------------------------------
				-- Se obtiene la meta
				-- -------------------------------------------------------------------------------------------------------------------------------
				SELECT
					[GH].[GOAL_HEADER_ID]
					,[T].[NAME_TEAM] AS [TEAM_NAME]
					,[GH].[GOAL_NAME]
					,(CAST(@GOAL_DETAIL_COUNT AS VARCHAR) + ' / '
						+ CAST(@GOAL_DETAIL_COUNT AS VARCHAR)) AS [RANKING]
					,@GOAL_AMOUNT_OF_SELLER AS [GOAL_AMOUNT]
					,0 AS [ACCUMULATED_AMOUNT]
					,0 AS [GOAL_PERCENTAGE_COVERED]
					,[acsa].[SWIFT_FN_GET_LABOR_DAYS]([GH].[GOAL_DATE_FROM] ,
														[GH].[GOAL_DATE_TO] ,
														[GH].[INCLUDE_SATURDAY]) AS [REMAINING_DAYS]
					,@DAILY_GOAL_OF_SELLER AS [GOAL_AMOUNT_OF_DAY]
				FROM
					[acsa].[SWIFT_GOAL_HEADER] AS [GH]
				INNER JOIN [acsa].[SWIFT_TEAM] AS [T]
				ON	[T].[TEAM_ID] = [GH].[TEAM_ID]
				WHERE GH.[GOAL_HEADER_ID] = @GOAL_HEADER_ID
				AND [GH].[STATUS] = 'IN_PROGRESS';
			END;
		END;
	END;