CLASS lcl_regex DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS has_only_letters
      IMPORTING iv_text TYPE c
      RETURNING VALUE(rv_has) TYPE abap_bool.

    CLASS-METHODS has_only_alphanumeric
      IMPORTING iv_text TYPE c
      RETURNING VALUE(rv_has) TYPE abap_bool.

ENDCLASS.

CLASS lcl_regex IMPLEMENTATION.

  METHOD has_only_alphanumeric.
    rv_has = cl_abap_matcher=>create(
      pattern = |^[[:alnum:]]+$|
      text    = iv_text
    )->match( ).
  ENDMETHOD.

  METHOD has_only_letters.
    rv_has = cl_abap_matcher=>create(
      pattern = |([a-zA-Z])|
      text    = iv_text
    )->match( ).
  ENDMETHOD.

ENDCLASS.
