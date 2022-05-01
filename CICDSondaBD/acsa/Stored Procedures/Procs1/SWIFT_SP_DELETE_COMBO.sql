-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	08-Dec-16 @ A-TEAM Sprint Chatuluka 
-- Description:			SP que borra un combo

-- Modificacion 7/26/2017 @ Sprint Bearbeitung
					-- rodrigo.gomez
					-- Se agrega el mensaje de error con la tabla SWIFT_PROMO_BY_COMBO_PROMO_RULE

/*
-- Ejemplo de Ejecucion:
				SELECT * FROM [acsa].[SWIFT_COMBO]
				--
				EXEC [acsa].[SWIFT_SP_DELETE_COMBO]
					@COMBO_ID = 5
				-- 
				SELECT * FROM [acsa].[SWIFT_COMBO]

*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_COMBO](
	@COMBO_ID INT
)
AS
BEGIN
	BEGIN TRY
		DELETE FROM [acsa].[SWIFT_COMBO]
		WHERE [COMBO_ID] = @COMBO_ID
		--
		SELECT  1 as Resultado , 'Proceso Exitoso' Mensaje ,  0 Codigo, '' DbData
	END TRY
	BEGIN CATCH
		SELECT  -1 as Resultado
		,CASE 
			WHEN CAST(@@ERROR AS VARCHAR) = '547' AND ERROR_MESSAGE() LIKE '%SWIFT_SKU_BY_COMBO%' THEN 'El combo tiene productos asociados'
			WHEN CAST(@@ERROR AS VARCHAR) = '547' AND ERROR_MESSAGE() LIKE '%SWIFT_TRADE_AGREEMENT%' THEN 'El combo esta relacionado a un acuerdo comercial'
			WHEN CAST(@@ERROR AS VARCHAR) = '547' AND ERROR_MESSAGE() LIKE '%SWIFT_PROMO_BY_COMBO_PROMO_RULE%' THEN 'El combo esta relacionado a una promoción.'
			ELSE ERROR_MESSAGE()
		END Mensaje 
		,@@ERROR Codigo 
	END CATCH
END

