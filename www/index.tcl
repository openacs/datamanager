ad_page_contract {
    Show the list of communities where an object can be moved
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
} -properties {
}


# prevent this page from being called when not in a community
# (i.e. the main dotlrn instance
if {[empty_string_p [dotlrn_community::get_community_id]]} {
    ad_returnredirect "[dotlrn::get_url]"
}

set context [list]
set community_id [dotlrn_community::get_community_id]
db_1row datamanager::select_folder_package_id {}
set root_folder_id [fs::get_root_folder -package_id $package_id]

template::list::create \
    -name objects \
    -multirow objects \
    -elements {
        name {
            label {[_ datamanager.Name]]}
      }
        object_type {
            label {[_ datamanager.Type]}
      }
        move {
            display_template {[_ datamanager.Move]}        
    	    link_url_col move_object_url
        }
        copy {
            display_template {[_ datamanager.Copy]}
    	    link_url_col copy_object_url
        }
        delete { 
            display_template {[_ datamanager.Delete]}
    	    link_url_col delete_object_url
        }

    }

db_multirow -extend { move_object_url
                      copy_object_url
                      delete_object_url                         
} objects datamanager::select_objects {
} {
    set move_object_url [export_vars -base one-object-move { object_id }]
    set copy_object_url [export_vars -base one-object-copy { object_id }]       
    set delete_object_url [export_vars -base one-object-delete { object_id }]       
}
