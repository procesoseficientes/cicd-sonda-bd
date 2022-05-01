/*==========================================

Autor: diego.as
Fecha de Creacion: 15-07-2016 Sprint ζ
Descripcion: Obtiene la informacion de una Resolucion
	Nota: El SP ya existia pero carecia de firma
		  , por tal motivo se firma como script de creacion.

-- Modificacion 		11/30/2019 @ G-Force Team Sprint Oslo
-- Autor: 				diego.as
-- Historia/Bug:		Product Backlog Item 33218: Configuración de Frases y Escenarios
-- Descripcion: 		11/30/2019 - Se agregan columnas para indicar el TIPO DE DOCUMENTO FEL al que haran referencia las facturas generadas con la resolucion, asi como el CODIGO DE ESTABLECIMIENTO que de igual forma
--						se enviara en las facturas.

Ejemplo de Ejecucion:

	exec [acsa].[SWIFT_SP_GET_RESOLUTION]

==========================================*/

CREATE PROC [acsa].[SWIFT_SP_GET_RESOLUTION]
AS
SELECT [RS].[ROWPK],
       [RS].[AUTH_ID],
       [RS].[AUTH_ASSIGNED_DATETIME],
       [RS].[AUTH_POST_DATETIME],
       [RS].[AUTH_ASSIGNED_BY],
       [RS].[AUTH_DOC_FROM],
       [RS].[AUTH_DOC_TO],
       [RS].[AUTH_SERIE],
       [RS].[AUTH_DOC_TYPE],
       [RS].[AUTH_ASSIGNED_TO],
       [RS].[AUTH_CURRENT_DOC],
       [RS].[AUTH_LIMIT_DATETIME],
       [RS].[AUTH_STATUS],
       [RS].[AUTH_BRANCH_NAME],
       [RS].[AUTH_BRANCH_ADDRESS],
       [RS].[AUTH_TYPE],
       [RS].[BRANCH_ADDRESS2],
       [RS].[BRANCH_ADDRESS3],
       [RS].[BRANCH_ADDRESS4],
       CONCAT(
                 ISNULL([RS].[AUTH_BRANCH_ADDRESS], ' '),
                 ' ',
                 ISNULL([RS].[BRANCH_ADDRESS2], ' '),
                 ' ',
                 ISNULL([RS].[BRANCH_ADDRESS3], ' '),
                 ' ',
                 ISNULL([RS].[BRANCH_ADDRESS4], ' ')
             ) AS [BRANCH_ADDRESS_COMPLETE],
       [R].[ROUTE],
       [R].[CODE_ROUTE],
       [R].[NAME_ROUTE],
       [R].[GEOREFERENCE_ROUTE],
       [R].[COMMENT_ROUTE],
       [R].[LAST_UPDATE],
       [R].[LAST_UPDATE_BY],
       [R].[IS_ACTIVE_ROUTE],
       [RS].[FEL_DOCUMENT_TYPE_CLASSIFICATION_ID],
       [RS].[FEL_DOCUMENT_TYPE],
       [RS].[FEL_STABLISHMENT_CODE_CLASSIFICATION_ID],
       [RS].[FEL_STABLISHMENT_CODE]
FROM [acsa].[SONDA_POS_RES_SAT] [RS]
    LEFT JOIN [acsa].[SWIFT_ROUTES] [R]
        ON ([RS].[AUTH_ASSIGNED_TO] = [R].[CODE_ROUTE]);
