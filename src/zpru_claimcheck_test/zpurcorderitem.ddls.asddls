@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurcOrderItem
  as select from zpurc_order_item
  association [1..*] to ZPurcOrderHdr as _header on $projection.purchaseOrderId = _header.purchaseOrderId
{
  key item_number        as itemNumber,
  key purchase_order_id  as purchaseOrderId,
      product_id         as productId,
      product_name       as productName,
      quantity           as quantity,
      @Semantics.amount.currencyCode : 'itemCurrency'
      unit_price         as unitPrice,
      @Semantics.amount.currencyCode : 'itemCurrency'
      total_price        as totalPrice,
      delivery_date      as deliveryDate,
      warehouse_location as warehouseLocation,
      item_currency      as itemCurrency,
      _header // Association to Header Table
}
