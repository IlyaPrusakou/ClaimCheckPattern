CLASS lsc_zinvoiceheadertp DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zinvoiceheadertp IMPLEMENTATION.

  METHOD save_modified.
    DATA(lv_invoice) = 1.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CLASS-DATA: mv_last_id TYPE i.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR invoice RESULT result.

    METHODS onpurchaseordercreate FOR MODIFY
      IMPORTING keys FOR ACTION invoice~onpurchaseordercreate.

ENDCLASS.

CLASS lhc_invoice IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD onpurchaseordercreate.

    DATA: lt_invoice_create TYPE TABLE FOR CREATE zinvoiceheadertp.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT invoiceid
    FROM zinvoiceheader
    ORDER BY invoiceid DESCENDING
    INTO @DATA(lv_last_id) UP TO 1 ROWS.
      IF sy-subrc <> 0.
        lv_last_id = 0.
      ENDIF.
    ENDSELECT.

    IF lhc_invoice=>mv_last_id > lv_last_id.
      lv_last_id = lhc_invoice=>mv_last_id.
    ENDIF.


    lv_last_id = |{ lv_last_id ALPHA = OUT }|.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_input>).
      LOOP AT <ls_input>-%param ASSIGNING FIELD-SYMBOL(<ls_param>).
        APPEND INITIAL LINE TO lt_invoice_create ASSIGNING FIELD-SYMBOL(<ls_create>).
        <ls_create>-%cid                   = |{ <ls_input>-%cid }_{ sy-tabix }|.
        lv_last_id += 1.
        <ls_create>-invoiceid              = |{ lv_last_id ALPHA = IN }|.
        <ls_create>-purchaseorderid        = <ls_param>-header-purchaseorderid.
        <ls_create>-%data-invoicedate      = <ls_param>-header-orderdate.
        <ls_create>-%data-controltimestamp = <ls_param>-timestamp.
        lhc_invoice=>mv_last_id = lv_last_id.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zinvoiceheadertp
    IN LOCAL MODE
    ENTITY invoice
    CREATE FIELDS ( invoiceid purchaseorderid invoicedate controltimestamp )
    WITH  lt_invoice_create.

  ENDMETHOD.

ENDCLASS.
