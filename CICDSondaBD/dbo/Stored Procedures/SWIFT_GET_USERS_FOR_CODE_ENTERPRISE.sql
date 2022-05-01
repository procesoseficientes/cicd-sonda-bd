﻿CREATE PROC [dbo].[SWIFT_GET_USERS_FOR_CODE_ENTERPRISE]
@CODE_ENTERPRISE VARCHAR(150)
AS
SELECT 
	A.CORRELATIVE,
	A.[LOGIN],
	A.NAME_USER,
	A.TYPE_USER,
	A.[PASSWORD],
	A.CODE_ENTERPRISE,
	A.[IMAGE],
	C.NAME_ROUTE AS SELLER_ROUTE,
	B.SELLER_NAME AS RELATED_SELLER
FROM dbo.SWIFT_USER AS A
LEFT OUTER JOIN profinsa.SWIFT_VIEW_SAP_SELLERS AS B
	ON A.RELATED_SELLER = B.SELLER_CODE
LEFT OUTER JOIN profinsa.SWIFT_VIEW_ROUTES AS C
	ON A.SELLER_ROUTE = C.CODE_ROUTE
 WHERE A.CODE_ENTERPRISE=@CODE_ENTERPRISE




