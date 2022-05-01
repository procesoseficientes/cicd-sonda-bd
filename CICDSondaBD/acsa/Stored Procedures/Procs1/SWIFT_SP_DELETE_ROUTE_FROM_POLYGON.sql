-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		29-08-2016 @ Sprint θ
-- Description:			    SP que elimina una ruta al eliminar un poligono de ruta


/*
-- Ejemplo de Ejecucion:
        EXEC [acsa].[SWIFT_SP_DELETE_ROUTE_FROM_POLYGON]
			@CODE_ROUTE = 'pablo@acsa'
		--
		SELECT * FROM [acsa].SWIFT_ROUTES WHERE CODE_ROUTE = 'pablo@acsa'

*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_DELETE_ROUTE_FROM_POLYGON] (
	@CODE_ROUTE VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	DELETE FROM [acsa].SWIFT_ROUTES
	WHERE CODE_ROUTE = @CODE_ROUTE
END

