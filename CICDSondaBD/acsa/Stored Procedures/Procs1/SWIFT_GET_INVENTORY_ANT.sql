-- =============================================
-- Autor:				alberto.ruiz
-- Fecha de Creacion: 	19-01-2016
-- Description:			Obtiene el inventario

-- Modificado 20-01-2016
		-- joel.delcompare
		-- Se modifco para agregar el bach supplier 

/*
-- Ejemplo de Ejecucion:
				exec acsa.[SWIFT_GET_INVENTORY]
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_GET_INVENTORY_ANT]
AS
  SELECT 
    A.WAREHOUSE
   ,A.LOCATION
   ,ISNULL(A.SERIAL_NUMBER, 'N/A') AS SERIAL_NUMBER
   ,A.SKU
   ,A.SKU_DESCRIPTION AS DESCRIPTION_SKU
   ,D.BARCODE_SKU AS BARCODE
   ,A.ON_HAND AS ON_HAND
   ,ISNULL(sb.BATCH_SUPPLIER, 'N/A') AS BATCH
   ,sb.BATCH_SUPPLIER_EXPIRATION_DATE AS EXP_DATE
   ,NULL AS EXPIRACION
   ,NULL AS TAGS_BY_BATCH
   ,NULL AS TAGS_BY_SERIE INTO #T
  FROM acsa.SWIFT_INVENTORY AS A
  INNER JOIN acsa.SWIFT_VIEW_ALL_SKU AS D ON (A.SKU = D.CODE_SKU)
  LEFT JOIN acsa.SWIFT_BATCH sb ON A.BATCH_ID = sb.BATCH_ID and sb.QTY > 0
  LEFT JOIN acsa.SWIFT_PALLET pl ON PL.BATCH_ID = A.PALLET_ID
  WHERE A.ON_HAND > 0  ;


  SELECT DISTINCT
    A.WAREHOUSE
   ,A.LOCATION
   ,A.SERIAL_NUMBER
   ,A.SKU
   ,MAX(A.DESCRIPTION_SKU) DESCRIPTION_SKU
   ,MAX(A.BARCODE) BARCODE_SKU
   ,SUM(A.ON_HAND) AS ON_HAND
   ,A.BATCH
   ,A.EXP_DATE
   ,NULL EXPIRACION
   ,NULL TAGS_BY_BATCH
   ,NULL TAGS_BY_SERIE
  FROM #T AS A
  GROUP BY A.WAREHOUSE
          ,A.LOCATION
          ,A.SERIAL_NUMBER
          ,A.SKU
          ,A.BATCH
          ,A.EXP_DATE
