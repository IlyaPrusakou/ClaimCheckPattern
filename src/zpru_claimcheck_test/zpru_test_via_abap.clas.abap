CLASS zpru_test_via_abap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpru_test_via_abap IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

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

ENDCLASS.
