@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval Request Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZApprovalRequestProj
  provider contract transactional_interface
  as projection on ZApprovalRequestTP
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
      ApprovalNotes,
      ControlTimestamp
}
