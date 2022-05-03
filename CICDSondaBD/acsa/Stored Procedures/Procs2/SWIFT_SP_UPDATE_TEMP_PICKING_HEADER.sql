﻿CREATE PROCEDURE [acsa].[SWIFT_SP_UPDATE_TEMP_PICKING_HEADER]
@PICKING_HEADER VARCHAR(50),
@CLASSIFICATIONPICKING VARCHAR(50),
@CODECUSTOMER VARCHAR(50),
@CODEOPERATOR VARCHAR(50),
@REFERENCE VARCHAR(50),
@DOC_SAP_RECEPTION VARCHAR(150),
@LASTUPDATEBY VARCHAR(50),
@SCHEDULE_FOR DATE,
@SEQ INT
AS
UPDATE acsa.SWIFT_TEMP_PICKING_HEADER
SET
CLASSIFICATION_PICKING =  @CLASSIFICATIONPICKING,
CODE_CLIENT = @CODECUSTOMER,
CODE_USER = @CODEOPERATOR,
REFERENCE = @REFERENCE,
DOC_SAP_RECEPTION = @DOC_SAP_RECEPTION,
LAST_UPDATE_BY = @LASTUPDATEBY,
LAST_UPDATE = GETDATE(),
STATUS = 'ASSIGNED',
SCHEDULE_FOR = @SCHEDULE_FOR,
SEQ = @SEQ



