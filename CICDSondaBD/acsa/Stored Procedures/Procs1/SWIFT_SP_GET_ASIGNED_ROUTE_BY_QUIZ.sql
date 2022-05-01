-- =============================================
-- Autor:                christian.hernandez
-- Fecha de Creacion:    31-Oct-2018 @ A-TEAM Sprint G-Force@Lion
-- Description:          SP que obtiene las rutas asignadas por microencuesta 

/*
-- Ejemplo de Ejecucion:
                EXEC [acsa].SWIFT_SP_GET_ASIGNED_ROUTE_BY_QUIZ
*/
-- =============================================

-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ASIGNED_ROUTE_BY_QUIZ] (@QUIZ_ID INT)
AS
BEGIN
SELECT 
	RO.CODE_ROUTE, 
	RO.NAME_ROUTE,
	US.CORRELATIVE,
	US.NAME_USER, 
	CASE WHEN US.[LOGIN] IS NULL THEN 'Sin Asignar' ELSE US.[LOGIN] END AS [LOGIN],	
	CASE WHEN ST.NAME_TEAM IS NULL THEN 'Sin Equipo' ELSE ST.NAME_TEAM END AS TEAM_NAME 
FROM 
	acsa.SWIFT_ROUTES RO LEFT JOIN acsa.USERS US ON US.SELLER_ROUTE = RO.SELLER_CODE 
	LEFT JOIN (SELECT SUT.[USER_ID], ST.NAME_TEAM FROM 
				acsa.[SWIFT_USER_BY_TEAM] SUT 
				INNER JOIN acsa.[SWIFT_TEAM] ST ON ST.TEAM_ID = SUT.TEAM_ID ) ST ON ST.[USER_ID] = US.CORRELATIVE
WHERE RO.CODE_ROUTE IN (SELECT ROUTE_CODE FROM acsa.SWIFT_ASIGNED_QUIZ WHERE QUIZ_ID = @QUIZ_ID) 
	ORDER BY RO.CODE_ROUTE 
END
