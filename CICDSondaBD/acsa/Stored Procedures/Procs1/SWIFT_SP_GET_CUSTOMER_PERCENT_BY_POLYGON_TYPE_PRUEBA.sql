
-- =============================================
-- Autor:                hector.gonzalez
-- Fecha de Creacion:     20-07-2016
-- Description:          obtiene la cantidad de clientes y el porcentaje del poligono 

/* --DROP PROCEDURE [acsa].[SWIFT_SP_GET_CUSTOMER_PERCENT_BY_POLYGON_TYPE]
-- Ejemplo de Ejecucion:
        --
        EXEC [acsa].[SWIFT_SP_GET_CUSTOMER_PERCENT_BY_POLYGON_TYPE_PRUEBA]
@POLYGON_TYPE = 'SECTOR'
  ,@POLYGON_SUB_TYPE = NULL
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CUSTOMER_PERCENT_BY_POLYGON_TYPE_PRUEBA] (@POLYGON_TYPE VARCHAR(250)
, @POLYGON_SUB_TYPE VARCHAR(250) = NULL)
AS
BEGIN
  BEGIN TRY

    -- ------------------------------------------------------------------------------------
    -- Declaramos las variables a utilizar
    -- ------------------------------------------------------------------------------------
    DECLARE @TOTAL_CUSTOMERS INT = 0
           ,@vPOLYGON_ID INT
           ,@vPOLYGON_NAME VARCHAR(250)
           ,@vPARENT_NAME VARCHAR(250)
           ,@vCOMMENT VARCHAR(250)
           ,@vDESCRIPTION VARCHAR(250)
           ,@vSUB_TYPE VARCHAR(250)
           ,@POLYGON NVARCHAR(MAX) = ''
           ,@POINT_IN_POLYGON INT = 0
           ,@PARENT INT
           ,@PARENTLAST INT = 0
           ,@POINT_OUT_PARENT INT = 0
           ,@GEOMETRY_POLYGON GEOMETRY
           ,@CUSTOMER_COUNT INT
           ,@PERCENT NUMERIC(18, 6)

    CREATE TABLE #POLIGONOSPORCENTAJES (
      POLYGON_ID INT
     ,POLYGON_NAME VARCHAR(250)
     ,SUB_TYPE VARCHAR(250) DEFAULT NULL
     ,CUSTOMERS_COUNT INT
     ,CUSTOMERS_PERCENT NUMERIC(18, 6)
     ,COMMENT VARCHAR(250)
     ,POLYGON_DESCRIPTION VARCHAR(250)
     ,PARENT_NAME VARCHAR(250)
    )

    -- ------------------------------------------------------------------------------------
    -- Obtenemos todos los poligonos del tipo y subtipo a generar
    -- ------------------------------------------------------------------------------------
    SELECT
      P.POLYGON_ID
     ,P.POLYGON_NAME
     ,P.POLYGON_DESCRIPTION
     ,P.COMMENT
     ,P.LAST_UPDATE_BY
     ,P.LAST_UPDATE_DATETIME
     ,P.POLYGON_ID_PARENT
     ,P.POLYGON_TYPE
     ,P.SUB_TYPE
     ,PP.POLYGON_NAME AS PARENT_NAME INTO #POLYGONS
    FROM acsa.SWIFT_POLYGON P
    LEFT JOIN acsa.SWIFT_POLYGON PP
      ON P.POLYGON_ID_PARENT = PP.POLYGON_ID
    WHERE P.POLYGON_TYPE = @POLYGON_TYPE
    AND (P.SUB_TYPE = @POLYGON_SUB_TYPE
    OR @POLYGON_SUB_TYPE IS NULL)


    -- ------------------------------------------------------------------------------------
    -- Obtiene todos los clientes que tienen una ubicacion 
    -- ------------------------------------------------------------------------------------

	DECLARE @LocationTVP AS CUSTOMER_POSITION_TYPE
  
/* Add data to the table variable. */  
INSERT INTO @LocationTVP (LATITUDE, LONGITUDE)  
    SELECT LATITUDE, LONGITUDE 
    FROM acsa.SWIFT_VIEW_ALL_COSTUMER scn		
    WHERE GPS <> '0,0'
    AND GPS IS NOT NULL 
  
