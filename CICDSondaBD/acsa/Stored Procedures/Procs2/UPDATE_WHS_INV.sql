﻿CREATE PROCEDURE [acsa].[UPDATE_WHS_INV](
	@SKU	VARCHAR(50),
	@WH		VARCHAR(50)
)
AS
BEGIN
	DECLARE @PSKU VARCHAR(200);

	BEGIN TRY
		IF EXISTS(SELECT 1 FROM 
			[acsa].[SWIFT_INVENTORY]
			where
			sku = @SKU and warehouse = @WH)
		BEGIN
			UPDATE acsa.SWIFT_INVENTORY SET ON_HAND = 10000 WHERE
			SKU = @SKU AND WAREHOUSE = @WH

			SELECT @PSKU = (SELECT TOP 1 [DESCRIPTION_SKU] FROM acsa.SWIFT_SKU WHERE [CODE_SKU] = @SKU)

			PRINT @PSKU + ' UPDATED ';

			RETURN 1;

		END ELSE BEGIN
			PRINT 'SKU ' + @SKU + ' NO EXISTE EN BODEGA ' + @WH;
			RETURN 2;
		END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE() 
		RETURN -0;
	END CATCH
END
