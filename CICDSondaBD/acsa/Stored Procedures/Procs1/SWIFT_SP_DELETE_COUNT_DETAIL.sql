﻿CREATE PROC [acsa].[SWIFT_SP_DELETE_COUNT_DETAIL]
@COUNT INT
AS
DELETE acsa.SWIFT_CYCLE_COUNT_DETAIL WHERE [COUNT] = @COUNT





