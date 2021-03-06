CREATE PROCEDURE [acsa].[SWIFT_SP_GET_USER_UNASSIGNED_TO_VEHICLE]
(
    @CODE_VEHICLE VARCHAR(50) 
)
  AS
    SET NOCOUNT ON;

    DECLARE @ID_VEHICLE INT ;
  SET @ID_VEHICLE = ( SELECT  TOP(1) VEHICLE FROM acsa.SWIFT_VEHICLES WHERE CODE_VEHICLE = @CODE_VEHICLE )

   SELECT U.* , ss.SELLER_NAME 
    FROM acsa.USERS U  
    LEFT JOIN acsa.SWIFT_SELLER ss 
      ON  (U.RELATED_SELLER = ss.SELLER_CODE)
  WHERE U.TYPE_USER = 'Operador' AND NOT
        EXISTS(SELECT 1 FROM acsa.SWIFT_VEHICLE_X_USER svxu WHERE U.LOGIN = svxu.LOGIN AND svxu.VEHICLE = @ID_VEHICLE )


