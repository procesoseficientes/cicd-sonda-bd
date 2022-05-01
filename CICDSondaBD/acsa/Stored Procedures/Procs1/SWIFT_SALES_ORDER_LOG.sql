-- =============================================
/*
-- Ejemplo de Ejecucion:
				EXEC [acsa].[SWIFT_SALES_ORDER_LOG]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SALES_ORDER_LOG] 
AS 
BEGIN
	SET NOCOUNT ON
	--
	DECLARE @ROW_QTY INT = 0
	--
	SELECT 
		SSOH.SALES_ORDER_ID[ORDEN]
		,SSOH.POS_TERMINAL[OPERADOR]
		,SSOH.TOTAL_AMOUNT[ENCABEZADO]
		, SUM(SSOD.TOTAL_LINE) [DETALLE] 
		,SSOH.CLIENT_ID [CLIENTE]
	INTO #T
	FROM acsa.SONDA_SALES_ORDER_HEADER SSOH WITH (NOLOCK)
		INNER JOIN acsa.SONDA_SALES_ORDER_DETAIL SSOD WITH (NOLOCK)ON (SSOH.SALES_ORDER_ID=SSOD.SALES_ORDER_ID)
		WHERE SSOH.POSTED_DATETIME>=  format (getdate(),'yyyyMMdd')
	GROUP BY SSOH.SALES_ORDER_ID, SSOH.POS_TERMINAL, SSOH.TOTAL_AMOUNT,SSOH.CLIENT_ID
	--
	SELECT	
		*, 
		(T.ENCABEZADO-T.DETALLE) DIFERENCIA,
		GETDATE() HORA
	INTO #RESUTL
	FROM #T AS T
	WHERE T.ENCABEZADO>T.DETALLE
	ORDER BY OPERADOR
	--
	SET @ROW_QTY = @@ROWCOUNT
	PRINT '--> @ROW_QTY: ' + CAST(@ROW_QTY AS VARCHAR)
	--
	IF(@ROW_QTY > 0)
	BEGIN
		-- ---------------------------------------------------------------
		-- Inserta el log
		-- ---------------------------------------------------------------
		INSERT INTO acsa.SWIFT_SALES_ORDER
		SELECT	
			*
		FROM #RESUTL AS T
			WHERE T.ENCABEZADO>T.DETALLE
		ORDER BY OPERADOR

		-- ---------------------------------------------------------------
		-- Envia alerta
		-- ---------------------------------------------------------------
		DECLARE
			@DEFAULT_PROFILE_NAME VARCHAR(250) = 'SoporteMobility'
			,@DEFAULT_RECIPIENTS VARCHAR(250) = 'alex.carrillo@mobilityscm.com;jose.garcia@mobilityscm.com;'
			,@DEFAULT_RECIPIENTS_CC VARCHAR(250) = 'fabrizio.rivera@mobilityscm.com;juanfrancisco.gonzalez@mobilityscm.com;'
			,@DEFAULT_RECIPIENTS_CCO VARCHAR(250) = ''
			,@BODY VARCHAR(MAX) = ''

		-- ------------------------------------------------------------------------------------
		-- Forma el html del correo
		-- ------------------------------------------------------------------------------------
		SET @BODY += '<style>
			table {
				border-collapse: collapse;
				width: 100%;
			}

			th, td {
				padding: 8px;
				text-align: left;
			}
			tr:nth-child(even){background-color: #f2f2f2}
		</style>'
		SET @BODY += '<p>Buen día, </p>'
		SET @BODY += '<p>En acsa en el servidor ' + @@SERVERNAME + ' con la IP ' + CAST(CONNECTIONPROPERTY('local_net_address') AS VARCHAR) + ',' + CAST(CONNECTIONPROPERTY('local_tcp_port') AS VARCHAR) + ' se han encontrado las siguientes ordenes de venta incompletas:</p>'
		SET @BODY += '<table>'
		SET @BODY += '<tr>'
		SET @BODY += '<th>SALES_ORDER_ID</th>'
		SET @BODY += '<th>LOGIN</th>'
		SET @BODY += '<th>HEADER</th>'
		SET @BODY += '<th>DETAIL</th>'
		SET @BODY += '<th>DIFERENCIA</th>'
		SET @BODY += '<th>HORA</th>'
		SET @BODY += '<th>CLIENTE</th>'
		SET @BODY += '</tr>'
		--
		SELECT 
			@BODY += '<tr>'
				+ '<td>' + CAST([T].[ORDEN] AS VARCHAR) + '</td>'
				+ '<td>' + [T].[OPERADOR] + '</td>'
				+ '<td>' + CONVERT(VARCHAR,[T].[ENCABEZADO]) + '</td>'
				+ '<td>' + CONVERT(VARCHAR,[T].[DETALLE]) + '</td>'
				+ '<td>' + CONVERT(VARCHAR,DIFERENCIA) + '</td>'
				+ '<td>' + CONVERT(VARCHAR,HORA,121) + '</td>'
				+ '<td>' + [T].[CLIENTE] + '</td>'
				+ '</tr>'
		FROM #RESUTL [T]
		--
		SET @BODY += '</table>'
		SET @BODY += '<p>Saludos, Equipo de soporte de Mobility.</p><br>'
		SET @BODY += '<img src="http://mobilityscm.com/img/mobility_colors.png" alt="MobilitySCM.com" style="width: 550px;height:150px;">'
		--
		PRINT '@BODY: ' + @BODY

		-- ------------------------------------------------------------------------------------
		-- Envia el correo
		-- ------------------------------------------------------------------------------------
		EXEC msdb.dbo.sp_send_dbmail  
			@profile_name = @DEFAULT_PROFILE_NAME
			,@recipients = @DEFAULT_RECIPIENTS
			,@copy_recipients = @DEFAULT_RECIPIENTS_CC
			,@blind_copy_recipients = @DEFAULT_RECIPIENTS_CCO
			,@subject = 'ALERTA! Ordenes de Venta'
			,@body_format = 'HTML'
			,@body = @BODY;

	END
	ELSE
	BEGIN
		PRINT 'No hay ordenes de venta incomplestas'
	END
END
