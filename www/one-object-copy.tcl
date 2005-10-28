ad_page_contract {
    Show the list of communities where an object can be copied
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
    object_id:multiple,notnull
    {mode: ""}
} -properties {
}


set context [list [_ datamanager.Object_Copy]]
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


if {$object_type eq "dotlrn_forums"} {
    if {$mode == ""} {
        set mode "empty"
    }
    set empty_button [list "Empty" \
                                    [export_vars -base one-object-copy {object_id {mode "empty"}}] \
                                    "Select the forums without threads"]
    set threads_button [list "Threads" \
                                    [export_vars -base one-object-copy {object_id {mode "threads"}}]\
                                    "Select the forums with threads, but no replies"]
    set all_button [list "All" \
                                [export_vars -base one-object-copy {object_id {mode "all"}}]\
                                "Select the forums with the threads and replies"]
    set mode_list [concat $empty_button $threads_button $all_button]
} else {
    set mode_list {}
}

set available_communities [datamanager::get_available_communities\
                                        -object_type $object_type\
                                        -action_type $action\
                                        -mode_list $mode_list\
                                        -bulk_action_export_vars [list [list object_id $object_id] [list mode $mode] ] ]
