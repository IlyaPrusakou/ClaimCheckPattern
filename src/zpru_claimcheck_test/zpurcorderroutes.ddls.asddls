@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Routes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurcOrderRoutes
  as select from zpru_po_routes
{
  key channel         as Channel,
  key route           as Route,
      bo_name         as BusinessObjectName,
      action_receiver as ActionReceiver
}
