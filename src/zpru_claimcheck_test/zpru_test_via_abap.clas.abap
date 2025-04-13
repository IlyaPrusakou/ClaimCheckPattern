CLASS zpru_test_via_abap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS test_raise.
    METHODS test_dyn_eml.
    METHODS insert_routes.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpru_test_via_abap IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    insert_routes( ).

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
                           action    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate )
                         ( channel = zpru_if_purc_order=>gcs_channel-po_order
                           route     = zpru_if_purc_order=>gcs_po_route-payment_terms-other
                           bdef      = zpru_if_purc_order=>gcs_bdef_name-invoice
                           entity    = zpru_if_purc_order=>gcs_entity_name-invoice
                           action    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate )
                         ( channel   = zpru_if_purc_order=>gcs_channel-po_order
                           route     = zpru_if_purc_order=>gcs_po_route-simple_router-approval_request
                           bdef      = zpru_if_purc_order=>gcs_bdef_name-approval_request
                           entity    = zpru_if_purc_order=>gcs_entity_name-approval_request
                           action    = zpru_if_purc_order=>gcs_action_reciver-onpurchaseordercreate ) ).

    INSERT zpru_chnl_assgmt FROM TABLE @lt_routes.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
