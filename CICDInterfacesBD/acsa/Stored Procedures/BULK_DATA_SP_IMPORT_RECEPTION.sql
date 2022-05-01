-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	29-02-2016
-- Description:			SP que importa recepciones

/*
-- Ejemplo de Ejecucion:
				-- 
				EXEC [acsa].[BULK_DATA_SP_IMPORT_RECEPTION]
*/
-- =============================================
CREATE PROCEDURE [acsa].[BULK_DATA_SP_IMPORT_RECEPTION]
AS
BEGIN
	SET NOCOUNT ON;
	--
	DELETE FROM [acsa].[SWIFT_ERP_RECEPTION]
	INSERT INTO [acsa].[SWIFT_ERP_RECEPTION]
	SELECT * FROM [acsa].[ERP_VIEW_RECEPTION]
END


