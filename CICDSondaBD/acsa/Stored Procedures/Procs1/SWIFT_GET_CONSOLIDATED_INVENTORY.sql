﻿CREATE PROCEDURE [acsa].[SWIFT_GET_CONSOLIDATED_INVENTORY]
AS
SELECT 
	INVENTORY = IDENTITY(int,1,1) ,
	--A.SERIAL_NUMBER,
	A.SKU,
	A.DESCRIPTION_SKU,
	A.BARCODE,
	A.ON_HAND
INTO #temp  FROM acsa.SWIFT_VIEW_CONSOLIDATED_INVENTORY A --WHERE C.CODE_SKU = A.SKU GROUP BY C.CODE_SKU,SKU_DESCRIPTION 
SELECT * FROM #temp 

DROP TABLE #temp






