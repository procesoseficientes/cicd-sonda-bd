/****** Object:  Table [acsa].[SWIFT_UPDATE_SCOUTING]   Script Date: 14/12/2015  ******/

-- Autor:				ppablo.loukota
-- Fecha de Creacion: 	14-12-2015
-- Description:			Elimina el procedimiento erroneo de SWIFT_UPDATE_SCOUTING
/*
--						Ejemplo de Ejecucion:				

						EXECUTE [acsa].[SWIFT_DROP_SCOUTING] 

*/
CREATE PROCEDURE [acsa].[SWIFT_DROP_SCOUTING]

AS

DROP PROCEDURE [acsa].[SWIFT_UPDATE_SCOUTING]

