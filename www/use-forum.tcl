ad_page_contract {
    Just call the callback implemented in forums package
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-11
    
} -query {
     object_id:integer,notnull
     selected_community:integer,optional
     action:notnull
} -properties {
}

dotlrn::require_user_admin_community  -community_id [dotlrn_community::get_community_id]

set context [list []]
set title "[_ datamanager.Confirmation]"    

switch $action {
    "move" {
         #only administrator or professor must be allowed to enter this page
        dotlrn::require_user_admin_community  -community_id $selected_community
            
        callback -catch datamanager::move_forum -object_id $object_id -selected_community $selected_community    }
    "copy" {
         #only administrator or professor must be allowed to enter this page
        dotlrn::require_user_admin_community  -community_id $selected_community

        callback -catch datamanager::copy_forum -object_id $object_id -selected_community $selected_community    }    
    "delete" {
        callback -catch datamanager::delete_forum -object_id $object_id         

    }
    default {
    }
}
 


ad_returnredirect "./"
