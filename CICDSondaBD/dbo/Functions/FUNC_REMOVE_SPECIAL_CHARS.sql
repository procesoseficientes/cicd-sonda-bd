﻿
CREATE FUNCTION [dbo].[FUNC_REMOVE_SPECIAL_CHARS]
  (@Cadena as varchar(255))
RETURNS varchar(255)
AS
BEGIN
  DECLARE @Respuesta varchar(255)
  SET @Respuesta = SWIFT_INTERFACES_R.dbo.FUNC_REMOVE_SPECIAL_CHARS(@Cadena)
  return @Respuesta
END






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[FUNC_REMOVE_SPECIAL_CHARS] TO [sonda]
    AS [dbo];

