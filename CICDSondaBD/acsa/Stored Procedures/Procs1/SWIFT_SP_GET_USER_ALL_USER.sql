﻿/****** Object:  StoredProcedure [acsa].[SWIFT_SP_GET_USER_ALL_USER]    Script Date: 15/12/2015 9:09:38 AM ******/
-- =============================================
-- Autor:				JOSE ROBERTO
-- Fecha de Creacion: 	17-12-2015
-- Description:			Muestra	los usuarios con codigo y nombre

/*
-- Ejemplo de Ejecucion:				
				--
				 [acsa].[SWIFT_SP_GET_USER_ALL_USER]
				--				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_USER_ALL_USER]	
AS
SELECT
	 [LOGIN]
	,[NAME_USER]
FROM [acsa].[USERS]


