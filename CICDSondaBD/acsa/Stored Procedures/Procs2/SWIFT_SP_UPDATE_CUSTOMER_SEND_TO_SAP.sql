-- =============================================
-- Autor:				jose.garcia
-- Fecha de Creacion: 	02-05-2016
-- Description:			Actualiza los clientes de scouting para que no se envien a sap con las interfaces



/*
-- Ejemplo de Ejecucion:
				exec [acsa].[SWIFT_SP_UPDATE_CUSTOMER_SEND_TO_SAP]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_UPDATE_CUSTOMER_SEND_TO_SAP]
AS
DECLARE @DF AS VARCHAR(25)
		,@USUARIO AS VARCHAR(25) 
		,@WH AS VARCHAR(25) ='C002'
		--,@CODECUSTOMER AS VARCHAR(25)


select top 1 @USUARIO = SELLER_DEFAULT_CODE from acsa.SWIFT_CUSTOMERS_NEW
where IS_POSTED_ERP <> 1 --and @WH != (select  DEFAULT_WAREHOUSE from acsa.USERS where DEFAULT_WAREHOUSE != @WH)
select @USUARIO as seller


select @DF = DEFAULT_WAREHOUSE from acsa.USERS
where LOGIN= @USUARIO OR  UPPER(LOGIN)= UPPER('Operador gerente')
select @DF as Bodega


--IF (@DF != @WH)
--BEGIN
--UPDATE acsa.SWIFT_CUSTOMERS_NEW
--SET IS_POSTED_ERP = 1
--	,POSTED_ERP = GETDATE()
--    ,POSTED_RESPONSE='ENVIADO'
--	,@DF = 'ENVIADO'
--WHERE SELLER_DEFAULT_CODE = @USUARIO
--and IS_POSTED_ERP <>1
--END 
--SELECT @DF ESTADO
