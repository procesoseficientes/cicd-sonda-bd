﻿-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	7/23/2017 @ Reborn-TEAM Sprint Bearbeitung
-- Description:			SP que obtiene los registros de la tabla [acsa].SWIFT_PROMO_DISCOUNT_BY_GENERAL_AMOUNT

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_DISCOUNT_BY_GENERAL_AMOUNT_ASSOCIATED_TO_PROMOTION_OF_DISCOUNT_BY_GENERAL_AMOUNT]
				@PROMO_ID = 20
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_DISCOUNT_BY_GENERAL_AMOUNT_ASSOCIATED_TO_PROMOTION_OF_DISCOUNT_BY_GENERAL_AMOUNT](
	@PROMO_ID INT
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT [PROMO_ID]
			,[LOW_AMOUNT]
			,[HIGH_AMOUNT]
			,[DISCOUNT]
			,[DISCOUNT_BY_GENERAL_AMOUNT_ID] 
	FROM [acsa].[SWIFT_PROMO_DISCOUNT_BY_GENERAL_AMOUNT]
	WHERE [PROMO_ID] = @PROMO_ID
END

