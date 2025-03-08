CLASS lhc_zr_pru_msg_broker DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR broker
        RESULT result,
      raisebroadcast FOR MODIFY
        IMPORTING keys FOR ACTION broker~raisebroadcast.
ENDCLASS.

CLASS lhc_zr_pru_msg_broker IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD raisebroadcast.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF zr_pru_msg_broker IN LOCAL MODE
    ENTITY broker
    CREATE FIELDS ( brokerclaimid )
    AUTO FILL CID WITH VALUE #( FOR <ls_k>
                                IN keys
                                ( %key-brokerclaimid = <ls_k>-%param-claim_id  ) )
    REPORTED DATA(ls_reported)
    FAILED DATA(ls_failed).

    IF ls_failed IS NOT INITIAL.
      reported = CORRESPONDING #( DEEP ls_reported ).
      failed = CORRESPONDING #( DEEP ls_failed ).
      RETURN.
    ENDIF.

    RAISE ENTITY EVENT zr_pru_msg_broker~broadcastevent
          FROM VALUE #( FOR <ls_key> IN keys
                        ( %key-BrokerClaimId = <ls_key>-%param-claim_id
                          %param-claim_id = <ls_key>-%param-claim_id )  ).

  ENDMETHOD.

ENDCLASS.
