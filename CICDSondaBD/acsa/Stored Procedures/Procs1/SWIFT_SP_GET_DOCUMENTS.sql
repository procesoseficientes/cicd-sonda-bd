﻿CREATE PROC [acsa].[SWIFT_SP_GET_DOCUMENTS]
@DTBEGIN DATE,
@DTEND DATE
AS
SELECT * FROM acsa.SWIFT_VIEW_DOCUMENTS_HEADER AS A
WHERE CONVERT(DATE,@DTEND) >= CONVERT(DATE,A.CREATED_DATESTAMP) AND CONVERT(DATE,@DTBEGIN) <= CONVERT(DATE,A.CREATED_DATESTAMP)


