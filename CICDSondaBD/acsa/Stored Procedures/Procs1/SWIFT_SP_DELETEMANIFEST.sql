﻿CREATE PROCEDURE [acsa].[SWIFT_SP_DELETEMANIFEST]
@MANIFEST_HEADER INT
AS
DELETE FROM SWIFT_MANIFEST_HEADER WHERE MANIFEST_HEADER=@MANIFEST_HEADER
DELETE FROM SWIFT_MANIFEST_DETAIL WHERE CODE_MANIFEST_HEADER=@MANIFEST_HEADER





