﻿CREATE PROCEDURE [acsa].[SWIFT_SP_VALIDATED_PICKING]
@PICKING_DETAIL VARCHAR(50)
,@CODE_CUSTOMER VARCHAR(50)
AS
DECLARE 
	@PICKING_HEADER INT

	select @PICKING_HEADER = D.PICKING_HEADER from [acsa].[SWIFT_PICKING_DETAIL] D WHERE D.PICKING_DETAIL = @PICKING_DETAIL

	IF NOT EXISTS (select TOP 1 1 from [acsa].[SWIFT_PICKING_HEADER] H WHERE H.PICKING_HEADER = @PICKING_HEADER AND H.STATUS = 'COMPLETED')
	BEGIN
		SELECT  -1 as Resultado , 'No ha finalizado la tarea de picking' as  Mensaje ,  -1  as Codigo 						
		RETURN -1
	END

	IF (SELECT SUM(D.SCANNED) FROM [acsa].[SWIFT_PICKING_DETAIL] D WHERE D.PICKING_HEADER = @PICKING_HEADER) < 1
	BEGIN
		SELECT  -1 as Resultado , 'No tiene SKU escaniados' as  Mensaje ,  -1  as Codigo 						
		RETURN -1
	END
	
	IF EXISTS (
		SELECT TOP 1 1
		FROM [acsa].[SWIFT_PICKING_DETAIL] D
		LEFT JOIN (
			select DISTINCT S.CODE_SKU
			from [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER] C
			INNER JOIN [acsa].[SWIFT_PRICE_LIST_BY_SKU] S ON (C.CODE_PRICE_LIST = S.CODE_PRICE_LIST)
			WHERE C.CODE_CUSTOMER = @CODE_CUSTOMER
		) T ON (D.CODE_SKU = T.CODE_SKU)
		WHERE D.PICKING_HEADER = @PICKING_HEADER
		AND T.CODE_SKU IS NULL
	)
	BEGIN
		SELECT  -1 as Resultado , 'No esta correcta la configuracion de los SKU en la lista de precios' as  Mensaje ,  -1  as Codigo 				
		RETURN -1
	END
	
	SELECT  1 as Resultado , 'Proceso Exitoso' Mensaje ,  0 Codigo 					
RETURN 0





