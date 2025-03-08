CLASS lhc_zr_pru_stock_reqst DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zrprustockreqst
        RESULT result.
ENDCLASS.

CLASS lhc_zr_pru_stock_reqst IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
ENDCLASS.

CLASS lsc_zr_pru_stock_reqst DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_pru_stock_reqst IMPLEMENTATION.

  METHOD save_modified.
    IF create-zrprustockreqst IS INITIAL.
      RETURN.
    ENDIF.

    READ ENTITIES OF zr_pru_stock_reqst IN LOCAL MODE
         ENTITY zrprustockreqst
         FIELDS ( stockreqid
                  stockname
                  stockqnty
                  stockunitmeasure ) WITH CORRESPONDING #( create-zrprustockreqst )
         RESULT DATA(lt_stock_requests).

    TRY.
        RAISE ENTITY EVENT zr_pru_stock_reqst~sendclaim
              FROM VALUE #( FOR <ls_stock_request> IN lt_stock_requests
                            ( %key-stockreqid = <ls_stock_request>-%key-stockreqid
                              %param-claim_id = cl_system_uuid=>create_uuid_x16_static( ) )  ).

      CATCH cx_uuid_error.
        RETURN.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
