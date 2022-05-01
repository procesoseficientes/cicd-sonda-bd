﻿-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	01-28-2016
-- Description:			Inserta una nueva bodega en la tabla de SWIFT_WAREHOUSES

-- Modificacion 12/28/2016 @ A-Team Sprint Balder
					-- rodrigo.gomez
					-- Se agrego el parametro @DISTRIBUTION_CENTER_ID para que se pueda ejecutar el SP SWIFT_SP_SET_WAREHOUSE_TO_DISTRIBUTION_CENTER

-- Modificacion 01-10-2017 @ A-Team Sprint Balder
					-- diego.as
					-- Se agrego el parametro @CODE_WAREHOUSE_3PL
/*
-- Ejemplo de Ejecucion:				
				--
				exec [acsa].[SWIFT_SP_INSERTWAREHOUSE] 
					@CODE_WAREHOUSE = 'B11'
					,@DESCRIPTION_WAREHOUSE = 'Bodega 11'
					,@WEATHER_WAREHOUSE = 'SECO'
					,@STATUS_WAREHOUSE = 'ACTIVA'
					,@LAST_UPDATE = 'GERENTE@acsa'
					,@LAST_UPDATE_BY = GETDATE()
					,@IS_EXTERNAL INT = '0'
					,@TYPE_WAREHOUSE = '56'
					,@ERP_WAREHOUSE = 'V12'
					,@ADDRESS_WAREHOUSE = 'AAA'
					,@BARCODE_WAREHOUSE = 'B001-TEST'
					,@SHORT_DESCRIPTION_WAREHOUSE = 'B001'
					,@GPS_WAREHOUSE = '0'
					,@DISTRIBUTION_CENTER_ID = 1
          ,@CODE_WAREHOUSE_3PL = 'BODEGA_01'
				--				
*/
-- =============================================
CREATE PROC [acsa].[SWIFT_SP_INSERTWAREHOUSE]
	@CODE_WAREHOUSE VARCHAR(50)
	,@DESCRIPTION_WAREHOUSE VARCHAR(MAX)
	,@WEATHER_WAREHOUSE VARCHAR(50)
	,@STATUS_WAREHOUSE VARCHAR(10)
	,@LAST_UPDATE DATETIME
	,@LAST_UPDATE_BY VARCHAR(50)
	,@IS_EXTERNAL INT
	,@TYPE_WAREHOUSE INT
	,@ERP_WAREHOUSE [varchar](50)
	,@ADDRESS_WAREHOUSE [varchar](MAX)
	,@BARCODE_WAREHOUSE [varchar](50)
	,@SHORT_DESCRIPTION_WAREHOUSE [varchar](MAX)
	,@GPS_WAREHOUSE [varchar](50)
	,@DISTRIBUTION_CENTER_ID INT
  ,@CODE_WAREHOUSE_3PL VARCHAR(50)
AS
	INSERT INTO acsa.SWIFT_WAREHOUSES (
		CODE_WAREHOUSE
		,DESCRIPTION_WAREHOUSE
		,WEATHER_WAREHOUSE
		,STATUS_WAREHOUSE
		,LAST_UPDATE
		,LAST_UPDATE_BY
		,IS_EXTERNAL
		,TYPE_WAREHOUSE
		,ERP_WAREHOUSE
		,ADDRESS_WAREHOUSE
		,BARCODE_WAREHOUSE
		,SHORT_DESCRIPTION_WAREHOUSE
		,GPS_WAREHOUSE
    ,CODE_WAREHOUSE_3PL
	) VALUES (
		@CODE_WAREHOUSE
		,@DESCRIPTION_WAREHOUSE
		,@WEATHER_WAREHOUSE
		,@STATUS_WAREHOUSE
		,@LAST_UPDATE
		,@LAST_UPDATE_BY
		,@IS_EXTERNAL
		,@TYPE_WAREHOUSE
		,@ERP_WAREHOUSE
		,@ADDRESS_WAREHOUSE
		,@BARCODE_WAREHOUSE
		,@SHORT_DESCRIPTION_WAREHOUSE
		,@GPS_WAREHOUSE
    ,@CODE_WAREHOUSE_3PL
	)

	
EXEC [acsa].[SWIFT_SP_SET_WAREHOUSE_TO_DISTRIBUTION_CENTER] 
	@DISTRIBUTION_CENTER_ID = @DISTRIBUTION_CENTER_ID , -- int
	@CODE_WAREHOUSE = @CODE_WAREHOUSE -- varchar(50)




