﻿

CREATE VIEW [acsa].[SWIFT_VIEW_ALL_PROVIDERS] 
AS

SELECT
  CAST(PROVIDER AS VARCHAR) PROVIDER,
  CODE_PROVIDER,
  NAME_PROVIDER,
  CLASSIFICATION_PROVIDER,
  CONTACT_PROVIDER,
  0 FROM_ERP
FROM [acsa].SWIFT_PROVIDERS
UNION
SELECT
  [ERP].[PROVIDER]  COLLATE SQL_Latin1_General_CP1_CI_AS PROVIDER,
  [ERP].CODE_PROVIDER COLLATE SQL_Latin1_General_CP1_CI_AS CODE_PROVIDER,
  [ERP].NAME_PROVIDER COLLATE SQL_Latin1_General_CP1_CI_AS NAME_PROVIDER,
  [ERP].CLASSIFICATION_PROVIDER COLLATE SQL_Latin1_General_CP1_CI_AS CLASSIFICATION_PROVIDER,
  [ERP].CONTACT_PROVIDER COLLATE SQL_Latin1_General_CP1_CI_AS CONTACT_PROVIDER,
  [ERP].FROM_ERP FROM_ERP
FROM 
[$(CICDInterfacesBD)].[acsa].ERP_VIEW_PROVIDERS [ERP]

