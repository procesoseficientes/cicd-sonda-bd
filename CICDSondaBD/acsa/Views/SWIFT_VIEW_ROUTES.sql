-- =============================================
-- Autor:				        hector.gonzalez
-- Fecha de Creacion: 	18-Nov-16 @ A-TEAM Sprint 5 
-- Description:			    Se configuro vista para que mande el codigo y nombre del vendedor

/*
-- Ejemplo de Ejecucion:
		SELECT * FROM [acsa].SWIFT_VIEW_ROUTES
*/
-- =============================================
CREATE VIEW [acsa].[SWIFT_VIEW_ROUTES]
AS
 SELECT
  ROUTE
 ,CODE_ROUTE
 ,NAME_ROUTE
 ,GEOREFERENCE_ROUTE
 ,COMMENT_ROUTE
 ,sr.SELLER_CODE
,ss.SELLER_NAME
FROM [acsa].SWIFT_ROUTES sr 
  LEFT JOIN [acsa].SWIFT_SELLER ss 
  ON sr.SELLER_CODE = ss.SELLER_CODE

