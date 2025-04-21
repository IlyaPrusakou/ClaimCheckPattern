CLASS zpru_test_via_abap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS test_raise.
    METHODS test_dyn_eml.
    METHODS insert_routes.
    METHODS test_event_pipeline.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpru_test_via_abap IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    test_event_pipeline( ).

  ENDMETHOD.

  METHOD test_event_pipeline.


    DATA: lt_po_create TYPE TABLE FOR CREATE zpurcorderhdrproj.
    DATA: lv_timestamp  TYPE timestampl,
          lv_local_date TYPE d,
          lv_local_time TYPE t,
          lv_time_zone  TYPE cl_abap_context_info=>ty_time_zone.

*    DELETE FROM zapproval_reqst.
*    IF sy-subrc = 0.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*    DELETE FROM zgr_receipt_head.
*    IF sy-subrc = 0.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*    DELETE FROM zinvoice_header.
*    IF sy-subrc = 0.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*    DELETE FROM zpru_chnl_store.
*    IF sy-subrc = 0.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*    DELETE FROM zpurc_order_hdr.
*    IF sy-subrc = 0.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*
*    DELETE FROM zpurc_order_item.
*    IF sy-subrc = 0.
*      COMMIT WORK AND WAIT.
*    ELSE.
*      ROLLBACK WORK.
*    ENDIF.
*    RETURN.
    lv_local_date = cl_abap_context_info=>get_system_date( ).
    lv_local_time = cl_abap_context_info=>get_system_time( ).
    TRY.
        lv_time_zone = cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
        lv_time_zone = `UTC`.
    ENDTRY.

    CONVERT DATE lv_local_date TIME lv_local_time
      INTO TIME STAMP lv_timestamp TIME ZONE lv_time_zone.

    SELECT purchaseorderid
    FROM zpurcorderhdr
    ORDER BY    purchaseorderid DESCENDING
    INTO @DATA(lv_last_id) UP TO 1 ROWS.
      IF sy-subrc <> 0.
        lv_last_id = 0.
      ENDIF.
    ENDSELECT.

    lv_last_id = |{ lv_last_id ALPHA = OUT }|.

    APPEND INITIAL LINE TO lt_po_create ASSIGNING FIELD-SYMBOL(<ls_po>).
    " invalide bcz value supplier id
    lv_last_id += 1.
    <ls_po>-%cid            = lv_last_id.
    <ls_po>-purchaseorderid = |{ lv_last_id ALPHA = IN }|.
    <ls_po>-orderdate       = lv_local_date.
    <ls_po>-supplierid      = `SUP001`.
    <ls_po>-suppliername    = `Global Supplies Ltd.`.
    <ls_po>-buyerid         = `BUY101`.
    <ls_po>-buyername       = `Acme Industries`.
    <ls_po>-totalamount     = `100.00`.
    <ls_po>-headercurrency  = 'USD'.
    <ls_po>-deliverydate    = lv_local_date.
    <ls_po>-status          = zpru_if_purc_order=>gcs_po_status-approved.
    <ls_po>-paymentterms    = zpru_if_purc_order=>gcs_po_payment_terms-prepaid.
    <ls_po>-shippingmethod  = `Freight Shipping`.
    <ls_po>-controltimestamp = lv_timestamp.

    APPEND INITIAL LINE TO lt_po_create ASSIGNING <ls_po>.
    " valid prepaid APPROVED
    lv_last_id += 1.
    <ls_po>-%cid            = lv_last_id.
    <ls_po>-purchaseorderid = |{ lv_last_id ALPHA = IN }|.
    <ls_po>-orderdate       = lv_local_date.
    <ls_po>-supplierid      = `SUP002`.
    <ls_po>-suppliername    = `Acme Components Inc.`.
    <ls_po>-buyerid         = `BUY101`.
    <ls_po>-buyername       = `Acme Industries`.
    <ls_po>-totalamount     = `100.00`.
    <ls_po>-headercurrency  = 'USD'.
    <ls_po>-deliverydate    = lv_local_date.
    <ls_po>-status          = zpru_if_purc_order=>gcs_po_status-approved.
    <ls_po>-paymentterms    = zpru_if_purc_order=>gcs_po_payment_terms-prepaid.
    <ls_po>-shippingmethod  = `Freight Shipping`.
    <ls_po>-controltimestamp = lv_timestamp.

    APPEND INITIAL LINE TO lt_po_create ASSIGNING <ls_po>.
    " valid prepaid pending
    lv_last_id += 1.
    <ls_po>-%cid            = lv_last_id.
    <ls_po>-purchaseorderid = |{ lv_last_id ALPHA = IN }|.
    <ls_po>-orderdate       = lv_local_date.
    <ls_po>-supplierid      = `SUP002`.
    <ls_po>-suppliername    = `Acme Components Inc.`.
    <ls_po>-buyerid         = `BUY101`.
    <ls_po>-buyername       = `Acme Industries`.
    <ls_po>-totalamount     = `100.00`.
    <ls_po>-headercurrency  = 'USD'.
    <ls_po>-deliverydate    = lv_local_date.
    <ls_po>-status          = zpru_if_purc_order=>gcs_po_status-pending_approval.
    <ls_po>-paymentterms    = zpru_if_purc_order=>gcs_po_payment_terms-prepaid.
    <ls_po>-shippingmethod  = `Freight Shipping`.
    <ls_po>-controltimestamp = lv_timestamp.

    APPEND INITIAL LINE TO lt_po_create ASSIGNING <ls_po>.
    " valid postpaid APPROVED
    lv_last_id += 1.
    <ls_po>-%cid            = lv_last_id.
    <ls_po>-purchaseorderid = |{ lv_last_id ALPHA = IN }|.
    <ls_po>-orderdate       = lv_local_date.
    <ls_po>-supplierid      = `SUP002`.
    <ls_po>-suppliername    = `Acme Components Inc.`.
    <ls_po>-buyerid         = `BUY101`.
    <ls_po>-buyername       = `Acme Industries`.
    <ls_po>-totalamount     = `100.00`.
    <ls_po>-headercurrency  = 'USD'.
    <ls_po>-deliverydate    = lv_local_date.
    <ls_po>-status          = zpru_if_purc_order=>gcs_po_status-approved.
    <ls_po>-paymentterms    = zpru_if_purc_order=>gcs_po_payment_terms-eom60.
    <ls_po>-shippingmethod  = `Freight Shipping`.
    <ls_po>-controltimestamp = lv_timestamp.

    APPEND INITIAL LINE TO lt_po_create ASSIGNING <ls_po>.
    " valid postpaid APPROVED fall into dead letter bcz wrong payment terms
    lv_last_id += 1.
    <ls_po>-%cid            = lv_last_id.
    <ls_po>-purchaseorderid = |{ lv_last_id ALPHA = IN }|.
    <ls_po>-orderdate       = lv_local_date.
    <ls_po>-supplierid      = `SUP002`.
    <ls_po>-suppliername    = `Acme Components Inc.`.
    <ls_po>-buyerid         = `BUY101`.
    <ls_po>-buyername       = `Acme Industries`.
    <ls_po>-totalamount     = `100.00`.
    <ls_po>-headercurrency  = 'USD'.
    <ls_po>-deliverydate    = lv_local_date.
    <ls_po>-status          = zpru_if_purc_order=>gcs_po_status-approved.
    <ls_po>-paymentterms    = `ERR`.
    <ls_po>-shippingmethod  = `Freight Shipping`.
    <ls_po>-controltimestamp = lv_timestamp.

    APPEND INITIAL LINE TO lt_po_create ASSIGNING <ls_po>.
    lv_last_id += 1.
    <ls_po>-%cid            = lv_last_id.
    <ls_po>-purchaseorderid = |{ lv_last_id ALPHA = IN }|.
    <ls_po>-orderdate       = lv_local_date.
    <ls_po>-supplierid      = `SUP005`.
    <ls_po>-suppliername    = `Universal Manufacturing Co.`.
    <ls_po>-buyerid         = `BUY505`.
    <ls_po>-buyername       = `Apex Innovations`.
    <ls_po>-totalamount     = `100.00`.
    <ls_po>-headercurrency  = 'USD'.
    <ls_po>-deliverydate    = lv_local_date.
    <ls_po>-status          = zpru_if_purc_order=>gcs_po_status-processed. " there is no route for this status
    <ls_po>-paymentterms    = zpru_if_purc_order=>gcs_po_payment_terms-eom60.
    <ls_po>-shippingmethod  = `Freight Shipping`.
    <ls_po>-controltimestamp = lv_timestamp.

    APPEND INITIAL LINE TO lt_po_create ASSIGNING <ls_po>.
    lv_last_id += 1.
    <ls_po>-%cid            = lv_last_id.
    <ls_po>-purchaseorderid = |{ lv_last_id ALPHA = IN }|.
    <ls_po>-orderdate       = lv_local_date.
    <ls_po>-supplierid      = `SUP003`. " will be invalid
    <ls_po>-suppliername    = `Prime Industrial Solutions`.
    <ls_po>-buyerid         = `BUY303`.
    <ls_po>-buyername       = `Orion Tech Corp`.
    <ls_po>-totalamount     = `100.00`.
    <ls_po>-headercurrency  = 'USD'.
    <ls_po>-deliverydate    = lv_local_date.
    <ls_po>-status          = zpru_if_purc_order=>gcs_po_status-approved.
    <ls_po>-paymentterms    = zpru_if_purc_order=>gcs_po_payment_terms-eom60.
    <ls_po>-shippingmethod  = `Freight Shipping`.
    <ls_po>-controltimestamp = lv_timestamp.

    MODIFY ENTITIES OF zpurcorderhdrproj
       ENTITY purchaseorder
       CREATE FIELDS (  purchaseorderid
   orderdate
   supplierid
   suppliername
   buyerid
   buyername
   totalamount
   headercurrency
   deliverydate
   status
   paymentterms
   shippingmethod
   controltimestamp ) WITH lt_po_create

       MAPPED DATA(lt_mapped)
       FAILED DATA(ls_failed)
       REPORTED DATA(ls_reported).

    IF ls_failed IS NOT INITIAL.
      ROLLBACK ENTITIES.
      RETURN.
    ENDIF.

    COMMIT ENTITIES
    RESPONSES FAILED DATA(lt_failed_commit)
    REPORTED DATA(lt_reported_commit).

