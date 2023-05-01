INTERFACE lif_object_container.
  METHODS get_all RETURNING VALUE(rt_objects) TYPE lif_object=>ty_t_objects.
  METHODS get_by_name IMPORTING iv_name TYPE string RETURNING VALUE(ro_object) TYPE REF TO lif_object.
ENDINTERFACE.
