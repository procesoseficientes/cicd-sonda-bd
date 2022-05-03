﻿
/*=======================================================
Autor:				diego.as
Fecha de Creacion:	16-09-2016 TEAM-A @ Sprint 1
Descripcion:		Valida si los datos de bonificacion que se envian como parametros, no colisionan con algun registro ya existente.

Ejemplo de Ejecucion:

	EXEC [acsa].[SWIFT_SP_VALIDATED_BONUS_SCALE]
		@TRADE_AGREEMENT_BONUS_ID = NULL
		,@TRADE_AGREEMENT_ID = 21
		,@CODE_SKU = '100005'
		,@PACK_UNIT = 7
		,@LOW_LIMIT = 1
		,@HIGH_LIMIT = 15
		,@CODE_SKU_BONUS = '100005'
		,@PACK_UNIT_BONUS = 7
		,@BONUS_QTY = 1
		------------------------------
		SELECT * FROM [acsa].[SWIFT_TRADE_AGREEMENT_BONUS]
=======================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_VALIDATED_BONUS_SCALE]
(
	@TRADE_AGREEMENT_BONUS_ID INT = NULL
	,@TRADE_AGREEMENT_ID INT
	,@CODE_SKU VARCHAR(50)
	,@PACK_UNIT INT
	,@LOW_LIMIT NUMERIC(18,0)
	,@HIGH_LIMIT NUMERIC(18,0)
	,@CODE_SKU_BONUS VARCHAR(50)
	,@PACK_UNIT_BONUS INT
	,@BONUS_QTY NUMERIC(18,0)

) AS
BEGIN
	--
	SET NOCOUNT ON;

	--
	DECLARE 
		@MESSAGE VARCHAR(250) = NULL

	--
	SELECT TOP 1 
		@MESSAGE = CASE
			WHEN @LOW_LIMIT BETWEEN S.LOW_LIMIT AND S.HIGH_LIMIT THEN 'Limite inferior del SKU: '+CAST(@CODE_SKU AS VARCHAR) +' entre rango existente'
			WHEN @HIGH_LIMIT BETWEEN S.LOW_LIMIT AND S.HIGH_LIMIT THEN 'Limite superior del SKU: '+CAST(@CODE_SKU AS VARCHAR) +' entre rango existente'
			WHEN S.LOW_LIMIT BETWEEN @LOW_LIMIT AND @HIGH_LIMIT THEN 'Rango del SKU: '+CAST(@CODE_SKU AS VARCHAR) +' absorve un rango ya existente'
			WHEN S.HIGH_LIMIT BETWEEN @LOW_LIMIT AND @HIGH_LIMIT THEN 'Rango del SKU: '+CAST(@CODE_SKU AS VARCHAR) +' absorve un rango ya existente'
			ELSE 'Rangos mal definidos'
		END
	FROM [acsa].[SWIFT_TRADE_AGREEMENT_BONUS] AS S
	WHERE S.TRADE_AGREEMENT_ID = @TRADE_AGREEMENT_ID
		AND S.CODE_SKU = @CODE_SKU
		AND S.CODE_SKU_BONUS = @CODE_SKU_BONUS
		AND S.PACK_UNIT = @PACK_UNIT
		AND S.PACK_UNIT_BONUS = @PACK_UNIT_BONUS
		AND (
			(
				@LOW_LIMIT BETWEEN S.LOW_LIMIT AND S.HIGH_LIMIT
				OR @HIGH_LIMIT BETWEEN S.LOW_LIMIT AND S.HIGH_LIMIT
			)
			OR
			(
				S.LOW_LIMIT BETWEEN @LOW_LIMIT AND @HIGH_LIMIT
				OR S.HIGH_LIMIT BETWEEN @LOW_LIMIT AND @HIGH_LIMIT
			)
		)
		AND (
			@TRADE_AGREEMENT_BONUS_ID IS NULL 
			OR S.TRADE_AGREEMENT_BONUS_ID != @TRADE_AGREEMENT_BONUS_ID
		)
	
	--
	IF @MESSAGE IS NOT NULL
	BEGIN
		RAISERROR(@MESSAGE,16,1)
	END
END 

