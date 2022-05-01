-- =============================================
--  Autor:		joel.delcompare
-- Fecha de Creacion: 	2016-04-27 18:10:10
-- Description:		Obtiene los primeros 5 clientes que estan listos para ser enviados al erp   

--Modificacion 03-05-2016
		-- alberto.ruiz
		-- Se agregaron filtro para que solo obtenga a los scouting con status de aceptado

/*
-- Ejemplo de Ejecucion:
USE SWIFT_EXPRESS_R
GO

DECLARE @RC int

EXECUTE @RC = acsa.SWIFT_SP_GET_TOP5_CUSTOMERS_NEW
GO
  
*/
-- =============================================

create PROCEDURE [acsa].[SWIFT_SP_GET_TOP5_CUSTOMERS_NEW_all]
AS

  SELECT 

    scn.CUSTOMER
   ,scn.CODE_CUSTOMER
   ,scn.NAME_CUSTOMER
   ,scn.PHONE_CUSTOMER
   ,scn.ADRESS_CUSTOMER
   ,scn.CLASSIFICATION_CUSTOMER
   ,scn.CONTACT_CUSTOMER
   ,scn.CODE_ROUTE
   ,scn.LAST_UPDATE
   ,scn.LAST_UPDATE_BY
   ,u.RELATED_SELLER SALES_PERSON_CODE
   ,scn.CREDIT_LIMIT
   ,'' SIGN
   ,'' PHOTO
   ,scn.STATUS
   ,scn.NEW
   ,scn.GPS
   ,scn.CODE_CUSTOMER_HH
   ,scn.REFERENCE
   ,scn.POST_DATETIME
   ,scn.POS_SALE_NAME
   ,scn.INVOICE_NAME
   ,scn.INVOICE_ADDRESS
   ,ISNULL(scn.NIT,'C.F.')  NIT
   ,scn.CONTACT_ID
   ,scn.COMMENTS
   ,scn.ATTEMPTED_WITH_ERROR
   ,scn.IS_POSTED_ERP
   ,scn.POSTED_ERP
   ,scn.POSTED_RESPONSE
   ,scn.LATITUDE
   ,scn.LONGITUDE
   ,scn.SELLER_DEFAULT_CODE
   ,ISNULL(scfn.FREQUENCY_WEEKS,1) FREQUENCY_WEEKS
   ,scfn.MONDAY
   ,scfn.TUESDAY
   ,scfn.WEDNESDAY
   ,scfn.THURSDAY
   ,scfn.FRIDAY
   ,scfn.SATURDAY
   ,scfn.SUNDAY
  FROM [acsa].SWIFT_CUSTOMERS_NEW scn
  INNER JOIN acsa.USERS u
    ON u.LOGIN = scn.SELLER_DEFAULT_CODE
  INNER JOIN acsa.SWIFT_CUSTOMER_FREQUENCY_NEW scfn
    ON scn.CODE_CUSTOMER = scfn.CODE_CUSTOMER
  WHERE POSTED_RESPONSE='This entry already exists in the following tables (ODBC -2035)'
