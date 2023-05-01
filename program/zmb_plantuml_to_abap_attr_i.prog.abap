INTERFACE lif_attribute.
  TYPES ty_t_attributes TYPE STANDARD TABLE OF REF TO lif_attribute WITH DEFAULT KEY.
  INTERFACES lif_source_code_getter.
  DATA mo_visibility TYPE REF TO lce_token.
ENDINTERFACE.
