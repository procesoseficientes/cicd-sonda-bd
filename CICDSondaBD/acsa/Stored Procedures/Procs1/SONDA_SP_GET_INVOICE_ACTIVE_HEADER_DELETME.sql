-- =============================================
-- Author:     	rudi.garcia
-- Create date: 2016-02-24 09:03:26
-- Description: Obtiene las facturas encabezados activas de todos los cliente o de uno especifico

/*
Ejemplo de Ejecucion:
          -- Para obtener todas las facturas
            EXEC acsa.SONDA_SP_GET_INVOICE_ACTIVE_HEADER_DELETME @CODE_ROUTE = '16103@acsa'
          -- Para obtener todas las facturas por cliente
			      EXEC acsa.SONDA_SP_GET_INVOICE_ACTIVE_HEADER @CODE_ROUTE = '16103@acsa', @CODE_CUSTOMER = 'BO-100018'
          --Obtien los clientes de la ruta
			      EXEC acsa.SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING @CODE_ROUTE = '16103@acsa'
*/
-- =============================================

CREATE PROCEDURE [acsa].[SONDA_SP_GET_INVOICE_ACTIVE_HEADER_DELETME] @CODE_ROUTE AS VARCHAR(50)
, @CODE_CUSTOMER AS VARCHAR(50) = NULL
AS
BEGIN
  --
  CREATE TABLE #COSTUMER (
    CODE_CUSTOMER VARCHAR(50)
   ,NAME_CUSTOMER VARCHAR(100)
   ,TAX_ID_NUMERBER VARCHAR(3)
   ,ADRESS_CUSTUMER VARCHAR(200)
   ,PHONE_CUSTUMER VARCHAR(90)
   ,CONTACT_CUSTUMER VARCHAR(90)
   ,CREDIT_LIMIT FLOAT
   ,EXTRA_DAYS INT
  )
  --
  DECLARE @CUSTUMERS VARCHAR(MAX) = ''
         ,@SQL VARCHAR(max)

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
    INSERT INTO #COSTUMER (CODE_CUSTOMER) VALUES (@CODE_CUSTOMER);

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
    	FROM openquery (ERP_SERVER,''    
          SELECT
            IV.DocEntry AS DOC_ENTRY
            ,IV.DocNum AS DOC_NUM
            ,IV.CardCode AS CAR_CODE
            ,IV.DocTotal AS DOC_TOTAL
            ,IV.PaidToDate AS PAID_TO_DATE
            ,IV.DocDueDate AS DOC_DUE_DATE
            ,IV.CardCode AS CARD_CODE
		        ,null AS SERIE
		        ,null AS RESOLUTION
		        ,IV.DocDate AS DOC_DATE
          FROM [Me_Llega_DB].dbo.OINV IV
          WHERE 
            IV.DocStatus = ''''O''''		      
		      ORDER BY 
            IV.CardCode
            ,IV.DocDueDate
	    '')   WHERE  CAR_CODE IN ( SELECT CODE_CUSTOMER COLLATE SQL_Latin1_General_CP850_CI_AS  FROM #COSTUMER  )'

  PRINT '@SQL: ' + @SQL
  EXEC (@SQL)

END
