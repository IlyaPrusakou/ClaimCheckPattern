@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Message Broker'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PRU_MSG_BROKER 
provider contract transactional_interface 
as projection on ZR_PRU_MSG_BROKER
{
    key BrokerClaimId
}
