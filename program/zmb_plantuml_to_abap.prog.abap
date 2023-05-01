*&---------------------------------------------------------------------*
*& Report zmb_plantuml_to_abap
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmb_plantuml_to_abap.

PARAMETERS p_file TYPE rlgrap-filename.

INCLUDE zmb_plantuml_to_abap_tokens.
INCLUDE zmb_plantuml_to_abap_param_ty.
INCLUDE zmb_plantuml_to_abap_uml_event.
INCLUDE zmb_plantuml_to_abap_code_get.

INCLUDE zmb_plantuml_to_abap_method_i.
INCLUDE zmb_plantuml_to_abap_attr_i.
INCLUDE zmb_plantuml_to_abap_object.
INCLUDE zmb_plantuml_to_abap_obj_con_i.

INCLUDE zmb_plantuml_to_abap_attr.
INCLUDE zmb_plantuml_to_abap_method.
INCLUDE zmb_plantuml_to_abap_class.
INCLUDE zmb_plantuml_to_abap_interface.
INCLUDE zmb_plantuml_to_abap_obj_cont.
INCLUDE zmb_plantuml_to_abap_file.
INCLUDE zmb_plantuml_to_abap_regex.
INCLUDE zmb_plantuml_to_abap_semantics.

INITIALIZATION.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  p_file = lcl_file=>get_file_name( ).

END-OF-SELECTION.

  DATA lt_content          TYPE string_table.
  DATA lo_object_container TYPE REF TO lcl_object_container.

  lt_content = lcl_file=>get_file_content( p_file ).
  lo_object_container = NEW #( ).
  lcl_semantics=>translate( lt_content ).
  lo_object_container->write_objects( ).
