@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPurcOrderItemProj
  as projection on ZPurcOrderItemTP 
{
  key itemNumber,
  key purchaseOrderId,
      productId,
      productName,
      quantity,
      @Semantics.amount.currencyCode : 'itemCurrency'
      unitPrice,
      @Semantics.amount.currencyCode : 'itemCurrency'
      totalPrice,
      deliveryDate,
      warehouseLocation,
      itemCurrency,
      /* Associations */
      _header : redirected to parent ZPurcOrderHdrProj
}
