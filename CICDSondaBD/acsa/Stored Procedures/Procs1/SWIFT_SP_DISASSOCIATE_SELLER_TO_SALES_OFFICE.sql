-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	2/23/2017 @ A-TEAM Sprint  
-- Description:			SP que desasocia un vendedor de una oficina de ventas

/*
-- Ejemplo de Ejecucion:
		EXEC [acsa].[SWIFT_SP_DISASSOCIATE_SELLER_TO_SALES_OFFICE]
			@SALES_OFFICE_ID = 2
			,@SELLER_CODE = 'V001'
		-- 
		SELECT * FROM [acsa].[SWIFT_SELLER] WHERE SELLER_CODE = 'V001'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DISASSOCIATE_SELLER_TO_SALES_OFFICE](
	@SELLER_CODE VARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		UPDATE [acsa].[SWIFT_SELLER]
		SET	[SALES_OFFICE_ID] = NULL
		WHERE [SELLER_CODE] = @SELLER_CODE
		--
		SELECT  1 as Resultado , 'Proceso Exitoso' Mensaje ,  0 Codigo, '' DbData
	END TRY
	BEGIN CATCH
		SELECT  -1 as Resultado
		,ERROR_MESSAGE() Mensaje 
		,@@ERROR Codigo 
	END CATCH
END
