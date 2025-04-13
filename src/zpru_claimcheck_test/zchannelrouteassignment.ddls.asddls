@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Channel Route Assingment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZChannelRouteAssignment
  as select from zpru_chnl_assgmt
{
  key channel as Channel,
  key route   as Route,
  key bdef    as BusinessObject,
  key entity  as BusinessObjectEntity,
      action  as BusinessObjectAction
}
