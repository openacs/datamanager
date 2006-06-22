ad_page_contract {
} -query {
    object_id:multiple,notnull
    {department_key: "all"}
    {mode: ""}
} -properties {
}

set context [list [_ datamanager.Copy_Objects]]
set title "[_ datamanager.Choose_Destination]"    

#only administrator or professor must be allowed to enter this page
dotlrn::require_user_admin_community  -community_id [dotlrn_community::get_community_id]

set object_data [list]
set object_name [list]

if {[llength $object_id] == 1} {
    if {[llength [lindex $object_id 0]] > 1} {
        set object_id [lindex $object_id 0]
    }
}

foreach object $object_id {
    
        set object_type [datamanager::get_object_type -object_id $object]       
        set object_data_temp [datamanager::get_object_data -object_type $object_type -object_id $object]
        lappend object_data $object_data_temp
        lappend object_name [lindex $object_data_temp 0]
        

}
set object_url [lindex [lindex $object_data 0] 1]
set object_type [lindex [lindex $object_data 0] 2]
set action "copy"

set mode_list {}

set departments_temp [db_list_of_lists get_departments_list {}]
set departments [linsert $departments_temp 0 [list All all]]

form create department_form -has_submit 1
element create department_form department_key \
    -label "#datamanager.Departments#" \
    -datatype text \
    -widget select \
    -options $departments \
    -optional \
    -html {onChange document.department_form.submit()} \
    -value $department_key
 element create department_form object_id \
    -datatype text \
    -widget hidden \
    -value $object_id

