﻿-- =============================================
-- Autor:				alberto.ruiz	
-- Fecha de Creacion: 	01-12-2015
-- Description:			Reubica un sku en otra locacion

/*
-- Ejemplo de Ejecucion:
				exec [acsa].SWIFT_SP_RELOCATED_INVENTORY_REPORT @STARDATE = '20151201 00:00:00.000', @ENDDATE = '20151203 00:00:00.000'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_RELOCATED_INVENTORY_REPORT]
	@START_DATE DATETIME
	,@END_DATE DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT 
		I.SKU
		,I.SKU_DESCRIPTION
		,I.SERIAL_NUMBER
		,I.WAREHOUSE
		,I.LOCATION
		,I.RELOCATED_DATE
		,DATEDIFF(DAY,I.RELOCATED_DATE,GETDATE()) RELOCATED_DAYS
	FROM [$(CICDSondaBD)].[acsa].[SWIFT_INVENTORY] I
	WHERE IS_SCANNED = 0
	AND I.RELOCATED_DATE BETWEEN @START_DATE AND @END_DATE

END

