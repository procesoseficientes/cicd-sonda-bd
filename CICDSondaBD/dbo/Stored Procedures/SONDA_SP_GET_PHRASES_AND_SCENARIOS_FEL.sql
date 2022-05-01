-- ================================================================================
-- Autor: 				DENIS.VILLAGRAN
-- Fecha de creación:   12/10/2019 @ G-Force - TEAM Spring Oslo
-- Historia/Bug:		
-- Descripcion: 		12/10/2019 - Obtiene todas las frases y escenarios

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_GET_PHRASES_AND_SCENARIOS_FEL]
*/
-- =============================================
CREATE PROCEDURE [SONDA_SP_GET_PHRASES_AND_SCENARIOS_FEL]
AS
BEGIN
    SELECT [ID] AS [Id],
           [FEL_DOCUMENT_TYPE] AS [FelDocumentType],
           [PHRASE_CODE] AS [PhraseCode],
           [SCENARIO_CODE] AS [ScenarioCode],
           [DESCRIPTION] AS [Description],
           [TEXT_TO_SHOW] AS [TextToShow]
    FROM [acsa].[SONDA_PHRASES_AND_SCENARIOS_FEL];
END;