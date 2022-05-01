-- =============================================
-- Autor:				jose.garcia
-- Fecha de Creacion: 	06-07-2017
-- Description:			Obtiene los clinentes de las ventas de los ultimos 15 dias 
--						y los realizados en scouting del dia actual



/*
-- Ejemplo de Ejecucion:
				--
				EXEC [acsa].[SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING_FOR_SALES]
				--
				SELECT * FROM acsa.SONDA_COSTUMER_FOR_SALES
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CUSTUMER_FOR_SCOUTING_FOR_SALES]
AS
BEGIN

------------------------------------------------------------------------------------------------
-- LIMPIA LA TABLA DE CLIENTES PARA SONDA
------------------------------------------------------------------------------------------------
TRUNCATE TABLE acsa.SONDA_COSTUMER_FOR_SALES
------------------------------------------------------------------------------------------------
-- TRAE LOS CLIENTES A LOS QUE SE REALIZO VENTA LOS ULTIMOS 15 DIAS
------------------------------------------------------------------------------------------------
	SELECT DISTINCT CLIENT_ID 
	INTO #CLSALES
	FROM acsa.SONDA_SALES_ORDER_HEADER WITH(NOLOCK)
	WHERE POSTED_DATETIME BETWEEN FORMAT (GETDATE()-15,'yyyyMMdd') AND FORMAT (GETDATE()+1,'yyyyMMdd') 
	AND IS_VOID=0
	and IS_READY_TO_SEND=1

------------------------------------------------------------------------------------------------
-- INSERTA LOS CLIENTES DE LAS ULTIMAS VENTAS 
------------------------------------------------------------------------------------------------
SELECT
       [CUSTOMER]
      ,[CODE_CUSTOMER]
      ,[NAME_CUSTOMER]
      ,[PHONE_CUSTOMER]
      ,[ADRESS_CUSTOMER]
      ,[CLASSIFICATION_CUSTOMER]
      ,[CONTACT_CUSTOMER]
      ,[CODE_ROUTE]
      ,[LAST_UPDATE]
      ,[LAST_UPDATE_BY]
      ,[SELLER_DEFAULT_CODE]
      ,[CREDIT_LIMIT]
      ,[FROM_ERP]
      ,[TAX_ID_NUMBER]
      ,[GPS]
      ,[LATITUDE]
      ,[LONGITUDE]
      ,[FREQUENCY]
      ,[SUNDAY]
      ,[MONDAY]
      ,[TUESDAY]
      ,[WEDNESDAY]
      ,[THURSDAY]
      ,[FRIDAY]
      ,[SATURDAY]
      ,[SCOUTING_ROUTE]
      ,[EXTRA_DAYS]
      ,[DISCOUNT]
      ,[OFIVENTAS]
      ,[ORGVENTAS]
      ,[RUTAVENTAS]
      ,[RUTAENTREGA]
      ,[SECUENCIA]
      ,[RGA_CODE]
      ,[ORGANIZACION_VENTAS]
      ,[PAYMENT_CONDITIONS]
      ,[OWNER]
      ,[OWNER_ID]
      ,[BALANCE]
	  INTO #CUSTOMERSFORSALES 
	  FROM acsa.SWIFT_VIEW_ALL_COSTUMER VAC
		INNER JOIN #CLSALES  CFS ON (VAC.code_customer=CFS.CLIENT_ID) 
------------------------------------------------------------------------------------------------
-- TRAE LOS CLIENTES DEL SCOUTING DEL DIA DE HOY
------------------------------------------------------------------------------------------------
	SELECT DISTINCT CODE_CUSTOMER
	INTO #CLSCOUNTING
	 FROM acsa.SWIFT_CUSTOMERS_NEW WITH (NOLOCK)
	WHERE POST_DATETIME>= FORMAT (GETDATE(),'yyyyMMdd')
	
------------------------------------------------------------------------------------------------
-- INSERTA LOS CLIENTES DEL SCOUTING DEL DIA DE HOY
------------------------------------------------------------------------------------------------
SELECT
       [VAC].[CUSTOMER]
      ,[VAC].[CODE_CUSTOMER]
      ,[VAC].[NAME_CUSTOMER]
      ,[VAC].[PHONE_CUSTOMER]
      ,[VAC].[ADRESS_CUSTOMER]
      ,[VAC].[CLASSIFICATION_CUSTOMER]
      ,[VAC].[CONTACT_CUSTOMER]
      ,[VAC].[CODE_ROUTE]
      ,[VAC].[LAST_UPDATE]
      ,[VAC].[LAST_UPDATE_BY]
      ,[VAC].[SELLER_DEFAULT_CODE]
      ,[VAC].[CREDIT_LIMIT]
      ,[VAC].[FROM_ERP]
      ,[VAC].[TAX_ID_NUMBER]
      ,[VAC].[GPS]
      ,[VAC].[LATITUDE]
      ,[VAC].[LONGITUDE]
      ,[VAC].[FREQUENCY]
      ,[VAC].[SUNDAY]
      ,[VAC].[MONDAY]
      ,[VAC].[TUESDAY]
      ,[VAC].[WEDNESDAY]
      ,[VAC].[THURSDAY]
      ,[VAC].[FRIDAY]
      ,[VAC].[SATURDAY]
      ,[VAC].[SCOUTING_ROUTE]
      ,[VAC].[EXTRA_DAYS]
      ,[VAC].[DISCOUNT]
      ,[VAC].[OFIVENTAS]
      ,[VAC].[ORGVENTAS]
      ,[VAC].[RUTAVENTAS]
      ,[VAC].[RUTAENTREGA]
      ,[VAC].[SECUENCIA]
      ,[VAC].[RGA_CODE]
      ,[VAC].[ORGANIZACION_VENTAS]
      ,[VAC].[PAYMENT_CONDITIONS]
      ,[VAC].[OWNER]
      ,[VAC].[OWNER_ID]
      ,[VAC].[BALANCE]
	  INTO #CUSTOMERSFORSCOUTING
	  FROM acsa.SWIFT_VIEW_ALL_COSTUMER VAC
		INNER JOIN #CLSCOUNTING  CFS ON (VAC.CODE_CUSTOMER=CFS.CODE_CUSTOMER) 

------------------------------------------------------------------------------------------------
-- UNIFICA LOS CLIENTES PARA ENVIAR AL SONDA
------------------------------------------------------------------------------------------------

SELECT 
	   S.[CODE_CUSTOMER] CUSTOMER
      ,S.[CODE_CUSTOMER]
      ,S.[NAME_CUSTOMER]
      ,S.[PHONE_CUSTOMER]
      ,S.[ADRESS_CUSTOMER]
      ,S.[CLASSIFICATION_CUSTOMER]
      ,S.[CONTACT_CUSTOMER]
      ,S.[CODE_ROUTE]
      ,S.[LAST_UPDATE]
      ,S.[LAST_UPDATE_BY]
      ,S.[SELLER_DEFAULT_CODE]
      ,S.[CREDIT_LIMIT]
      ,S.[FROM_ERP]
      ,S.[TAX_ID_NUMBER]
      ,S.[GPS]
      ,S.[LATITUDE]
      ,S.[LONGITUDE]
      ,S.[FREQUENCY]
      ,S.[SUNDAY]
      ,S.[MONDAY]
      ,S.[TUESDAY]
      ,S.[WEDNESDAY]
      ,S.[THURSDAY]
      ,S.[FRIDAY]
      ,S.[SATURDAY]
      ,S.[SCOUTING_ROUTE]
      ,S.[EXTRA_DAYS]
      ,S.[DISCOUNT]
      ,S.[OFIVENTAS]
      ,S.[ORGVENTAS]
      ,S.[RUTAVENTAS]
      ,S.[RUTAENTREGA]
      ,S.[SECUENCIA]
      ,S.[RGA_CODE]
      ,S.[ORGANIZACION_VENTAS]
      ,S.[PAYMENT_CONDITIONS]
      ,S.[OWNER]
      ,S.[OWNER_ID]
      ,S.[BALANCE]
 INTO #SONDACUSTOMERS
 FROM #CUSTOMERSFORSALES S
 UNION  ALL
 SELECT 
       C.[CODE_CUSTOMER] CUSTOMER
      ,C.[CODE_CUSTOMER]
      ,C.[NAME_CUSTOMER]
      ,C.[PHONE_CUSTOMER]
      ,C.[ADRESS_CUSTOMER]
      ,C.[CLASSIFICATION_CUSTOMER]
      ,C.[CONTACT_CUSTOMER]
      ,C.[CODE_ROUTE]
      ,C.[LAST_UPDATE]
      ,C.[LAST_UPDATE_BY]
      ,C.[SELLER_DEFAULT_CODE]
      ,C.[CREDIT_LIMIT]
      ,C.[FROM_ERP]
      ,C.[TAX_ID_NUMBER]
      ,C.[GPS]
      ,C.[LATITUDE]
      ,C.[LONGITUDE]
      ,C.[FREQUENCY]
      ,C.[SUNDAY]
      ,C.[MONDAY]
      ,C.[TUESDAY]
      ,C.[WEDNESDAY]
      ,C.[THURSDAY]
      ,C.[FRIDAY]
      ,C.[SATURDAY]
      ,C.[SCOUTING_ROUTE]
      ,C.[EXTRA_DAYS]
      ,C.[DISCOUNT]
      ,C.[OFIVENTAS]
      ,C.[ORGVENTAS]
      ,C.[RUTAVENTAS]
      ,C.[RUTAENTREGA]
      ,C.[SECUENCIA]
      ,C.[RGA_CODE]
      ,C.[ORGANIZACION_VENTAS]
      ,C.[PAYMENT_CONDITIONS]
      ,C.[OWNER]
      ,C.[OWNER_ID]
      ,C.[BALANCE]
	 FROM   #CUSTOMERSFORSCOUTING C

------------------------------------------------------------------------------------------------
-- INSERTA LOS CLIENTES PARA ENVIAR AL SONDA
------------------------------------------------------------------------------------------------

INSERT INTO acsa.SONDA_COSTUMER_FOR_SALES
        ( CUSTOMER ,
          CODE_CUSTOMER ,
          NAME_CUSTOMER ,
          PHONE_CUSTOMER ,
          ADRESS_CUSTOMER ,
          CLASSIFICATION_CUSTOMER ,
          CONTACT_CUSTOMER ,
          CODE_ROUTE ,
          LAST_UPDATE ,
          LAST_UPDATE_BY ,
          SELLER_DEFAULT_CODE ,
          CREDIT_LIMIT ,
          FROM_ERP ,
          TAX_ID_NUMBER ,
          GPS ,
          LATITUDE ,
          LONGITUDE ,
          FREQUENCY ,
          SUNDAY ,
          MONDAY ,
          TUESDAY ,
          WEDNESDAY ,
          THURSDAY ,
          FRIDAY ,
          SATURDAY ,
          SCOUTING_ROUTE ,
          EXTRA_DAYS ,
          DISCOUNT ,
          OFIVENTAS ,
          ORGVENTAS ,
          RUTAVENTAS ,
          RUTAENTREGA ,
          SECUENCIA ,
          RGA_CODE ,
          ORGANIZACION_VENTAS ,
          PAYMENT_CONDITIONS ,
          OWNER ,
          OWNER_ID ,
          BALANCE
        )

		SELECT DISTINCT
		CUSTOMER ,
          CODE_CUSTOMER ,
          NAME_CUSTOMER ,
          PHONE_CUSTOMER ,
          ADRESS_CUSTOMER ,
          CLASSIFICATION_CUSTOMER ,
          CONTACT_CUSTOMER ,
          CODE_ROUTE ,
          LAST_UPDATE ,
          LAST_UPDATE_BY ,
          SELLER_DEFAULT_CODE ,
          CREDIT_LIMIT ,
          FROM_ERP ,
          TAX_ID_NUMBER ,
          GPS ,
          LATITUDE ,
          LONGITUDE ,
          FREQUENCY ,
          SUNDAY ,
          MONDAY ,
          TUESDAY ,
          WEDNESDAY ,
          THURSDAY ,
          FRIDAY ,
          SATURDAY ,
          SCOUTING_ROUTE ,
          EXTRA_DAYS ,
          DISCOUNT ,
          OFIVENTAS ,
          ORGVENTAS ,
          RUTAVENTAS ,
          RUTAENTREGA ,
          SECUENCIA ,
          RGA_CODE ,
          ORGANIZACION_VENTAS ,
          PAYMENT_CONDITIONS ,
          OWNER ,
          OWNER_ID ,
          BALANCE
		  FROM #SONDACUSTOMERS

END
