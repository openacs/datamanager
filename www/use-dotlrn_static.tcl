ad_page_contract {
    Just call the callback implemented in static-portlet package
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-11
    
} -query {
     object_id:notnull
     action:notnull
     dest_community_id:multiple
} -properties {
}


set selected_community $dest_community_id
dotlrn::require_user_admin_community  -community_id [dotlrn_community::get_community_id]
set context [list []]
set title "[_ datamanager.Confirmation]"    


switch $action {
    "move" {
         #only administrator or professor must be allowed to enter this page
        foreach object $object_id {
        dotlrn::require_user_admin_community  -community_id $selected_community
        callback -catch datamanager::move_static -object_id $object -selected_community $selected_community
        }
    }
    "copy" {
         #only administrator or professor must be allowed to enter this page
        foreach community $selected_community {
            foreach object $object_id {
                dotlrn::require_user_admin_community  -community_id $community
                callback -catch datamanager::copy_static -object_id $object -selected_community $community
            }
        }
    }
    "delete" {
        callback -catch datamanager::delete_static -object_id $object_id         
    }
    default {
    }
}


ad_returnredirect "./"
