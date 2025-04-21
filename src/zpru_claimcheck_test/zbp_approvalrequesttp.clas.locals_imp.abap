CLASS lsc_zapprovalrequesttp DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zapprovalrequesttp IMPLEMENTATION.

  METHOD save_modified.
    DATA(lv_approve) = 1.
  ENDMETHOD.

ENDCLASS.

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

    DATA: lt_approval_create TYPE TABLE FOR CREATE zapprovalrequesttp.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT  approvalrequestid
    FROM zapprovalrequest
    ORDER BY approvalrequestid DESCENDING
    INTO @DATA(lv_last_id) UP TO 1 ROWS.
      IF sy-subrc <> 0.
        lv_last_id = 0.
      ENDIF.
    ENDSELECT.

    lv_last_id = |{ lv_last_id ALPHA = OUT }|.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_input>).
      LOOP AT <ls_input>-%param ASSIGNING FIELD-SYMBOL(<ls_param>).
        APPEND INITIAL LINE TO lt_approval_create ASSIGNING FIELD-SYMBOL(<ls_create>).
        <ls_create>-%cid                   = |{ <ls_input>-%cid }_{ sy-tabix }|.
        lv_last_id += 1.
        <ls_create>-approvalrequestid      = |{ lv_last_id ALPHA = IN }|.
        <ls_create>-purchaseorderid        = <ls_param>-header-purchaseorderid.
        <ls_create>-%data-requestdate      = <ls_param>-header-orderdate.
        <ls_create>-%data-controltimestamp = <ls_param>-timestamp.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zapprovalrequesttp
    IN LOCAL MODE
    ENTITY approvalrequest
    CREATE FIELDS ( approvalrequestid
                    purchaseorderid
                    requestdate
                    controltimestamp )
    WITH lt_approval_create.

  ENDMETHOD.

ENDCLASS.
