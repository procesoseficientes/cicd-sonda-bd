﻿CREATE PROCEDURE [acsa].[SWIFT_SP_GET_CUSTOMER_FREQUENCY] (
   @CODE_CUSTOMER VARCHAR(50) = NULL
)
AS
  SET NOCOUNT ON;

  SELECT 
    CF.CODE_FREQUENCY AS ID_FREQUENCY
    ,CF.CODE_CUSTOMER
    ,CONVERT(INT,CF.SUNDAY) AS SUNDAY
    ,CONVERT(INT,CF.MONDAY) AS MONDAY
    ,CONVERT(INT,CF.TUESDAY) AS TUESDAY
    ,CONVERT(INT,CF.WEDNESDAY) AS WEDNESDAY
    ,CONVERT(INT,CF.THURSDAY) AS THURSDAY
    ,CONVERT(INT,CF.FRIDAY) AS FRIDAY
    ,CONVERT(INT,CF.SATURDAY) AS SATURDAY
    ,CONVERT(INT,CF.FREQUENCY_WEEKS) AS FREQUENCY_WEEKS
    ,CF.LAST_DATE_VISITED
    ,CF.LAST_UPDATED_BY
    ,CF.LAST_UPDATED
  FROM acsa.SWIFT_CUSTOMER_FREQUENCY CF
  WHERE (@CODE_CUSTOMER IS NULL OR CF.CODE_CUSTOMER = @CODE_CUSTOMER)


