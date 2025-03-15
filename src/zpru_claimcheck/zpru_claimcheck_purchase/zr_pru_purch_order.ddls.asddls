@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_PRU_PURCH_ORDER
  as select from zpru_purch_order
{
  key puchase_order_id as PurchaseOrderId,
  purchase_name as PurchaseName,
  purchase_qnty as PurchaseQnty,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  purchase_unit_measure as PurchaseUnitMeasure,
  stock_req_id as ReferenceStockID
  
}
