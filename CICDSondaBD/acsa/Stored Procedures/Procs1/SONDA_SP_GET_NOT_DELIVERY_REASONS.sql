﻿-- =============================================
-- Autor:				diego.as
-- Fecha de Creacion: 	11/23/2017 @ Reborn-TEAM Sprint Nach
-- Description:			SP que obtiene los registros de las razones de no entrega para Sonda SD 

/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SONDA_SP_GET_NOT_DELIVERY_REASONS]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_NOT_DELIVERY_REASONS]
AS
BEGIN
	SET NOCOUNT ON;
	
	--
	DECLARE @NOT_DELIVERY_REASONS TABLE(
		[GROUP_CLASSIFICATION] VARCHAR(50)
		,[NAME_CLASSIFICATION] VARCHAR(50)
		,[PRIORITY_CLASSIFICATION] INT
		,[VALUE_TEXT_CLASSIFICATION] VARCHAR(50)
	)

	--
	INSERT INTO @NOT_DELIVERY_REASONS
			(
				[GROUP_CLASSIFICATION]
				,[NAME_CLASSIFICATION]
				,[PRIORITY_CLASSIFICATION]
				,[VALUE_TEXT_CLASSIFICATION]
			)
	SELECT [GROUP_CLASSIFICATION]
		,[NAME_CLASSIFICATION]
		,[PRIORITY_CLASSIFICATION]
		,[VALUE_TEXT_CLASSIFICATION]
	FROM [acsa].[SWIFT_CLASSIFICATION] 
	WHERE [GROUP_CLASSIFICATION] = 'NOT_DELIVERY_REASONS';

	--
	INSERT INTO @NOT_DELIVERY_REASONS
			(
				[GROUP_CLASSIFICATION]
				,[NAME_CLASSIFICATION]
				,[PRIORITY_CLASSIFICATION]
				,[VALUE_TEXT_CLASSIFICATION]
			)
	VALUES
			(
				'NOT_DELIVERY_REASONS'
				,'SIN RAZONES'
				,0
				,'SIN_RAZONES'
			);

	--
	SELECT [GROUP_CLASSIFICATION]
			,[NAME_CLASSIFICATION]
			,[PRIORITY_CLASSIFICATION]
			,[VALUE_TEXT_CLASSIFICATION] 
	FROM @NOT_DELIVERY_REASONS
	ORDER BY [PRIORITY_CLASSIFICATION]
	--
END
