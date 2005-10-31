ad_page_contract {
    Just call the callback implemented in file-storage package
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-18
    
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
          foreach object $object_id {
            #only administrator or professor must be allowed to enter this page
            dotlrn::require_user_admin_community  -community_id $selected_community
            callback -catch datamanager::move_folder -object_id $object -selected_community $selected_community
          }
    }
    "copy" {
         foreach community $selected_community {
            foreach object $object_id { 
                 #only administrator or professor must be allowed to enter this page
                dotlrn::require_user_admin_community  -community_id $community
                callback -catch datamanager::copy_folder -object_id $object -selected_community $community
            }
         }
    }
    "delete" {
        callback -catch datamanager::delete_folder -object_id $object_id         
    }
    default {
    }
}



ad_returnredirect "./"
