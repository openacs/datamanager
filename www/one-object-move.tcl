ad_page_contract {
    Show the list of communities where an object can be moved 
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
    object_id:integer,notnull,multiple
} -properties {
}

set context [list [_ datamanager.Object_Move]]
set title "[_ datamanager.Choose_Destination]"    

#only administrator or professor must be allowed to enter this page
dotlrn::require_user_admin_community  -community_id [dotlrn_community::get_community_id]


set object_data [list]
set object_name [list]

foreach object $object_id {
    set object_type [datamanager::get_object_type -object_id $object]
    set object_data_temp [datamanager::get_object_data -object_type $object_type -object_id $object]
    lappend object_data $object_data_temp
    lappend object_name [lindex $object_data_temp 0]
}


set object_url [lindex [lindex $object_data 0] 1]
set object_type [lindex [lindex $object_data 0] 2]

set action "move"

set available_communities [datamanager::get_available_communities -object_type $object_type -action_type $action]

