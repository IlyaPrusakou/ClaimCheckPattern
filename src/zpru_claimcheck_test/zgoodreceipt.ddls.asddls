@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Good Receipt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGoodReceipt
  as select from zgr_receipt_head
{
  key goods_receipt_id   as GoodsReceiptId,
      purchase_order_id  as PurchaseOrderId,
      receipt_date       as ReceiptDate,
      supplier_id        as SupplierId,
      supplier_name      as SupplierName,
      warehouse_id       as WarehouseId,
      warehouse_location as WarehouseLocation,
      received_by        as ReceivedBy,
      total_items        as TotalItems,
      status             as Status,
      remarks            as Remarks
}
