CLASS lce_parameter_type DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.
    CLASS-DATA importing TYPE REF TO lce_parameter_type.
    CLASS-DATA returning TYPE REF TO lce_parameter_type.
    CLASS-METHODS class_constructor.
ENDCLASS.

CLASS lce_parameter_type IMPLEMENTATION.
  METHOD class_constructor.
    importing = NEW #( ).
    returning = NEW #( ).
  ENDMETHOD.
ENDCLASS.
