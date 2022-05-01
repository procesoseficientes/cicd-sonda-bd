-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	10/1/2017 @ Reborn-TEAM Sprint Collin  
-- Description:			SP que obtiene los registros de la tabla SWIFT_TAX

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SONDA_SP_GET_TAX_FOR_SKU]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_TAX_FOR_SKU]
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT [TAX_CODE]
			,[TAX_NAME]
			,[TAX_VALUE] 
	FROM [acsa].[SWIFT_TAX]
END

