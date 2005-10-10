ad_page_contract {
    Show the list of communities where an object can be copied
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
    object_id:integer,notnull
} -properties {
}


set context [list [_ datamanager.Object_Copy]]
set title "[_ datamanager.Choose_Destination]"    

#only administrator or professor must be allowed to enter this page
dotlrn::require_user_admin_community  -community_id [dotlrn_community::get_community_id]

set object_type [datamanager::get_object_type -object_id $object_id]
set object_data [datamanager::get_object_data -object_type $object_type -object_id $object_id]

set object_name [lindex $object_data 0]
set object_url [lindex $object_data 1]
set object_type [lindex $object_data 2]

set action "copy"

set available_communities [datamanager::get_available_communities -object_type $object_type]

