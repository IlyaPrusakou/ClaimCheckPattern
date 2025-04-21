CLASS lcl_channel DEFINITION.
  PUBLIC SECTION.

    METHODS filter_by_supplier_id
      CHANGING
        ct_po_invalidated TYPE abp_behv_changes_tab
        ct_po_approved    TYPE zpru_if_purc_order=>tt_purc_order_message
        ct_po_pending     TYPE zpru_if_purc_order=>tt_purc_order_message.

    METHODS send_2_invalid_message
      IMPORTING
        it_po_invalidated TYPE abp_behv_changes_tab.

    METHODS send_2_deadletter_message
      IMPORTING
        it_po_deadletter TYPE abp_behv_changes_tab .

    METHODS send_2_receiver
      IMPORTING
        it_operation_package TYPE abp_behv_changes_tab .

    METHODS get_black_list
      RETURNING
        VALUE(rt_black_list) TYPE zpru_if_purc_order=>tt_supplier_id.

  PROTECTED SECTION.

    METHODS send_payload
      IMPORTING
        it_operation_package TYPE abp_behv_changes_tab
      CHANGING
        cs_failed_dyn        TYPE abp_behv_response_tab
        cs_reported_dyn      TYPE abp_behv_response_tab.

  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_router DEFINITION.
  PUBLIC SECTION.
    METHODS split_po_by_status
      IMPORTING
        it_purc_order_messsage TYPE zpru_if_purc_order=>tt_purc_order_message
      EXPORTING
        et_po_approved         TYPE zpru_if_purc_order=>tt_purc_order_message
        et_po_pending          TYPE zpru_if_purc_order=>tt_purc_order_message
      CHANGING
        ct_po_invalidated      TYPE abp_behv_changes_tab.

    METHODS route_approved_po_paymentterms
      IMPORTING
        it_channel_assignments TYPE zpru_if_purc_order=>tt_channel_assignments
        it_po_approved         TYPE zpru_if_purc_order=>tt_purc_order_message
      EXPORTING
        et_po_prepaid          TYPE abp_behv_changes_tab
        et_po_postpaid         TYPE abp_behv_changes_tab
      CHANGING
        ct_po_deadletter       TYPE abp_behv_changes_tab.

    METHODS route_pending_po_for_approval
      IMPORTING
        it_channel_assignments TYPE zpru_if_purc_order=>tt_channel_assignments
        it_po_pending          TYPE zpru_if_purc_order=>tt_purc_order_message
      EXPORTING
        et_po_for_approval     TYPE abp_behv_changes_tab
      CHANGING
        ct_po_deadletter       TYPE abp_behv_changes_tab.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_utility DEFINITION.
  PUBLIC SECTION.

    CLASS-DATA: mv_last_cid TYPE int8 VALUE '1'.

    CLASS-METHODS prepare_operation_package
      IMPORTING
        is_channel_assignments TYPE zchannelrouteassignment
        it_purc_order_messsage TYPE zpru_if_purc_order=>tt_purc_order_message
      CHANGING
        ct_operation_package   TYPE abp_behv_changes_tab.

    CLASS-METHODS get_deadletter_route
      RETURNING
        VALUE(rs_deadletter_route) TYPE zpru_if_purc_order=>ts_channel_assignments.

    CLASS-METHODS get_invalid_message_route
      RETURNING
        VALUE(rs_invalid_message_route) TYPE zpru_if_purc_order=>ts_channel_assignments.

    CLASS-METHODS validate_channel_assignments
      IMPORTING
        iv_simple_route        TYPE char3
        it_channel_assignments TYPE zpru_if_purc_order=>tt_channel_assignments
      EXPORTING
        et_valid_assignments   TYPE zpru_if_purc_order=>tt_channel_assignments.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_local_event_consumption DEFINITION
INHERITING FROM cl_abap_behavior_event_handler.

  PRIVATE SECTION.
    METHODS on_order_created
        FOR ENTITY EVENT it_purchase_order
          FOR purchaseorder~ordercreated.

ENDCLASS.

