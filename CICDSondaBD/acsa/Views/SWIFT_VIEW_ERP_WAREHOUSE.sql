﻿
CREATE VIEW [acsa].[SWIFT_VIEW_ERP_WAREHOUSE]
AS
SELECT [CODE_WAREHOUSE]
      ,[DESCRIPTION_WAREHOUSE]
      ,[WEATHER_WAREHOUSE]
      ,[STATUS_WAREHOUSE]
      ,[LAST_UPDATE]
      ,[LAST_UPDATE_BY]
      ,[IS_EXTERNAL]
  FROM [$(CICDInterfacesBD)].[acsa].[SWIFT_ERP_WAREHOUSE]


