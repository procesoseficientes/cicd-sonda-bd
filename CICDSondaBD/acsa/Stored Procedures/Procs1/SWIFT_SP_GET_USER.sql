-- =============================================
-- Autor:				rodrigo.gomez
-- Fecha de Creacion: 	12/28/2016 @ A-TEAM Sprint Balder
-- Description:			Obtiene todos o solo un usuario

-- Modificacion 3/7/2017 @ A-Team Sprint Ebonne
					-- diego.as
					-- Se agrega columna CODE_PRICE_LIST

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SP_GET_USER]
					@LOGIN = 'gerente@acsa'

		SELECT * FROM [acsa].[USERS]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_USER](
	@LOGIN VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	
	SELECT [CORRELATIVE]
			,[LOGIN]
			,[NAME_USER]
			,[TYPE_USER]
			,[PASSWORD]
			,[ENTERPRISE]
			,[IMAGE]
			,[RELATED_SELLER]
			,[SELLER_ROUTE]
			,[USER_TYPE]
			,[DEFAULT_WAREHOUSE]
			,[USER_ROLE]
			,[PRESALE_WAREHOUSE]
			,[ROUTE_RETURN_WAREHOUSE]
			,CASE CAST(USE_PACK_UNIT AS VARCHAR)
			WHEN '1' THEN 'Si'
			ELSE 'No'
			END AS [USE_PACK_UNIT_DESCRIPTION]
			,[USE_PACK_UNIT]
			,[ZONE_ID]
			,[DISTRIBUTION_CENTER_ID]
			,[CODE_PRICE_LIST]
	FROM [acsa].[USERS] 
	WHERE @LOGIN IS NULL OR [LOGIN] = @LOGIN

END
