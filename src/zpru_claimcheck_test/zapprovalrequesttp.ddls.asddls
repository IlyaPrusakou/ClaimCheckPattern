@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval Request Transactional'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZApprovalRequestTP
  as select from ZApprovalRequest

{
  key ApprovalRequestId,
      PurchaseOrderId,
      RequestDate,
      RequesterId,
      RequesterName,
      ApproverId,
      ApproverName,
      ApprovalStatus,
      ApprovalDeadline,
      ApprovalNotes
}
