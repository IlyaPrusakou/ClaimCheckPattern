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
  ENDMETHOD.

  METHOD processdeadletter.
  ENDMETHOD.

  METHOD processinvalidmessage.
  ENDMETHOD.

ENDCLASS.
