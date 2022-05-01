﻿-- =============================================
-- Autor:						Christian Hernandez 
-- Fecha de Modificacion: 		05/25/2018
-- Description:					Obtiene los descuentos de promocion por tipo de pago. 

-- =============================================


CREATE PROCEDURE [acsa].[SWIFT_SP_GET_DISCOUNT_FROM_PROMO_OF_DISCOUNT_BY_PAYMENT_TYPE_FAMILY](
	@PROMO_ID INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT [DF].[PROMO_DISCOUNT_ID] AS [PROMO_IDENTITY]
			,[DF].[PROMO_ID]
			,[DF].[CODE_FAMILY_SKU]			
			,[FS].[DESCRIPTION_FAMILY_SKU]
			,CASE [DF].[PAYMENT_TYPE]
				WHEN 'CREDIT' THEN 'CREDITO'
				WHEN 'CASH' THEN 'CONTADO'
			END [PAYMENT_TYPE]	
			,[DF].[DISCOUNT]
			,CASE [DF].[DISCOUNT_TYPE]
				WHEN 'PERCENTAGE' THEN 'PORCENTAJE'
				WHEN 'MONETARY' THEN 'MONETARIO' 
			END [DISCOUNT_TYPE]	
	FROM [acsa].[SWIFT_PROMO_DISCOUNT_BY_PAYMENT_TYPE_AND_FAMILY] [DF]
		INNER JOIN [acsa].[SWIFT_FAMILY_SKU] [FS] ON ([FS].[CODE_FAMILY_SKU] = [DF].[CODE_FAMILY_SKU])		
	WHERE [DF].[PROMO_ID] = @PROMO_ID

END
