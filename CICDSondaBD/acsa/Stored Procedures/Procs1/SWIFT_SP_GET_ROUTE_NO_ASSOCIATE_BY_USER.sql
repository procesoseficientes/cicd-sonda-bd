/****** Object:  StoredProcedure [acsa].[SWIFT_SP_GET_ROUTE_NO_ASSOCIATE_BY_USER]    Script Date: 15/12/2015 9:09:38 AM ******/
-- =============================================
-- Autor:				JOSE ROBERTO
-- Fecha de Creacion: 	15-12-2015
-- Description:			Muestra	los usuarios que no estan asociados a una ruta

/*
-- Ejemplo de Ejecucion:				
				--
				 [acsa].[SWIFT_SP_GET_ROUTE_NO_ASSOCIATE_BY_USER]@CODE_ROUTE='R001'
				--				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ROUTE_NO_ASSOCIATE_BY_USER]	
@LOGIN VARCHAR(50)
AS
	SELECT AR.CODE_ROUTE
		, AR.NAME_ROUTE
	FROM [acsa].[SWIFT_VIEW_ALL_ROUTE] AR
	WHERE NOT EXISTS (SELECT  1 
					FROM [acsa].[SWIFT_ROUTE_BY_USER] AS RU
					WHERE RU.CODE_ROUTE= AR.CODE_ROUTE
					AND RU.LOGIN = @LOGIN)

