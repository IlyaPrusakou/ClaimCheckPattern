CLASS lhc_purchaseorder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR purchaseorder RESULT result.

ENDCLASS.

CLASS lhc_purchaseorder IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zpurcorderhdrtp DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zpurcorderhdrtp IMPLEMENTATION.

  METHOD save_modified.

    IF create-purchaseorder IS INITIAL.
      RETURN.
    ENDIF.

    RAISE ENTITY EVENT zpurcorderhdrtp~ordercreated
    FROM VALUE #( FOR <ls_order>
                  IN create-purchaseorder
                  ( %key-purchaseorderid          = <ls_order>-purchaseorderid
                    %param-header-purchaseorderid = <ls_order>-purchaseorderid
                    %param-header-buyername       = <ls_order>-buyername
                    %param-header-items           = VALUE #( FOR <ls_item>
                                                             IN create-purchaseitem
                                                             WHERE ( %key-purchaseorderid = <ls_order>-purchaseorderid )
                                                             ( purchaseorderid = <ls_item>-purchaseorderid
                                                               itemnumber      = <ls_item>-itemnumber
                                                               productname     = <ls_item>-productname ) ) ) ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
