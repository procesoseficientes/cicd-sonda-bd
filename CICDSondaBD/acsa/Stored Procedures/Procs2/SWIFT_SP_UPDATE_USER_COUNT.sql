CREATE PROC [acsa].[SWIFT_SP_UPDATE_USER_COUNT]
@COUNT_ID int,
@CORRELATIVE VARCHAR(50)
AS
UPDATE acsa.SWIFT_CYCLE_COUNT_DETAIL SET COUNT_OPERATOR=@CORRELATIVE
WHERE COUNT = @COUNT_ID AND COUNT_STATUS != 'COUNTED'





