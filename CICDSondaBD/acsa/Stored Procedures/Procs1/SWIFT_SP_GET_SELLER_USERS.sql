-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		04-07-2016
-- Description:			    Obtiene los usuarios de tipo preventa y venta

/*
-- Ejemplo de Ejecucion:
        EXEC [acsa].[SWIFT_SP_GET_SELLER_USERS]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_SELLER_USERS]
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT
		[U].[CORRELATIVE]
		,[U].[LOGIN]
		,[U].[NAME_USER]
		,[U].[TYPE_USER]
		,[U].[PASSWORD]
		,[U].[ENTERPRISE]
		,[U].[IMAGE]
		,[U].[RELATED_SELLER]
		,[U].[SELLER_ROUTE]
		,[U].[USER_TYPE]
		,[U].[DEFAULT_WAREHOUSE]
		,[U].[USER_ROLE]
		,[U].[PRESALE_WAREHOUSE]
		,[U].[ROUTE_RETURN_WAREHOUSE]
		,[U].[USE_PACK_UNIT]
	FROM [acsa].[USERS] [U]
	WHERE [USER_TYPE] IN ('PRE','VEN')
	ORDER BY [U].[CORRELATIVE]
END
