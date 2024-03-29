﻿-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	09-03-2016
-- Description:			Crear la tarea de una nueva recepcion

/*
-- Ejemplo de Ejecucion:
        EXEC [acsa].[SWIFT_INSERT_IN_TRANSAXION_AND_TASK]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_INSERT_IN_TRANSAXION_AND_TASK]
AS
BEGIN
	DECLARE 
		@RECEPTION_HEADER INT
		,@TASK_COMMENTS VARCHAR(50)
		,@TYPE_RECEPTION VARCHAR(50)

	-- ------------------------------------------------------------------------------------
	-- Obtiene valores
	-- ------------------------------------------------------------------------------------
	SELECT TOP 1 @RECEPTION_HEADER = RECEPTION_HEADER 
	FROM acsa.SWIFT_RECEPTION_HEADER 
	ORDER BY RECEPTION_HEADER DESC	
	--
	SELECT TOP 1 @TYPE_RECEPTION = H.TYPE_RECEPTION 
	FROM acsa.SWIFT_RECEPTION_HEADER H
	WHERE H.RECEPTION_HEADER = @RECEPTION_HEADER
	ORDER BY H.RECEPTION_HEADER DESC
	--
	SELECT @TASK_COMMENTS = VALUE_TEXT_CLASSIFICATION 
	FROM acsa.SWIFT_CLASSIFICATION C 
	WHERE C.GROUP_CLASSIFICATION = 'RECEPTION' 
	AND C.MPC01 = @TYPE_RECEPTION
	--
	PRINT '@RECEPTION_HEADER: ' + CAST(@RECEPTION_HEADER AS VARCHAR)
	PRINT '@TYPE_RECEPTION: ' + @TYPE_RECEPTION
	PRINT '@TASK_COMMENTS: ' + @TASK_COMMENTS
 
	-- ------------------------------------------------------------------------------------
	-- Inserta la tarea
	-- ------------------------------------------------------------------------------------
	INSERT INTO acsa.SWIFT_TASKS (
		TASK_TYPE
		,TASK_DATE
		,CREATED_STAMP
		,ASSIGEND_TO
		,ASSIGNED_STAMP
		,RELATED_PROVIDER_CODE
		,RELATED_PROVIDER_NAME
		,COSTUMER_CODE
		,COSTUMER_NAME
		,REFERENCE
		,SAP_REFERENCE
		,RECEPTION_NUMBER
		,SCHEDULE_FOR
		,TASK_SEQ
		,ACTION
		,TASK_COMMENTS
		,TASK_STATUS
		,SCANNING_STATUS
	)
	SELECT 
		'RECEPTION'
		,CONVERT(DATE,GETDATE())
		,GETDATE()
		,H.CODE_USER
		,GETDATE()
		,H.CODE_PROVIDER
		,ISNULL(
			(
				SELECT NAME_PROVIDER 
				FROM acsa.SWIFT_VIEW_ALL_PROVIDERS 
				WHERE CODE_PROVIDER = H.CODE_PROVIDER
			)
			,(
				SELECT NAME_CUSTOMER 
				FROM acsa.SWIFT_VIEW_ALL_COSTUMER 
				WHERE CODE_CUSTOMER = H.CODE_PROVIDER
			)
		)
		,H.CODE_PROVIDER
		,ISNULL(
			(
				SELECT NAME_PROVIDER 
				FROM acsa.SWIFT_VIEW_ALL_PROVIDERS 
				WHERE CODE_PROVIDER = H.CODE_PROVIDER
			)
			,(
				SELECT NAME_CUSTOMER 
				FROM acsa.SWIFT_VIEW_ALL_COSTUMER 
				WHERE CODE_CUSTOMER = H.CODE_PROVIDER
			)
		)
		,H.REFERENCE
		,H.DOC_SAP_RECEPTION
		,H.RECEPTION_HEADER
		,H.SCHEDULE_FOR
		,H.SEQ
		,'PLAY'
		,@TASK_COMMENTS
		,'ASSIGNED'
		,'PENDING'
	FROM acsa.SWIFT_RECEPTION_HEADER H
	WHERE H.RECEPTION_HEADER = @RECEPTION_HEADER

END



