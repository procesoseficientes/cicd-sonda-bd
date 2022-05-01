-- =============================================
-- Autor:				ppablo.loukota
-- Fecha de Creacion: 	07-12-2015
-- Description:			Inserta la secuencia de documentos

-- Modificacion 		12/4/2019 @ G-Force Team Sprint Oslo
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 33798: Generacion de documento de contingencia
-- Descripcion: 		12/4/2019 - Se agrega validacion de rango de documentos para DOCUMENTOS DE CONTINGENCIA FEL en SONDA SD

--                      
/*
-- Ejemplo de Ejecucion:				
				--
DECLARE @DOC_TYPE varchar(50)
DECLARE @ASSIGNED_DATETIME datetime
DECLARE @POST_DATETIME datetime
DECLARE @ASSIGNED_BY varchar(100)
DECLARE @DOC_FROM int
DECLARE @DOC_TO int
DECLARE @SERIE varchar(100)
DECLARE @ASSIGNED_TO varchar(100)
DECLARE @CURRENT_DOC int
DECLARE @STATUS varchar(15)
DECLARE @BRANCH_NAME varchar(50)
DECLARE @BRANCH_ADDRESS varchar(150)

-- TODO: Set parameter values here.

EXECUTE [acsa].[SWIFT_SP_INSERT_DOCUMENT_SEQUENCE] 
   @DOC_TYPE
  ,@ASSIGNED_DATETIME
  ,@POST_DATETIME
  ,@ASSIGNED_BY
  ,@DOC_FROM
  ,@DOC_TO
  ,@SERIE
  ,@ASSIGNED_TO
  ,@CURRENT_DOC
  ,@STATUS
  ,@BRANCH_NAME
  ,@BRANCH_ADDRESS
GO
				--				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_INSERT_DOCUMENT_SEQUENCE]
    @DOC_TYPE VARCHAR(50),
    @POST_DATETIME DATETIME,
    @ASSIGNED_BY VARCHAR(100),
    @DOC_FROM INT,
    @DOC_TO INT,
    @SERIE VARCHAR(100),
    @ASSIGNED_TO VARCHAR(100),
    @CURRENT_DOC INT,
    @STATUS VARCHAR(15),
    @BRANCH_NAME VARCHAR(50),
    @BRANCH_ADDRESS VARCHAR(150)
AS
BEGIN TRY

    DECLARE @MESSAGE VARCHAR(250) = NULL;

    -- ---------------------------------------------------------------
    -- CUANDO LA SECUENCIA DE DOCUMENTOS SEA DOCUMENTOS DE CONTINGENCIA
    -- VALIDAR LOS RANGOS PARA VER SI YA SE ENCUENTRA UTILIZADA LA CANTIDAD
    -- DEL RANGO DE DOCUMENTOS
    -- ---------------------------------------------------------------
    IF (@DOC_TYPE = 'CONTINGENCY_DOCUMENT')
    BEGIN

        -- ---------------------------------------------------------------
        -- Se verifica que el rango de la secuencia cumpla con el rango
        -- definido por SAT
        -- ---------------------------------------------------------------
        IF (
               NOT (@DOC_FROM
           BETWEEN 100000000 AND 999999999
                   )
               OR NOT (@DOC_TO
           BETWEEN 100000000 AND 999999999
                      )
           )
        BEGIN
            RAISERROR(
                         'El rango de documentos no cumple con lo requerido por SAT, el rango debe estar dentro de 100000000 a 999999999. Por favor verifique y vuelva a intentar.',
                         16,
                         1
                     );
        END;
        ELSE
        BEGIN
            -- ---------------------------------------------------------------
            -- Se verifica que no haya traslape de rango de documentos
            -- ---------------------------------------------------------------
            SELECT TOP (1)
                   @MESSAGE
                       = CASE
                             WHEN @DOC_FROM
                                  BETWEEN [S].[DOC_FROM] AND [S].[DOC_TO] THEN
                                 'El limite inferior de la secuencia de documentos se encuentra dentro de un rango existente.'
                             WHEN @DOC_TO
                                  BETWEEN [S].[DOC_FROM] AND [S].[DOC_TO] THEN
                                 'El limite superior de la secuencia de documentos se encuentra dentro de un rango existente'
                             WHEN [S].[DOC_FROM]
                                  BETWEEN @DOC_FROM AND @DOC_TO THEN
                                 'El limite inferior de la secuencia de documentos absorbe un rango existente'
                             WHEN [S].[DOC_TO]
                                  BETWEEN @DOC_FROM AND @DOC_TO THEN
                                 'El limite superior de la secuencia de documentos absorbe un rango existente'
                             ELSE
                                 'Rangos mal definidos'
                         END
            FROM [acsa].[SWIFT_DOCUMENT_SEQUENCE] AS [S]
            WHERE [S].[DOC_TYPE] = @DOC_TYPE
                  AND
                  (
                      (
                          @DOC_FROM
                  BETWEEN [S].[DOC_FROM] AND [S].[DOC_TO]
                          OR @DOC_TO
                  BETWEEN [S].[DOC_FROM] AND [S].[DOC_TO]
                      )
                      OR
                      (
                          [S].[DOC_FROM]
                  BETWEEN @DOC_FROM AND @DOC_TO
                          OR [S].[DOC_TO]
                  BETWEEN @DOC_FROM AND @DOC_TO
                      )
                  )
            ORDER BY [S].[ID_DOCUMENT_SECUENCE];

            -- ---------------------------------------------------------------
            -- Si existe traslape no se debe continuar con el almacenamiento
            -- de lo contrario, almacenar la secuencia de documentos
            -- ---------------------------------------------------------------
            IF @MESSAGE IS NOT NULL
            BEGIN
                RAISERROR(@MESSAGE, 16, 1);
            END;
            ELSE
            BEGIN
                INSERT INTO [acsa].[SWIFT_DOCUMENT_SEQUENCE]
                (
                    [DOC_TYPE],
                    [ASSIGNED_DATETIME],
                    [POST_DATETIME],
                    [ASSIGNED_BY],
                    [DOC_FROM],
                    [DOC_TO],
                    [SERIE],
                    [ASSIGNED_TO],
                    [CURRENT_DOC],
                    [STATUS],
                    [BRANCH_NAME],
                    [BRANCH_ADDRESS]
                )
                VALUES
                (@DOC_TYPE, GETDATE(), @POST_DATETIME, @ASSIGNED_BY, @DOC_FROM, @DOC_TO, @SERIE, @ASSIGNED_TO,
                 @CURRENT_DOC, @STATUS, @BRANCH_NAME, @BRANCH_ADDRESS);
                IF @@error = 0
                BEGIN
                    SELECT 1 AS [Resultado],
                           'Proceso Exitoso' [Mensaje],
                           0 [Codigo];
                END;
                ELSE
                BEGIN
                    SELECT -1 AS [Resultado],
                           ERROR_MESSAGE() [Mensaje],
                           @@ERROR [Codigo];
                END;
            END;
        END;
    END;
    ELSE
    BEGIN
        INSERT INTO [acsa].[SWIFT_DOCUMENT_SEQUENCE]
        (
            [DOC_TYPE],
            [ASSIGNED_DATETIME],
            [POST_DATETIME],
            [ASSIGNED_BY],
            [DOC_FROM],
            [DOC_TO],
            [SERIE],
            [ASSIGNED_TO],
            [CURRENT_DOC],
            [STATUS],
            [BRANCH_NAME],
            [BRANCH_ADDRESS]
        )
        VALUES
        (@DOC_TYPE, GETDATE(), @POST_DATETIME, @ASSIGNED_BY, @DOC_FROM, @DOC_TO, @SERIE, @ASSIGNED_TO, @CURRENT_DOC,
         @STATUS, @BRANCH_NAME, @BRANCH_ADDRESS);
        IF @@error = 0
        BEGIN
            SELECT 1 AS [Resultado],
                   'Proceso Exitoso' [Mensaje],
                   0 [Codigo];
        END;
        ELSE
        BEGIN
            SELECT -1 AS [Resultado],
                   ERROR_MESSAGE() [Mensaje],
                   @@ERROR [Codigo];
        END;
    END;
END TRY
BEGIN CATCH
    SELECT -1 AS [Resultado],
           ERROR_MESSAGE() [Mensaje],
           @@ERROR [Codigo];
END CATCH;
