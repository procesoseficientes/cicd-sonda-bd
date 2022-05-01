-- =============================================
-- Autor:                hector.gonzalez
-- Fecha de Creacion:    22-07-2016
-- Description:          obtiene los clientes por un polygon id 

-- Modificado 2016-08-024 Sprint ?
-- rudi.garcia
-- Se agrego un left join a la tabla "SWIFT_CUSTOMERS_NEW" para obtener la foto del scouting y un left join a la tabla "SWIFT_FREQUENCY_X_CUSTOMER" para saber si tiene una frecuencia.

-- Modificado 2016-09-20 Sprint 1 TEAM-A
-- rudi.garcia
-- Se agrego un left join a la tabla [SWIFT_POLYGON_X_CUSTOMER] para obtener el estado del cliente en el polygono. 

-- Modificado 2016-09-20 Sprint 2 TEAM-A
-- rudi.garcia
-- Se agrego el campo de id_poligono

/* 
-- Ejemplo de Ejecucion:
        --
        EXEC [acsa].[SWIFT_SP_GET_CUSTOMER_BY_POLYGON_ID]
        @POLYGON_ID = 69
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CUSTOMER_BY_POLYGON_ID_TUNNING] ( @POLYGON_ID INT )
AS
    BEGIN
        BEGIN TRY

            DECLARE @GEOMETRY_POLYGON GEOMETRY;            
            SELECT  @GEOMETRY_POLYGON = acsa.SWIFT_GET_GEOMETRY_POLYGON_BY_POLIGON_ID(@POLYGON_ID);


            SELECT  C.CODE_CUSTOMER ,
                    C.NAME_CUSTOMER ,
                    C.PHONE_CUSTOMER ,
                    C.ADRESS_CUSTOMER ,
                    C.LATITUDE ,
                    C.LONGITUDE ,
                    @GEOMETRY_POLYGON.MakeValid().STContains(geometry::Point(ISNULL(C.LATITUDE,
                                                              0),
                                                              ISNULL(C.LONGITUDE,
                                                              0), 0)) IS_IN
            INTO    #CUSTOMER
            FROM    acsa.SWIFT_VIEW_ALL_COSTUMER C;

            DELETE  FROM #CUSTOMER
            WHERE   IS_IN = 0;

            

    -- ------------------------------------------------------------------------------------
    -- Muestra quienes estan en el poligono
    -- ------------------------------------------------------------------------------------
            SELECT  C.CODE_CUSTOMER ,
                    C.NAME_CUSTOMER ,
                    C.PHONE_CUSTOMER ,
                    C.ADRESS_CUSTOMER ,
                    C.LATITUDE ,
                    C.LONGITUDE ,
                    C.IS_IN ,
                    ISNULL(CF.CODE_FREQUENCY, 0) AS CODE_FREQUENCY ,
                    ISNULL(CONVERT(INT, CF.SUNDAY), 0) AS SUNDAY ,
                    ISNULL(CONVERT(INT, CF.MONDAY), 0) AS MONDAY ,
                    ISNULL(CONVERT(INT, CF.TUESDAY), 0) AS TUESDAY ,
                    ISNULL(CONVERT(INT, CF.WEDNESDAY), 0) AS WEDNESDAY ,
                    ISNULL(CONVERT(INT, CF.THURSDAY), 0) AS THURSDAY ,
                    ISNULL(CONVERT(INT, CF.FRIDAY), 0) AS FRIDAY ,
                    ISNULL(CONVERT(INT, CF.SATURDAY), 0) AS SATURDAY ,
                    ISNULL(CONVERT(INT, CF.FREQUENCY_WEEKS), 0) AS FREQUENCY_WEEKS ,
                    CF.LAST_DATE_VISITED ,
                    CASE WHEN PC.HAS_PROPOSAL IS NOT NULL
                              AND CF.CODE_CUSTOMER IS NOT NULL THEN 1
                         ELSE 0
                    END HAS_PROPOSAL ,
                    CASE WHEN PC.HAS_FREQUENCY IS NOT NULL
                              AND FC.ID_FREQUENCY IS NOT NULL THEN 1
                         ELSE 0
                    END HAS_FREQUENCY ,
                    COALESCE(PC.IS_NEW, 0) IS_NEW ,
                    PC.POLYGON_ID ,
                    ROW_NUMBER() OVER ( PARTITION BY C.CODE_CUSTOMER ORDER BY PC.POLYGON_ID DESC, FC.CODE_CUSTOMER DESC, CF.CODE_FREQUENCY DESC ) [ROWNUM]
            INTO    #RESULT
            FROM    #CUSTOMER C
                    LEFT JOIN [acsa].[SWIFT_POLYGON_X_CUSTOMER] PC ON ( C.CODE_CUSTOMER = PC.CODE_CUSTOMER
                                                              AND PC.POLYGON_ID = @POLYGON_ID
                                                              )
                    LEFT JOIN acsa.SWIFT_CUSTOMER_FREQUENCY CF ON ( CF.CODE_CUSTOMER = C.CODE_CUSTOMER )
                    LEFT JOIN [acsa].[SWIFT_FREQUENCY_X_CUSTOMER] FC ON ( C.CODE_CUSTOMER = FC.CODE_CUSTOMER );

            SELECT  R.CODE_CUSTOMER ,
                    R.NAME_CUSTOMER ,
                    R.PHONE_CUSTOMER ,
                    R.ADRESS_CUSTOMER ,
                    R.LATITUDE ,
                    R.LONGITUDE ,
                    R.IS_IN ,
                    R.CODE_FREQUENCY ,
                    R.SUNDAY ,
                    R.MONDAY ,
                    R.TUESDAY ,
                    R.WEDNESDAY ,
                    R.THURSDAY ,
                    R.FRIDAY ,
                    R.SATURDAY ,
                    R.FREQUENCY_WEEKS ,
                    R.LAST_DATE_VISITED ,
                    R.HAS_PROPOSAL ,
                    R.HAS_FREQUENCY ,
                    R.IS_NEW ,
                    R.POLYGON_ID
            FROM    #RESULT R
            WHERE   R.ROWNUM = 1;

        END TRY
        BEGIN CATCH
            SELECT  -1 AS RESULTADO ,
                    ERROR_MESSAGE() MENSAJE ,
                    @@ERROR CODIGO;
        END CATCH;
    END;
