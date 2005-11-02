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


if { [llength $object_id] > 1 } {
    set descendant_ids [list]
    set ancestors_ids [list]
    set checked_items [list]
    
    db_multirow tree_sortkey_list get_tree_sortkey {} {
#always add to the list the first element
    if {[llength $ancestors_ids]=="0"} {
        lappend ancestors_ids $item_id
    } else {
#a flag for "descendancy" test. At the begin, item has no ancestors
        set descendant_p "f"
        foreach c_item $checked_items {
           set ancestor_p [db_exec_plsql get_ancestors_p1 {}]

           if {$ancestor_p && $c_item != $tree_sortkey} {set descendant_p "t"}
        }
        if {$descendant_p eq "f"} {lappend ancestors_ids $item_id} else {lappend descendant_ids $item_id}
    }
        lappend checked_items $tree_sortkey
    }
}

set object_data [list]
set object_name [list]

foreach object $ancestors_ids {
    set object_type [datamanager::get_object_type -object_id $object]
    set object_data_temp [datamanager::get_object_data -object_type $object_type -object_id $object]
    lappend object_data $object_data_temp
    lappend object_name [lindex $object_data_temp 0]
}


set object_url [lindex [lindex $object_data 0] 1]
set object_type [lindex [lindex $object_data 0] 2]

set action "move"

set available_communities [datamanager::get_available_communities -object_type $object_type -action_type $action]

