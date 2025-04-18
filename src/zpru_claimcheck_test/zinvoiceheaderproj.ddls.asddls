@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Header Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZInvoiceHeaderProj
  provider contract transactional_interface
  as projection on ZInvoiceHeaderTP
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
