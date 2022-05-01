-- =============================================
-- Autor:	pablo.aguilar
-- Fecha de Creacion: 	2017-03-16 @ Team ERGON - Sprint V-ERGON 
-- Description:	 Se crea procedimiento para hacer commit del inventario de una orden de venta. 

-- Modificacion 		9/12/2019 @ G-Force Team Sprint Jakarta
-- Autor: 				diego.as
-- Historia/Bug:		
-- Descripcion: 		9/12/2019 - Se agrega "[SH].[IS_DRAFT] = 0" en el WHERE para evitar rebaja de inventario por documentos DRAFT


/*
-- Ejemplo de Ejecucion:
			EXEC [acsa].[SONDA_SP_COMMIT_INVENTORY_BY_SALES_ORDER_ID] @SALE_ORDER_ID = 

  SELECT * FROM [acsa].[SONDA_IS_COMITED_BY_WAREHOUSE] [C] WHERE C.CODE_SKU IN ('100003'
,'100007'
, '100012'
,'100018') AND C.CODE_WAREHOUSE = 'C001' 

   SELECT * FROM [acsa].[SONDA_SALES_ORDER_HEADER] [SH]
  INNER JOIN [acsa].[SONDA_SALES_ORDER_DETAIL] [SD]
    ON [SH].[SALES_ORDER_ID] = [SD].[SALES_ORDER_ID] 

  WHERE SH.SALES_ORDER_ID = 36954
*/
-- =============================================
CREATE PROCEDURE [acsa].[SONDA_SP_COMMIT_INVENTORY_BY_SALES_ORDER_ID] (@SALE_ORDER_ID INT)
AS
BEGIN
    SET NOCOUNT ON;
    --
    UPDATE [C]
    SET [C].[IS_COMITED] = [C].[IS_COMITED] + [SD].[QTY]
    FROM [acsa].[SONDA_SALES_ORDER_HEADER] [SH]
        INNER JOIN [acsa].[SONDA_SALES_ORDER_DETAIL] [SD]
            ON [SH].[SALES_ORDER_ID] = [SD].[SALES_ORDER_ID]
        INNER JOIN [acsa].[SONDA_IS_COMITED_BY_WAREHOUSE] [C]
            ON [C].[CODE_WAREHOUSE] = [SH].[WAREHOUSE]
               AND [C].[CODE_SKU] = [SD].[SKU]
    WHERE [SH].[SALES_ORDER_ID] = @SALE_ORDER_ID
          AND [SH].[IS_DRAFT] = 0;

END;
