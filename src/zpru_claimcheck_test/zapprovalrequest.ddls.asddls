@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval Request'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZApprovalRequest
  as select from zapproval_reqst
{
  key approval_request_id as ApprovalRequestId,
      purchase_order_id   as PurchaseOrderId,
      request_date        as RequestDate,
      requester_id        as RequesterId,
      requester_name      as RequesterName,
      approver_id         as ApproverId,
      approver_name       as ApproverName,
      approval_status     as ApprovalStatus,
      approval_deadline   as ApprovalDeadline,
      approval_notes      as ApprovalNotes,
      control_timestamp   as ControlTimestamp
}
