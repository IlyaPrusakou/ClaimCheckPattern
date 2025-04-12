CLASS lcl_local_event_consumption DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS on_order_created FOR ENTITY EVENT it_purchase_order FOR purchaseorder~ordercreated.
ENDCLASS.

CLASS lcl_local_event_consumption IMPLEMENTATION.
  METHOD on_order_created.

    DATA: lt_purchase_order TYPE zpru_if_purc_order=>tt_purc_order_messsage.

    LOOP AT it_purchase_order ASSIGNING FIELD-SYMBOL(<ls_input>).
      APPEND INITIAL LINE TO  lt_purchase_order ASSIGNING FIELD-SYMBOL(<ls_purchase_order>).
      <ls_purchase_order> = <ls_input>-%param.
    ENDLOOP.

    DATA(lv_test) = VALUE #( it_purchase_order[ 1 ]-%param-header-purchaseorderid OPTIONAL ).

  ENDMETHOD.

ENDCLASS.