CLASS lcl_local_event_consumption IMPLEMENTATION.
  METHOD on_order_created.

    DATA: ls_failed_dyn     TYPE abp_behv_response_tab,
          ls_reported_dyn   TYPE abp_behv_response_tab,
          lt_po_invalidated TYPE abp_behv_changes_tab,
          lt_po_deadletter  TYPE abp_behv_changes_tab.

    DATA(lo_channel) = NEW lcl_channel( ).
    DATA(lo_router)  = NEW lcl_router( ).

    " Splitter pattern
    lo_router->split_po_by_status(
      EXPORTING
        it_purc_order_messsage = CORRESPONDING #( it_purchase_order )
      IMPORTING
        et_po_approved         = DATA(lt_po_approved)
        et_po_pending          = DATA(lt_po_pending)
      CHANGING
        ct_po_invalidated = lt_po_invalidated ).

    " Message Filter pattern
    lo_channel->filter_by_supplier_id(
      CHANGING
        ct_po_approved    = lt_po_approved
        ct_po_pending     = lt_po_pending
        ct_po_invalidated = lt_po_invalidated ).

    " Invalid Message Channel pattern
    lo_channel->send_2_invalid_message(
      EXPORTING
          it_po_invalidated = lt_po_invalidated ).

    " read customizing table with list of receivers
    " further it will be used in Contend-Based and
    " Point-to-Point patterns
    SELECT * FROM zchannelrouteassignment
    WHERE channel = @zpru_if_purc_order=>gcs_channel-po_order
    INTO TABLE @DATA(lt_channel_assignments).

    " Content-Based Router pattern
    lo_router->route_approved_po_paymentterms(
      EXPORTING
        it_channel_assignments = lt_channel_assignments
        it_po_approved         = lt_po_approved
      IMPORTING
        et_po_prepaid          = DATA(lt_po_prepaid)
        et_po_postpaid         = DATA(lt_po_postpaid)
      CHANGING
        ct_po_deadletter       = lt_po_deadletter ).

    " Point to Point
    lo_router->route_pending_po_for_approval(
      EXPORTING
        it_channel_assignments = lt_channel_assignments
        it_po_pending          = lt_po_pending
      IMPORTING
        et_po_for_approval     = DATA(lt_po_for_approval)
      CHANGING
        ct_po_deadletter       = lt_po_deadletter ).

    " Dead Letter Pattern
    lo_channel->send_2_deadletter_message(
      EXPORTING
          it_po_deadletter = lt_po_deadletter ).

    " Publish-Subscribe
    " 1. Good Receipt creation
    lo_channel->send_2_receiver(
      EXPORTING
          it_operation_package = lt_po_prepaid ).

    " 2. Invoice creation
    lo_channel->send_2_receiver(
      EXPORTING
          it_operation_package = lt_po_postpaid ).

    " 3.Approval Request creation
    lo_channel->send_2_receiver(
      EXPORTING
          it_operation_package = lt_po_for_approval ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_channel IMPLEMENTATION.

  METHOD filter_by_supplier_id.

    DATA: lt_po_invalidated LIKE ct_po_approved.

    DATA: lt_processinvalidmessage TYPE zpru_if_purc_order=>tt_processinvalidmessage.
    FIELD-SYMBOLS: <ls_processinvalidmessage> TYPE zpru_if_purc_order=>ts_processinvalidmessage.

    DATA(lt_po_approved) = ct_po_approved.
    DATA(lt_po_pending) = ct_po_pending.

    LOOP AT lt_po_approved ASSIGNING FIELD-SYMBOL(<ls_po_approved>).
      IF <ls_po_approved>-header-supplierid IN get_black_list( ).
        APPEND INITIAL LINE TO lt_po_invalidated ASSIGNING FIELD-SYMBOL(<ls_po_invalidated>).
        <ls_po_invalidated> = CORRESPONDING #( DEEP <ls_po_approved> ).

        DELETE ct_po_approved WHERE table_line = <ls_po_approved>.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_po_pending ASSIGNING FIELD-SYMBOL(<ls_po_pending>).
      IF <ls_po_pending>-header-supplierid IN get_black_list( ).
        APPEND INITIAL LINE TO lt_po_invalidated ASSIGNING <ls_po_invalidated>.
        <ls_po_invalidated> = CORRESPONDING #( DEEP <ls_po_pending> ).

        DELETE ct_po_pending WHERE table_line = <ls_po_pending>.
      ENDIF.
    ENDLOOP.

    IF lt_po_invalidated IS NOT INITIAL.
      lcl_utility=>prepare_operation_package(
            EXPORTING
                is_channel_assignments = lcl_utility=>get_invalid_message_route( )
                it_purc_order_messsage = lt_po_invalidated
            CHANGING
                ct_operation_package   = ct_po_invalidated ).
    ENDIF.

  ENDMETHOD.

  METHOD send_2_invalid_message.
    DATA: ls_failed_dyn   TYPE abp_behv_response_tab,
          ls_reported_dyn TYPE abp_behv_response_tab.

    IF it_po_invalidated IS INITIAL.
      RETURN.
    ENDIF.

    send_payload(
        EXPORTING
            it_operation_package = it_po_invalidated
        CHANGING
            cs_failed_dyn        = ls_failed_dyn
            cs_reported_dyn      = ls_reported_dyn ).

  ENDMETHOD.

  METHOD send_2_deadletter_message.

    DATA: ls_failed_dyn   TYPE abp_behv_response_tab,
          ls_reported_dyn TYPE abp_behv_response_tab.

    IF it_po_deadletter IS INITIAL.
      RETURN.
    ENDIF.

    send_payload(
        EXPORTING
            it_operation_package = it_po_deadletter
        CHANGING
            cs_failed_dyn        = ls_failed_dyn
            cs_reported_dyn      = ls_reported_dyn ).
  ENDMETHOD.

  METHOD send_2_receiver.

    DATA: ls_failed_dyn   TYPE abp_behv_response_tab,
          ls_reported_dyn TYPE abp_behv_response_tab.

    IF it_operation_package IS INITIAL.
      RETURN.
    ENDIF.

    send_payload(
        EXPORTING
          it_operation_package = it_operation_package
        CHANGING
          cs_failed_dyn        = ls_failed_dyn
          cs_reported_dyn      = ls_reported_dyn ).

  ENDMETHOD.

  METHOD get_black_list.
    rt_black_list = VALUE #( ( sign   = `I`
                               option = `EQ`
                               low    = `SUP003` ) ).
  ENDMETHOD.

  METHOD send_payload.

    MODIFY ENTITIES OPERATIONS it_operation_package
     FAILED   cs_failed_dyn
     REPORTED cs_reported_dyn.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_router IMPLEMENTATION.
  METHOD split_po_by_status.

    DATA: lt_po_invalidated LIKE et_po_approved.

    CLEAR: et_po_approved, et_po_pending.

    LOOP AT it_purc_order_messsage ASSIGNING FIELD-SYMBOL(<ls_po>).
      CASE <ls_po>-header-status.
        WHEN zpru_if_purc_order=>gcs_po_status-approved.

          APPEND INITIAL LINE TO et_po_approved ASSIGNING FIELD-SYMBOL(<ls_po_approved>).
          <ls_po_approved> = CORRESPONDING #( DEEP <ls_po> ).

        WHEN zpru_if_purc_order=>gcs_po_status-pending_approval.
          APPEND INITIAL LINE TO et_po_pending ASSIGNING FIELD-SYMBOL(<ls_po_pending>).
          <ls_po_pending> = CORRESPONDING #( DEEP <ls_po> ).
        WHEN OTHERS.
          APPEND INITIAL LINE TO lt_po_invalidated ASSIGNING FIELD-SYMBOL(<ls_po_invalidated>).
          <ls_po_invalidated> = CORRESPONDING #( DEEP <ls_po> ).
      ENDCASE.
    ENDLOOP.

    IF lt_po_invalidated IS NOT INITIAL.
      lcl_utility=>prepare_operation_package(
            EXPORTING
                is_channel_assignments = lcl_utility=>get_invalid_message_route( )
                it_purc_order_messsage = lt_po_invalidated
            CHANGING
                ct_operation_package   = ct_po_invalidated ).
    ENDIF.
  ENDMETHOD.

  METHOD route_approved_po_paymentterms.

    DATA: lt_po_prepaid  LIKE it_po_approved,
          lt_po_postpaid LIKE it_po_approved,
          lt_po_no_route LIKE it_po_approved.

    IF it_channel_assignments IS INITIAL.
      lcl_utility=>prepare_operation_package(
        EXPORTING
            is_channel_assignments = lcl_utility=>get_deadletter_route( )
            it_purc_order_messsage = it_po_approved
        CHANGING
            ct_operation_package   = ct_po_deadletter ).
      RETURN.
    ENDIF.

    LOOP AT it_po_approved ASSIGNING FIELD-SYMBOL(<ls_po_approved>).
      IF <ls_po_approved>-header-paymentterms = zpru_if_purc_order=>gcs_po_payment_terms-prepaid.
        APPEND INITIAL LINE TO lt_po_prepaid ASSIGNING FIELD-SYMBOL(<ls_po_prepaid>).
        <ls_po_prepaid> = CORRESPONDING #( DEEP <ls_po_approved> ).
      ELSEIF <ls_po_approved>-header-paymentterms = zpru_if_purc_order=>gcs_po_payment_terms-cod OR
             <ls_po_approved>-header-paymentterms = zpru_if_purc_order=>gcs_po_payment_terms-eom60 OR
             <ls_po_approved>-header-paymentterms = zpru_if_purc_order=>gcs_po_payment_terms-net30 OR
             <ls_po_approved>-header-paymentterms = zpru_if_purc_order=>gcs_po_payment_terms-net45.
        APPEND INITIAL LINE TO lt_po_postpaid ASSIGNING FIELD-SYMBOL(<ls_po_postpaid>).
        <ls_po_postpaid> = CORRESPONDING #( DEEP <ls_po_approved> ).
      ELSE.
        APPEND INITIAL LINE TO lt_po_no_route ASSIGNING FIELD-SYMBOL(<ls_po_no_route>).
        <ls_po_no_route> = CORRESPONDING #( DEEP <ls_po_approved> ).
      ENDIF.
    ENDLOOP.

    IF lt_po_prepaid IS NOT INITIAL.
      ASSIGN it_channel_assignments[ route =
           zpru_if_purc_order=>gcs_po_route-payment_terms-prepaid ]
                                               TO FIELD-SYMBOL(<ls_channel_assignment>).
      IF sy-subrc = 0.
        lcl_utility=>prepare_operation_package(
          EXPORTING
              is_channel_assignments = <ls_channel_assignment>
              it_purc_order_messsage = lt_po_prepaid
          CHANGING
              ct_operation_package   = et_po_prepaid ).
      ELSE.
        lcl_utility=>prepare_operation_package(
       EXPORTING
           is_channel_assignments = lcl_utility=>get_deadletter_route( )
           it_purc_order_messsage = lt_po_prepaid
       CHANGING
           ct_operation_package   = ct_po_deadletter ).
      ENDIF.
    ENDIF.

    IF lt_po_postpaid IS NOT INITIAL.
      ASSIGN it_channel_assignments[ route =
                    zpru_if_purc_order=>gcs_po_route-payment_terms-other ]
                                                             TO <ls_channel_assignment>.
      IF sy-subrc = 0.
        lcl_utility=>prepare_operation_package(
          EXPORTING
              is_channel_assignments = <ls_channel_assignment>
              it_purc_order_messsage = lt_po_postpaid
          CHANGING
              ct_operation_package   = et_po_postpaid ).
      ELSE.
        lcl_utility=>prepare_operation_package(
          EXPORTING
              is_channel_assignments = lcl_utility=>get_deadletter_route( )
              it_purc_order_messsage = lt_po_postpaid
          CHANGING
              ct_operation_package   = ct_po_deadletter ).
      ENDIF.
    ENDIF.

    IF lt_po_no_route IS NOT INITIAL.
      lcl_utility=>prepare_operation_package(
        EXPORTING
            is_channel_assignments = lcl_utility=>get_deadletter_route( )
            it_purc_order_messsage = lt_po_no_route
        CHANGING
            ct_operation_package   = ct_po_deadletter ).
    ENDIF.

  ENDMETHOD.


  METHOD route_pending_po_for_approval.

    IF it_channel_assignments IS INITIAL.
      RETURN.
    ENDIF.

    lcl_utility=>validate_channel_assignments(
          EXPORTING
            iv_simple_route        = zpru_if_purc_order=>gcs_po_route-simple_router-approval_request
            it_channel_assignments = it_channel_assignments
          IMPORTING
            et_valid_assignments   = DATA(lt_valid_assignments) ).

    IF lt_valid_assignments IS INITIAL.
      lcl_utility=>prepare_operation_package(
        EXPORTING
            is_channel_assignments = lcl_utility=>get_deadletter_route( )
            it_purc_order_messsage = it_po_pending
        CHANGING
            ct_operation_package   = ct_po_deadletter ).
      RETURN.
    ENDIF.

    lcl_utility=>prepare_operation_package(
      EXPORTING
          is_channel_assignments = VALUE #( lt_valid_assignments[ 1 ] OPTIONAL )
          it_purc_order_messsage = it_po_pending
      CHANGING
          ct_operation_package   = et_po_for_approval ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_utility IMPLEMENTATION.
  METHOD prepare_operation_package.

    DATA lr_data TYPE REF TO data.
    DATA: lv_type_name TYPE string.

    FIELD-SYMBOLS: <lt_action_tab> TYPE INDEX TABLE.
    FIELD-SYMBOLS: <lt_param_tab> TYPE zpru_if_purc_order=>tt_purc_order_message.
    FIELD-SYMBOLS: <ls_param> TYPE zpru_if_purc_order=>ts_purc_order_message.

    lv_type_name = `\BDEF=` && |{ is_channel_assignments-businessobject }| &&
                   `\ENTITY=` && |{ is_channel_assignments-businessobjectentity }| &&
                   `\ACTION=` && |{ is_channel_assignments-businessobjectaction }| &&
                   `\TYPE=IMPORTING`.

    CREATE DATA lr_data TYPE (lv_type_name).

    ASSIGN lr_data->* TO <lt_action_tab>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    APPEND INITIAL LINE TO <lt_action_tab> ASSIGNING FIELD-SYMBOL(<ls_entry>).
    ASSIGN COMPONENT '%CID' OF STRUCTURE <ls_entry> TO FIELD-SYMBOL(<ls_cid>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lcl_utility=>mv_last_cid += 1.
    <ls_cid> = lcl_utility=>mv_last_cid.

    ASSIGN COMPONENT '%PARAM' OF STRUCTURE <ls_entry> TO <lt_param_tab>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT it_purc_order_messsage ASSIGNING FIELD-SYMBOL(<ls_po_message>).
      APPEND INITIAL LINE TO <lt_param_tab> ASSIGNING <ls_param>.
      <ls_param> = CORRESPONDING #( DEEP <ls_po_message> ).
    ENDLOOP.

    APPEND INITIAL LINE TO ct_operation_package ASSIGNING FIELD-SYMBOL(<ls_operation>).
    <ls_operation>-op          = if_abap_behv=>op-m-action.
    <ls_operation>-entity_name = is_channel_assignments-businessobjectentity.
    <ls_operation>-sub_name    = is_channel_assignments-businessobjectaction.
    <ls_operation>-instances   = lr_data.

  ENDMETHOD.

  METHOD get_deadletter_route.
    SELECT *
    FROM zchannelrouteassignment
    WHERE channel = @zpru_if_purc_order=>gcs_channel-po_order
    AND   route   = @zpru_if_purc_order=>gcs_po_route-simple_router-dead_letter
    INTO TABLE @DATA(lt_process_deadletter_route).

    rs_deadletter_route =  VALUE #( lt_process_deadletter_route[ 1 ] OPTIONAL ).
  ENDMETHOD.

  METHOD get_invalid_message_route.
    SELECT *
    FROM zchannelrouteassignment
    WHERE channel = @zpru_if_purc_order=>gcs_channel-po_order
    AND   route   = @zpru_if_purc_order=>gcs_po_route-simple_router-invalid_message
    INTO TABLE @DATA(lt_invalid_message_route).

    rs_invalid_message_route =  VALUE #( lt_invalid_message_route[ 1 ] OPTIONAL ).
  ENDMETHOD.


  METHOD validate_channel_assignments.

    CLEAR: et_valid_assignments.

    DATA(lv_simple_route_count) = 0.
    LOOP AT it_channel_assignments TRANSPORTING NO FIELDS
     WHERE channel = zpru_if_purc_order=>gcs_channel-po_order AND
           route   = iv_simple_route.
      lv_simple_route_count += 1.
    ENDLOOP.

    IF sy-subrc <> 0 OR lv_simple_route_count > 1.
      RETURN.
    ENDIF.

    ASSIGN it_channel_assignments[
        channel = zpru_if_purc_order=>gcs_channel-po_order
        route   = iv_simple_route ] TO FIELD-SYMBOL(<ls_source_assignment>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    APPEND INITIAL LINE TO et_valid_assignments ASSIGNING FIELD-SYMBOL(<ls_target_assignment>).
    <ls_target_assignment> =  <ls_source_assignment>.

  ENDMETHOD.

ENDCLASS.
