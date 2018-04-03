ad_page_contract {
} -query {
     object_id:multiple,notnull
     action:notnull
     dest_community_id:notnull
     {sufix:optional ""}
} -properties {
}

dotlrn::require_user_admin_community -community_id [dotlrn_community::get_community_id]

set context [list []]
set title "[_ datamanager.Confirmation]"    
set error_url "error.tcl"
set ok_url "ok.tcl"
set items_ok 0

if {[info exists sufix] eq 0} {
    set sufix ""
}     

regsub -all {\{} $object_id "" object_id
regsub -all {\}} $object_id "" object_id
regsub -all {\{} $dest_community_id "" dest_community_id
regsub -all {\}} $dest_community_id "" dest_community_id

switch $action {
    "copy" {
            foreach community $dest_community_id {
                foreach object $object_id {
                    dotlrn::require_user_admin_community -community_id $community
                    if { [catch {callback datamanager::copy_faq -object_id $object -selected_community $community -sufix $sufix} errmsg] } {
                      ad_returnredirect [append tmp $error_url "?error=" $errmsg]
                      ad_script_abort             
                    } else {
                      set items_ok [expr $items_ok + 1]
                    }
                }
            }
        }
    "export" {
            foreach community $dest_community_id {
                foreach object $object_id {
                    dotlrn::require_user_admin_community  -community_id $community
                    if { [catch {callback datamanager::export_faq -object_id $object} errmsg] } {
                      ad_returnredirect [append tmp $error_url "?error=" $errmsg]
                      ad_script_abort             
                    } else {
                      set items_ok [expr $items_ok + 1]
                    }
                }
            }
        }        
    default {
    }
}

set okmsg "#datamanager.items_performed#: $items_ok"
ad_returnredirect [append tmp $ok_url "?msg=" $okmsg]

