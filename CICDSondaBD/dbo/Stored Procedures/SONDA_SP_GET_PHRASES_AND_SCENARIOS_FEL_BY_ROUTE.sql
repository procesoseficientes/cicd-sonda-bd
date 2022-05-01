-- =============================================
-- Autor:				DIEGO.AS
-- Fecha de Creacion: 	12/1/2019 @ G-Force - TEAM Sprint OSLO
-- Historia/Bug:		Product Backlog Item 33218: Configuración de Frases y Escenarios
-- Descripcion: 		12/1/2019 - Obtiene la configuracion de frases y escenarios FEL para imprimir el texto respectivo en las facturas generadas

/*
-- Ejemplo de Ejecucion:
	EXEC [acsa].[SONDA_SP_GET_PHRASES_AND_SCENARIOS_FEL_BY_ROUTE]
	@CODE_ROUTE = '46'
*/
-- =============================================

CREATE PROCEDURE [SONDA_SP_GET_PHRASES_AND_SCENARIOS_FEL_BY_ROUTE] (@CODE_ROUTE VARCHAR(50))
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FEL_DOCUMENT_TYPE VARCHAR(250);

    -- ---------------------------------------------------------------
    -- OBTENEMOS EL TIPO DE DOCUMENTO FEL EN BASE A LA RESOLUCION
    -- DE FACTURACION ASOCIADA A LA RUTA
    -- ---------------------------------------------------------------
    SELECT TOP (1)
           @FEL_DOCUMENT_TYPE = [SPRS].[FEL_DOCUMENT_TYPE]
    FROM [acsa].[SONDA_POS_RES_SAT] AS [SPRS]
    WHERE [SPRS].[AUTH_ASSIGNED_TO] = @CODE_ROUTE
    ORDER BY [SPRS].[ROWPK];

    -- ---------------------------------------------------------------------------------
    -- SE OBTIENEN LAS FRASES Y ESCENARIOS CONFIGURADOS PARA EL TIPO DE DOCUMENTO FEL
    -- ---------------------------------------------------------------------------------
    SELECT [SPSFEL].[ID],
           [SPSFEL].[FEL_DOCUMENT_TYPE],
           [SPSFEL].[PHRASE_CODE],
           [SPSFEL].[SCENARIO_CODE],
           [SPSFEL].[DESCRIPTION],
           [SPSFEL].[TEXT_TO_SHOW]
    FROM [acsa].[SONDA_PHRASES_AND_SCENARIOS_FEL] AS [SPSFEL]
    WHERE [SPSFEL].[FEL_DOCUMENT_TYPE] = @FEL_DOCUMENT_TYPE;

END;