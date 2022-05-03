﻿CREATE PROC [acsa].[SWIFT_GET_INVENTORY_PICKING]
AS
SELECT 	
	C.CODE_SKU ,
	A.SKU_DESCRIPTION, 	
	SUM(ON_HAND) AS ON_HAND,
	ISNULL ((SELECT SUM(DISPATCH) FROM acsa.SWIFT_PICKING_DETAIL B LEFT OUTER JOIN acsa.SWIFT_PICKING_HEADER X ON X.PICKING_HEADER = B.PICKING_HEADER WHERE B.CODE_SKU = C.CODE_SKU AND X.STATUS <> 'CLOSED'),0)	
	AS RESERVED,
	(SUM(ON_HAND)-
	(ISNULL ((SELECT SUM(DISPATCH) FROM acsa.SWIFT_PICKING_DETAIL B LEFT OUTER JOIN acsa.SWIFT_PICKING_HEADER X ON X.PICKING_HEADER = B.PICKING_HEADER WHERE B.CODE_SKU = C.CODE_SKU AND X.STATUS <> 'CLOSED'),0)))
	AS TO_SALE 
FROM acsa.SWIFT_VIEW_ALL_SKU C, acsa.SWIFT_INVENTORY A 
WHERE C.CODE_SKU = A.SKU 
and (
	((SELECT SUM(ON_HAND)
		 FROM acsa.SWIFT_INVENTORY I
		where I.SKU = A.SKU)-
	(ISNULL ((SELECT SUM(DISPATCH) 
			FROM acsa.SWIFT_PICKING_DETAIL D 
				LEFT OUTER JOIN acsa.SWIFT_PICKING_HEADER X ON X.PICKING_HEADER = D.PICKING_HEADER 
				WHERE D.CODE_SKU = C.CODE_SKU AND X.STATUS <> 'CLOSED'),0)))
) > 0
GROUP BY C.CODE_SKU,SKU_DESCRIPTION
ORDER BY C.CODE_SKU



