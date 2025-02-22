@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_PRU_MSG_BROKER
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_PRU_MSG_BROKER
{
  key ClaimId
  
}
