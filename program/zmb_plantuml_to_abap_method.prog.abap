CLASS lcl_method DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_method.
    TYPES BEGIN OF ty_s_parameter.
      TYPES type      TYPE REF TO lce_parameter_type.
      TYPES name      TYPE string.
      TYPES abap_type TYPE string.
    TYPES END OF ty_s_parameter.
    TYPES ty_t_parameters TYPE STANDARD TABLE OF ty_s_parameter WITH DEFAULT KEY.

    METHODS constructor
      IMPORTING
        io_visibility TYPE REF TO lce_token
        io_type       TYPE REF TO lce_token
        iv_name       TYPE string
        io_object     TYPE REF TO lif_object.
  PRIVATE SECTION.
    DATA mt_parameters TYPE ty_t_parameters.

ENDCLASS.

CLASS lcl_method IMPLEMENTATION.

  METHOD lif_method~add_importing_parameter.
    APPEND VALUE #(
      type      = lce_parameter_type=>importing
      name      = iv_name
      abap_type = iv_type
    ) TO mt_parameters.
  ENDMETHOD.

  METHOD lif_method~add_returning_parameter.
    APPEND VALUE #(
      type      = lce_parameter_type=>returning
      abap_type = iv_type
    ) TO mt_parameters.
  ENDMETHOD.

  METHOD constructor.
    lif_method~mo_visibility = io_visibility.
    lif_method~mo_type       = io_type.
    lif_method~mv_name       = iv_name.
    lif_method~mo_object     = io_object.
  ENDMETHOD.

  METHOD lif_source_code_getter~get.

  ENDMETHOD.

ENDCLASS.
