CLASS lsc_zchannelpersistencetp DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zchannelpersistencetp IMPLEMENTATION.

  METHOD save_modified.
    DATA(lv_persist) = 1.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_channelpersistence DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR channelpersistence RESULT result.

    METHODS persistmessage FOR MODIFY
      IMPORTING keys FOR ACTION channelpersistence~persistmessage.

    METHODS processdeadletter FOR MODIFY
      IMPORTING keys FOR ACTION channelpersistence~processdeadletter.

    METHODS processinvalidmessage FOR MODIFY
      IMPORTING keys FOR ACTION channelpersistence~processinvalidmessage.

ENDCLASS.

CLASS lhc_channelpersistence IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD persistmessage.
    DATA: lt_approval_create TYPE TABLE FOR CREATE zchannelpersistencetp.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT persistencyid
    FROM zchannelpersistence
    ORDER BY persistencyid DESCENDING
    INTO @DATA(lv_last_id) UP TO 1 ROWS.
      IF sy-subrc <> 0.
        lv_last_id = 0.
      ENDIF.
    ENDSELECT.

    lv_last_id = |{ lv_last_id ALPHA = OUT }|.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_input>).
      LOOP AT <ls_input>-%param ASSIGNING FIELD-SYMBOL(<ls_param>).
        APPEND INITIAL LINE TO lt_approval_create ASSIGNING FIELD-SYMBOL(<ls_create>).
        <ls_create>-%cid            = |{ <ls_input>-%cid }_{ sy-tabix }|.
        lv_last_id += 1.
        <ls_create>-persistencyid   = |{ lv_last_id ALPHA = IN }|.
        <ls_create>-%data-messageid = <ls_param>-messageid.
        <ls_create>-purchaseorderid = <ls_param>-header-purchaseorderid.
        <ls_create>-%data-orderdate = <ls_param>-header-orderdate.
        <ls_create>-%data-status    = zpru_if_purc_order=>gcs_storage_type-persist_message.
        <ls_create>-%data-controltimestamp = <ls_param>-timestamp.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zchannelpersistencetp
    IN LOCAL MODE
    ENTITY channelpersistence
    CREATE FIELDS ( persistencyid
                    messageid
                    purchaseorderid
                    orderdate
                    status
                    controltimestamp )
    WITH lt_approval_create.
  ENDMETHOD.

  METHOD processdeadletter.
    DATA: lt_approval_create TYPE TABLE FOR CREATE zchannelpersistencetp.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT persistencyid
    FROM zchannelpersistence
    ORDER BY persistencyid DESCENDING
    INTO @DATA(lv_last_id) UP TO 1 ROWS.
      IF sy-subrc <> 0.
        lv_last_id = 0.
      ENDIF.
    ENDSELECT.

    lv_last_id = |{ lv_last_id ALPHA = OUT }|.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_input>).
      LOOP AT <ls_input>-%param ASSIGNING FIELD-SYMBOL(<ls_param>).
        APPEND INITIAL LINE TO lt_approval_create ASSIGNING FIELD-SYMBOL(<ls_create>).
        <ls_create>-%cid            = |{ <ls_input>-%cid }_{ sy-tabix }|.
        lv_last_id += 1.
        <ls_create>-persistencyid   = |{ lv_last_id ALPHA = IN }|.
        <ls_create>-%data-messageid = <ls_param>-messageid.
        <ls_create>-purchaseorderid = <ls_param>-header-purchaseorderid.
        <ls_create>-%data-orderdate = <ls_param>-header-orderdate.
        <ls_create>-%data-status    = zpru_if_purc_order=>gcs_storage_type-dead_letter.
        <ls_create>-%data-controltimestamp = <ls_param>-timestamp.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zchannelpersistencetp
    IN LOCAL MODE
    ENTITY channelpersistence
    CREATE FIELDS ( persistencyid
                    messageid
                    purchaseorderid
                    orderdate
                    status
                    controltimestamp )
    WITH lt_approval_create.

  ENDMETHOD.

  METHOD processinvalidmessage.
    DATA: lt_approval_create TYPE TABLE FOR CREATE zchannelpersistencetp.

    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    SELECT persistencyid
    FROM zchannelpersistence
    ORDER BY persistencyid DESCENDING
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
        <ls_create>-persistencyid          = |{ lv_last_id ALPHA = IN }|.
        <ls_create>-%data-messageid        = <ls_param>-messageid.
        <ls_create>-purchaseorderid        = <ls_param>-header-purchaseorderid.
        <ls_create>-%data-orderdate        = <ls_param>-header-orderdate.
        <ls_create>-%data-status           = zpru_if_purc_order=>gcs_storage_type-invalide_message.
        <ls_create>-%data-controltimestamp = <ls_param>-timestamp.
      ENDLOOP.
    ENDLOOP.

    MODIFY ENTITIES OF zchannelpersistencetp
    IN LOCAL MODE
    ENTITY channelpersistence
    CREATE FIELDS ( persistencyid
                    messageid
                    purchaseorderid
                    orderdate
                    status
                    controltimestamp )
    WITH lt_approval_create.
  ENDMETHOD.

ENDCLASS.
