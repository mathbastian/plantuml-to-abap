CLASS lcl_attribute DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_attribute.
    METHODS constructor
      IMPORTING
        io_visibility TYPE REF TO lce_token
        io_type       TYPE REF TO lce_token
        iv_name       TYPE string
        iv_type       TYPE string.
  PRIVATE SECTION.
    DATA mo_type       TYPE REF TO lce_token.
    DATA mv_name       TYPE string.
    DATA mv_type       TYPE string.

ENDCLASS.

CLASS lcl_attribute IMPLEMENTATION.

  METHOD constructor.
    lif_attribute~mo_visibility = io_visibility.
    mo_type       = io_type.
    mv_name       = iv_name.
    mv_type       = iv_type.
  ENDMETHOD.

  METHOD lif_source_code_getter~get.

  ENDMETHOD.

ENDCLASS.
