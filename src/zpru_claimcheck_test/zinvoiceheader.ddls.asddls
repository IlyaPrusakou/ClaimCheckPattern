@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZInvoiceHeader
  as select from zinvoice_header
{
  key invoice_id        as InvoiceId,
      purchase_order_id as PurchaseOrderId,
      invoice_date      as InvoiceDate,
      due_date          as DueDate,
      supplier_id       as SupplierId,
      supplier_name     as SupplierName,
      buyer_id          as BuyerId,
      buyer_name        as BuyerName,
      @Semantics.amount.currencyCode : 'InvoiceCurrency'
      total_amount      as TotalAmount,
      invoice_currency  as InvoiceCurrency,
      status            as Status
}
