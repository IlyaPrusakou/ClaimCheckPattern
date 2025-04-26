@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Channel Route Assingment BO'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZChannelRouteAssignmentTP
  as select from ZChannelRouteAssignment
{
  key Channel,
  key Route,
  key BusinessObject,
  key BusinessObjectEntity,
  key BusinessObjectAction,
      Description
}
