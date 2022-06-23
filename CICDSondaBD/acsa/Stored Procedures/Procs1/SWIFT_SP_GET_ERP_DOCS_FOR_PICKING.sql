-- =============================================
-- Autor:				joel.delcompare
-- Fecha de Creacion: 	01-23-2016
-- Description:			obtiene los documentos bases de erp para basarse un picking

-- modificacion 04-04-2016
				-- alberto.ruiz
				-- Se corrigio para que utilizara la vista de documentos para picking

-- Modificado	08-09-2016
			-- diego.as
			-- Se agrego el campo DOC_DATE en formato 'dd-MM-yyyy'

/*
-- Ejemplo de Ejecucion:
        USE $(CICDSondaBD)
        GO
        --
        EXEC acsa.SWIFT_SP_GET_ERP_DOCS_FOR_PICKING
			@CODE_SELLER = '149,141'
*/
-- =============================================
CREATE PROCEDURE [acsa].[SWIFT_SP_GET_ERP_DOCS_FOR_PICKING]
	@CODE_SELLER VARCHAR(MAX) = NULL
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	--
	SET @SQL = 'SELECT
		P.SAP_REFERENCE
		,P.DOC_TYPE
		,P.DESCRIPTION_TYPE
		,FORMAT(P.DOC_DATE,"dd-MM-yyyy") AS DOC_DATE
		,P.CUSTOMER_ID
		,CASE P.DOC_TYPE
			WHEN ''SO'' THEN U.PRESALE_WAREHOUSE
			ELSE P.COD_WAREHOUSE
		END AS COD_WAREHOUSE
		,P.CUSTOMER_NAME
		,CASE P.DOC_TYPE
			WHEN ''SO'' THEN W.DESCRIPTION_WAREHOUSE
			ELSE P.WAREHOUSE_NAME
		END AS WAREHOUSE_NAME
		,P.CODE_OPER
		,R.CODE_ROUTE
		,R.NAME_ROUTE
		,S.SELLER_CODE
		,S.SELLER_NAME
	FROM [SWIFT_INTERFACES].[acsa].[ERP_VIEW_DOC_FOR_PICKING] P
	LEFT JOIN [acsa].[USERS] U ON (P.CODE_OPER = U.LOGIN)
	LEFT JOIN [acsa].[SWIFT_ROUTES] R ON (U.SELLER_ROUTE = R.CODE_ROUTE)
	LEFT JOIN [acsa].[SWIFT_VIEW_ALL_SELLERS] S ON (U.RELATED_SELLER = S.SELLER_CODE)
	LEFT JOIN [acsa].[SWIFT_WAREHOUSES] W ON (U.PRESALE_WAREHOUSE = W.CODE_WAREHOUSE)
	'
	+ CASE WHEN @CODE_SELLER IS NOT NULL AND @CODE_SELLER != '' THEN 'WHERE S.SELLER_CODE IN (' + @CODE_SELLER + ')' ELSE '' END
	+ ' ORDER BY P.DOC_TYPE DESC, P.SAP_REFERENCE ASC'
	--
	PRINT '@SQL: ' + @SQL
	--
	EXEC SP_EXECUTESQL @SQL

END

SET QUOTED_IDENTIFIER ON
