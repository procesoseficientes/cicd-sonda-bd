CREATE PROCEDURE [acsa].[SWIFT_SP_SALES_CUSTOMER]          
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @route VARCHAR(50)
,@client INT
,@scouting VARCHAR(50)
,@sales int
,@start INT=0

------------------------------------------------------------------------------------
-- VERIFICA SI EXISTEN PEDIDOS SIN CLIENTES
------------------------------------------------------------------------------------


select  @start=COUNT(*)
from acsa.SONDA_SALES_ORDER_HEADER with (nolock)
where POSTED_DATETIME>=  format (getdate(),'yyyyMMdd')
AND is_void=0
and is_ready_to_send=1
AND CLIENT_ID LIKE '-%'


SELECT @start [PEDIDOS]

	IF (@start>0) 
		BEGIN

			 ------------------------------------------------------------------------------------
			-- TOMA LOS DATOS DEL PEDIDO SIN CLIENTE
			------------------------------------------------------------------------------------
		
			select  TOP 1 @route=POS_TERMINAL, @client=CLIENT_ID, @sales=SALES_ORDER_ID
			from acsa.SONDA_SALES_ORDER_HEADER with (nolock)
			where POSTED_DATETIME>=  format (getdate(),'yyyyMMdd')
			AND is_void=0
			and is_ready_to_send=1
			AND CLIENT_ID LIKE '-%'
			SELECT @route [OPERADOR], @client [CLIENTE HH] ,@sales [ORDEN]
			------------------------------------------------------------------------------------
			-- BUSCAR EL CLIENTE AL QUE PERTENECE EL PEDIDO
			------------------------------------------------------------------------------------

			SELECT TOP 1 @scouting=CODE_CUSTOMER
			 from acsa.SWIFT_CUSTOMERS_NEW with (nolock)
			where POST_DATETIME>= format (getdate(),'yyyyMMdd')
			AND CODE_ROUTE=@route
			AND CODE_CUSTOMER_HH=@client
			SELECT @scouting [CLIENTE BO]

			------------------------------------------------------------------------------------
			-- ACTUALIZAR EL CLIENTE AL PEDIDO
			------------------------------------------------------------------------------------

			update   acsa.SONDA_SALES_ORDER_HEADER
			SET CLIENT_ID=@scouting
			WHERE SALES_ORDER_ID=@sales


		END
	ELSE
		BEGIN
			SELECT 'VENTAS COMPLETAS' [RESULTADO]
		END


END
