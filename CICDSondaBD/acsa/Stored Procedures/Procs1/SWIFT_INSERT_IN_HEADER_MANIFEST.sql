-- =============================================
-- Autor Modificación:				pablo.aguilar
-- Fecha de Modificación: 			10-Oct-2016
-- Description:			   Se modifica sp para que almacene el nombre del conductor y la placa del vehiculo 

-- Autor Modificación:				pablo.aguilar
-- Fecha de Modificación: 			20-Oct-2016
-- Description:			   Se agrega nuevo parametro de manifest source. para identificar qie fuente tiene el manifiesto creado. 
/*
	Ejemplo Ejecucion: 
    EXEC [acsa].[SWIFT_INSERT_IN_HEADER_MANIFEST] @CODEMANIFEST = '123111'
												,@CODE_DRIVER = 'PL002'
												,@CODE_VEHICLE = '001'
												,@COMMENTS = 'ASDADSSADSADASD'
												,@LAST_UPDATE_BY = '2015-10-06 22:32:54.577'
												,@ROUTE = '4'
												,@pHeaderManifest = 0
												,@pResult = '' 
	
	


 */
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_INSERT_IN_HEADER_MANIFEST] @CODEMANIFEST VARCHAR(50),
@CODE_DRIVER VARCHAR(50),
@CODE_VEHICLE VARCHAR(50),
@COMMENTS VARCHAR(MAX),
@LAST_UPDATE_BY VARCHAR(50),
@ROUTE VARCHAR(50),
@MANIFEST_SOURCE VARCHAR(25) ='SWIFT_EXPRESS_R',
@pHeaderManifest INT OUTPUT,
@pResult VARCHAR(250) OUTPUT
AS
BEGIN
	BEGIN TRAN t1


	
	BEGIN
		DECLARE	@DRIVER_NAME AS VARCHAR(50)
				,@PLATE_VEHICLE AS VARCHAR(25)
				,@NAME_ROUTE AS VARCHAR(50)

		SELECT
			@DRIVER_NAME = [sd].[NAME_DRIVER]
		FROM [acsa].[SWIFT_DRIVERS] [sd]
		WHERE [sd].[CODE_DRIVER] = @CODE_DRIVER

		SELECT
			@NAME_ROUTE = [sr].[NAME_ROUTE]
		FROM [acsa].[SWIFT_ROUTES] [sr]
		WHERE [sr].[CODE_ROUTE] = @ROUTE

		SELECT
			@PLATE_VEHICLE = [sv].[PLATE_VEHICLE]
		FROM [acsa].[SWIFT_VEHICLES] [sv]
		WHERE [sv].[CODE_VEHICLE] = @CODE_VEHICLE

		INSERT INTO acsa.SWIFT_MANIFEST_HEADER (CODE_MANIFEST_HEADER,
		CODE_DRIVER,
		CODE_VEHICLE,
		COMMENTS,
		STATUS,
		CREATED_DATE,
		LAST_UPDATE,
		LAST_UPDATE_BY,
		CODE_ROUTE
		,[NAME_DRIVER]
		,[PLATE_VEHICLE]
		,[MANIFEST_SOURCE] 
		,[NAME_ROUTE]
		)
			VALUES (@CODEMANIFEST, @CODE_DRIVER, @CODE_VEHICLE, @COMMENTS, 'PENDING', current_timestamp, current_timestamp, @LAST_UPDATE_BY, @ROUTE, @DRIVER_NAME, @PLATE_VEHICLE, @MANIFEST_SOURCE,@NAME_ROUTE)
	END

	IF @@error = 0
	BEGIN
		SELECT
			@pResult = ''
		SELECT
			@pHeaderManifest = @@identity
		COMMIT TRAN t1
	END
	ELSE
	BEGIN
		ROLLBACK TRAN t1
		SELECT
			@pResult = ERROR_MESSAGE()
	END
END
