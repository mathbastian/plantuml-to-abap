CLASS lcl_class DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_object.
    METHODS constructor
      IMPORTING
        iv_name             TYPE string
        iv_is_abstract      TYPE abap_bool
        io_object_container TYPE REF TO lif_object_container.
  PRIVATE SECTION.
    DATA mt_methods       TYPE lif_method=>ty_t_methods.
    DATA mt_attributes    TYPE lif_attribute=>ty_t_attributes.
    DATA mt_relationships TYPE lif_object=>ty_t_relationships.
    DATA mv_is_abstract   TYPE abap_bool.
    DATA mo_object_container TYPE REF TO lif_object_container.

    METHODS get_data_by_visibility
      IMPORTING io_visibility TYPE REF TO lce_token
      RETURNING VALUE(rt_source_code) TYPE string_table.

ENDCLASS.

CLASS lcl_class IMPLEMENTATION.

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
    lif_object~mv_name  = iv_name.
    lif_object~mo_type  = lce_token=>class.
    mv_is_abstract      = iv_is_abstract.
    mo_object_container = io_object_container.
  ENDMETHOD.

  METHOD lif_source_code_getter~get.
    DATA lv_super_classes   TYPE string.
    DATA lv_abstract        TYPE string.
    DATA lv_has_super_class TYPE abap_bool.

    lv_super_classes = | INHERITING FROM|.

    LOOP AT mt_relationships ASSIGNING FIELD-SYMBOL(<ls_relationship>) WHERE type = lce_token=>extends.
      lv_super_classes = |{ lv_super_classes } { <ls_relationship>-object_name }|.
      lv_has_super_class = abap_true.
    ENDLOOP.

    IF mv_is_abstract = abap_true.
      lv_abstract = | ABSTRACT |.
    ENDIF.

    IF lv_has_super_class = abap_false.
      CLEAR lv_super_classes.
    ENDIF.

    APPEND |CLASS { lif_object~mv_name } DEFINITION{ lv_abstract }{ lv_super_classes }.| TO rt_source_code.

    APPEND |PUBLIC SECTION.| TO rt_source_code.
    APPEND LINES OF get_data_by_visibility( lce_token=>public ) TO rt_source_code.

    APPEND |PROTECTED SECTION.| TO rt_source_code.
    APPEND LINES OF get_data_by_visibility( lce_token=>protected ) TO rt_source_code.

    APPEND |PRIVATE SECTION.| TO rt_source_code.
    APPEND LINES OF get_data_by_visibility( lce_token=>private ) TO rt_source_code.

    APPEND |ENDCLASS.| TO rt_source_code.

    APPEND |CLASS { lif_object~mv_name } IMPLEMENTATION.| TO rt_source_code.

    "Interface methods, inherited methods
    LOOP AT lif_object~get_methods_to_implement( ) ASSIGNING FIELD-SYMBOL(<lo_method>)
      WHERE TABLE_LINE->mo_object <> me.

      IF <lo_method>->mo_object->mo_type = lce_token=>interface.
        APPEND |METHOD { <lo_method>->mo_object->mv_name }~{ <lo_method>->mv_name }.| TO rt_source_code.
      ELSE.
        APPEND |METHOD { <lo_method>->mv_name }.| TO rt_source_code.
      ENDIF.
      APPEND |"Method implementation here...| TO rt_source_code.
      APPEND |ENDMETHOD.| TO rt_source_code.
      APPEND || TO rt_source_code.
    ENDLOOP.

    "then all methods from mt_methods
    LOOP AT mt_methods ASSIGNING <lo_method> WHERE TABLE_LINE->mo_type <> lce_token=>abstract.
      APPEND |METHOD { <lo_method>->mv_name }.| TO rt_source_code.
      APPEND |"Method implementation here...| TO rt_source_code.
      APPEND |ENDMETHOD.| TO rt_source_code.
      APPEND || TO rt_source_code.
    ENDLOOP.

    APPEND |ENDCLASS.| TO rt_source_code.
  ENDMETHOD.

  METHOD get_data_by_visibility.
    IF io_visibility = lce_token=>public.
      LOOP AT mt_relationships ASSIGNING FIELD-SYMBOL(<ls_relationship>)
        WHERE type = lce_token=>implements.
        APPEND |INTERFACES { <ls_relationship>-object_name }.| TO rt_source_code.
      ENDLOOP.
    ENDIF.

    LOOP AT mt_methods ASSIGNING FIELD-SYMBOL(<lo_method>)
      WHERE table_line->mo_visibility = io_visibility.
      APPEND LINES OF <lo_method>->lif_source_code_getter~get( ) TO rt_source_code.
    ENDLOOP.

    LOOP AT mt_attributes ASSIGNING FIELD-SYMBOL(<lo_attribute>)
      WHERE table_line->mo_visibility = io_visibility.
      APPEND LINES OF <lo_attribute>->lif_source_code_getter~get( ) TO rt_source_code.
    ENDLOOP.
  ENDMETHOD.

  METHOD lif_object~get_methods.
    rt_methods = mt_methods.
  ENDMETHOD.

  METHOD lif_object~get_relationships.
    rt_relationships = mt_relationships.
  ENDMETHOD.

  METHOD lif_object~get_methods_to_implement.
    LOOP AT mt_relationships ASSIGNING FIELD-SYMBOL(<lo_relationship>)
      WHERE type = lce_token=>implements
         OR type = lce_token=>extends.

      APPEND LINES OF mo_object_container->get_by_name( <lo_relationship>-object_name
             )->get_methods_to_implement( )
             TO rt_methods.
    ENDLOOP.

    LOOP AT mt_methods ASSIGNING FIELD-SYMBOL(<lo_method>)
      WHERE TABLE_LINE->mo_type = lce_token=>abstract.
      APPEND <lo_method> TO rt_methods.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
