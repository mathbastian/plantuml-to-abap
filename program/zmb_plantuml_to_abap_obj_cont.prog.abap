CLASS lcl_object_container DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_object_container.
    METHODS constructor.
    METHODS on_class                      FOR EVENT class                      OF lif_uml_events IMPORTING iv_name iv_is_abstract.
    METHODS on_inheritance                FOR EVENT inheritance                OF lif_uml_events IMPORTING iv_super_class_name.
    METHODS on_implementation             FOR EVENT implementation             OF lif_uml_events IMPORTING iv_interface_name.
    METHODS on_interface                  FOR EVENT interface                  OF lif_uml_events IMPORTING iv_name.
    METHODS on_method                     FOR EVENT method                     OF lif_uml_events IMPORTING io_visibility iv_name io_type.
    METHODS on_method_importing_parameter FOR EVENT method_importing_parameter OF lif_uml_events IMPORTING iv_name iv_type.
    METHODS on_method_returning_parameter FOR EVENT method_returning_parameter OF lif_uml_events IMPORTING iv_type.
    METHODS on_attribute                  FOR EVENT attribute                  OF lif_uml_events IMPORTING io_visibility io_type iv_name iv_type.
    METHODS write_objects.

  PRIVATE SECTION.
    DATA mo_object TYPE REF TO lif_object.
    DATA mo_method TYPE REF TO lif_method.

    DATA mt_objects TYPE lif_object=>ty_t_objects.
ENDCLASS.

CLASS lcl_object_container IMPLEMENTATION.

  METHOD on_class.
    IF iv_is_abstract = abap_true.
      WRITE |Abstract class { iv_name } being created|. NEW-LINE.
    ELSE.
      WRITE |Class { iv_name } being created|. NEW-LINE.
    ENDIF.

    mo_object = NEW lcl_class(
      iv_name             = iv_name
      iv_is_abstract      = iv_is_abstract
      io_object_container = me
    ).
    APPEND mo_object TO mt_objects.
  ENDMETHOD.

  METHOD on_implementation.
    WRITE |Current object implements { iv_interface_name }|. NEW-LINE.
    mo_object->add_relationship(
      io_type        = lce_token=>implements
      iv_object_name = iv_interface_name
    ).
  ENDMETHOD.

  METHOD on_inheritance.
    WRITE |Current class extends { iv_super_class_name }|. NEW-LINE.
    mo_object->add_relationship(
      io_type        = lce_token=>extends
      iv_object_name = iv_super_class_name
    ).
  ENDMETHOD.

  METHOD on_interface.
    WRITE |Interface { iv_name } being created|. NEW-LINE.
    mo_object = NEW lcl_interface(
      iv_name             = iv_name
      io_object_container = me
    ).
    APPEND mo_object TO mt_objects.
  ENDMETHOD.

  METHOD on_method.
    IF io_type IS BOUND.
      WRITE |Current object has a { io_type->value } { io_visibility->value } method called { iv_name }|. NEW-LINE.
    ELSE.
      WRITE |Current object has a { io_visibility->value } method called { iv_name }|. NEW-LINE.
    ENDIF.
    mo_method = NEW lcl_method(
      io_visibility = io_visibility
      io_type       = io_type
      iv_name       = iv_name
      io_object     = mo_object
    ).
    mo_object->add_method( mo_method ).
  ENDMETHOD.

  METHOD on_method_importing_parameter.
    WRITE |Current method has an importing parameter called { iv_name } of type { iv_type }|. NEW-LINE.
    mo_method->add_importing_parameter(
      iv_name = iv_name
      iv_type = iv_type
    ).
  ENDMETHOD.

  METHOD on_method_returning_parameter.
    WRITE |Current method has a returning parameter of type { iv_type }|. NEW-LINE.
    IF iv_type IS INITIAL OR iv_type = 'void' OR iv_type = 'VOID'.
      RETURN.
    ENDIF.
    mo_method->add_returning_parameter( iv_type ).
  ENDMETHOD.

  METHOD on_attribute.
    IF io_type IS BOUND.
      WRITE |Current object has a { io_type->value } { io_visibility->value } attribute called { iv_name } of type { iv_type }|. NEW-LINE.
    ELSE.
      WRITE |Current object has a { io_visibility->value } attribute called { iv_name } of type { iv_type }|. NEW-LINE.
    ENDIF.
    DATA(lo_attribute) = NEW lcl_attribute(
      io_visibility = io_visibility
      io_type       = io_type
      iv_name       = iv_name
      iv_type       = iv_type
    ).

    mo_object->add_attribute( lo_attribute ).
  ENDMETHOD.

  METHOD constructor.
    SET HANDLER on_class.
    SET HANDLER on_inheritance.
    SET HANDLER on_implementation.
    SET HANDLER on_interface.
    SET HANDLER on_method.
    SET HANDLER on_method_importing_parameter.
    SET HANDLER on_method_returning_parameter.
    SET HANDLER on_attribute.
  ENDMETHOD.

  METHOD write_objects.
    NEW-LINE.
    WRITE |ABAP CODE BELOW:|.
    NEW-LINE.

    LOOP AT mt_objects ASSIGNING FIELD-SYMBOL(<lo_object>).
      LOOP AT <lo_object>->lif_source_code_getter~get( ) ASSIGNING FIELD-SYMBOL(<lv_line>).
        WRITE <lv_line>. NEW-LINE.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD lif_object_container~get_all.
    rt_objects = mt_objects.
  ENDMETHOD.

  METHOD lif_object_container~get_by_name.
    READ TABLE mt_objects WITH KEY table_line->mv_name = iv_name INTO ro_object.
  ENDMETHOD.

ENDCLASS.
