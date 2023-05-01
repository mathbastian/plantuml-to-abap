CLASS lcl_semantics DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS translate IMPORTING it_file_content TYPE string_table.
    INTERFACES lif_uml_events.
  PRIVATE SECTION.
    CLASS-DATA file_content TYPE string_table.
    CLASS-DATA pointer      TYPE i.
    CLASS-DATA current_line TYPE i.
    CLASS-DATA look_ahead   TYPE c.
    CLASS-DATA line_content TYPE string.
    CLASS-DATA lexeme       TYPE string.
    CLASS-DATA last_lexeme  TYPE string.
    CLASS-DATA token        TYPE REF TO lce_token.

    CLASS-METHODS move_look_ahead.
    CLASS-METHODS get_next_token.
    CLASS-METHODS skip_line.

    CLASS-METHODS begin.
    CLASS-METHODS definitions.
    CLASS-METHODS definition.

    CLASS-METHODS class IMPORTING iv_is_abstract TYPE abap_bool.
    CLASS-METHODS interface.
    CLASS-METHODS enum.
    CLASS-METHODS attributes_and_methods.
    CLASS-METHODS attribute_or_method.
    CLASS-METHODS method_parameters.
    CLASS-METHODS importing_parameters.
    CLASS-METHODS importing_parameter.
    CLASS-METHODS returning_parameter.

ENDCLASS.

