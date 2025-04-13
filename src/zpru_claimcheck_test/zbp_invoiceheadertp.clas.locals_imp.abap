CLASS lhc_invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR invoice RESULT result.

    METHODS onpurchaseordercreate FOR MODIFY
      IMPORTING keys FOR ACTION invoice~onpurchaseordercreate.

ENDCLASS.

CLASS lhc_invoice IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD onpurchaseordercreate.
    DATA(lv_inv) = VALUE #( keys[ 1 ]-%param[ 1 ]-messageid OPTIONAL ).
  ENDMETHOD.

ENDCLASS.
