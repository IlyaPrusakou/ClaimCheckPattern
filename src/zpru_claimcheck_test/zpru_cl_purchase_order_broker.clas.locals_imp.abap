CLASS lcl_channel DEFINITION.
  PUBLIC SECTION.

    METHODS filter_by_supplier_id
      EXPORTING
        et_po_invalidated TYPE zpru_if_purc_order=>tt_purc_order_messsage
      CHANGING
        ct_po_approved    TYPE zpru_if_purc_order=>tt_purc_order_messsage
        ct_po_pending     TYPE zpru_if_purc_order=>tt_purc_order_messsage.

    METHODS send_2_invalid_message_channel
      IMPORTING
        it_po_invalidated TYPE zpru_if_purc_order=>tt_purc_order_messsage   .


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_router DEFINITION.
  PUBLIC SECTION.
    METHODS split_po_by_status
      IMPORTING
        it_purc_order_messsage TYPE zpru_if_purc_order=>tt_purc_order_messsage
      EXPORTING
        et_po_approved         TYPE zpru_if_purc_order=>tt_purc_order_messsage
        et_po_pending          TYPE zpru_if_purc_order=>tt_purc_order_messsage.

   methods route_approved_po_paymentterms.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_local_event_consumption DEFINITION INHERITING FROM cl_abap_behavior_event_handler.
  PRIVATE SECTION.
    METHODS on_order_created FOR ENTITY EVENT it_purchase_order FOR purchaseorder~ordercreated.
ENDCLASS.

CLASS lcl_local_event_consumption IMPLEMENTATION.
  METHOD on_order_created.

    DATA(lo_channel) = NEW lcl_channel( ).
    DATA(lo_router)  = NEW lcl_router( ).

    " Splitter pattern
    lo_router->split_po_by_status(
      EXPORTING
        it_purc_order_messsage = CORRESPONDING #( it_purchase_order )
      IMPORTING
        et_po_approved         = DATA(lt_po_approved)
        et_po_pending          = DATA(lt_po_pending) ).

    " Message Filter pattern
    lo_channel->filter_by_supplier_id(
      IMPORTING
        et_po_invalidated = DATA(lt_po_invalidated)
      CHANGING
        ct_po_approved    = lt_po_approved
        ct_po_pending     = lt_po_pending ).

    IF lt_po_invalidated IS NOT INITIAL.
      " Invalid Message Channel pattern
      lo_channel->send_2_invalid_message_channel(
        EXPORTING
            it_po_invalidated = lt_po_invalidated ).
    ENDIF.

    " Content-Based Router pattern


  ENDMETHOD.

ENDCLASS.

CLASS lcl_channel IMPLEMENTATION.

  METHOD filter_by_supplier_id.

  ENDMETHOD.

  METHOD send_2_invalid_message_channel.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_router IMPLEMENTATION.
  METHOD split_po_by_status.

  ENDMETHOD.
  METHOD route_approved_po_paymentterms.

  ENDMETHOD.

ENDCLASS.