*supplier id
*SUP001
*SUP002
*SUP003
*SUP004
*SUP005

*supplier name
*SUP001 - Global Supplies Ltd.
*SUP002 - Acme Components Inc.
*SUP003 - Prime Industrial Solutions
*SUP004 - Continental Trade Corp.
*SUP005 - Universal Manufacturing Co.


*buyer id
*BUY101
*BUY202
*BUY303
*BUY404
*BUY505

*buyer name
*BUY101: Acme Industries
*BUY202: Stellar Solutions
*BUY303: Orion Tech Corp
*BUY404: Nova Enterprises
*BUY505: Apex Innovations

  ENDMETHOD.

  METHOD test_raise.
    DELETE FROM zpurc_order_hdr.
    DELETE FROM zpurc_order_item.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

    MODIFY ENTITIES OF zpurcorderhdrproj
    ENTITY purchaseorder
    CREATE FROM  VALUE #( ( %cid                 = `1`
                            %key-purchaseorderid = `0000000001`
                            %data-buyername      = 'ILYA1'
                            %control-purchaseorderid = if_abap_behv=>mk-on
                            %control-buyername   = if_abap_behv=>mk-on )
                          ( %cid                 = `2`
                            %key-purchaseorderid = `0000000002`
                            %data-buyername      = 'ILYA2'
                            %control-purchaseorderid = if_abap_behv=>mk-on
                            %control-buyername   = if_abap_behv=>mk-on  )   )
    MAPPED DATA(lt_mapped)
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported).

    IF ls_failed IS NOT INITIAL.
      ROLLBACK ENTITIES.
      RETURN.
    ENDIF.


    MODIFY ENTITIES OF zpurcorderhdrproj
    ENTITY purchaseorder
    CREATE BY \_items FROM VALUE #( ( %key-purchaseorderid = `0000000001`
                                      %target = VALUE #( ( %cid                 = `1_1`
                                                           %key-itemnumber      = 1
                                                           %key-purchaseorderid = `0000000001`
                                                           %data-productname    = 'PROD1'
                                                           %control-itemnumber  = if_abap_behv=>mk-on
                                                           %control-purchaseorderid = if_abap_behv=>mk-on
                                                           %control-productname = if_abap_behv=>mk-on )
                                                         ( %cid                 = `1_2`
                                                           %key-itemnumber      = 2
                                                           %key-purchaseorderid = `0000000001`
                                                           %data-productname    = 'PROD2'
                                                           %control-itemnumber  = if_abap_behv=>mk-on
                                                           %control-purchaseorderid = if_abap_behv=>mk-on
                                                           %control-productname = if_abap_behv=>mk-on ) ) )
                                    ( %key-purchaseorderid = `0000000002`
                                      %target = VALUE #( ( %cid                 = `2_1`
                                                           %key-itemnumber      = 1
                                                           %key-purchaseorderid = `0000000002`
                                                           %data-productname    = 'PROD3'
                                                           %control-itemnumber  = if_abap_behv=>mk-on
                                                           %control-purchaseorderid = if_abap_behv=>mk-on
                                                           %control-productname = if_abap_behv=>mk-on )
                                                         ( %cid                 = `2_2`
                                                           %key-itemnumber      = 2
                                                           %key-purchaseorderid = `0000000002`
                                                           %data-productname    = 'PROD4'
                                                           %control-itemnumber  = if_abap_behv=>mk-on
                                                           %control-purchaseorderid = if_abap_behv=>mk-on
                                                           %control-productname = if_abap_behv=>mk-on ) ) ) )


    MAPPED DATA(lt_mapped_itm)
    FAILED DATA(ls_failed_itm)
    REPORTED DATA(ls_reported_itm).


    IF ls_failed_itm IS NOT INITIAL.
      ROLLBACK ENTITIES.
      RETURN.
    ENDIF.


    COMMIT ENTITIES
    RESPONSES FAILED DATA(lt_failed_commit)
    REPORTED DATA(lt_reported_commit).
  ENDMETHOD.

  METHOD test_dyn_eml.

    DATA: lt_1 TYPE TABLE FOR ACTION IMPORT zinvoiceheadertp\\invoice~onpurchaseordercreate,
          lt_2 TYPE TABLE FOR ACTION IMPORT zinvoiceheaderproj\\invoice~onpurchaseordercreate.


    DATA: lt_operation TYPE abp_behv_changes_tab.
    DATA: ls_failed_dyn   TYPE abp_behv_response_tab,
          ls_reported_dyn TYPE abp_behv_response_tab.

    DATA lr_data TYPE REF TO data.


    FIELD-SYMBOLS: <lt_action_tab> TYPE INDEX TABLE.
    FIELD-SYMBOLS: <lt_param_tab> TYPE zpru_if_purc_order=>tt_purc_order_message.
    FIELD-SYMBOLS: <ls_param> TYPE zpru_if_purc_order=>ts_purc_order_message.

    CREATE DATA lr_data TYPE (`\BDEF=ZINVOICEHEADERPROJ\ENTITY=ZINVOICEHEADERPROJ\ACTION=ONPURCHASEORDERCREATE\TYPE=IMPORTING`).

    ASSIGN lr_data->* TO <lt_action_tab>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    APPEND INITIAL LINE TO <lt_action_tab> ASSIGNING FIELD-SYMBOL(<ls_entry>).
    ASSIGN COMPONENT '%CID' OF STRUCTURE <ls_entry> TO FIELD-SYMBOL(<ls_cid>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    <ls_cid> = `\BDEF=ZINVOICEHEADERPROJ\ENTITY=ZINVOICEHEADERPROJ\ACTION=ONPURCHASEORDERCREATE\TYPE=IMPORTING`.

    ASSIGN COMPONENT '%PARAM' OF STRUCTURE <ls_entry> TO <lt_param_tab>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    APPEND INITIAL LINE TO <lt_param_tab> ASSIGNING <ls_param>.
    <ls_param>-messageid = `1`.


    APPEND INITIAL LINE TO lt_operation ASSIGNING FIELD-SYMBOL(<ls_operation>).
    <ls_operation>-op          = if_abap_behv=>op-m-action.
    <ls_operation>-entity_name = zpru_if_purc_order=>gcs_entity_name-invoice.
    <ls_operation>-sub_name    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate.
    <ls_operation>-instances   = lr_data.

*    CREATE DATA lr_data TYPE (`\BDEF=ZGOODRECEIPTTP\ENTITY=ZGOODRECEIPTTP\ACTION=ONPURCHASEORDERCREATE\TYPE=IMPORTING`).
*
*    ASSIGN lr_data->* TO <lt_action_tab>.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    APPEND INITIAL LINE TO <lt_action_tab> ASSIGNING <ls_entry>.
*    ASSIGN COMPONENT '%CID' OF STRUCTURE <ls_entry> TO <ls_cid>.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    <ls_cid> = `\BDEF=ZGOODRECEIPTTP\ENTITY=ZGOODRECEIPTTP\ACTION=ONPURCHASEORDERCREATE\TYPE=IMPORTING`.
*
*    ASSIGN COMPONENT '%PARAM' OF STRUCTURE <ls_entry> TO <lt_param_tab>.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    APPEND INITIAL LINE TO <lt_param_tab> ASSIGNING <ls_param>.
*    <ls_param>-messageid = `2`.
*
*
*    APPEND INITIAL LINE TO lt_operation ASSIGNING <ls_operation>.
*    <ls_operation>-op          = if_abap_behv=>op-m-action.
*    <ls_operation>-entity_name = `ZGOODRECEIPTTP`. "zpru_if_purc_order=>gcs_entity_name-good_receipt.
*    <ls_operation>-sub_name    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate.
*    <ls_operation>-instances   = lr_data.
*
*    CREATE DATA lr_data TYPE (`\BDEF=ZAPPROVALREQUESTTP\ENTITY=ZAPPROVALREQUESTTP\ACTION=ONPURCHASEORDERCREATE\TYPE=IMPORTING`).
*
*    ASSIGN lr_data->* TO <lt_action_tab>.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    APPEND INITIAL LINE TO <lt_action_tab> ASSIGNING <ls_entry>.
*    ASSIGN COMPONENT '%CID' OF STRUCTURE <ls_entry> TO <ls_cid>.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    <ls_cid> = `\BDEF=ZGOODRECEIPTTP\ENTITY=ZGOODRECEIPTTP\ACTION=ONPURCHASEORDERCREATE\TYPE=IMPORTING`.
*
*    ASSIGN COMPONENT '%PARAM' OF STRUCTURE <ls_entry> TO <lt_param_tab>.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    APPEND INITIAL LINE TO <lt_param_tab> ASSIGNING <ls_param>.
*    <ls_param>-messageid = `3`.
*
*    APPEND INITIAL LINE TO lt_operation ASSIGNING <ls_operation>.
*    <ls_operation>-op          = if_abap_behv=>op-m-action.
*    <ls_operation>-entity_name = `ZAPPROVALREQUESTTP`. "zpru_if_purc_order=>gcs_entity_name-approval_request.
*    <ls_operation>-sub_name    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate.
*    <ls_operation>-instances   = lr_data.

    MODIFY ENTITIES OPERATIONS lt_operation
      FAILED   ls_failed_dyn
      REPORTED ls_reported_dyn.

    DATA(lv_test) = 1.

  ENDMETHOD.

  METHOD insert_routes.

    DATA: lt_routes TYPE STANDARD TABLE OF zpru_chnl_assgmt WITH EMPTY KEY.

    DELETE FROM zpru_chnl_assgmt.
    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

    lt_routes = VALUE #( ( channel   = zpru_if_purc_order=>gcs_channel-po_order
                           route     = zpru_if_purc_order=>gcs_po_route-payment_terms-prepaid
                           bdef      = zpru_if_purc_order=>gcs_bdef_name-good_receipt
                           entity    = zpru_if_purc_order=>gcs_entity_name-good_receipt
                           action    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate
                           description = 'Route for Prepaid Terms' )
                         ( channel = zpru_if_purc_order=>gcs_channel-po_order
                           route     = zpru_if_purc_order=>gcs_po_route-payment_terms-other
                           bdef      = zpru_if_purc_order=>gcs_bdef_name-invoice
                           entity    = zpru_if_purc_order=>gcs_entity_name-invoice
                           action    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate
                           description = 'Route for Other Payment Terms' )
                         ( channel   = zpru_if_purc_order=>gcs_channel-po_order
                           route     = zpru_if_purc_order=>gcs_po_route-simple_router-approval_request
                           bdef      = zpru_if_purc_order=>gcs_bdef_name-approval_request
                           entity    = zpru_if_purc_order=>gcs_entity_name-approval_request
                           action    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate
                           description = 'Route for Creation of Approval Request' )
                         ( channel   = zpru_if_purc_order=>gcs_channel-po_order
                           route     = zpru_if_purc_order=>gcs_po_route-simple_router-dead_letter
                           bdef      = zpru_if_purc_order=>gcs_bdef_name-message_store
                           entity    = zpru_if_purc_order=>gcs_entity_name-message_store
                           action    = zpru_if_purc_order=>gcs_action_reciver-processdeadletter
                           description = 'Route for Dead Letter Queue' )
                         ( channel   = zpru_if_purc_order=>gcs_channel-po_order
                           route     = zpru_if_purc_order=>gcs_po_route-simple_router-invalid_message
                           bdef      = zpru_if_purc_order=>gcs_bdef_name-message_store
                           entity    = zpru_if_purc_order=>gcs_entity_name-message_store
                           action    = zpru_if_purc_order=>gcs_action_reciver-processinvalidmessage
                           description = 'Route for Invalide Message Queue' ) ).

    INSERT zpru_chnl_assgmt FROM TABLE @lt_routes.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
