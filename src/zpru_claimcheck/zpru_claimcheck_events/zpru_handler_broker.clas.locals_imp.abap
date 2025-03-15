CLASS lcl_local_event_consumption DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS consume_send_claim FOR ENTITY EVENT it_stock_claim_id FOR zrprustockreqst~sendclaim.
ENDCLASS.

CLASS lcl_local_event_consumption IMPLEMENTATION.
  METHOD consume_send_claim.

    MODIFY ENTITIES OF zi_pru_msg_broker
    ENTITY broker
    EXECUTE raisebroadcast
    AUTO FILL CID WITH VALUE #( FOR <ls_k> IN it_stock_claim_id ( %param-claim_id = <ls_k>-%param-claim_id ) )
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported).

    " process response

  ENDMETHOD.
ENDCLASS.
