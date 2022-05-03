﻿CREATE PROC [acsa].[SWIFT_GET_STATUS_INVENTORY]
AS
SELECT 
	INVENTORY = IDENTITY(int,1,1) , 
	C.CODE_SKU,
	A.SKU_DESCRIPTION AS DESCRIPTION_SKU, 
	SUM(ON_HAND) AS ON_HAND,
	ISNULL ((SELECT SUM(DISPATCH) FROM acsa.SWIFT_PICKING_DETAIL B LEFT OUTER JOIN acsa.SWIFT_PICKING_HEADER X ON X.PICKING_HEADER = B.PICKING_HEADER  WHERE B.CODE_SKU = C.CODE_SKU COLLATE SQL_Latin1_General_CP1_CI_AS AND X.STATUS <> 'CLOSED' AND X.STATUS <> 'COMPLETED'),0)+
	ISNULL ((SELECT SUM(DISPATCH) FROM acsa.SWIFT_TEMP_PICKING_DETAIL B WHERE B.CODE_SKU = C.CODE_SKU COLLATE SQL_Latin1_General_CP1_CI_AS),0)    
	AS RESERVED,
	(SUM(ON_HAND)-
	(ISNULL ((SELECT SUM(DISPATCH) FROM acsa.SWIFT_PICKING_DETAIL B LEFT OUTER JOIN acsa.SWIFT_PICKING_HEADER X ON X.PICKING_HEADER = B.PICKING_HEADER WHERE B.CODE_SKU = C.CODE_SKU COLLATE SQL_Latin1_General_CP1_CI_AS AND X.STATUS <> 'CLOSED' AND X.STATUS <> 'COMPLETED'),0)+
	ISNULL ((SELECT SUM(DISPATCH) FROM acsa.SWIFT_TEMP_PICKING_DETAIL B WHERE B.CODE_SKU = C.CODE_SKU COLLATE SQL_Latin1_General_CP1_CI_AS),0)  )  ) 
	AS TO_SALE 
INTO #temp  FROM acsa.SWIFT_VIEW_SKU C,  acsa.SWIFT_INVENTORY A WHERE C.CODE_SKU = A.SKU COLLATE SQL_Latin1_General_CP1_CI_AS GROUP BY C.CODE_SKU , SKU_DESCRIPTION 
SELECT * FROM #temp
DROP TABLE #temp





