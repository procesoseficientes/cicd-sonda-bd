
-- =============================================
-- Autor:                christian.hernandez
-- Fecha de Creacion:    31-Oct-2018 @ A-TEAM Sprint G-Force@Lion
-- Description:          SP que obtiene las rutas sin microencuesta asignada

/*
-- Ejemplo de Ejecucion:
                EXEC [acsa].SWIFT_SP_GET_ASSIGNED_CHANNEL_BY_QUIZ @QUIZ_ID = 16
*/
-- =============================================


CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ASSIGNED_CHANNEL_BY_QUIZ] (@QUIZ_ID INT)
AS 
BEGIN 



SELECT 
	SC.CODE_CHANNEL, 
	SC.NAME_CHANNEL, 
	SC.DESCRIPTION_CHANNEL 
FROM acsa.SWIFT_CHANNEL SC 
	LEFT JOIN acsa.SWIFT_ASIGNED_QUIZ AQ ON AQ.CODE_CHANNEL = SC.CODE_CHANNEL 
WHERE AQ.QUIZ_ID = @QUIZ_ID


END
