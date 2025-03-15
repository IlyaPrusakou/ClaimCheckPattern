CLASS lcl_local_event_consumption DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS consume_broadcast_claim FOR ENTITY EVENT it_broker_claim_id FOR broker~broadcastevent .
ENDCLASS.

CLASS lcl_local_event_consumption IMPLEMENTATION.
  METHOD consume_broadcast_claim.

    DATA: lt_process_msg TYPE TABLE FOR ACTION IMPORT zi_pru_purch_order\\zrprupurchorder~processmessage.

    IF it_broker_claim_id IS INITIAL.
      RETURN.
    ENDIF.

    lt_process_msg = VALUE #( FOR <ls_in>
                              IN it_broker_claim_id
                              ( %param-claim_id = <ls_in>-%param-claim_id ) ).


    MODIFY ENTITIES OF zi_pru_purch_order
    ENTITY zrprupurchorder
    EXECUTE processmessage AUTO FILL CID WITH lt_process_msg
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported).

" process response

  ENDMETHOD.
ENDCLASS.
