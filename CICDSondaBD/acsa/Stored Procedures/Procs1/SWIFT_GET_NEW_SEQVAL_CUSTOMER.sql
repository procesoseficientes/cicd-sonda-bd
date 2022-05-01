CREATE  procedure  [acsa].[SWIFT_GET_NEW_SEQVAL_CUSTOMER]
as
begin      
declare @NewSeqValue int

      set NOCOUNT ON

      insert into acsa.SWIFT_CUSTOMER_SEQ (SEQ_VAL) values ('a')

     

      set @NewSeqValue = scope_identity()

     

      delete from  acsa.SWIFT_CUSTOMER_SEQ WITH (READPAST)

return @NewSeqValue

end

