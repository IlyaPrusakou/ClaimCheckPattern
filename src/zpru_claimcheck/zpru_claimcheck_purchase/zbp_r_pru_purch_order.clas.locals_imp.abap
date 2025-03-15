CLASS lhc_zr_pru_purch_order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zrprupurchorder
        RESULT result,
      processmessage FOR MODIFY
        IMPORTING keys FOR ACTION zrprupurchorder~processmessage.
ENDCLASS.

CLASS lhc_zr_pru_purch_order IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD processmessage.

    DATA: lt_store_read TYPE TABLE FOR READ IMPORT zi_pru_msg_store\\zrprumsgstore.
    DATA: lt_purchase_create TYPE TABLE FOR CREATE zi_pru_purch_order\\zrprupurchorder.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    lt_store_read = VALUE #( FOR <ls_k>
                             IN keys
                             ( %tky-claim = <ls_k>-%param-claim_id ) ).

    READ ENTITIES OF zi_pru_msg_store
    ENTITY zrprumsgstore
    ALL FIELDS WITH lt_store_read
    RESULT DATA(lt_stored_stocks).

    IF lt_stored_stocks IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE MAX( purchaseorderid ) AS lastid
    FROM zi_pru_purch_order AS purch
    GROUP BY purchaseorderid
    INTO @DATA(lv_last_id).

    lt_purchase_create = VALUE #( FOR <ls_r>
                                  IN lt_stored_stocks
                                  ( %key-purchaseorderid      = lv_last_id + 1
                                    %data-purchasename        = <ls_r>-stockname
                                    %data-purchaseqnty        = <ls_r>-stockqnty
                                    %data-purchaseunitmeasure = <ls_r>-stockunitmeasure
                                    %data-referencestockid    = <ls_r>-stockreqid ) ).

    MODIFY ENTITIES OF zi_pru_purch_order
    ENTITY zrprupurchorder
    CREATE AUTO FILL CID WITH lt_purchase_create
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported)
    MAPPED DATA(lt_mapped).

    failed = CORRESPONDING #( DEEP ls_failed ).
    reported = CORRESPONDING #( DEEP ls_reported ).
    mapped = CORRESPONDING #( DEEP lt_mapped ).

  ENDMETHOD.

ENDCLASS.
