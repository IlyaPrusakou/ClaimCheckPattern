@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_PRU_PURCH_ORDER
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_PRU_PURCH_ORDER
{
  key StockReqId,
  PurchaseName,
  PurchaseQnty,
  @Semantics.unitOfMeasure: true
  PurchaseUnitMeasure
  
}
