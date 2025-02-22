@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_PRU_PURCH_ORDER
  as select from ZPRU_PURCH_ORDER
{
  key stock_req_id as StockReqId,
  purchase_name as PurchaseName,
  purchase_qnty as PurchaseQnty,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  purchase_unit_measure as PurchaseUnitMeasure
  
}
