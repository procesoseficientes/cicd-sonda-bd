CREATE PROC [acsa].[SWIFT_GET_ALL_DELIVERY_COMPLIANCE]
AS
SELECT 
	A.MANIFEST_HEADER, 
	(SELECT COUNT(J.CODE_PICKING) FROM acsa.SWIFT_MANIFEST_DETAIL J WHERE J.CODE_MANIFEST_HEADER = A.MANIFEST_HEADER 
	) AS 'CANTIDAD_PEDIDOS', 
	A.CREATED_DATE, 
	A.ACCEPTED_STAMP,
	A.LAST_UPDATE,
	A.COMPLETED_STAMP, 
	B.NAME_DRIVER, 
	c.NAME_ROUTE
 FROM 
	acsa.SWIFT_MANIFEST_HEADER A, 
	acsa.SWIFT_DRIVERS B, 
	acsa.SWIFT_ROUTES C
 
 WHERE 
	B.CODE_DRIVER = A.CODE_DRIVER 
	AND C.CODE_ROUTE = A.CODE_ROUTE
 
 ORDER BY A.MANIFEST_HEADER ASC





