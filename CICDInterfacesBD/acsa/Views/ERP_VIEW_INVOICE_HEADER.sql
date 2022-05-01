


CREATE VIEW [acsa].[ERP_VIEW_INVOICE_HEADER]
AS
select *from [acsa].[SWIFT_ERP_ORDER_HEADER]
--openquery (ACSASERVER,'SELECT * FROM [SONDA_ACSA_PRUEBAS].[dbo].[mov_pedidos_encabezado_tracking]')





