-- =============================================
-- Autor:					alberto.ruiz
-- Fecha de Creacion: 		10-May-17 @ A-Team Sprint Issa
-- Description:			    SP que actuliza las columnas de departamento, municipio y colonia para los clientes viejos

/*
-- Ejemplo de Ejecucion:
				--
				SELECT * FROM [acsa].[SWIFT_ERP_CUSTOMERS] WHERE CODE_CUSTOMER = '172'
				--
				EXEC [acsa].[SWIFT_SP_SET_GEOCODING_TO_CUSTOMER]
					@CODE_CUSTOMER = '172'
					,@DEPARTAMENT = 'guatemala'
					,@MUNICIPALITY = 'mixco'
					,@COLONY = 'CONDADO naranjo'
				--
				SELECT * FROM [acsa].[SWIFT_ERP_CUSTOMERS] WHERE CODE_CUSTOMER = '172'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_SET_GEOCODING_TO_CUSTOMER] (
	@CODE_CUSTOMER VARCHAR(50)
	,@DEPARTAMENT VARCHAR(250)
	,@MUNICIPALITY VARCHAR(250)
	,@COLONY VARCHAR(250)
)
AS
BEGIN
	SET NOCOUNT ON;
	--
	UPDATE [acsa].[SWIFT_ERP_CUSTOMERS]
	SET DEPARTAMENT = UPPER(@DEPARTAMENT)
		,MUNICIPALITY = UPPER(@MUNICIPALITY)
		,COLONY = UPPER(@COLONY)
	WHERE [CODE_CUSTOMER] = @CODE_CUSTOMER
END
