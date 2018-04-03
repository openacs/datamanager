ad_page_contract {
} -query {
} -properties {
}

if {[info exists department_key] eq 0} {
    set department_key ""
} 
    set available_name [join [list "available" $communities_classes] "_"]
if {$action_type eq "copy"} {

        set $available_name [datamanager::get_available_communities \
                                                            -object_type $object_type \
                                                            -action_type $action_type \
                                                            -mode_list $mode_list \
                                                            -bulk_action_export_vars [list [list object_id $object_id] [list mode $mode] ] \
                                                            -communities_classes $communities_classes \
                                                            -department_key $department_key]
} elseif {$action_type eq "export"} {

        set $available_name [datamanager::get_available_communities \
                                                            -object_type $object_type \
                                                            -action_type $action_type \
                                                            -mode_list $mode_list \
                                                            -bulk_action_export_vars [list [list object_id $object_id] [list mode $mode] ] \
                                                            -communities_classes $communities_classes \
                                                            -department_key $department_key]
}

