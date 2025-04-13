INTERFACE zpru_if_purc_order
  PUBLIC.
  TYPES: ts_purc_order_message TYPE STRUCTURE FOR HIERARCHY zpurcmessageheader\\messageheader.
  TYPES: tt_purc_order_message TYPE TABLE FOR HIERARCHY zpurcmessageheader\\messageheader.
  TYPES: tt_channel_assignments TYPE STANDARD TABLE OF zchannelrouteassignment WITH EMPTY KEY.
  TYPES: tt_processinvalidmessage TYPE TABLE FOR ACTION IMPORT zchannelpersistencetp\\channelpersistence~processinvalidmessage.
  TYPES: ts_processinvalidmessage TYPE STRUCTURE FOR ACTION IMPORT zchannelpersistencetp\\channelpersistence~processinvalidmessage.
  TYPES: tt_supplier_id TYPE RANGE OF char10.

  CONSTANTS: BEGIN OF gcs_po_status,
               pending_approval TYPE char1 VALUE `P`,
               approved         TYPE char1 VALUE `A`,
             END OF gcs_po_status.

  CONSTANTS: BEGIN OF gcs_po_payment_terms,
               net30   TYPE char1 VALUE `A`,
               net45   TYPE char1 VALUE `B`,
               cod     TYPE char1 VALUE `C`,
               prepaid TYPE char1 VALUE `D`,
               eom60   TYPE char1 VALUE `E`,
             END OF gcs_po_payment_terms.

  CONSTANTS: BEGIN OF gcs_channel,
               po_order TYPE char2 VALUE `PO`,
             END OF gcs_channel.

  CONSTANTS: BEGIN OF gcs_po_route,
               BEGIN OF simple_router,
                 approval_request TYPE char3 VALUE `APR`,
               END OF simple_router,
               BEGIN OF payment_terms,
                 prepaid TYPE char3 VALUE `PRP`,
                 other   TYPE char3 VALUE `OTH`,
               END OF payment_terms,
             END OF gcs_po_route.

  CONSTANTS: BEGIN OF gcs_bdef_name,
               invoice          TYPE abp_entity_name VALUE `ZINVOICEHEADERPROJ`,
               good_receipt     TYPE abp_entity_name VALUE `ZGOODRECEIPTPROJ`,
               approval_request TYPE abp_entity_name VALUE `ZAPPROVALREQUESTPROJ`,
               message_store    TYPE abp_entity_name VALUE `ZCHANNELPERSISTENCEPROJ`,
             END OF gcs_bdef_name.

  CONSTANTS: BEGIN OF gcs_entity_name,
               invoice          TYPE abp_entity_name VALUE `ZINVOICEHEADERPROJ`,
               good_receipt     TYPE abp_entity_name VALUE `ZGOODRECEIPTPROJ`,
               approval_request TYPE abp_entity_name VALUE `ZAPPROVALREQUESTPROJ`,
               message_store    TYPE abp_entity_name VALUE `ZCHANNELPERSISTENCEPROJ`,
             END OF gcs_entity_name.

  CONSTANTS: BEGIN OF gcs_action_reciver,
               onpurchaseordercreate TYPE char30 VALUE `ONPURCHASEORDERCREATE`,
               persistmessage        TYPE char30 VALUE `PERSISTMESSAGE`,
               processinvalidmessage TYPE char30 VALUE `PROCESSINVALIDMESSAGE`,
               processdeadletter     TYPE char30 VALUE `PROCESSDEADLETTER`,
             END OF gcs_action_reciver.

ENDINTERFACE.
