@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_PRU_MSG_STORE
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_PRU_MSG_STORE
{
  key Claim,
  StockReqId,
  StockName,
  StockQnty,
  @Semantics.unitOfMeasure: true
  StockUnitMeasure
  
}
