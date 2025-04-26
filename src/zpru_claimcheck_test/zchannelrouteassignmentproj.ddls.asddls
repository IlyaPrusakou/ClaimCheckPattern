@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Channel Route Assingment Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZChannelRouteAssignmentPROJ 
    provider contract transactional_interface
    as projection on ZChannelRouteAssignmentTP
{
    key Channel,
    key Route,
    key BusinessObject,
    key BusinessObjectEntity,
    key BusinessObjectAction,
    Description
}
