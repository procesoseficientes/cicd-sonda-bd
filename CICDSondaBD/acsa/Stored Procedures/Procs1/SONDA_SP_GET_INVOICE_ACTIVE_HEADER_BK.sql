

-- =============================================
-- Author:     	rudi.garcia
-- Create date: 2016-02-24 09:03:26
-- Description: Obtiene las facturas encabezados activas de todos los cliente o de uno especifico

-- Modificacion 10-06-2016
-- jose.roberto
-- Se coloco el where afuera del openquery

-- Modificacion			
-- 18-07-2016
-- hector.gonzalez
-- Se agrego parametro GPS por problema con el inicio de ruta ya que SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING devolvia GPS y este SP no lo tenia

-- Modificacion			
-- 12-12-2016 @ Sprint 6
-- alberto.ruiz
-- Se agregaron las columnas de lista de bonificacion y descuento

-- Modificacion			
-- 26-12-2016 @ Sprint 6
-- rodrigo.gomez
-- Se agregaro la columna de lista de precios

--/*
--Ejemplo de Ejecucion:
--           Para obtener todas las facturas
--            EXEC acsa.SONDA_SP_GET_INVOICE_ACTIVE_HEADER_BK @CODE_ROUTE = 'rudi@acsa' ,@CODE_CUSTOMER = 'CLIE000019'
--           Para obtener todas las facturas por cliente
--			      EXEC acsa.SONDA_SP_GET_INVOICE_ACTIVE_HEADER @CODE_ROUTE = '16103@acsa', @CODE_CUSTOMER = 'BO-100018'
--          Obtien los clientes de la ruta
--			      EXEC acsa.SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING @CODE_ROUTE = '16103@acsa'
--*/
-- =============================================

CREATE PROCEDURE [acsa].[SONDA_SP_GET_INVOICE_ACTIVE_HEADER_BK] 
  @CODE_ROUTE AS VARCHAR(50)
, @CODE_CUSTOMER AS VARCHAR(50) = NULL
AS
BEGIN
  
  CREATE TABLE #COSTUMER (
    CODE_CUSTOMER VARCHAR(50)
   ,NAME_CUSTOMER VARCHAR(100)
   ,TAX_ID_NUMERBER VARCHAR(3)
   ,ADRESS_CUSTUMER VARCHAR(200)
   ,PHONE_CUSTUMER VARCHAR(90)
   ,CONTACT_CUSTUMER VARCHAR(90)
   ,CREDIT_LIMIT FLOAT
   ,EXTRA_DAYS INT
   ,DISCOUNT NUMERIC(18, 6)
   ,GPS VARCHAR(256)
   ,RGA_CODE VARCHAR(150)
   ,DISCOUNT_LIST_ID INT
   ,BONUS_LIST_ID INT
   ,PRICE_LIST_ID VARCHAR(50)
  )
  
  DECLARE @CUSTUMERS VARCHAR(MAX) = ''
         ,@SQL VARCHAR(MAX)

  -- ----------------------------------------------------------------------------------
  -- Se valida si se obtienen todas las factuas o solo con un cliente especifico, con la siguiente validacion
  -- ----------------------------------------------------------------------------------
  IF @CODE_CUSTOMER IS NULL
  BEGIN
    -- ----------------------------------------------------------------------------------
    -- Se obtienen todos los clientes de la ruta
    -- ----------------------------------------------------------------------------------
    INSERT INTO #COSTUMER
    EXEC acsa.SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING @CODE_ROUTE = @CODE_ROUTE

  END
  ELSE
  BEGIN
    -- ----------------------------------------------------------------------------------
    -- Se estable el cliente para el openquery
    -- ----------------------------------------------------------------------------------
    INSERT INTO #COSTUMER (CODE_CUSTOMER)
      VALUES (@CODE_CUSTOMER);

  END

  SELECT
    @SQL = ' 
	    SELECT
		 DOC_ENTRY
			  ,DOC_NUM
    		,DOC_TOTAL
    		,PAID_TO_DATE
    		,DOC_DUE_DATE
    		,CARD_CODE
			  ,SERIE
			  ,RESOLUTION
			  ,DOC_DATE
    	FROM openquery (ACSASERVER,''    
          SELECT IV.cod_pedido AS DOC_ENTRY
			,IV.NUMERO_FACTURA AS DOC_NUM
			,IV.TOTAL_FACTURA AS DOC_TOTAL
			,0 AS "PAID_TO_DATE"
			,DATEADD(DAY,15,PH.FECHA_PEDIDO) DOC_DUE_DATE
			,PH.CTACTE CARD_CODE
			,NULL SERIE
			,NULL RESOLUTION
			,PH.FECHA_PEDIDO DOC_DATE
         FROM [dbo].[mov_pedidos_encabezado_tracking] IV
			left join [dbo].[mov_pedidos_encabezado_hist] PH ON PH.numero_pedido=IV.numero_pedido and PH.numero_pedido=IV.numero_pedido
			left join [dbo].[mov_pedidos_encabezado] PE ON PE.numero_pedido=IV.numero_pedido and PE.numero_pedido=IV.numero_pedido
			left join [dbo].[mov_cliente] CTE ON CTE.ctacte=ISNULL(PH.ctacte,PE.ctacte)
          WHERE 
            IV.DocStatus = ''''O''''		      
		      ORDER BY 
            IV.CardCode
            ,IV.DocDueDate
	    '')   WHERE  CAR_CODE IN ( SELECT CODE_CUSTOMER COLLATE SQL_Latin1_General_CP850_CI_AS  FROM #COSTUMER  )'

  PRINT '@SQL: ' + @SQL
  EXEC (@SQL)
 
 select * from #COSTUMER
END



