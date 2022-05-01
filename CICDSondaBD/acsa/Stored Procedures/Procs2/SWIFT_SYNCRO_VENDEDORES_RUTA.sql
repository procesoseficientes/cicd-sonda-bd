-- =============================================
-- Autor:				404
-- Fecha de Creacion: 	18-11-2019
-- Description:			Copiar reporte de tareas a las intermedias del cliente

/*
-- Ejemplo de Ejecucion:
				-- 
				EXEC [acsa].[SWIFT_SYNCRO_VENDEDORES_RUTA]
				--
			
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SYNCRO_VENDEDORES_RUTA]
AS
BEGIN
	SET NOCOUNT ON;

------------------------------------------------------------------------------------------
--Declaramos la variable @Ruta
------------------------------------------------------------------------------------------
DECLARE @RUTA AS VARCHAR(100);

--------------------------------------------------------------------------------------------
--Insertamos todas las rutas activas en el sistema
--------------------------------------------------------------------------------------------
PRINT 'Identificando Rutas'
SELECT CODE_ROUTE
INTO #Rutas
FROM acsa.SWIFT_ROUTES
ORDER BY CODE_ROUTE


--------------------------------------------------------------------------------------------
--Insertamos todas las ventas y preventas por tarea con su respectivo total
--------------------------------------------------------------------------------------------
PRINT 'Cargando Transacciones'
SELECT TASK_ID,
       TOTAL_AMOUNT,
       'PRESALE' [TYPE]
INTO #TOTAL_AMOUNT
FROM acsa.SONDA_SALES_ORDER_HEADER
WHERE POSTED_DATETIME >= FORMAT(GETDATE(), 'yyyMMdd')
      AND IS_READY_TO_SEND = 1
      AND IS_VOID = 0
	  

UNION
SELECT TASK_ID,
       TOTAL_AMOUNT,
       'SALE' [TYPE]
FROM acsa.SONDA_POS_INVOICE_HEADER
WHERE POSTED_DATETIME >= FORMAT(GETDATE(), 'yyyMMdd')
      AND IS_READY_TO_SEND = 1
      AND VOIDED_INVOICE IS NULL
UNION ALL
SELECT TASK_ID,
	   '0' [TOTAL_AMOUNT],
		 TASK_TYPE [TYPE]
 FROM acsa.SWIFT_TASKS
 WHERE SCHEDULE_FOR >= FORMAT(GETDATE(), 'yyyMMdd')
 AND COMPLETED_SUCCESSFULLY=0


--------------------------------------------------------------------------------------------
--Insertamos todas las ventas y preventas por tarea con su respectivo total
--------------------------------------------------------------------------------------------

	WHILE EXISTS (SELECT TOP 1 1 CODE_ROUTE FROM #Rutas)
		BEGIN

			SELECT TOP 1
				   @RUTA = CODE_ROUTE
			FROM #Rutas;

			PRINT 'Syncronizando Ruta ' + @RUTA

			INSERT INTO DIPROCOM_SERVER.SONDA.dbo.VENDEDOR_RUTA
			(
				CODIGO_DE_RUTA,
				ORDEN,
				FECHA_FINALIZADA,
				CODIGO_DE_CLIENTE,
				GPS_GESTION,
				GPS_ESPERADO,
				TOTAL_VENTA
			)
			SELECT T.CODE_ROUTE,
				   ROW_NUMBER() OVER (ORDER BY T.TASK_ID ASC) AS [ORDEN],
				   T.COMPLETED_STAMP,
				   T.COSTUMER_CODE,
				   T.EXPECTED_GPS,
				   T.POSTED_GPS,
				   I.TOTAL_AMOUNT
			FROM acsa.SWIFT_TASKS T
				INNER JOIN #TOTAL_AMOUNT I
					ON T.TASK_ID = I.TASK_ID
			WHERE T.SCHEDULE_FOR = FORMAT(GETDATE(), 'yyyyMMdd')
				  AND T.CODE_ROUTE = @RUTA
			ORDER BY T.COMPLETED_STAMP;


			DELETE FROM #Rutas
			WHERE CODE_ROUTE = @RUTA
		END
END
