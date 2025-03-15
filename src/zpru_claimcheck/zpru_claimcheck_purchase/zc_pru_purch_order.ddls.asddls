@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_PRU_PURCH_ORDER
  provider contract transactional_query
  as projection on ZR_PRU_PURCH_ORDER
{
  key PurchaseOrderId,
  PurchaseName,
  PurchaseQnty,
  @Semantics.unitOfMeasure: true
  PurchaseUnitMeasure,
  ReferenceStockID
  
}
