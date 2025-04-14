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

    METHODS generate_messageid
      RETURNING
        VALUE(rv_message_id) TYPE string.

    METHODS get_receiversystem
      RETURNING
        VALUE(rv_receiver_system) TYPE string.

    METHODS generate_version
      RETURNING
        VALUE(rv_version) TYPE string.

    METHODS fetch_auth_token
      RETURNING
        VALUE(rv_auth_token) TYPE string.
    METHODS generate_message_type
      RETURNING
        VALUE(rv_message_type) TYPE string.

ENDCLASS.

CLASS lsc_zpurcorderhdrtp IMPLEMENTATION.

  METHOD save_modified.

    DATA: lt_payload TYPE TABLE FOR EVENT zpurcorderhdrtp\\purchaseorder~ordercreated.

    IF create-purchaseorder IS INITIAL.
      RETURN.
    ENDIF.

    GET TIME STAMP FIELD DATA(lv_now).

    LOOP AT create-purchaseorder ASSIGNING FIELD-SYMBOL(<ls_order>).
      APPEND INITIAL LINE TO lt_payload ASSIGNING FIELD-SYMBOL(<ls_payload>).
      <ls_payload>-%key-purchaseorderid          = <ls_order>-purchaseorderid.
      <ls_payload>-%param-messageid              = generate_messageid( ).
      <ls_payload>-%param-timestamp              = lv_now.
      <ls_payload>-%param-sendersystem           = sy-sysid.
      <ls_payload>-%param-receiversystem         = get_receiversystem( ).
      <ls_payload>-%param-messagetype            = generate_message_type( ).
      <ls_payload>-%param-priority               = abap_false.
      <ls_payload>-%param-version                = generate_version( ).
      <ls_payload>-%param-authorizationtoken     = fetch_auth_token( ).
      <ls_payload>-%param-header-purchaseorderid = <ls_order>-purchaseorderid.
      <ls_payload>-%param-header-orderdate       = <ls_order>-orderdate.
      <ls_payload>-%param-header-supplierid      = <ls_order>-supplierid.
      <ls_payload>-%param-header-suppliername    = <ls_order>-suppliername.
      <ls_payload>-%param-header-buyerid         = <ls_order>-buyerid.
      <ls_payload>-%param-header-buyername       = <ls_order>-buyername.
      <ls_payload>-%param-header-totalamount     = <ls_order>-totalamount.
      <ls_payload>-%param-header-headercurrency  = <ls_order>-headercurrency.
      <ls_payload>-%param-header-deliverydate    = <ls_order>-deliverydate.
      <ls_payload>-%param-header-status          = <ls_order>-status.
      <ls_payload>-%param-header-paymentterms    = <ls_order>-paymentterms.
      <ls_payload>-%param-header-shippingmethod  = <ls_order>-shippingmethod.
      LOOP AT create-purchaseitem ASSIGNING FIELD-SYMBOL(<ls_item>)
                                  WHERE purchaseorderid = <ls_order>-purchaseorderid.
        APPEND INITIAL LINE TO <ls_payload>-%param-header-items ASSIGNING FIELD-SYMBOL(<ls_payload_item>).
        <ls_payload_item>-itemnumber         = <ls_item>-itemnumber.
        <ls_payload_item>-purchaseorderid    = <ls_item>-purchaseorderid .
        <ls_payload_item>-productid          = <ls_item>-productid.
        <ls_payload_item>-productname        = <ls_item>-productname.
        <ls_payload_item>-quantity           = <ls_item>-quantity.
        <ls_payload_item>-unitprice          = <ls_item>-unitprice.
        <ls_payload_item>-totalprice         = <ls_item>-totalprice.
        <ls_payload_item>-deliverydate       = <ls_item>-deliverydate.
        <ls_payload_item>-warehouselocation  = <ls_item>-warehouselocation.
        <ls_payload_item>-itemcurrency       = <ls_item>-itemcurrency.
      ENDLOOP.
    ENDLOOP.

    RAISE ENTITY EVENT zpurcorderhdrtp~ordercreated FROM lt_payload.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
  METHOD generate_messageid.
    rv_message_id = `1`.
  ENDMETHOD.

  METHOD generate_message_type.
    rv_message_type = zpru_if_purc_order=>gcs_message_type-po_document.
  ENDMETHOD.

  METHOD get_receiversystem.
    rv_receiver_system = sy-sysid.
  ENDMETHOD.
  METHOD generate_version.
    rv_version = `1`.
  ENDMETHOD.

  METHOD fetch_auth_token.
    rv_auth_token = 'ASDWWxxxas123132vfgeqwdsx11212323DDSA'.
  ENDMETHOD.

ENDCLASS.
