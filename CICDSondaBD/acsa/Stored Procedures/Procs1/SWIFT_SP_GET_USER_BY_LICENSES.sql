-- =============================================
-- Autor:				Christian Hernandez
-- Fecha de Creacion: 	08/08/2018 @ GForce-TEAM Sprint Hormiga
-- Description:			SP que obtiene los usuarios del back office que no esten asociados a ninguna licencia  

/*
-- Ejemplo de Ejecucion:
				EXEC acsa.[SP_GET_USER_BY_LICENSES] '<ArrayOfString>
  <string>oper01@acsa</string>
  <string>oper03@acsa</string>
  <string>CHRISTIAN@acsa</string>
</ArrayOfString>'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_USER_BY_LICENSES] @XML XML
AS
	DECLARE	@TABLE_RESULT TABLE ([LOGIN] VARCHAR(250));

  -- -------------------------------------------------------------------------------
  -- Generamos la tabla desde el XML 
  -- -------------------------------------------------------------------------------
	INSERT	INTO @TABLE_RESULT
			(
				[LOGIN]
			)
	SELECT
		[x].[Rec].[value]('.' ,'varchar(250)')
	FROM
		@XML.[nodes]('ArrayOfString/string') AS [x] ([Rec]);
-- -------------------------------------------------------------------------------
-- Tabla para mostrar los usuarios que estan asociadas a una licencia 
-- -------------------------------------------------------------------------------

	BEGIN 
		SELECT
			[USR].[CORRELATIVE]
			,[USR].[LOGIN]
			,[USR].[NAME_USER]
			,[USR].[SELLER_ROUTE]
			,[R].[NAME_ROUTE] [RELATED_SELLER]
		FROM
			[acsa].[USERS] [USR]
		LEFT JOIN [acsa].[SWIFT_ROUTES] AS [R]
		ON	([USR].[SELLER_ROUTE] = [R].[CODE_ROUTE])
		WHERE
			UPPER([USR].[LOGIN]) IN (SELECT
										[LOGIN]
									FROM
										@TABLE_RESULT);
	END;
