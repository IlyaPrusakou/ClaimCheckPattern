@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Puchase Order Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PRU_PURCH_ORDER
  provider contract transactional_interface
  as projection on ZR_PRU_PURCH_ORDER
{
  key PurchaseOrderId,
      PurchaseName,
      PurchaseQnty,
      PurchaseUnitMeasure,
      ReferenceStockID
}
