-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		11-07-2016 @ Sprint  ζ
-- Description:			    SP que obtiene un centro de distibucion o todos

-- Modificacion 12/27/2016 @ A-Team Sprint Balder
					-- rodrigo.gomez
					-- Se le agreron las columnas ADDRESS_DISTRIBUTION_CENTER, LATITUDE Y LONGITUDE 

/*
-- Ejemplo de Ejecucion:
		--
		EXEC [acsa].[SWIFT_SP_GET_DISTRIBUTION_CENTER]
			@DISTRIBUTION_CENTER_ID = NULL
		--
        EXEC [acsa].[SWIFT_SP_GET_DISTRIBUTION_CENTER]
			@DISTRIBUTION_CENTER_ID = 3
		--
		SELECT * FROM [acsa].[SWIFT_DISTRIBUTION_CENTER]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_DISTRIBUTION_CENTER] (
	@DISTRIBUTION_CENTER_ID INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	SELECT
		[DC].[DISTRIBUTION_CENTER_ID]
		,[DC].[NAME_DISTRIBUTION_CENTER]
		,[DC].[DESCRIPTION_DISTRIBUTION_CENTER]
		,[DC].[LOGO_IMG]
		,[DC].[LAST_UPDATE_BY]
		,[DC].[LAST_UPDATE_DATETIME]
		,[DC].[ADRESS_DISTRIBUTION_CENTER]
		,CONVERT(VARCHAR(50),[DC].[LATITUDE]) [LATITUDE]
		,CONVERT(VARCHAR(50),[DC].[LONGITUDE]) [LONGITUDE]
	FROM [acsa].[SWIFT_DISTRIBUTION_CENTER] [DC]
	WHERE @DISTRIBUTION_CENTER_ID IS NULL OR [DC].[DISTRIBUTION_CENTER_ID] = @DISTRIBUTION_CENTER_ID
END



