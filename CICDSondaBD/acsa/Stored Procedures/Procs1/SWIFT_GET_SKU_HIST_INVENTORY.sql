﻿CREATE PROCEDURE [acsa].[SWIFT_GET_SKU_HIST_INVENTORY]
@SKU VARCHAR(50)
AS

SELECT     
	A.INVENTORY, 
	ISNULL(A.SERIAL_NUMBER,'N/A') AS SERIAL_NUMBER,
	A.WAREHOUSE, 
	A.LOCATION, 
	A.SKU,
	A.SKU_DESCRIPTION AS DESCRIPTION_SKU, 
	D.BARCODE_SKU AS BARCODE, 
	A.ON_HAND,
	ISNULL(E.BATCH_ID,'N/A') AS BATCH,
	A.PROC_DATE, 
	A.INV_DATE, 
	A.COST, 
	CONVERT(DATE,E.EXP_DATE) AS EXP_DATE,
CASE 
            WHEN CONVERT(DATE,E.EXP_DATE) <= CONVERT(DATE,GETDATE())
               THEN 'LOTE EXPIRADO'
            WHEN CONVERT(DATE,E.EXP_DATE) >= CONVERT(DATE,GETDATE()) AND CONVERT(DATE,E.EXP_DATE) <= CONVERT(DATE,GETDATE()+5)
               THEN 'LOTE PROXIMO A EXPIRAR'
            WHEN CONVERT(DATE,E.EXP_DATE) >= CONVERT(DATE,GETDATE())
               THEN 'LOTE VIGENTE'
END AS EXPIRACION,
	(A.ON_HAND * A.COST) AS TOTAL
FROM         acsa.SWIFT_HIST_INVENTORY AS A 
LEFT OUTER JOIN acsa.SWIFT_VIEW_ALL_SKU AS D ON A.SKU = D.CODE_SKU

LEFT OUTER JOIN acsa.SWIFT_BATCHES AS E ON A.BATCH_ID = E.BATCH_ID


WHERE D.CODE_SKU = @SKU





