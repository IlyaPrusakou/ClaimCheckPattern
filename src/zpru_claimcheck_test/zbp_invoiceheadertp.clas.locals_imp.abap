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

    lv_last_id = |{ lv_last_id ALPHA = OUT }|.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_input>).
      LOOP AT <ls_input>-%param ASSIGNING FIELD-SYMBOL(<ls_param>).
        APPEND INITIAL LINE TO lt_invoice_create ASSIGNING FIELD-SYMBOL(<ls_create>).
        <ls_create>-%cid              = <ls_input>-%cid.
        lv_last_id += 1.
        <ls_create>-invoiceid         = |{ lv_last_id ALPHA = IN }|.
        <ls_create>-purchaseorderid   = <ls_param>-header-purchaseorderid.
        <ls_create>-%data-invoicedate = <ls_param>-header-orderdate.
        <ls_create>-%data-controltimestamp = <ls_param>-timestamp.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zinvoiceheadertp
    IN LOCAL MODE
    ENTITY invoice
    CREATE FIELDS ( invoiceid purchaseorderid invoicedate controltimestamp )
    WITH  lt_invoice_create.

  ENDMETHOD.

ENDCLASS.
