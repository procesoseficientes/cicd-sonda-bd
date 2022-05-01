-- =====================================================
-- Author:         rudi.garcia
-- Create date:    22-08-2016
-- Description:    Trae las listas descuentos de los clientes  
--				   de las tareas asignadas al dia de trabajo

-- Modificacion 19-09-2016 @ A-TEAM Sprint 1
				-- alberto.ruiz
				-- Se agrego llamada al sp SWIFT_SP_GENERATE_DISCOUNT_FROM_TRADE_AGREEMENT

/*
-- EJEMPLO DE EJECUCION: 
		
		EXEC [acsa].[SONDA_SP_GET_DISCOUNT_LIST_BY_CUSTOMER_FOR_ROUTE]
			@CODE_ROUTE = 'RUDI@acsa'
		
*/			
-- =====================================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_DISCOUNT_LIST_BY_CUSTOMER_FOR_ROUTE]
(
	@CODE_ROUTE VARCHAR(50)
)
AS
BEGIN
	EXEC [acsa].[SWIFT_SP_GENERATE_DISCOUNT_FROM_TRADE_AGREEMENT]
		@CODE_ROUTE = @CODE_ROUTE
	--
	SELECT
		DLC.DISCOUNT_LIST_ID
		,DLC.CODE_CUSTOMER 
	FROM [acsa].SWIFT_DISCOUNT_LIST_BY_CUSTOMER DLC
	INNER JOIN [acsa].SWIFT_DISCOUNT_LIST DL ON(
		DL.DISCOUNT_LIST_ID = DLC.DISCOUNT_LIST_ID
	)
	WHERE DL.NAME_DISCOUNT_LIST LIKE (@CODE_ROUTE + '%')
END


