﻿CREATE PROCEDURE [acsa].[SWIFT_GET_PICKING_DETAIL_FOR_PICKING_HEADER]
@PICKINGHEADER INT
AS
SELECT A.PICKING_DETAIL,A.CODE_SKU,A.DESCRIPTION_SKU AS SKU_DESCRIPTION,A.DISPATCH
FROM acsa.SWIFT_TEMP_PICKING_DETAIL A
WHERE A.PICKING_HEADER=@PICKINGHEADER





