﻿
-- Modificacion 6/22/2017 @ A-Team Sprint Khalid
					-- rodrigo.gomez
					-- Se cambio la fuente de datos a la vista de todos los customer new

-- =============================================
/*
-- Ejemplo de Ejecucion:
		EXEC [acsa].SWIFT_SP_GET_SCOUTING

		EXEC [acsa].SWIFT_SP_GET_SCOUTING 
			@CODE_CUSTOMER = 'SO-1762'
*/
-- =============================================

CREATE PROCEDURE [acsa].[SWIFT_SP_GET_SCOUTING] (@CODE_CUSTOMER VARCHAR(50) = NULL)
AS
  SET NOCOUNT ON;

  SELECT
    [CN].[CUSTOMER]
	,[CN].[CODE_CUSTOMER]
	,[CN].[NAME_CUSTOMER]
	,[CN].[PHONE_CUSTOMER]
	,[CN].[ADRESS_CUSTOMER]
	,[CN].[CLASSIFICATION_CUSTOMER]
	,[CN].[CONTACT_CUSTOMER]
	,[CN].[CODE_ROUTE]
	,[CN].[LAST_UPDATE]
	,[CN].[LAST_UPDATE_BY]
	,[CN].[SELLER_DEFAULT_CODE]
	,[CN].[CREDIT_LIMIT]
	,[CN].[SIGN]
	,[CN].[PHOTO]
	,[CN].[STATUS]
	,[CN].[NEW]
	,[CN].[GPS]
	,[CN].[CODE_CUSTOMER_HH]
	,[CN].[REFERENCE]
	,[CN].[POST_DATETIME]
	,[CN].[POS_SALE_NAME]
	,[CN].[INVOICE_NAME]
	,[CN].[INVOICE_ADDRESS]
	,[CN].[NIT]
	,[CN].[CONTACT_ID]
	,[CN].[COMMENTS]
	,[CN].[ATTEMPTED_WITH_ERROR]
	,[CN].[IS_POSTED_ERP]
	,[CN].[POSTED_ERP]
	,[CN].[POSTED_RESPONSE]
	,[CN].[LATITUDE]
	,[CN].[LONGITUDE]
	,[CN].[DEPARTAMENT]
	,[CN].[MUNICIPALITY]
	,[CN].[COLONY]
	,[CN].[UPDATED_FROM_BO]
	,[CN].[SYNC_ID]
	,[CN].[CODE_CUSTOMER_BO]
	,[CN].[PHOTO_2]
	,[CN].[PHOTO_3]
	,[CN].[PHOTO_4]
	,[CN].[OWNER_ID]
	,[CN].[IS_FROM]
	,[CN].[JSON]
	,[CN].[DOC_SERIE]
	,[CN].[DOC_NUM]
	,[CN].[POSTED_BY]
	,[CN].[IS_READY_TO_SEND]
	,[CN].[IS_SENDING]
	,[CN].[LAST_UPDATE_IS_SENDING]
  FROM [acsa].[SWIFT_VIEW_ALL_CUSTOMER_NEW] CN
  WHERE (@CODE_CUSTOMER IS NULL
  OR CN.CODE_CUSTOMER = @CODE_CUSTOMER)
  AND CN.[IS_READY_TO_SEND] = 1

