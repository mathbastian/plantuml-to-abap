CLASS lce_token DEFINITION FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.

    CLASS-DATA start               TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA end                 TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA title               TYPE REF TO lce_token READ-ONLY.

    CLASS-DATA class               TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA interface           TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA enum                TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA abstract_object     TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA abstract            TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA static              TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA package             TYPE REF TO lce_token READ-ONLY.

    CLASS-DATA id                  TYPE REF TO lce_token READ-ONLY.

    CLASS-DATA extends             TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA implements          TYPE REF TO lce_token READ-ONLY.

    CLASS-DATA opening_brace       TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA closing_brace       TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA opening_parenthesis TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA closing_parenthesis TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA type                TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA comma               TYPE REF TO lce_token READ-ONLY.

    CLASS-DATA public              TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA protected           TYPE REF TO lce_token READ-ONLY.
    CLASS-DATA private             TYPE REF TO lce_token READ-ONLY.

    CLASS-DATA end_of_file         TYPE REF TO lce_token READ-ONLY.

    DATA value TYPE string READ-ONLY.

  PRIVATE SECTION.
    METHODS constructor IMPORTING iv_value TYPE string OPTIONAL.
ENDCLASS.

CLASS lce_token IMPLEMENTATION.

  METHOD class_constructor.
    end_of_file         = NEW #( |!| ).
    start               = NEW #( |@startuml|  ).
    end                 = NEW #( |@enduml|  ).
    title               = NEW #( |title|  ).
    class               = NEW #( |class|  ).
    interface           = NEW #( |interface|  ).
    enum                = NEW #( |enum| ).
    abstract_object     = NEW #( |abstract| ).
    package             = NEW #( |package| ).
    id                  = NEW #( |id| ).
    extends             = NEW #( |extends| ).
    implements          = NEW #( |implements| ).
    opening_brace       = NEW #( '{' ).
    closing_brace       = NEW #( '}' ).
    opening_parenthesis = NEW #( |(| ).
    closing_parenthesis = NEW #( |)| ).
    type                = NEW #( |:| ).
    public              = NEW #( |public| ).
    protected           = NEW #( |protected| ).
    private             = NEW #( |private| ).
    comma               = NEW #( |,| ).
    static              = NEW #( '{static}' ).
    abstract            = NEW #( '{abstract}' ).
  ENDMETHOD.

  METHOD constructor.
    value = iv_value.
  ENDMETHOD.

ENDCLASS.
