﻿

CREATE VIEW [acsa].[SWIFT_VIEW_CLASSIFICATION_NOT_DELIVERY]
AS
SELECT     CLASSIFICATION, NAME_CLASSIFICATION, PRIORITY_CLASSIFICATION, VALUE_TEXT_CLASSIFICATION, MPC01
FROM         acsa.SWIFT_CLASSIFICATION
WHERE     (GROUP_CLASSIFICATION = 'NOT_DELIVERY_REASONS')







