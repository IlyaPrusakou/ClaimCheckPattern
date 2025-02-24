@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Stock Request'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PRU_STOCK_REQST
provider contract transactional_interface 
as projection on ZR_PRU_STOCK_REQST 
{
key StockReqId,  
StockName,  
StockQnty,  
StockUnitMeasure  
}
