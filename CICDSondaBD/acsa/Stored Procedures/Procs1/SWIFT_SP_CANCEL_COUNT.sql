﻿CREATE PROC [acsa].[SWIFT_SP_CANCEL_COUNT]
@COUNT_ID VARCHAR(50)
AS
UPDATE acsa.SWIFT_CYCLE_COUNT_HEADER SET
COUNT_CANCELED_DATETIME = GETDATE(),COUNT_STATUS = 'CANCELLED'
WHERE COUNT_ID = @COUNT_ID

UPDATE acsa.SWIFT_CYCLE_COUNT_DETAIL SET COUNT_STATUS = 'CANCELLED'
WHERE COUNT_ID = @COUNT_ID





