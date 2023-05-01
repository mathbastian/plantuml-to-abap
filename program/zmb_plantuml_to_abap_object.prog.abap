INTERFACE lif_object.
  INTERFACES lif_source_code_getter.
  TYPES ty_t_objects TYPE STANDARD TABLE OF REF TO lif_object WITH DEFAULT KEY.
  TYPES BEGIN OF ty_s_relationship.
    TYPES type        TYPE REF TO lce_token.
    TYPES object_name TYPE string.
  TYPES END OF ty_s_relationship.
  TYPES ty_t_relationships TYPE STANDARD TABLE OF ty_s_relationship WITH DEFAULT KEY.
  DATA mv_name TYPE string.
  DATA mo_type TYPE REF TO lce_token.
  METHODS add_relationship
    IMPORTING
      io_type        TYPE REF TO lce_token
      iv_object_name TYPE string.
  METHODS add_method    IMPORTING io_method TYPE REF TO lif_method.
  METHODS add_attribute IMPORTING io_attribute TYPE REF TO lif_attribute.
  METHODS get_relationships RETURNING VALUE(rt_relationships) TYPE lif_object=>ty_t_relationships.
  METHODS get_methods RETURNING VALUE(rt_methods) TYPE lif_method=>ty_t_methods.
  METHODS get_methods_to_implement RETURNING VALUE(rt_methods) TYPE lif_method=>ty_t_methods.
ENDINTERFACE.
