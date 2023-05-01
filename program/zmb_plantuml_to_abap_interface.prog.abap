CLASS lcl_interface DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_object.
    METHODS constructor
      IMPORTING
        iv_name TYPE string
        io_object_container TYPE REF TO lif_object_container.
  PRIVATE SECTION.
    DATA mt_methods       TYPE lif_method=>ty_t_methods.
    DATA mt_attributes    TYPE lif_attribute=>ty_t_attributes.
    DATA mt_relationships TYPE lif_object=>ty_t_relationships.
    DATA mo_object_container TYPE REF TO lif_object_container.

ENDCLASS.

CLASS lcl_interface IMPLEMENTATION.

  METHOD lif_object~add_attribute.
    APPEND io_attribute TO mt_attributes.
  ENDMETHOD.

  METHOD lif_object~add_method.
    APPEND io_method TO mt_methods.
  ENDMETHOD.

  METHOD lif_object~add_relationship.
    APPEND VALUE #( type = io_type object_name = iv_object_name ) TO mt_relationships.
  ENDMETHOD.

  METHOD constructor.
    lif_object~mv_name = iv_name.
    lif_object~mo_type = lce_token=>interface.
    mo_object_container = io_object_container.
  ENDMETHOD.

  METHOD lif_source_code_getter~get.
    APPEND |INTERFACE { lif_object~mv_name }.| TO rt_source_code.

    LOOP AT mt_relationships ASSIGNING FIELD-SYMBOL(<ls_relationships>).
      APPEND |  INTERFACES { <ls_relationships>-object_name }.| TO rt_source_code.
    ENDLOOP.

    LOOP AT mt_methods ASSIGNING FIELD-SYMBOL(<lo_method>).
      APPEND LINES OF <lo_method>->lif_source_code_getter~get( ) TO rt_source_code.
    ENDLOOP.

    LOOP AT mt_attributes ASSIGNING FIELD-SYMBOL(<lo_attribute>).
      APPEND LINES OF <lo_attribute>->lif_source_code_getter~get( ) TO rt_source_code.
    ENDLOOP.

    APPEND |ENDINTERFACE.| TO rt_source_code.
  ENDMETHOD.

  METHOD lif_object~get_methods.
    rt_methods = mt_methods.
  ENDMETHOD.

  METHOD lif_object~get_relationships.
    rt_relationships = mt_relationships.
  ENDMETHOD.

  METHOD lif_object~get_methods_to_implement.
    LOOP AT mt_relationships ASSIGNING FIELD-SYMBOL(<ls_relationship>)
      WHERE type = lce_token=>implements.

      APPEND LINES OF mo_object_container->get_by_name( <ls_relationship>-object_name
        )->get_methods_to_implement( )
        TO rt_methods.
    ENDLOOP.

    APPEND LINES OF mt_methods TO rt_methods.
  ENDMETHOD.

ENDCLASS.
