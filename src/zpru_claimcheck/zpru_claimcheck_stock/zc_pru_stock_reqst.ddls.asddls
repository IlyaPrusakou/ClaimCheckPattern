@Metadata.allowExtensions: true
@EndUserText.label: 'Stock UI ODATA Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_PRU_STOCK_REQST
  provider contract transactional_query
  as projection on ZI_PRU_STOCK_REQST
{
  key StockReqId,
      StockName,
      StockQnty,
      @Semantics.unitOfMeasure: true
      StockUnitMeasure,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt

}