CLASS lcl_semantics IMPLEMENTATION.

  METHOD translate.
    file_content = it_file_content.
    move_look_ahead( ).
    get_next_token( ).

    begin( ).
  ENDMETHOD.

  METHOD move_look_ahead.
    IF ( pointer + 1 ) > strlen( line_content ).
      current_line += 1.
      pointer = 0.

      READ TABLE file_content INDEX current_line INTO line_content.
      IF sy-subrc <> 0.
        look_ahead = lce_token=>end_of_file->value.
        EXIT.
      ENDIF.

      IF strlen( line_content ) > 0.
        look_ahead = line_content+pointer(1).
      ELSE.
        CLEAR look_ahead.
      ENDIF.

    ELSE.
      look_ahead = line_content+pointer(1).
    ENDIF.

    pointer += 1.
  ENDMETHOD.

  METHOD get_next_token.
    DATA lv_aux_lexeme TYPE string.

    IF lexeme IS NOT INITIAL.
      last_lexeme = lexeme.
    ENDIF.

    WHILE look_ahead = ' '.
      move_look_ahead( ).
    ENDWHILE.

    IF lcl_regex=>has_only_letters( look_ahead ).

      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      move_look_ahead( ).

      WHILE lcl_regex=>has_only_alphanumeric( look_ahead ) OR look_ahead = '_'.
         lv_aux_lexeme = lv_aux_lexeme && look_ahead.
         move_look_ahead( ).
      ENDWHILE.

      lexeme = lv_aux_lexeme.
      lexeme = to_upper( lexeme ).

      IF     lexeme = 'CLASS'.
        token = lce_token=>class.
      ELSEIF lexeme = 'INTERFACE'.
        token = lce_token=>interface.
      ELSEIF lexeme = 'ENUM'.
        token = lce_token=>enum.
      ELSEIF lexeme = 'ABSTRACT'.
        token = lce_token=>abstract.
      ELSEIF lexeme = 'PACKAGE'.
        token = lce_token=>package.
      ELSEIF lexeme = 'IMPLEMENTS'.
        token = lce_token=>implements.
      ELSEIF lexeme = 'EXTENDS'.
        token = lce_token=>extends.
      ELSE.
        token = lce_token=>id.
      ENDIF.

    ELSEIF look_ahead = '@'.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      move_look_ahead( ).
      WHILE lcl_regex=>has_only_letters( look_ahead ).
        lv_aux_lexeme = lv_aux_lexeme && look_ahead.
        move_look_ahead( ).
      ENDWHILE.

      lv_aux_lexeme = to_upper( lv_aux_lexeme ).
      IF lv_aux_lexeme = '@STARTUML'.
        token = lce_token=>start.
      ELSEIF lv_aux_lexeme = '@ENDUML'.
        token = lce_token=>end.
      ENDIF.

    ELSEIF look_ahead = '('.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>opening_parenthesis.
      move_look_ahead( ).
    ELSEIF look_ahead = ')'.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>closing_parenthesis.
      move_look_ahead( ).
    ELSEIF look_ahead = '{'.

      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>opening_brace.
      move_look_ahead( ).

      WHILE lcl_regex=>has_only_letters( look_ahead ).
        lv_aux_lexeme = lv_aux_lexeme && look_ahead.
        move_look_ahead( ).
      ENDWHILE.
      IF sy-subrc = 0.
        lv_aux_lexeme = lv_aux_lexeme && look_ahead.
        move_look_ahead( ).
        lv_aux_lexeme = to_upper( lv_aux_lexeme ).
        IF     lv_aux_lexeme = '{STATIC}'.
          token = lce_token=>static.
        ELSEIF lv_aux_lexeme = '{ABSTRACT}'.
          token = lce_token=>abstract.
        ENDIF.
      ENDIF.

    ELSEIF look_ahead = '}'.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>closing_brace.
      move_look_ahead( ).
    ELSEIF look_ahead = '+'.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>public.
      move_look_ahead( ).
    ELSEIF look_ahead = '-'.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>private.
      move_look_ahead( ).
    ELSEIF look_ahead = '#'.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>protected.
      move_look_ahead( ).
    ELSEIF look_ahead = ':'.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>type.
      move_look_ahead( ).
    ELSEIF look_ahead = ','.
      lv_aux_lexeme = lv_aux_lexeme && look_ahead.
      token = lce_token=>comma.
      move_look_ahead( ).
    ELSEIF look_ahead = '<'.
      move_look_ahead( ).
      WHILE look_ahead <> '>'.
        move_look_ahead( ).
      ENDWHILE.
      WHILE look_ahead = '>'.
        move_look_ahead( ).
      ENDWHILE.
      get_next_token( ).
    ENDIF.

    lexeme = lv_aux_lexeme.
  ENDMETHOD.

  METHOD skip_line.
    pointer = strlen( line_content ).
  ENDMETHOD.

  METHOD begin.
    IF token = lce_token=>start.
      get_next_token( ).
    ENDIF.

    definitions( ).
    "relationships using arrows will be supported later

    IF token = lce_token=>end.
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD definitions.
    definition( ).
    IF token = lce_token=>closing_brace.
      get_next_token( ).
      definitions( ).
    ENDIF.
  ENDMETHOD.

  METHOD definition.
    CASE token.
      WHEN lce_token=>abstract.
        get_next_token( ).
        IF token = lce_token=>class.
          class( iv_is_abstract = abap_true ).
        ENDIF.
      WHEN lce_token=>class.
        class( iv_is_abstract = abap_false ).
      WHEN lce_token=>interface.
        interface( ).
      WHEN lce_token=>enum.
        enum( ).
    ENDCASE.
  ENDMETHOD.

  METHOD class.
    IF token = lce_token=>class.
      get_next_token( ).
      IF token = lce_token=>id.
        RAISE EVENT lif_uml_events~class
          EXPORTING
            iv_name        = lexeme
            iv_is_abstract = iv_is_abstract.
        get_next_token( ).
        IF token = lce_token=>extends.
          get_next_token( ).
          IF token = lce_token=>id.
            RAISE EVENT lif_uml_events~inheritance EXPORTING iv_super_class_name = lexeme.
            get_next_token( ).
            IF token = lce_token=>opening_brace.
              get_next_token( ).
              attributes_and_methods( ).
            ENDIF.
          ENDIF.
        ELSEIF token = lce_token=>implements.
          get_next_token( ).
          IF token = lce_token=>id.
            RAISE EVENT lif_uml_events~implementation EXPORTING iv_interface_name = lexeme.
            get_next_token( ).
            IF token = lce_token=>opening_brace.
              get_next_token( ).
              attributes_and_methods( ).
            ENDIF.
          ENDIF.
        ELSEIF token = lce_token=>opening_brace.
          get_next_token( ).
          attributes_and_methods( ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD enum.

  ENDMETHOD.

  METHOD interface.
    IF token = lce_token=>interface.
      get_next_token( ).
      IF token = lce_token=>id.
        RAISE EVENT lif_uml_events~interface EXPORTING iv_name = lexeme.
        get_next_token( ).
        IF token = lce_token=>implements.
          get_next_token( ).
          IF token = lce_token=>id.
            RAISE EVENT lif_uml_events~implementation EXPORTING iv_interface_name = lexeme.
            get_next_token( ).
            IF token = lce_token=>opening_brace.
              get_next_token( ).
              attributes_and_methods( ).
            ENDIF.
          ENDIF.
        ELSEIF token = lce_token=>opening_brace.
          get_next_token( ).
          attributes_and_methods( ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD attributes_and_methods.
    attribute_or_method( ).

    IF token = lce_token=>public    OR
       token = lce_token=>protected OR
       token = lce_token=>private.
      attributes_and_methods( ).
    ENDIF.
  ENDMETHOD.

  METHOD attribute_or_method.
    DATA lo_visibility TYPE REF TO lce_token.
    DATA lo_type       TYPE REF TO lce_token.
    DATA lv_name       TYPE string.

    IF token = lce_token=>public    OR
       token = lce_token=>protected OR
       token = lce_token=>private.
      lo_visibility = token.
      get_next_token( ).

      IF token = lce_token=>abstract OR token = lce_token=>static.
        lo_type = token.
        get_next_token( ).
      ENDIF.

      IF token = lce_token=>id.
        lv_name = lexeme.
        get_next_token( ).

        IF token = lce_token=>opening_parenthesis.
          RAISE EVENT lif_uml_events~method
            EXPORTING
              io_visibility = lo_visibility
              io_type       = lo_type
              iv_name       = lv_name.
          get_next_token( ).
          method_parameters( ).

        ELSEIF token = lce_token=>type.
          get_next_token( ).
          IF token = lce_token=>id.
            RAISE EVENT lif_uml_events~attribute
              EXPORTING
                io_visibility = lo_visibility
                io_type       = lo_type
                iv_name       = lv_name
                iv_type       = lexeme.
            get_next_token( ).
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD method_parameters.
    importing_parameters( ).
    IF token = lce_token=>closing_parenthesis.
      get_next_token( ).
      returning_parameter( ).
    ENDIF.
  ENDMETHOD.

  METHOD importing_parameters.
    importing_parameter( ).
    IF token = lce_token=>comma.
      get_next_token( ).
      importing_parameters( ).
    ENDIF.
  ENDMETHOD.

  METHOD importing_parameter.
    DATA lv_parameter_name TYPE string.
    DATA lv_parameter_type TYPE string.

    IF token = lce_token=>id.
      lv_parameter_name = lexeme.
      get_next_token( ).
      IF token = lce_token=>type.
        get_next_token( ).
        IF token = lce_token=>id.
          lv_parameter_type = lexeme.
          get_next_token( ).
          RAISE EVENT lif_uml_events~method_importing_parameter
            EXPORTING
              iv_name = lv_parameter_name
              iv_type = lv_parameter_type.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD returning_parameter.
    IF token = lce_token=>type.
      get_next_token( ).
      IF token = lce_token=>id.
        "@TODO In event handler, check if param type is class or interface and adjust
        "prefix accordingly: rv_result or ro_result
        RAISE EVENT lif_uml_events~method_returning_parameter EXPORTING iv_type = lexeme.
        get_next_token( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
