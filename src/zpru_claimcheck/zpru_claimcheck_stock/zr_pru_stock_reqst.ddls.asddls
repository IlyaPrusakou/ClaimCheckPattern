@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_PRU_STOCK_REQST
  as select from zpru_stock_reqst
{
  key stock_req_id       as StockReqId,
      stock_name         as StockName,
      stock_qnty         as StockQnty,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' },
                                            useForValidation: true } ]
      stock_unit_measure as StockUnitMeasure,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      //local ETag field --> OData ETag
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      //total ETag field
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt      

}
