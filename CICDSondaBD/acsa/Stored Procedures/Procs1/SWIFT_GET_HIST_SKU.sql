﻿CREATE PROC [acsa].[SWIFT_GET_HIST_SKU]
@SKU VARCHAR(MAX),
@DTBEGIN VARCHAR(50),
@DTEND VARCHAR(50)
AS

SELECT INVENTORY = IDENTITY(int,1,1) , *
INTO #temp FROM [acsa].SWIFT_VIEW_HIST_SKU SKU WHERE SKU IN 
(select Data from [acsa].Split
(@SKU,','))


--DECLARE @SQL varchar(MAX)

SELECT * FROM #temp 
WHERE
CONVERT(DATE, @DTBEGIN ) >= CONVERT(DATE,INV_DATE) AND CONVERT(DATE,@DTEND) <= CONVERT(DATE,INV_DATE)
ORDER BY INV_DATE

DROP TABLE #temp


--SELECT * FROM #temp

--DROP TABLE #temp

--DECLARE @SQL varchar(MAX)
--SET @SQL = '

--SELECT INVENTORY = IDENTITY(int,1,1) , *
--INTO #temp  FROM [acsa].SWIFT_VIEW_HIST_SKU WHERE SKU IN ('+ @SKU +') ORDER BY DESCRIPTION_SKU ASC

--SELECT * FROM #temp 
--WHERE
--CONVERT(DATE,''' + @DTBEGIN + ''') >= CONVERT(DATE,INV_DATE) AND CONVERT(DATE,''' + @DTEND + ''') <= CONVERT(DATE,INV_DATE)
--ORDER BY INV_DATE

--DROP TABLE #temp
--'
--EXEC(@SQL)	
--SELECT * FROM #temp 

--WHERE
--CONVERT(DATETIME,'+ @DTBEGIN +') >= CONVERT(DATETIME,INV_DATE) AND CONVERT(DATETIME,' + @DTEND + ') <= CONVERT(DATETIME,INV_DATE)
--ORDER BY INV_DATE

--WHERE
--CONVERT(DATE,'+ @DTBEGIN +') >= CONVERT(DATE,INV_DATE) AND CONVERT(DATE,' + @DTEND + ') <= CONVERT(DATE,INV_DATE)

