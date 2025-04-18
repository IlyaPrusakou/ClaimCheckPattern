@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Good Receipt Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZGoodReceiptProj
  provider contract transactional_interface
  as projection on ZGoodReceiptTP
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
