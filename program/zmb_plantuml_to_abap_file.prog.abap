CLASS lcl_file DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS get_file_name RETURNING VALUE(rv_file_name) TYPE rlgrap-filename.
    CLASS-METHODS get_file_content
      IMPORTING iv_file_name TYPE rlgrap-filename
      RETURNING VALUE(rt_content) TYPE string_table.
ENDCLASS.

CLASS lcl_file IMPLEMENTATION.

  METHOD get_file_name.
    DATA lt_file        TYPE filetable.
    DATA lv_user_action TYPE i.

    cl_gui_frontend_services=>file_open_dialog(
      CHANGING
        file_table = lt_file
        rc         = lv_user_action
      EXCEPTIONS
        OTHERS     = 0 ).

    READ TABLE lt_file INTO rv_file_name INDEX 1.
  ENDMETHOD.

  METHOD get_file_content.
    DATA lv_file_name TYPE string.
    lv_file_name = iv_file_name.

    cl_gui_frontend_services=>gui_upload(
      EXPORTING
        filename                = lv_file_name
        filetype                = 'ASC'
      CHANGING
        data_tab                = rt_content
      EXCEPTIONS
        others                  = 4
    ).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
