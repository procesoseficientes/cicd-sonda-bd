-- =============================================
-- Autor:				      rudi.garcia
-- Fecha de Creacion: 02-Oct-2018 G-Force@Koala
-- Description:			  SP que borra la todas las respuestas.

CREATE PROCEDURE [acsa].[SWIFT_SP_ALL_DELETE_ANSWER] (@QUESTION_ID INT)
AS
BEGIN TRY

  DELETE [acsa].[SWIFT_ANSWER]
  WHERE [QUESTION_ID] = @QUESTION_ID

  SELECT
    1 AS Resultado
   ,'Proceso Exitoso' Mensaje
   ,0 Codigo
   ,CAST(@QUESTION_ID AS VARCHAR) DbData

END TRY
BEGIN CATCH
  SELECT
    -1 AS Resultado
   ,ERROR_MESSAGE() Mensaje
   ,@@ERROR Codigo
END CATCH
