@EndUserText.label: 'Purchase Order'
define abstract entity ZPurcOrderHdrAbstract
{
  purchaseOrderId : abap.char(10);
  orderDate       : abap.dats;
  supplierId      : abap.char(10);
  supplierName    : abap.char(50);
  buyerId         : abap.char(10);
  buyerName       : abap.char(50);
  @Semantics.amount.currencyCode : 'headerCurrency'
  totalAmount     : abap.curr(15,2);
  headerCurrency  : abap.cuky;
  deliveryDate    : abap.dats;
  status          : abap.char(20);
  paymentTerms    : abap.char(20);
  shippingMethod  : abap.char(20);
  message         : association to parent ZPurcMessageHeader;
  items           : composition of exact one to many ZPurcOrderItemAbstract;
}
