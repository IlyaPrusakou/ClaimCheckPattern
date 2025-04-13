INTERFACE zpru_if_purc_order
  PUBLIC.
  TYPES: ts_purc_order_messsage TYPE STRUCTURE FOR HIERARCHY zpurcmessageheader\\messageheader.
  TYPES: tt_purc_order_messsage TYPE TABLE FOR HIERARCHY zpurcmessageheader\\messageheader.

  CONSTANTS: BEGIN OF gcs_po_status,
               pending_approval TYPE char1 VALUE `P`,
               approval         TYPE char1 VALUE `A`,
             END OF gcs_po_status.

  CONSTANTS: BEGIN OF gcs_po_payment_terms,
               net30   TYPE char1 VALUE `A`,
               net45   TYPE char1 VALUE `B`,
               cod     TYPE char1 VALUE `C`,
               prepaid TYPE char1 VALUE `D`,
               eom60   TYPE char1 VALUE `E`,
             END OF gcs_po_payment_terms.

ENDINTERFACE.
