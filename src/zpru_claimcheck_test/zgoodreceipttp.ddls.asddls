@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Good Receipt Transactional'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZGoodReceiptTP
  as select from ZGoodReceipt
{
  key GoodsReceiptId,
      PurchaseOrderId,
      ReceiptDate,
      SupplierId,
      SupplierName,
      WarehouseId,
      WarehouseLocation,
      ReceivedBy,
      TotalItems,
      Status,
      Remarks,
      ControlTimestamp
}
