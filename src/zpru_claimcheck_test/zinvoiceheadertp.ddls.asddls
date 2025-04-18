@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZInvoiceHeaderTP
  as select from ZInvoiceHeader

{
  key InvoiceId,
      PurchaseOrderId,
      InvoiceDate,
      DueDate,
      SupplierId,
      SupplierName,
      BuyerId,
      BuyerName,
      @Semantics.amount.currencyCode : 'InvoiceCurrency'
      TotalAmount,
      InvoiceCurrency,
      Status,
      ControlTimestamp
}
