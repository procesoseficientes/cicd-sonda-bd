-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	09-09-2016 @ A-TEAM Sprint 1
-- Description:			SP que obtiene todos los canales o uno en especifico

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].SWIFT_SP_GET_CHANNEL
					@CHANNEL_ID = 1
				--
				EXEC [acsa].SWIFT_SP_GET_CHANNEL
				-- 
				SELECT * FROM [acsa].SWIFT_CHANNEL
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CHANNEL](
	@CHANNEL_ID INT = NULL
)
AS
BEGIN
	SELECT
		CHANNEL_ID
		,CODE_CHANNEL
		,NAME_CHANNEL
		,DESCRIPTION_CHANNEL
		,TYPE_CHANNEL
		,LAST_UPDATE
		,LAST_UPDATE_BY
	FROM [acsa].SWIFT_CHANNEL
	WHERE @CHANNEL_ID IS NULL
		OR CHANNEL_ID = @CHANNEL_ID
END

