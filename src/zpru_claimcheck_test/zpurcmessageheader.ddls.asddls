@EndUserText.label: 'Message Header'
define root abstract entity ZPurcMessageHeader
{
  MessageID               : abap.char(36);  
  Timestamp               : abap.utclong;   
  SenderSystem            : abap.char(50); 
  ReceiverSystem          : abap.char(50); 
  MessageType             : abap.char(20); 
  ProcedureName           : abap.char(50); 
  RequestType             : abap.char(20);
  Priority                : abap.char(10); 
  Version                 : abap.char(10); 
  AuthorizationToken      : abap.char(255);   
  CorrelationID           : abap.char(36); 
  Timeout                 : abap.int4;
  header : composition of exact one to one ZPurcOrderHdrAbstract;
    
}
