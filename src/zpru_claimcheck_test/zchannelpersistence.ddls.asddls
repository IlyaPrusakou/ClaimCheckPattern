@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Channel Store'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZChannelPersistence
  as select from zpru_chnl_store
{
  key persistency_id    as PersistencyId,
      messageid         as Messageid,
      purchase_order_id as PurchaseOrderId,
      order_date        as Orderdate,
      status            as Status,
      control_timestamp as ControlTimestamp

}
