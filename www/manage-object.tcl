ad_page_contract {
} -query {
    object_type
} -properties {
}

set community_id [dotlrn_community::get_community_id]
set query_name [join [list select $object_type] "_"]

switch $object_type { 

  "folder" {
  # CASO FILE_STORAGE
    set display_template {<div style="text-indent: @usable_objects.level_num@em;">@usable_objects.object_name@</div>}
    db_1row select_folder_package_id {}
    set root_folder_id [fs::get_root_folder -package_id $package_id]
  } 

  "pa_album" {
  # CASO PHOTO_ALBUM            
        # creamos un multirow para evitar una super consulta posterior
        template::multirow create pa_folders object_id object_name creation_user creation_date level_num item_url
        set display_template_pa_folder {<div style="text-indent: @pa_folders.level_num@em;">@pa_folders.object_name@</div>}
        set display_template {<div style="text-indent: @usable_objects.level_num@em;">@usable_objects.object_name@</div>}
        db_1row select_photo_album_package_id {}
        set pa_root_folder [pa_get_root_folder $package_id]
        # Get a list of object_id folders
        set l_photo_folders [db_list select_photo_folders  { * SQL *}]
        foreach folder $l_photo_folders {
          db_1row get_folder_info "select object_id, label as object_name, creation_user , creation_date, tree_level(tree_sortkey) as level_num from acs_objects a, cr_folders f where object_id = folder_id and object_id = :folder"
      template::multirow append pa_folders $object_id $object_name $creation_user $creation_date $level_num 
      set num [template::multirow size grades]
      set item_url [export_vars -base "item" { object_id }]
      template::multirow set pa_folders $num item_url $item_url 
    }
                
        # this case is for the pa_folders
    template::list::create\
      -name usable_objects2 \
      -multirow pa_folders\
      -key object_id\
      -bulk_actions { Copy one-object-copy {#datamanager.Copy_checked_items#} \
                                          Export one-object-export {#datamanager.Export_checked_items#} \
                        } \
      -elements {
          object_name {
            label "#datamanager.name#"
            display_template $display_template_pa_folder
          }
          creation_user {
           label "#datamanager.creation_user#"
          }
          creation_date {
           label "#datamanager.creation_date#"
          }
        }    
        } 
        
        "dotlrn_club" {
                set display_template {<div>@usable_objects.object_name@</div>}
        }
        
        "users" {
                set display_template {<div>@usable_objects.object_name@</div>}
        }
        
        # RESTO DE CASOS
    default {
       set display_template {}
        } 
}

template::list::create\
  -name usable_objects \
  -multirow usable_objects\
  -key object_id\
  -bulk_actions { Copy one-object-copy {#datamanager.Copy_checked_items#} Export one-object-export {#datamanager.Export_checked_items#} }\
  -elements {
    object_name {
        label "#datamanager.name#"
        display_template $display_template
    }
    creation_user {
        label "#datamanager.creation_user#"
    }
    creation_date {
        label "#datamanager.creation_date#"
    }
}                       

db_multirow -extend { item_url } usable_objects $query_name {} {
   set item_url [export_vars -base "item" { object_id }]
}