/* Pass the table variable data to a stored procedure. */  



	  SELECT
      @TOTAL_CUSTOMERS = COUNT(1)
    FROM @LocationTVP


    PRINT @TOTAL_CUSTOMERS
    -- ------------------------------------------------------------------------------------
    -- Inicia ciclo para cada poligono obtenido
    -- ------------------------------------------------------------------------------------
    WHILE EXISTS (SELECT TOP 1
          1
        FROM #POLYGONS)
    BEGIN
      SELECT TOP 1
        @vPOLYGON_ID = POLYGON_ID
       ,@vPOLYGON_NAME = POLYGON_NAME
       ,@PARENT = POLYGON_ID_PARENT
       ,@vPARENT_NAME = PARENT_NAME
       ,@vDESCRIPTION = POLYGON_DESCRIPTION
       ,@vCOMMENT = COMMENT
       ,@vSUB_TYPE = SUB_TYPE
      FROM #POLYGONS
      ORDER BY POLYGON_ID_PARENT ASC


      -- ------------------------------------------------------------------------------------
      -- Obtener el total de clientes del poligono padre actual 
      -- ------------------------------------------------------------------------------------
      IF @PARENT <> NULL
      BEGIN
        IF @PARENTLAST <> @PARENT
        BEGIN
          SET @PARENTLAST = @PARENT
          SET @GEOMETRY_POLYGON = acsa.SWIFT_GET_GEOMETRY_POLYGON_BY_POLIGON_ID(@PARENT)
          SELECT
            @TOTAL_CUSTOMERS = acsa.SWIFT_GET_CUSTOMERS_COUNT_BY_GEOMETRY_POLYGON_PRUEBA(@GEOMETRY_POLYGON, @LocationTVP)
        END
        PRINT @TOTAL_CUSTOMERS
      END

      -- ------------------------------------------------------------------------------------
      -- Obtener el total de clientes del poligono actual 
      -- ------------------------------------------------------------------------------------
      SET @GEOMETRY_POLYGON = acsa.SWIFT_GET_GEOMETRY_POLYGON_BY_POLIGON_ID(@vPOLYGON_ID)
      SELECT
        @CUSTOMER_COUNT = acsa.SWIFT_GET_CUSTOMERS_COUNT_BY_GEOMETRY_POLYGON(@GEOMETRY_POLYGON)
      IF @TOTAL_CUSTOMERS <> 0
      BEGIN
        SET @PERCENT = (CAST(@CUSTOMER_COUNT AS NUMERIC(18, 6)) * 100 / CAST(@TOTAL_CUSTOMERS AS NUMERIC(18, 6)))
      END
      ELSE
      BEGIN
        SET @PERCENT = 0
      END

      INSERT INTO #POLIGONOSPORCENTAJES (POLYGON_ID, POLYGON_NAME, SUB_TYPE, CUSTOMERS_COUNT, CUSTOMERS_PERCENT, PARENT_NAME, POLYGON_DESCRIPTION, COMMENT)
        VALUES (@vPOLYGON_ID, @vPOLYGON_NAME, @vSUB_TYPE, @CUSTOMER_COUNT, @PERCENT, @vPARENT_NAME, @vDESCRIPTION, @vCOMMENT)

      DELETE FROM #POLYGONS
      WHERE POLYGON_ID = @vPOLYGON_ID
    END
    -- ------------------------------------------------------------------------------------
    -- Termina ciclo
    -- ------------------------------------------------------------------------------------
    SELECT
      POLYGON_ID
     ,POLYGON_NAME
     ,SUB_TYPE
     ,CUSTOMERS_COUNT
     ,CUSTOMERS_PERCENT
     ,PARENT_NAME
     ,POLYGON_DESCRIPTION
     ,COMMENT
    FROM #POLIGONOSPORCENTAJES
    DROP TABLE #POLIGONOSPORCENTAJES
    DROP TABLE #POLYGONS
  END TRY
  BEGIN CATCH

    SELECT
      -1 AS RESULTADO
     ,ERROR_MESSAGE() MENSAJE
     ,@@ERROR CODIGO
  END CATCH
END



