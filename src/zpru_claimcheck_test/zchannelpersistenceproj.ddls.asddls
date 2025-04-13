@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Channel Store'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZChannelPersistenceProj
  provider contract transactional_interface
  as projection on ZChannelPersistenceTP
{
  key Messageid
}
