@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPurcOrderHdr
  as select from zpurc_order_hdr
  association [1..*] to ZPurcOrderItem as _items on $projection.purchaseOrderId = _items.purchaseOrderId
{
  key purchase_order_id as purchaseOrderId,
      order_date        as orderDate,
      supplier_id       as supplierId,
      supplier_name     as supplierName,
      buyer_id          as buyerId,
      buyer_name        as buyerName,
      @Semantics.amount.currencyCode : 'headerCurrency'
      total_amount      as totalAmount,
      header_currency   as headerCurrency,
      delivery_date     as deliveryDate,
      status            as status,
      payment_terms     as paymentTerms,
      shipping_method   as shippingMethod,
      _items
}
