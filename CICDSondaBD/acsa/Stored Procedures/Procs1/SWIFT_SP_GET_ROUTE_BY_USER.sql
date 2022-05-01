-- =============================================
-- Autor:				        hector.gonzalez
-- Fecha de Creacion: 	07-10-2016
-- Description:			    obtine las rutas por usuario

-- Modificacion 18-Nov-16 @ A-Team Sprint 5
					-- alberto.ruiz
					-- Se agrego que obtenga el nombre de usuario, vendedor y tipo de ruta
/*
	Ejemplo Ejecucion: 
    EXEC [acsa].SWIFT_SP_GET_ROUTE_BY_USER 
		@LOGIN = 'gerente@acsa'
 */
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ROUTE_BY_USER] (
	@LOGIN VARCHAR(50)
)AS
BEGIN
	SELECT DISTINCT
		[SR].[ROUTE]
		,[SR].[CODE_ROUTE]
		,[SR].[NAME_ROUTE]
		,[SR].[GEOREFERENCE_ROUTE]
		,[SR].[COMMENT_ROUTE]
		,[SR].[LAST_UPDATE]
		,[SR].[LAST_UPDATE_BY]
		,[U].[LOGIN]
		,[U].[NAME_USER]
		,[U].[USER_TYPE]
		,[C].[VALUE_TEXT_CLASSIFICATION] [TYPE_USER_DESCRIPTION]
    ,[S].[SELLER_CODE]
    ,[S].[SELLER_NAME]
	FROM [acsa].[SWIFT_VIEW_ALL_ROUTE] [SR]
	INNER JOIN [acsa].[SWIFT_ROUTE_BY_USER] [srbu] ON (
		[SR].[CODE_ROUTE] = [srbu].[CODE_ROUTE]
	)
	LEFT JOIN [acsa].[USERS] [U] ON (
		[U].[SELLER_ROUTE] = [SR].[CODE_ROUTE]
	)
	LEFT JOIN [acsa].[SWIFT_SELLER] [S] ON (
		[S].[SELLER_CODE] = [U].[RELATED_SELLER]
	)
	LEFT JOIN [acsa].[SWIFT_CLASSIFICATION] [C] ON (
		[C].[GROUP_CLASSIFICATION] = 'USER_ROLE'
		AND [C].[NAME_CLASSIFICATION] = [U].[USER_TYPE]
	)    
	WHERE [srbu].[LOGIN] = @LOGIN;
END;


