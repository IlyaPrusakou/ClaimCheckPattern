CLASS lcl_local_event_consumption DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS consume_broadcast_claim FOR ENTITY EVENT it_broker_claim_id FOR Broker~broadCastEvent .
ENDCLASS.

CLASS lcl_local_event_consumption IMPLEMENTATION.
  METHOD consume_broadcast_claim.
" place to proceed
  ENDMETHOD.
ENDCLASS.
