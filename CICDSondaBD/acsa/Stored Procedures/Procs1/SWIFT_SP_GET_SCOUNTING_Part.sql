-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	01-10-2015
-- Description:			Obtine los clientes de scouting

--Modificacion 24-11-2015
		-- alberto.ruiz
		-- Se agregaron las siguientes columnas: POS_SALE_NAME, INVOICE_NAME, INVOICE_ADDRESS, NIT, CONTACT_ID, COMMENTS

--Modificacion 14-12-2015
		-- alberto.ruiz
		-- Se corrigio por motivos de eficiencia y se quitaron las etiquetas del select

--Modificacion 23-12-2015
		-- jose.garcia
		-- Se agregro un INNER JOIN con la tabla ROUTE_BY_USER con el parametro de @LOGIN para
		-- las validadciones de las rutas de scouting en asignacion de supervisor

--Modificacion 02-05-2016
		-- alberto.ruiz
		-- Se agregaron las columnas ATTEMPTED_WITH_ERROR, IS_POSTED_ERP, POSTED_ERP, POSTED_RESPONSE
/*
--Ejemplo de Ejecucion:
						exec [acsa].[SWIFT_SP_GET_SCOUNTING_part] 
										@TAGS = ''				--Codigo de color separados por coma y en blanco son todos
										,@Type = ''				--Es el estado: NEW, ACCEPTED, REJECTED y en blanco son todos
										,@NOT_TAGS = 0			--0 = Todos los registros y 1 = Solo con etiqueta
										,@FechaIncio = '2016-07-04 00:00:00.000'		--Fecha con hora
										,@FechaFinal  = '2016-07-09 23:59:59.000'		--Fecha con hora
										,@LOGIN ='GERENTE@acsa'
*/

-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_SCOUNTING_Part]
	@TAGS VARCHAR(MAX)
	,@Type AS VARCHAR(20)
	,@NOT_TAGS AS INT
	,@FechaIncio AS datetime
	,@FechaFinal AS datetime
	,@LOGIN AS VARCHAR(50)
AS
BEGIN
	SELECT
		CFN.CODE_CUSTOMER
		,(
			CASE CFN.FREQUENCY_WEEKS
				WHEN 1 THEN '1 Semana'
				WHEN 2 THEN '2 Semanas'
				WHEN 3 THEN '3 Semanas'
				ELSE CFN.FREQUENCY_WEEKS + 'Semanas'
			END
			+ CASE CFN.SUNDAY WHEN 1 THEN ',Domingo' ELSE '' END
			+ CASE CFN.MONDAY WHEN 1 THEN ',Lunes' ELSE '' END
			+ CASE CFN.TUESDAY WHEN 1 THEN ',Martes' ELSE '' END
			+ CASE CFN.WEDNESDAY WHEN 1 THEN ',Miercoles' ELSE '' END
			+ CASE CFN.THURSDAY WHEN 1 THEN ',Jueves' ELSE '' END
			+ CASE CFN.FRIDAY WHEN 1 THEN ',Viernes' ELSE '' END
			+ CASE CFN.SATURDAY WHEN 1 THEN ',Sabado' ELSE '' END
		) AS FREQUENCY
	INTO #FREQUENCY
	FROM [acsa].[SWIFT_CUSTOMER_FREQUENCY_NEW] CFN
	--
	SELECT DISTINCT
		CN.CUSTOMER
		,CN.CODE_CUSTOMER
		,CN.NAME_CUSTOMER
		,CN.PHONE_CUSTOMER
		,CN.ADRESS_CUSTOMER
		--,CN.CLASSIFICATION_CUSTOMER
		,CN.CONTACT_CUSTOMER
		,CN.CODE_ROUTE
		,CN.LAST_UPDATE
		--,CN.LAST_UPDATE_BY
		--,CN.SELLER_DEFAULT_CODE
		--,CN.CREDIT_LIMIT
		--,CN.SIGN
		--,CN.PHOTO
		--,CN.STATUS
	--	,CN.NEW
		,CN.GPS
	--	,CN.CODE_CUSTOMER_HH
		,CN.REFERENCE
		--,CN.POST_DATETIME
		,CN.POS_SALE_NAME
		,CN.INVOICE_NAME
		,CN.INVOICE_ADDRESS
		,CN.NIT
		,CN.CONTACT_ID
		,CN.COMMENTS
		,CN.LATITUDE
		,CN.LONGITUDE
		--,VR.CODE_ROUTE
		--,VR.NAME_ROUTE
		,F.FREQUENCY
		--,CN.ATTEMPTED_WITH_ERROR
		--,IS_POSTED_ERP
		--,ISNULL(
		--	CASE CAST(CN.IS_POSTED_ERP AS VARCHAR)
		--		WHEN '-2' THEN 'Errado'
		--		WHEN '1' THEN 'Enviado'
		--		ELSE 'Pendiente'
		--	END
		--	,'Pendiente'
		--) AS IS_POSTED_ERP_DESCRIPTION
		--,CN.POSTED_ERP
		--,ISNULL(CN.POSTED_RESPONSE,'') POSTED_RESPONSE
	FROM [acsa].[SWIFT_CUSTOMERS_NEW] CN
	INNER JOIN [acsa].[SWIFT_VIEW_ALL_ROUTE] VR ON (CN.CODE_ROUTE = VR.CODE_ROUTE)
	INNER JOIN #FREQUENCY F ON (CN.CODE_CUSTOMER = F.CODE_CUSTOMER)
	INNER JOIN [acsa].[SWIFT_ROUTE_BY_USER] RU ON (RU.CODE_ROUTE = CN.CODE_ROUTE)
	LEFT JOIN [acsa].[SWIFT_TAG_X_CUSTOMER_NEW] TCN ON (CN.CODE_CUSTOMER = TCN.CUSTOMER)
	WHERE RU.LOGIN = @LOGIN
		AND CN.POST_DATETIME BETWEEN @FechaIncio AND @FechaFinal
		AND (@TAGS = '' OR TCN.TAG_COLOR IN (SELECT Splitcolumn FROM acsa.[SWIFT_FUNC_GET_TABLE_SPLIT](@TAGS,',')))
		AND (@Type = '' OR CN.[STATUS] = @Type)
		AND (@NOT_TAGS = 0 OR 0 < (SELECT COUNT(*) FROM acsa.SWIFT_TAG_X_CUSTOMER_NEW TC WHERE CN.CODE_CUSTOMER = TC.CUSTOMER))
END
