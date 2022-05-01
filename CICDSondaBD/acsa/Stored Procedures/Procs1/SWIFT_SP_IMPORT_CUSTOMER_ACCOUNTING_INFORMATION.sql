-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	4/29/2018 @ G-FORCE TEAM - Sprint CASTOR
-- Description:			SP que importa la informacion contable de los clientes (limite de credito, dias de credito, condiciones de pago)
      
/*
-- Ejemplo de Ejecucion:
      		EXEC [acsa].[SWIFT_SP_IMPORT_CUSTOMER_ACCOUNTING_INFORMATION]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_IMPORT_CUSTOMER_ACCOUNTING_INFORMATION]
AS
	BEGIN
--
		SET NOCOUNT ON;
--
		DECLARE	@QUERY VARCHAR(MAX);

		BEGIN TRY
			-- -------------------------------------------------------------
			-- Definimos la tabla temporal que almacenara los clientes
			-- -------------------------------------------------------------
			CREATE TABLE [#CUSTOMER]
				(
					[CUSTOMER_ID] INT IDENTITY(1 ,1)
										PRIMARY KEY
					,[CODE_CUSTOMER] VARCHAR(250)
				);


			-- ------------------------------------------------------------
			-- Definimos tabla para almacenar las facturas
			-- ------------------------------------------------------------
			CREATE TABLE [#CUSTOMER_ACCOUNTING_INFORMATION]
				(
					[ID] INT IDENTITY(1 ,1)
					,[CODE_CUSTOMER] VARCHAR(250)
					,[GROUP_NUM] INT
					,[CREDIT_LIMIT] NUMERIC(18 ,6)
					,[OUTSTANDING_BALANCE] NUMERIC(18 ,6)
					,[EXTRA_DAYS] INT
				);

			-- -------------------------------------------------------------
			-- Creamos un indice sobre la tabla
			-- -------------------------------------------------------------
			CREATE NONCLUSTERED INDEX [IDX_CUSTOMER_TO_PROCESS]
			ON [#CUSTOMER]
			([CUSTOMER_ID], [CODE_CUSTOMER]);

			-- INICIAMOS TRANSACCION
			BEGIN TRAN;

			-- -------------------------------------------------------------
			-- Limpiamos la tabla
			-- -------------------------------------------------------------
			TRUNCATE TABLE [acsa].[SWIFT_CUSTOMER_ACCOUNTING_INFORMATION];

			-- -------------------------------------------------------------
			-- Obtenemos los clientes
			-- -------------------------------------------------------------
			INSERT	INTO [#CUSTOMER]
					(
						[CODE_CUSTOMER]
						
					)
			SELECT
				[CODE_CUSTOMER]
			FROM
				[acsa].[SWIFT_VIEW_ALL_COSTUMER];

			-- ------------------------------------------------------------
			-- Armamos y Ejecutamos la consulta
			-- ------------------------------------------------------------
			SELECT
				@QUERY = '
				INSERT INTO [#CUSTOMER_ACCOUNTING_INFORMATION]
					SELECT 
						AI.CODE_CUSTOMER
						,AI.GROUP_NUM
						,AI.CREDIT_LIMIT
						,AI.OUTSTANDING_BALANCE
						,AI.EXTRA_DAYS
					FROM OPENQUERY([DIPROCOM_SERVER], ''
						SELECT 
							C.CardCode CODE_CUSTOMER
							, C.GroupNum GROUP_NUM
							, C.CreditLine CREDIT_LIMIT
							, (C.CreditLine - C.Balance) OUTSTANDING_BALANCE
							, CP.ExtraDays EXTRA_DAYS
						FROM ME_LLEGA_DB.DBO.OCRD AS C
						INNER JOIN ME_LLEGA_DB.DBO.OCTG AS CP
						ON(CP.GroupNum = C.GroupNum)
				'') AS AI
				INNER JOIN #CUSTOMER AS VC
				ON ([AI].CODE_CUSTOMER COLLATE DATABASE_DEFAULT = [VC].[CODE_CUSTOMER] COLLATE DATABASE_DEFAULT)
					';
			EXECUTE (@QUERY);

				-- -------------------------------------------------------------------
				-- Insertamos en nuestra tabla que almacena toda la informacion
				-- -------------------------------------------------------------------
			INSERT	INTO [acsa].[SWIFT_CUSTOMER_ACCOUNTING_INFORMATION]
					(
						[CODE_CUSTOMER]
						,[GROUP_NUM]
						,[CREDIT_LIMIT]
						,[OUTSTANDING_BALANCE]
						,[EXTRA_DAYS]
					)
			SELECT
				[CODE_CUSTOMER]
				,[GROUP_NUM]
				,[CREDIT_LIMIT]
				,[OUTSTANDING_BALANCE]
				,[EXTRA_DAYS]
			FROM
				[#CUSTOMER_ACCOUNTING_INFORMATION]
			WHERE
				[ID] > 0;

			-- FINALIZAMOS TRANSACCION
			COMMIT;
		END TRY
		BEGIN CATCH
			--
			DECLARE	@ERROR_MESSAGE VARCHAR(MAX);
			SET @ERROR_MESSAGE = ERROR_MESSAGE();

			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK;
			END;

			--
			EXEC [acsa].[SONDA_SP_INSERT_SONDA_SERVER_ERROR_LOG] @CODE_ROUTE = '' , -- varchar(50)
				@LOGIN = '' , -- varchar(50)
				@SOURCE_ERROR = 'SWIFT_SP_IMPORT_CUSTOMER_ACCOUNTING_INFORMATION' , -- varchar(250)
				@DOC_RESOLUTION = '' , -- varchar(100)
				@DOC_SERIE = '' , -- varchar(100)
				@DOC_NUM = 0 , -- int
				@MESSAGE_ERROR = @ERROR_MESSAGE , -- varchar(max)
				@SEVERITY_CODE = 6000; -- int
			
			--
		END CATCH;

	END;
