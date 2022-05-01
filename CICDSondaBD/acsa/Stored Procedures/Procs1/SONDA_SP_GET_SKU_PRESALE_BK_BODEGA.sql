-- =============================================
-- Autor:				rudi.garcia
-- Fecha de Creacion: 	12-11-2015
-- Description:			Obtine los sku para la ordenes de venta para la ruta

--Modificacion 09-12-2015
					--alberto.ruiz
					--Se corrigio el obtener la lista de precios para que consumiera la funcion

--Modificacion 19-02-2016
					--rudi.garcia
					--Se modifico para que pudiera obtener el codigo de familia de sku
--Modificacion 10-04-2016
					--jose.garcia
					--Se modifico la funcion par traer la lista de precios por bodega

/*
-- Ejemplo de Ejecucion:
				exec [acsa].[SONDA_SP_GET_SKU_PRESALE] @WAREHOUSES = 'C002'
				  CODIGO BODEGA
					R001 Bodega Regional Retalhuleu
					R002 Bodega Regional Quetzaltenango
					R003 Bodega Regional Huehuetenango
					R004 Bodega Regional Jutiapa
					R005 Bodega Regional Escuintla
					R006 Bodega Regional Teculután
					R007 Bodega Regional Cobán
					R008 Bodega Regional Sololá
					R009 Bodega Regional Morales
					R010 Bodega Regional Petén
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_GET_SKU_PRESALE_BK_BODEGA]
	@WAREHOUSES VARCHAR(50)
	,@CODE_ROUTE VARCHAR(50)=''
AS
BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @ListaPrecios varchar(25)
	--
	--SELECT @ListaPrecios = acsa.[SWIFT_FN_GET_PRICE_LIST](DEFAULT)
	SELECT @ListaPrecios = acsa.[SWIFT_FN_GET_PRICE_LIST_BY_WH] (@WAREHOUSES)--(DEFAULT)
	--	
	SELECT 
		[WAREHOUSE]
		,I.[SKU]
		,SKU_DESCRIPTION AS SKU_NAME
		,[ON_HAND]
		,[IS_COMITED]
		,([ON_HAND] - [IS_COMITED]) AS [DIFFERENCE]
		,p.COST AS SKU_PRICE
		,S.CODE_FAMILY_SKU
		,S.CODE_PACK_UNIT AS SALES_PACK_UNIT
	FROM [acsa].[SWIFT_VIEW_PRESALE_SKU] I
	INNER JOIN acsa.SWIFT_PRICE_LIST_BY_SKU p on (p.CODE_SKU = I.SKU)
	LEFT JOIN acsa.SWIFT_VIEW_ALL_SKU S ON (I.SKU = S.CODE_SKU AND P.CODE_SKU = S.CODE_SKU)
	WHERE [WAREHOUSE] = @WAREHOUSES
	AND  p.CODE_PRICE_LIST = @ListaPrecios
END
