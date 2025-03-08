@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_PRU_MSG_BROKER
  as select from ZPRU_MSG_BROKER
{
  key claim_id as BrokerClaimId
  
}
