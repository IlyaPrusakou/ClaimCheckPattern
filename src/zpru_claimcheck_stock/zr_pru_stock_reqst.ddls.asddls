@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_PRU_STOCK_REQST
  as select from ZPRU_STOCK_REQST
{
  key stock_req_id as StockReqId,
  stock_name as StockName,
  stock_qnty as StockQnty,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  stock_unit_measure as StockUnitMeasure
  
}
