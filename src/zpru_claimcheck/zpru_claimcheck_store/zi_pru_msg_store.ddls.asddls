@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Store Interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PRU_MSG_STORE
provider contract transactional_interface 
as projection on ZR_PRU_MSG_STORE
{
    key Claim,
    StockReqId,
    StockName,
    StockQnty,
    StockUnitMeasure
}
