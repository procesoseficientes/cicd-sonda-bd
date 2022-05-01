/****** Object:  StoredProcedure [acsa].[SWIFT_SP_VALIDATE_DOCUMENT_SALE]    Script Date: 20/12/2015 9:09:38 AM ******/
-- =============================================
-- Autor:				JOSE ROBERTO
-- Fecha de Creacion: 	20-11-2015
-- Description:			Valida que el usuario de venta directa tenga asociado factura, resolucion y bodega.
/*
-- Ejemplo de Ejecucion:				
				--
	   exec acsa.[SWIFT_SP_VALIDATE_DOCUMENT_SALE] @user='a1b2c3'
				--				
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_VALIDATE_DOCUMENT_SALE]
	@USER VARCHAR(50),
	@pResult VARCHAR(250) OUTPUT
	AS 
BEGIN TRY
Select   T.CODE_ROUTE,U.DEFAULT_WAREHOUSE, T.TYPE_TASK,  R.AUTH_DOC_TYPE, concat ( R.AUTH_SERIE, ' ', R.AUTH_DOC_FROM ,'-', R.AUTH_DOC_TO ) Resolucion
	from [acsa].[SWIFT_FREQUENCY] T,[acsa].[SONDA_POS_RES_SAT] R,[SWIFT_USER] U
	Where T.CODE_ROUTE = R.AUTH_ASSIGNED_TO 
	AND T.TYPE_TASK='SALE'
	AND U.LOGIN=@USER

	IF @@ROWCOUNT = 0 BEGIN
			SET @pResult = 'Usuario NO tiene RESOLUCION'
		END
		ELSE
		BEGIN
			SET @pResult = 'Usuario tiene permiso RESOLUCION'
		END
END TRY
BEGIN CATCH
	 SET @pResult = ERROR_MESSAGE()
END CATCH
