ad_page_contract {
    Just call the callback implemented in file-storage package
    @author Paco Soler (paco.soler@uv.es)
    @creation_date 2006-06-21
    
} -query {
     object_id:notnull
     action:notnull
     dest_community_id:multiple
     {mode: "both"}
} -properties {
}


set source_community [dotlrn_community::get_community_id]
set selected_community $dest_community_id
dotlrn::require_user_admin_community  -community_id [dotlrn_community::get_community_id]
set context [list []]
set title "[_ datamanager.Confirmation]"    
set error_url "error.tcl"
set ok_url "ok.tcl"
set items_ok 0

regsub -all {\{} $object_id "" object_id
regsub -all {\}} $object_id "" object_id
regsub -all {\{} $dest_community_id "" dest_community_id
regsub -all {\}} $dest_community_id "" dest_community_id

switch $action {
    "copy" {
         foreach community $selected_community {
            foreach object $object_id { 
                 #only administrator or professor must be allowed to enter this page
                dotlrn::require_user_admin_community  -community_id $community
                                

                                if { [catch {callback datamanager::copy_album -object_id $object -selected_community $community -mode $mode
                                } errmsg] } {
                      ad_returnredirect [append tmp $error_url "?error=" $errmsg]
                      ad_script_abort             
                    } else {
                      set items_ok [expr $items_ok + 1]
                    }
                        set aux 0
            }
         }
    }
    default {
    }
        
}

set okmsg "Action performed on total items: $items_ok"
ad_returnredirect [append tmp $ok_url "?msg=" $okmsg]
