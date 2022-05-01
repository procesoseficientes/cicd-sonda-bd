-- =============================================
-- Autor:				Jonathan.Salvador
-- Fecha de Creacion: 	18-10-2019 
-- Description:			SP que obtiene los usuarios que no tienen monto de pedido minimo 

-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_USER_WITHOUT_MINIMUM_ORDER]
AS
BEGIN
    SELECT DISTINCT
           [U].[CORRELATIVE],
           [U].[LOGIN],
           [U].[NAME_USER],
           [U].[TYPE_USER]
    FROM [acsa].[USERS] [U]
    WHERE NOT EXISTS
    (
        SELECT NULL
        FROM [acsa].[SWIFT_MINIMUM_ORDER_BY_USER] [SMOU]
        WHERE [SMOU].[USER] = [U].[LOGIN]
    )
          AND [U].[SELLER_ROUTE] IS NOT NULL;
END;
