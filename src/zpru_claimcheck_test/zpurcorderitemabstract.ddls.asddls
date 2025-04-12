@EndUserText.label: 'Purchase Order Item'
define abstract entity ZPurcOrderItemAbstract

{
  itemNumber        : abap.int4;
  purchaseOrderId   : abap.char(10);
  productId         : abap.char(10);
  productName       : abap.char(50);
  quantity          : abap.int4;
  @Semantics.amount.currencyCode : 'itemCurrency'
  unitPrice         : abap.curr(15,2);
  @Semantics.amount.currencyCode : 'itemCurrency'
  totalPrice        : abap.curr(15,2);
  deliveryDate      : abap.dats;
  warehouseLocation : abap.char(20);
  itemCurrency      : abap.cuky;
  header            : association to parent ZPurcOrderHdrAbstract;
}
