INTERFACE zpru_if_purc_order
  PUBLIC .
  TYPES: ts_purc_order_messsage TYPE STRUCTURE FOR HIERARCHY zpurcmessageheader\\messageheader.
  TYPES: tt_purc_order_messsage TYPE TABLE FOR HIERARCHY zpurcmessageheader\\messageheader.
ENDINTERFACE.
