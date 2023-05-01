INTERFACE lif_uml_events.
  CLASS-EVENTS class          EXPORTING VALUE(iv_name) TYPE string VALUE(iv_is_abstract) TYPE abap_bool.
  CLASS-EVENTS inheritance    EXPORTING VALUE(iv_super_class_name) TYPE string.
  CLASS-EVENTS implementation EXPORTING VALUE(iv_interface_name)   TYPE string.
  CLASS-EVENTS interface      EXPORTING VALUE(iv_name)             TYPE string.
  CLASS-EVENTS method
    EXPORTING
      VALUE(io_visibility) TYPE REF TO lce_token
      VALUE(iv_name)       TYPE string
      VALUE(io_type)       TYPE REF TO lce_token OPTIONAL.
  CLASS-EVENTS method_importing_parameter
    EXPORTING
      VALUE(iv_name) TYPE string
      VALUE(iv_type) TYPE string.
  CLASS-EVENTS method_returning_parameter EXPORTING VALUE(iv_type) TYPE string.
  CLASS-EVENTS attribute
    EXPORTING
      VALUE(io_visibility) TYPE REF TO lce_token
      VALUE(io_type)       TYPE REF TO lce_token
      VALUE(iv_name)       TYPE string
      VALUE(iv_type)       TYPE string.
ENDINTERFACE.
