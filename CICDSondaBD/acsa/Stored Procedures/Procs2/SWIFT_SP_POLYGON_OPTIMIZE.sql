-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	31-08-2016
-- Description:			SP que ordena la prioridad de la frecuencia en base de quien esta mas cerca de la bodega y luego al cliente mas cercano

-- Modificacion:		    hector.gonzalez
-- Fecha de Creacion: 	05-09-2016
-- Descripcion:			    Se agrego parametro @DISTANCE 

-- Modificacion 25-Apr-17 @ A-Team Sprint Hondo
-- alberto.ruiz
-- Se agrego que valide si el vendedor tiene GPS, si tiene ese es su punto de partida y si es nulo, vacio o 0,0 debe de ser el del CDD

-- Modificacion 12-Jun-17 @ A-Team Sprint Jibade
-- alberto.ruiz
-- Se agrego que optimice por cada tipo de tarea la frecuencia

-- Modificacion 26-03-2019
-- alejandro.ochoa
-- Se agregan rutas multifrecuencias y se optimiza todos los clientes de cada ruta sin importar la frecuencia (para que no se resetee el orden en cada frecuencia)
-- y se agrega filtro para que optimice solo las frecuencias del dia

/*
-- Ejemplo de Ejecucion:
				-- 
				EXEC [acsa].[SWIFT_SP_POLYGON_OPTIMIZE]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_POLYGON_OPTIMIZE]
AS
BEGIN
	SET NOCOUNT ON;
	--
	CREATE TABLE #CUSTOMER (
		ID_FREQUENCY INT
		,CODE_CUSTOMER VARCHAR(50)
		,[PRIORITY] INT
		,GPS VARCHAR(50)
		,DISTANCE NUMERIC(18,6)
	)
	--
	DECLARE
		@TYPE_POLYGON_WITH_WAREHOUSE VARCHAR(50)
		,@TYPE_POLYGON_ROUTE VARCHAR(50)
		,@ID_FREQUENCY INT
		,@CODE_ROUTE VARCHAR(50)
		,@GPS_WAREHOUSE VARCHAR(50)
		,@PRIORITY INT
		,@CODE_CUSTOMER VARCHAR(50)
		,@GPS_CUSTOMER VARCHAR(50)
		,@DISTANCE FLOAT
		,@POLYGON_ID INT

	BEGIN TRAN
	BEGIN TRY
		-- ------------------------------------------------------------
		-- Obtiene parametros iniciales
		-- ------------------------------------------------------------
		SELECT 
			@TYPE_POLYGON_WITH_WAREHOUSE = acsa.SWIFT_FN_GET_PARAMETER('POLYGON','TYPE_POLYGON_WITH_WAREHOUSE')
			,@TYPE_POLYGON_ROUTE = acsa.SWIFT_FN_GET_PARAMETER('POLYGON','TYPE_POLYGON_ROUTE')
		
		-- ------------------------------------------------------------
		-- Obtiene las frecuencias para optimizar
		-- ------------------------------------------------------------
		--Poligonos de Frecuencia Unica y Multivendedor
		SELECT 
			[F].[ID_FREQUENCY]
			, CASE
				WHEN [S].[GPS] IS NULL THEN [W].[GPS_WAREHOUSE]
				WHEN [S].[GPS] = '' THEN [W].[GPS_WAREHOUSE]
				WHEN [S].[GPS] = '0,0' THEN [W].[GPS_WAREHOUSE]
				ELSE [S].[GPS]
			END [GPS_WAREHOUSE]
			,[PR].[POLYGON_ID]
			,[F].[CODE_ROUTE]
		INTO [#FREQUENCY]
		FROM [acsa].[SWIFT_FREQUENCY] [F]
		INNER JOIN [acsa].[SWIFT_FREQUENCY_BY_POLYGON] [PBR] ON (
			[PBR].[ID_FREQUENCY] = [F].[ID_FREQUENCY]
		)
		INNER JOIN [acsa].[SWIFT_POLYGON] [PR] ON (
			[PR].[POLYGON_ID] = [PBR].[POLYGON_ID]
		)
		INNER JOIN [acsa].[SWIFT_POLYGON] [PS] ON (
			[PR].[POLYGON_ID_PARENT] = [PS].[POLYGON_ID]
			AND [PR].[POLYGON_TYPE] = @TYPE_POLYGON_ROUTE
			AND [PS].[POLYGON_TYPE] = @TYPE_POLYGON_WITH_WAREHOUSE
		)
		INNER JOIN [acsa].[SWIFT_WAREHOUSES] [W] ON (
			[PS].[CODE_WAREHOUSE] = [W].[CODE_WAREHOUSE]
		)
		INNER JOIN [acsa].[USERS] [U] ON ([U].[SELLER_ROUTE] = [F].[CODE_ROUTE])
		INNER JOIN [acsa].[SWIFT_SELLER] [S] ON ([U].[RELATED_SELLER] = [S].[SELLER_CODE])
		WHERE [PS].[CODE_WAREHOUSE] IS NOT NULL 
		AND (CASE DATEPART(WEEKDAY,GETDATE()) 
			WHEN 1 THEN [F].[SUNDAY]	WHEN 2 THEN [F].[MONDAY]
			WHEN 3 THEN [F].[TUESDAY]	WHEN 4 THEN [F].[WEDNESDAY]
			WHEN 5 THEN [F].[THURSDAY]	WHEN 6 THEN [F].[FRIDAY]
			WHEN 7 THEN [F].[SATURDAY]	END) = 1

		--Frecuencias Multiples
		INSERT INTO [#FREQUENCY]
		SELECT
			[F].[ID_FREQUENCY]
			, CASE
				WHEN [S].[GPS] IS NULL THEN [W].[GPS_WAREHOUSE]
				WHEN [S].[GPS] = '' THEN [W].[GPS_WAREHOUSE]
				WHEN [S].[GPS] = '0,0' THEN [W].[GPS_WAREHOUSE]
				ELSE [S].[GPS]
			END [GPS_WAREHOUSE]
			,[PR].[POLYGON_ID]
			,[F].[CODE_ROUTE]
		FROM   [acsa].[SWIFT_FREQUENCY] [F]
		LEFT JOIN [acsa].[SWIFT_FREQUENCY_BY_POLYGON] [PBR] ON (
			[PBR].[ID_FREQUENCY] = [F].[ID_FREQUENCY]
		)
		LEFT JOIN [acsa].[SWIFT_POLYGON] [PR] ON (
			[PR].[POLYGON_ID] = [F].[POLYGON_ID]
		)
		LEFT JOIN [acsa].[SWIFT_POLYGON] [PS] ON (
			[PR].[POLYGON_ID_PARENT] = [PS].[POLYGON_ID]
			AND [PR].[POLYGON_TYPE] = @TYPE_POLYGON_ROUTE
			AND [PS].[POLYGON_TYPE] = @TYPE_POLYGON_WITH_WAREHOUSE
		)
		LEFT JOIN [acsa].[SWIFT_WAREHOUSES] [W] ON (
			[PS].[CODE_WAREHOUSE] = [W].[CODE_WAREHOUSE]
		)
		INNER JOIN [acsa].[USERS] [U] ON ([U].[SELLER_ROUTE] = [F].[CODE_ROUTE])
		INNER JOIN [acsa].[SWIFT_SELLER] [S] ON ([U].[RELATED_SELLER] = [S].[SELLER_CODE])
		WHERE [PS].[CODE_WAREHOUSE] IS NOT NULL AND [PBR].[POLYGON_ID] IS NULL
		AND (CASE DATEPART(WEEKDAY,GETDATE()) 
			WHEN 1 THEN [F].[SUNDAY]	WHEN 2 THEN [F].[MONDAY]
			WHEN 3 THEN [F].[TUESDAY]	WHEN 4 THEN [F].[WEDNESDAY]
			WHEN 5 THEN [F].[THURSDAY]	WHEN 6 THEN [F].[FRIDAY]
			WHEN 7 THEN [F].[SATURDAY]	END) = 1
		-- ------------------------------------------------------------
		-- Recorre las frecuencias
		-- ------------------------------------------------------------
		WHILE EXISTS(SELECT TOP 1 1 FROM #FREQUENCY)
		BEGIN
			-- ------------------------------------------------------------
			-- Obtiene la Ruta para optimizar
			-- ------------------------------------------------------------
			SELECT TOP 1
				@CODE_ROUTE = [F].[CODE_ROUTE]
				,@GPS_WAREHOUSE = F.GPS_WAREHOUSE
				,@PRIORITY = 1
				,@POLYGON_ID = F.POLYGON_ID
			FROM #FREQUENCY F

			-- ------------------------------------------------------------
			-- Obtiene los clientes de todas las frecuencias de la Ruta
			-- ------------------------------------------------------------
			INSERT INTO #CUSTOMER
			SELECT
				FC.ID_FREQUENCY
				,FC.CODE_CUSTOMER
				,FC.[PRIORITY]
				,C.GPS
				,dbo.SONDA_FN_CALCULATE_DISTANCE(@GPS_WAREHOUSE,C.GPS) DISTANCE
			FROM acsa.SWIFT_FREQUENCY_X_CUSTOMER FC
			INNER JOIN acsa.SWIFT_VIEW_ALL_COSTUMER C ON (
				FC.CODE_CUSTOMER = [C].[CODE_CUSTOMER]
			)
			INNER JOIN [#FREQUENCY] F ON (
				[F].[ID_FREQUENCY] = [FC].[ID_FREQUENCY]
				AND [F].[CODE_ROUTE] = @CODE_ROUTE
			)

			ORDER BY 5 ASC

			-- ------------------------------------------------------------
			-- Obtiene el cliente mas cercano y su GPS
			-- ------------------------------------------------------------
			SELECT TOP 1
				@ID_FREQUENCY = [C].[ID_FREQUENCY]
				,@CODE_CUSTOMER = C.CODE_CUSTOMER
				,@GPS_CUSTOMER = C.GPS
				,@DISTANCE = C.DISTANCE
			FROM #CUSTOMER C
			ORDER BY DISTANCE ASC
			--
			PRINT '@ID_FREQUENCY: ' + CAST(@ID_FREQUENCY AS VARCHAR)
			PRINT '@CODE_ROUTE: ' + @CODE_ROUTE
			PRINT '@GPS_WAREHOUSE: ' + @GPS_WAREHOUSE
			PRINT '@CODE_CUSTOMER: ' + @CODE_CUSTOMER
			PRINT '@PRIORITY: ' + CAST(@PRIORITY AS VARCHAR)

			-- ------------------------------------------------------------
			-- Actualiza el cliente mas cercano
			-- ------------------------------------------------------------
			EXEC [acsa].[SWIFT_SP_SET_CUSTOMER_PRIORITY_IN_FREQUENCY]
					@ID_FREQUENCY = @ID_FREQUENCY
					,@CODE_CUSTOMER = @CODE_CUSTOMER
					,@PRIORITY = @PRIORITY
					,@DISTANCE = @DISTANCE
			--
			SET @PRIORITY = (@PRIORITY + 1)

			-- ------------------------------------------------------------
			-- Borra el cliente mas cercano
			-- ------------------------------------------------------------
			DELETE FROM #CUSTOMER WHERE CODE_CUSTOMER = @CODE_CUSTOMER

			WHILE EXISTS(SELECT TOP 1 1 FROM #CUSTOMER)
			BEGIN
				-- ------------------------------------------------------------
				-- Actualiza la distancia en base al ultimo cliente
				-- ------------------------------------------------------------
				UPDATE #CUSTOMER
				SET DISTANCE = dbo.SONDA_FN_CALCULATE_DISTANCE(@GPS_CUSTOMER,GPS)

				-- ------------------------------------------------------------
				-- Obtiene el cliente mas cercano y su GPS
				-- ------------------------------------------------------------
				SELECT TOP 1
					@ID_FREQUENCY = [C].[ID_FREQUENCY]
					,@CODE_CUSTOMER = C.CODE_CUSTOMER
					,@GPS_CUSTOMER = C.GPS
					,@DISTANCE = C.DISTANCE
				FROM #CUSTOMER C
				ORDER BY DISTANCE ASC
				--
				PRINT '------------------------------------------------'
				PRINT '@ID_FREQUENCY: ' + CAST(@ID_FREQUENCY AS VARCHAR)
				PRINT '@CODE_ROUTE: ' + @CODE_ROUTE
				PRINT '@GPS_CUSTOMER: ' + @GPS_CUSTOMER
				PRINT '@CODE_CUSTOMER: ' + @CODE_CUSTOMER
				PRINT '@PRIORITY: ' + CAST(@PRIORITY AS VARCHAR)

				-- ------------------------------------------------------------
				-- Actualiza el cliente mas cercano
				-- ------------------------------------------------------------
				EXEC [acsa].[SWIFT_SP_SET_CUSTOMER_PRIORITY_IN_FREQUENCY]
						@ID_FREQUENCY = @ID_FREQUENCY
						,@CODE_CUSTOMER = @CODE_CUSTOMER
						,@PRIORITY = @PRIORITY
						,@DISTANCE = @DISTANCE
				--
				SET @PRIORITY = (@PRIORITY + 1)

				-- ------------------------------------------------------------
				-- Borra el cliente mas cercano
				-- ------------------------------------------------------------
				DELETE FROM #CUSTOMER WHERE CODE_CUSTOMER = @CODE_CUSTOMER
			END 

			-- ------------------------------------------------------------
			-- Borra los registros de la Ruta actual
			-- ------------------------------------------------------------
			DELETE FROM #FREQUENCY WHERE [CODE_ROUTE] = @CODE_ROUTE

     	-- ------------------------------------------------------------
			-- Actualiza el LAST_OPTIMIZATION del poligono
			-- ------------------------------------------------------------

			UPDATE acsa.SWIFT_POLYGON
			SET LAST_OPTIMIZATION = GETDATE()
			WHERE POLYGON_ID = @POLYGON_ID;
			
			PRINT '@POLYGON: ' + CAST(@POLYGON_ID AS VARCHAR)
			PRINT '------------------------------------------------'
			PRINT '------------------------------------------------'

		END

		PRINT 'COMMIT'
		--
		COMMIT 
	END TRY
	BEGIN CATCH
		ROLLBACK
		DECLARE @ERROR VARCHAR(1000) = ERROR_MESSAGE()
		PRINT 'CATCH: ' + @ERROR
		RAISERROR (@ERROR,16,1)
	END CATCH
END
