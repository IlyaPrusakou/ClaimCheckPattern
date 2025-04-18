CLASS lhc_goodreceipt DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR goodreceipt RESULT result.

    METHODS onpurchaseordercreate FOR MODIFY
      IMPORTING keys FOR ACTION goodreceipt~onpurchaseordercreate.

ENDCLASS.

CLASS lhc_goodreceipt IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD onpurchaseordercreate.
    DATA: lt_good_receipt_create TYPE TABLE FOR CREATE zgoodreceipttp.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT  goodsreceiptid
    FROM zgoodreceipt
    ORDER BY goodsreceiptid DESCENDING
    INTO @DATA(lv_last_id) UP TO 1 ROWS.
      IF sy-subrc <> 0.
        lv_last_id = 0.
      ENDIF.
    ENDSELECT.

    lv_last_id = |{ lv_last_id ALPHA = OUT }|.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_input>).
      LOOP AT <ls_input>-%param ASSIGNING FIELD-SYMBOL(<ls_param>).
        APPEND INITIAL LINE TO lt_good_receipt_create ASSIGNING FIELD-SYMBOL(<ls_create>).
        <ls_create>-%cid            = <ls_input>-%cid.
        lv_last_id += 1.
        <ls_create>-goodsreceiptid       = |{ lv_last_id ALPHA = IN }|.
        <ls_create>-purchaseorderid = <ls_param>-header-purchaseorderid.
        <ls_create>-%data-receiptdate = <ls_param>-header-orderdate.
        <ls_create>-%data-controltimestamp = <ls_param>-timestamp.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zgoodreceipttp
    IN LOCAL MODE
    ENTITY goodreceipt
    CREATE FIELDS ( goodsreceiptid
                    purchaseorderid
                    receiptdate
                    controltimestamp )
    WITH lt_good_receipt_create.

  ENDMETHOD.

ENDCLASS.
