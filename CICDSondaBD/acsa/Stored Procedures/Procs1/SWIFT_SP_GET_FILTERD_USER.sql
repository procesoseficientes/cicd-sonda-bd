-- =============================================
-- Autor:				PEDRO LOUKOTA
-- Fecha de Creacion: 	03-12-2015
-- Description:			Selecciona los usuarios filtrados
--                      
/*
-- Ejemplo de Ejecucion:				
				--


-- TODO: Set parameter values here.

DECLARE @SELLER_ROUTE varchar(50)
DECLARE @LOGIN varchar(50)

EXECUTE[acsa].[SWIFT_SP_GET_FILTERD_USER] 
   @SELLER_ROUTE = ''
  ,@LOGIN = ''
GO


				--				
*/
-- =============================================



CREATE PROCEDURE [acsa].[SWIFT_SP_GET_FILTERD_USER]
@SELLER_ROUTE  [varchar](50),
@LOGIN      [varchar](50)
AS
BEGIN

SELECT  [CORRELATIVE]
       ,[LOGIN]
       ,[IMAGE]
       ,[SELLER_ROUTE]
       ,[DEFAULT_WAREHOUSE]
       ,[PRESALE_WAREHOUSE]
  FROM  [SWIFT_EXPRESS_R].[acsa].[USERS]
  WHERE [SELLER_ROUTE] = @SELLER_ROUTE 
        AND [LOGIN] = @LOGIN 
		
		
END
