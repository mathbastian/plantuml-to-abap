INTERFACE lif_object DEFERRED.

INTERFACE lif_method.
  INTERFACES lif_source_code_getter.
  TYPES ty_t_methods TYPE STANDARD TABLE OF REF TO lif_method WITH DEFAULT KEY.
  DATA mo_visibility TYPE REF TO lce_token.
  DATA mo_type       TYPE REF TO lce_token.
  DATA mv_name       TYPE string.
  DATA mo_object     TYPE REF TO lif_object.
  METHODS add_importing_parameter
    IMPORTING
      iv_name TYPE string
      iv_type TYPE string.
  METHODS add_returning_parameter IMPORTING iv_type TYPE string.
ENDINTERFACE.
