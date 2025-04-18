@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Channel Store'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZChannelPersistenceTP
  as select from ZChannelPersistence
{
  key PersistencyId,
      Messageid,
      PurchaseOrderId,
      Orderdate,
      Status,
      ControlTimestamp
}
