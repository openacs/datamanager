ad_page_contract {

    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
    object_id:integer,notnull    
} -properties {
}


set context [list [_ datamanager.Delete_Objects]]
set title "Delete confirmation"

#only administrator must be allowed to enter this page
dotlrn::require_admin 

set object_type [datamanager::get_object_type -object_id $object_id]
set object_data [datamanager::get_object_data -object_type $object_type -object_id $object_id]

set object_name [lindex $object_data 0]
set object_url [lindex $object_data 1]
set object_type [lindex $object_data 2]

set action "delete_NOT_IMPLEMENTED_PROPERLY"

