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

    DATA: lt_invoice_create TYPE TABLE FOR CREATE zinvoiceheaderproj.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT invoiceid
    FROM zinvoiceheader
    ORDER BY invoiceid DESCENDING
    INTO @DATA(lv_last_id) UP TO 1 ROWS .
      IF sy-subrc <> 0.
        lv_last_id = 0.
      ENDIF.

    ENDSELECT.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_input>).

      LOOP AT <ls_input>-%param ASSIGNING FIELD-SYMBOL(<ls_param>).
        APPEND INITIAL LINE TO lt_invoice_create ASSIGNING FIELD-SYMBOL(<ls_create>).
        <ls_create>-%cid = <ls_input>-%cid.
        <ls_create>-invoiceid = lv_last_id + 1.
        <ls_create>-purchaseorderid = <ls_param>-header-purchaseorderid.
      ENDLOOP.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
