@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_PRU_STOCK_REQST
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_PRU_STOCK_REQST
{
  key StockReqId,
  StockName,
  StockQnty,
  @Semantics.unitOfMeasure: true
  StockUnitMeasure
  
}
