CREATE PROCEDURE [acsa].[SP_SWIFT_SERIE_BY_NUM]
AS

-------- POR SECUENCIA
select 
	doc_serie
	,doc_num
	,count(doc_num) [TOTAL]
	INTO  #SERIE
from  acsa.SONDA_SALES_ORDER_HEADER (NOLOCK)
where sales_order_id > 0
	and is_ready_to_send = 1
	and POSTED_DATETIME>=  format (getdate(),'yyyyMMdd')
group by doc_serie
	,doc_num
having count(doc_num) > 1

INSERT INTO acsa.swift_serie_by_num
SELECT * FROM #SERIE

--------- POR CLIENTE

select 
	client_id [CUSTOMER]
	,max(sales_order_id) [ORDER]
	,count(client_id) [TOTAL]
	INTO  #CST
from  acsa.SONDA_SALES_ORDER_HEADER (NOLOCK)
where  is_ready_to_send = 1 
	and POSTED_DATETIME>=  format (getdate(),'yyyyMMdd')
group by client_id
having count(client_id) > 1
order by 1

INSERT INTO acsa.swift_customer_by_sale
SELECT * FROM #CST

UPDATE acsa.SONDA_SALES_ORDER_HEADER 
SET IS_READY_TO_SEND=0
WHERE DOC_SERIE IN (SELECT S.DOC_SERIE FROM #SERIE S)
AND DOC_NUM IN (SELECT S.DOC_NUM FROM #SERIE S)


UPDATE acsa.SONDA_SALES_ORDER_HEADER
SET IS_READY_TO_SEND=0
WHERE SALES_ORDER_ID IN (SELECT [ORDER] FROM #CST)
