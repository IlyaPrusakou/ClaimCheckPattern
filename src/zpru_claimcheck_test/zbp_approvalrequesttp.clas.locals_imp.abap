CLASS lhc_approvalrequest DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR approvalrequest RESULT result.

    METHODS onpurchaseordercreate FOR MODIFY
      IMPORTING keys FOR ACTION approvalrequest~onpurchaseordercreate.

ENDCLASS.

CLASS lhc_approvalrequest IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD onpurchaseordercreate.

    DATA(lv_appr) = VALUE #( keys[ 1 ]-%param[ 1 ]-messageid OPTIONAL ).

  ENDMETHOD.

ENDCLASS.
