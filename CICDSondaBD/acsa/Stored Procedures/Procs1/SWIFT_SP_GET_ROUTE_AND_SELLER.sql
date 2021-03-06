-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	04-04-2016
-- Description:			obtiene los operadores

--Modificado 23-05-2016
--          rudi.garcia
--          Se agrego el left join con la tabla de vehiculoas, para obtener el vehiuclo asociado del usuario.
/*
-- Ejemplo de Ejecucion:
        USE $(CICDSondaBD)
        GO
        --
        EXEC [acsa].[SWIFT_SP_GET_ROUTE_AND_SELLER]
			@LOGIN = 'OPER202@acsa'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ROUTE_AND_SELLER]
	@LOGIN VARCHAR(50) = NULL
AS
BEGIN
	SELECT
		U.LOGIN
    ,ISNULL(V.CODE_VEHICLE, 'Sin Vehiculo')CODE_VEHICLE
		,R.CODE_ROUTE
		,R.NAME_ROUTE
		,S.SELLER_CODE
		,S.SELLER_NAME
	FROM [acsa].[USERS] U
	INNER JOIN [acsa].[SWIFT_ROUTES] R ON (U.SELLER_ROUTE = R.CODE_ROUTE)
	INNER JOIN [acsa].[SWIFT_VIEW_ALL_SELLERS] S ON (U.RELATED_SELLER = S.SELLER_CODE)
  LEFT JOIN [acsa].SWIFT_VEHICLE_X_USER VU ON (U.LOGIN = VU.LOGIN)
  LEFT JOIN [acsa].SWIFT_VEHICLES V ON (VU.VEHICLE = V.VEHICLE)
	WHERE @LOGIN IS NULL OR U.LOGIN = @LOGIN
END

