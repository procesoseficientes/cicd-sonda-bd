/*=======================================================
-- Author:         alejandro.ochoa
-- Create date:    17-08-2016
-- Description:    Inserta los Pedidos en DB de Interfaz para AX
				   

-- EJEMPLO DE EJECUCION: 
		EXEC [acsa].[SWIFT_SP_POST_SALES_ORDER_TO_ERP]

=========================================================*/
CREATE PROCEDURE [acsa].[SWIFT_SP_POST_SALES_ORDER_TO_ERP_OLD]
AS
BEGIN
	SET NOCOUNT OFF;

	
	DECLARE @Sales_Order_ID BIGINT
	DECLARE @CodeCustomer VARCHAR(50)
	DECLARE @PriceList VARCHAR(50)
	DECLARE @DaysMonth VARCHAR(50) = [acsa].[SWIFT_FN_GET_PARAMETER]('DEFAULT_DAYS_BY_MONTH','MONTH_CREDIT')
	DECLARE SalesOrder_Cursor CURSOR FOR  
		SELECT ssoh.SALES_ORDER_ID
		FROM [acsa].SONDA_SALES_ORDER_HEADER ssoh
		WHERE ISNULL(IS_POSTED_ERP, 0) = 0
		  AND ISNULL(ssoh.IS_VOID, 0) = 0
		  AND ISNULL(ssoh.IS_DRAFT, 0) = 0
		  AND [ssoh].[IS_READY_TO_SEND] = 1
		
	OPEN SalesOrder_Cursor;
		
	FETCH NEXT FROM SalesOrder_Cursor
	INTO @Sales_Order_ID 
		
	WHILE @@FETCH_STATUS = 0  
	BEGIN
		BEGIN TRY
		--PRINT(CONCAT('SOID: ',@Sales_Order_ID))

			
			SELECT @PriceList = ISNULL((SELECT CODE_PRICE_LIST FROM ACSA.[USERS] 
											WHERE LOGIN=(SELECT [POSTED_BY] FROM [acsa].[SONDA_SALES_ORDER_HEADER] WHERE [SALES_ORDER_ID]=@Sales_Order_ID))
										,[acsa].[SWIFT_FN_GET_PARAMETER]('ERP_HARDCODE_VALUES','PRICE_LIST'))

			INSERT INTO ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_pedidos_encabezado] (
				[cod_pedido]
				,[empresa]
				,[numero_pedido]
				,[ctacte]
				,[forma_pago]
				,[total_pedido]
				,[total_lineas]
				,[fecha_pedido]
				,[fecha_entrega]
				,[fecha_modifico]
				,[comentarios]
				,[usuario_grabo]
				,[estado]
				,[listaprecios]
				,[direccion_entrega]
				,[tipo_docto]
				,[numero]
				,[fecha_proceso]
				,[latitud]
				,[longitud]
				,[datosgps]
				,[total_descuento]
				,[totalbruto])
			SELECT 
				ssoh.SALES_ORDER_ID
				,'ACSA' AS EMPRESA
				,CONCAT(ssoh.DOC_SERIE,ssoh.DOC_NUM) AS NUMERO_PEDIDO
				,ssoh.CLIENT_ID
				,ISNULL((Select LTRIM(RTRIM(condpago)) from ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_cliente] 
							where LTRIM(RTRIM(ctacte)) COLLATE DATABASE_DEFAULT =ssoh.CLIENT_ID),
						(Select top 1 LTRIM(RTRIM(Descripcion)) FROM ACSASERVER.[SONDA_ACSA_PRUEBAS].dbo.vw_condiciones_pago 
							where ((ISNULL(LTRIM(RTRIM(Meses)), 0) * CONVERT(INT, @DaysMonth)) + ISNULL(LTRIM(RTRIM(Dias)), 0))=ISNULL(svac.extra_days,0))) AS forma_pago
				,ssoh.TOTAL_AMOUNT - (SELECT SUM(ROUND((ssod.TOTAL_LINE * (ssod.DISCOUNT/100)),2)) FROM acsa.SONDA_SALES_ORDER_DETAIL ssod WHERE ssod.SALES_ORDER_ID = ssoh.Sales_Order_ID) as TotalGross
				,(SELECT COUNT(*) FROM acsa.SONDA_SALES_ORDER_DETAIL ssod WHERE ssod.SALES_ORDER_ID = ssoh.Sales_Order_ID)
				,ssoh.POSTED_DATETIME
				,ssoh.DELIVERY_DATE
				,CAST('1900-01-01 00:00:00.000' AS DATETIME)
				,ssoh.COMMENT
				,ssoh.POS_TERMINAL
				,1 AS ESTADO
				,ISNULL(spc.CODE_PRICE_LIST,@PriceList)
				,svac.ADRESS_CUSTOMER
				,NULL
				,NULL
				,GETDATE()
				,SUBSTRING(ssoh.GPS_URL, 1, CHARINDEX(',', ssoh.GPS_URL) - 1) AS LATITUD
				,SUBSTRING(ssoh.GPS_URL, CHARINDEX(',', ssoh.GPS_URL) + 1, LEN(ssoh.GPS_URL)) AS LONGITUD
				,NULL
				,(SELECT SUM(ROUND((ssod.TOTAL_LINE * (ssod.DISCOUNT/100)),2)) FROM acsa.SONDA_SALES_ORDER_DETAIL ssod WHERE ssod.SALES_ORDER_ID = ssoh.Sales_Order_ID) AS TOTAL_DESCUENTO
				,ssoh.TOTAL_AMOUNT
			FROM [acsa].[SONDA_SALES_ORDER_HEADER] ssoh
			LEFT JOIN [acsa].SWIFT_VIEW_ALL_COSTUMER svac ON svac.CODE_CUSTOMER = ssoh.CLIENT_ID
			LEFT JOIN [acsa].SWIFT_PRICE_LIST_BY_CUSTOMER spc ON spc.CODE_CUSTOMER = svac.CODE_CUSTOMER
			WHERE ssoh.SALES_ORDER_ID = @Sales_Order_ID
			
			SELECT @CodeCustomer = [CLIENT_ID]
			FROM [acsa].[SONDA_SALES_ORDER_HEADER]
			WHERE [SALES_ORDER_ID] = @Sales_Order_ID
			
			INSERT INTO ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_pedidos_detalle](
				[cod_pedido]
				,[linea]
				,[cod_producto]
				,[cantidad]
				,[precio]
				,[total_linea]
				,[porcentaje_descuento]
				,[total_descuento]
				,[totalbruto])
			SELECT 
				ssod.SALES_ORDER_ID
				,ssod.LINE_SEQ
				,ssod.SKU
				,ssod.QTY
				,ssod.PRICE
				,(ssod.TOTAL_LINE - ROUND((ssod.TOTAL_LINE * (ssod.DISCOUNT/100)),2)) AS TotalGross
				,ssod.DISCOUNT
				,ROUND((ssod.TOTAL_LINE * (ssod.DISCOUNT/100)),2) as TOTAL_DISCOUNT
				,ssod.TOTAL_LINE
			FROM acsa.SONDA_SALES_ORDER_DETAIL ssod
			WHERE ssod.SALES_ORDER_ID = @Sales_Order_ID
				  AND [ssod].[IS_BONUS] = 0
			
			INSERT INTO ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_pedidos_detalle](
				[cod_pedido]
				,[linea]
				,[cod_producto]
				,[cantidad]
				,[precio]
				,[total_linea]
				,[porcentaje_descuento]
				,[total_descuento]
				,[totalbruto])
			SELECT
				ssod.SALES_ORDER_ID
				,ssod.LINE_SEQ
				,ssod.SKU
				,ssod.QTY
				,(SELECT [PRICE]
						FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE] PLBSPS
							LEFT JOIN [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER] PLBC ON [PLBC].[CODE_CUSTOMER] = @CodeCustomer
						WHERE [PLBSPS].[CODE_SKU] = [ssod].[SKU]
						AND [PLBSPS].[CODE_PRICE_LIST] = ISNULL([PLBC].[CODE_PRICE_LIST],@PriceList))  AS PRICE
				,0.01 AS TotalGross
				,99.99 AS DISCOUNT
				,((ssod.QTY * (SELECT [PRICE]
						FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE] PLBSPS
							LEFT JOIN [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER] PLBC ON [PLBC].[CODE_CUSTOMER] = @CodeCustomer
						WHERE [PLBSPS].[CODE_SKU] = [ssod].[SKU]
						AND [PLBSPS].[CODE_PRICE_LIST] = ISNULL([PLBC].[CODE_PRICE_LIST],@PriceList)))-0.01) AS TOTAL_DISCOUNT
				,(ssod.QTY * (SELECT [PRICE]
						FROM [acsa].[SWIFT_PRICE_LIST_BY_SKU_PACK_SCALE] PLBSPS
							LEFT JOIN [acsa].[SWIFT_PRICE_LIST_BY_CUSTOMER] PLBC ON [PLBC].[CODE_CUSTOMER] = @CodeCustomer
						WHERE [PLBSPS].[CODE_SKU] = [ssod].[SKU]
						AND [PLBSPS].[CODE_PRICE_LIST] = ISNULL([PLBC].[CODE_PRICE_LIST],@PriceList))) AS TOTAL_LINE
			FROM acsa.SONDA_SALES_ORDER_DETAIL ssod 
			WHERE ssod.SALES_ORDER_ID = @Sales_Order_ID
				  AND ssod.[IS_BONUS] = 1

			EXEC [acsa].[SWIFT_SP-STATUS-SEND_SO_TO_SAP] @SALES_ORDER_ID = @Sales_Order_ID , -- int
				@POSTED_RESPONSE = 'Proceso Exitoso' , -- varchar(4000)
				@ERP_REFERENCE = NULL -- varchar(256)

		END TRY
		BEGIN CATCH
			--ROLLBACK

			DELETE FROM ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_pedidos_detalle]
			WHERE cod_pedido = @Sales_Order_ID

			DELETE FROM ACSASERVER.[SONDA_ACSA_PRUEBAS].[dbo].[mov_pedidos_encabezado]
			WHERE cod_pedido = @Sales_Order_ID

			EXEC [acsa].[SWIFT_SP-STATUS-ERROR_SO_TO_SAP] @SALES_ORDER_ID = @Sales_Order_ID , -- int
				@POSTED_RESPONSE = ERROR_MESSAGE -- varchar(4000)
				
		END CATCH
		FETCH NEXT FROM SalesOrder_Cursor
		INTO @Sales_Order_ID;  
	END;  
	CLOSE SalesOrder_Cursor;  
	DEALLOCATE SalesOrder_Cursor;


END

