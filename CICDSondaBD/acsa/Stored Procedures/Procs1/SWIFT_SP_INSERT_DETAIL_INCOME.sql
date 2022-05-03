﻿CREATE PROCEDURE [acsa].[SWIFT_SP_INSERT_DETAIL_INCOME]
@INCOMEHEADER INT,
@CODE_SKU VARCHAR(50),
@EXPECTED FLOAT,
@DESCRIPTION_SKU VARCHAR(MAX)
AS
 
DECLARE @INCOMEDETAIL INT
DECLARE @MARCADORSKU INT
SET @MARCADORSKU = 0
DECLARE @CODEDETAIL INT
 
IF EXISTS (SELECT CODE_SKU FROM acsa.SWIFT_TEMP_RECEPTION_DETAIL WHERE CODE_SKU = @CODE_SKU AND RECEPTION_HEADER = @INCOMEHEADER)
            BEGIN
            SELECT @CODEDETAIL =  RECEPTION_DETAIL_TEMP FROM SWIFT_TEMP_RECEPTION_DETAIL WHERE RECEPTION_HEADER=@INCOMEHEADER AND CODE_SKU=@CODE_SKU
            UPDATE SWIFT_TEMP_RECEPTION_DETAIL SET EXPECTED = EXPECTED + @EXPECTED WHERE   RECEPTION_DETAIL_TEMP = @CODEDETAIL
print 'entroIf'
            END
ELSE
            BEGIN
  INSERT INTO SWIFT_TEMP_RECEPTION_DETAIL(RECEPTION_HEADER,CODE_SKU,EXPECTED,SCANNED,DIFFERENCE,DESCRIPTION_SKU)
            VALUES(@INCOMEHEADER,@CODE_SKU,@EXPECTED,0,0,@DESCRIPTION_SKU)
            print 'entroElse'
            END
           
SELECT  TOP 1 @INCOMEDETAIL =  RECEPTION_DETAIL_TEMP FROM SWIFT_TEMP_RECEPTION_DETAIL ORDER BY RECEPTION_DETAIL_TEMP DESC
 
print '@INCOMEDETAIL' print @INCOMEDETAIL
print '@EXPECTED' print @EXPECTED
 
 
UPDATE SWIFT_TEMP_RECEPTION_DETAIL
SET DIFFERENCE = (SELECT EXPECTED - SCANNED FROM SWIFT_TEMP_RECEPTION_DETAIL WHERE RECEPTION_DETAIL_TEMP=@INCOMEDETAIL)
WHERE RECEPTION_DETAIL_TEMP = @INCOMEDETAIL




