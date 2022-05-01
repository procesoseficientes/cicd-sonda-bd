CREATE FUNCTION [acsa].[FUNC_REMOVE_SPECIAL_CHARS_BK]
(
@Cadena as varchar(255)
)
RETURNS varchar(255)
AS
BEGIN
DECLARE @Caracteres varchar(255)
DECLARE @CaracteresSinTilde varchar(255)
-- Se omite - y & a peticion del cliente, Original: SET @Caracteres = '-;/''´()&\Ñ¡!?#:$%[_*@{}ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜàáâãäåæçèéêëìíîïðñòóôõö÷øùúûü'
SET @Caracteres = ';/''´()\¡!?#:$%[_*@{}ÀÂÃÄÅÆÇÈÊËÌÍÎÏÐÒÔÕÖ×ØÙÛÜàâãäåæçèéêëìîïðòóôõö÷øùûü'

SELECT @CaracteresSinTilde  =UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Cadena, 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u'))

--Quitar Caracteres
WHILE @CaracteresSinTilde LIKE '%[' + @Caracteres + ']%'
BEGIN


SELECT @CaracteresSinTilde = REPLACE(@CaracteresSinTilde
, SUBSTRING(@CaracteresSinTilde
, PATINDEX('%[' + @Caracteres + ']%'
, @CaracteresSinTilde)
, 1)
,'')
END

return @CaracteresSinTilde
END
